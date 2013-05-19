class Main::MainUserCrud < Crud
include General
require 'Connectionschema'

def self.drop_schema(schema_nm)
  Main::SchemaCrud.drop_schema(schema_nm)
  company = Main::MainCompany.find_by_schema_name(schema_nm)
  user =  Main::MainUser.find_by_main_company_id(company.id) if company
  user.destroy if user
  company.destroy if company
end
  
 def self.create_user(doc)
  user = add_user(doc)
  email = Email::Email.send_email('New User Create',user)
  email.trans_flag='H'
  begin
    Main::MainUser.transaction() do
      user.save!       
      email.save!
    end
  rescue Exception=>exp
      user.add_error(exp)
#      user.errors.add('Error!! ',"#{exp.to_s}")
      return user
  end
  user
 end

def self.add_user(doc)
  user_doc = doc/:main_users/:main_user
  user_id =  parse_xml(user_doc/'id') if (user_doc/'id').first 
  new_user= Main::MainUser.find_or_create(user_id)
#  new_user.apply_attributes(doc)
  new_user.apply_attributes(user_doc)
  new_user.login = new_user.email
#  new_user.password = parse_xml(user_doc/'password') if (user_doc/'password').first
#  new_user.password_confirmation = parse_xml(user_doc/'password_confirmation') if (user_doc/'password_confirmation').first
   new_user.password = rand( 10 ** 10).to_s
   new_user.password_confirmation = new_user.password
  new_user
  
end

def self.create_company(doc)
  main_user_id = (doc/:main_companies)[0].attributes['user_id']
  main_user = Main::MainUser.find(main_user_id)
  company = add_company(doc)
  schema_name = generate_schema_name(company.code) if company
  company.schema_name = schema_name.upcase
  begin
    existing_schema = Main::SchemaCrud.check_for_schema(schema_name)
    if not existing_schema.empty?
      company.add_error('Schema already exist....')
#      company.errors.add('Error!!!','Schema already exist....')
      raise
    end
    Main::MainCompany.transaction() do
      company.save! 
      if main_user
        main_user.main_company_id = company.id
        main_user.save!
#        main_user.update_attributes(:company_id=>company.id) 
      end
      seq =  Main::MainSequence.update_document_lno('schema')
      if not seq 
        company.add_error('Row for schema not found in Main Sequence table')
#        company.errors.add('Error!!!','Row for schema not found in Main Sequence table') 
        raise
      end
    end
    rescue Exception=>exp 
      company.add_error(exp)
      main_user.drop if main_user
#      company.errors.add('Error!! ',"#{exp.to_s}") 
      return company
  end
  begin
    Main::SchemaCrud.create_schema(schema_name) 
    Connectionschema.establish_connection_schema(schema_name)
    schema_user = add_user_in_schema(main_user.attributes,company.id) if main_user
    add_company_in_schema(company.attributes) 
    add_user_permissions_in_schema(schema_user.id,company.id) if schema_user
    rescue Exception=>exp
      company.drop
      main_user.drop if main_user
      Main::SchemaCrud.drop_schema(schema_name)
      company.add_error(exp)
#      company.errors.add('Error!!!',"#{exp.to_s} ")
      return company
  end
  #Updating Catalog Parameter fields
#  cat_param=Catalog::CatalogParameter.find(:all).first
#  cat_param.return_url = schema_name+'.'+cat_param.return_url
#  cat_param.ipn_server = schema_name+'.'+cat_param.ipn_server
#  cat_param.save!
   ## Updating email to user of company creation and URL details
  Connectionschema.establish_connection_schema('main')
  email = Email::Email.find_by_email_to(main_user.login)
  email.trans_flag='A'
  body_text = email.body
#  body_text["Your company short name"]=company.code
  body_text.gsub!('company_name',company.code)
  email.body = body_text
  email.save
  company
end


def self.add_company_in_schema(main_company)
  schema_company = Setup::Company.new
  schema_company.id = main_company['id']
  schema_company.company_id = main_company['id']
  schema_company.company_cd = main_company['code']
  schema_company.name = main_company['name']
  schema_company.address1 = main_company['address1']
  schema_company.address2 = main_company['address2']
  schema_company.city = main_company['city']
  if not schema_company.save!
    raise
  end
  schema_company
end

def  self.add_user_in_schema(main_user,company_id)
  schema_user = Admin::User.new
  schema_user.company_id = company_id
  schema_user.user_cd = main_user['user_cd']
  schema_user.login = main_user['login']
  schema_user.email = main_user['email']
  schema_user.first_name = main_user['first_name']
  schema_user.last_name = main_user['last_name']
  schema_user.login_type = 'G'
  schema_user.type_id = 0
  schema_user.crypted_password = main_user['crypted_password']
  schema_user.salt = main_user['salt']
  schema_user.default_company_id = company_id
#  schema_user.rememember_token = main_user.rememember_token
#  schema_user.rememember_token_expires_at = main_user.rememember_token_expires_at
  if not schema_user.save!
    raise
  end 
  schema_user
end

def self.add_user_permissions_in_schema(user_id,company_id)
  admin_role =Admin::Role.find_by_code('ADMIN')
  if admin_role
    admin_role_id = admin_role.id if admin_role
    up = Admin::UserPermission.new
    up.role_id = admin_role_id
    up.user_id = user_id
    up.company_id = company_id
    up.lock_version = 0
    if not up.save!
      raise
    end
  end
  
end

def self.add_company(doc)
  company_doc = doc/:main_companies/:main_company
  company_id =  parse_xml(company_doc/'id') if (company_doc/'id').first 
  
  new_company = Main::MainCompany.find_or_create(company_id ) 
#  new_company.apply_attributes(doc)
  new_company.apply_attributes(company_doc)
  new_company
  
end

def self.generate_schema_name(company_code)
  schema = company_code.strip if not company_code.empty?
  schema_name =  schema.length > 4 ? schema[0,4] : schema
  schema_no = (seq=Main::MainSequence.find_by_docu_typ_and_trans_flag('schema','A')) ? seq.docu_lno : '1001'
  schema_lno = schema_no.to_i + 1
  schema_name = schema_name << schema_lno.to_s   
  schema_name
end

def self.get_companyid_from_code(code)
  Main::MainCompany.find_by_code(code)
end


end
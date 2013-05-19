class Setup::Type < ActiveRecord::Base
  include Dbobject
  include UserStamp
  include General
  
  
  def add_line_errors_to_header    
  end

  def self.list(doc)
    types = []
    (doc/:params/:type_cd).each do |type_cd|
      type_cd_value = type_cd.attributes['value']
      elements = type_cd.search("subtype_cd")
      elements.each do |element|
        subtype_cd_value = element.attributes['value']  
        type = fetch_type_subtype_values(type_cd_value,subtype_cd_value)
        types << type if not type.empty?
      end
    end   
    types
  end

  def self.fetch_type_subtype_values(type_cd,subtype_cd)
    if subtype_cd != '*' 
      type = active.find(:all,
        :conditions => ["type_cd = ? and subtype_cd = ?   " ,type_cd,subtype_cd],
        :select => "type_cd, subtype_cd, value, description")
    else
      type = active.find(:all,
        :conditions => ["type_cd = ? " ,type_cd ],
        :select => "type_cd, subtype_cd, value, description")
    end
    type
  end

  def self.list_all_types(doc)
    types = []
    lists = active.find(:all,
      :select => 'DISTINCT type_cd')
                     
    lists.each do |list|
      type_cd_value = list.attributes['type_cd']
      type = fetch_type_subtype_values(type_cd_value,'*')
      types << type if not type.empty?
    end   
    types
  end
  
  def self.fetch_value_from_types(type_cd,subtype_cd)
    types = self.fetch_type_subtype_values(type_cd,subtype_cd)
    types.empty? ?  nil : types.first.value
  end
  
  def self.fetch_ini_values_for_accounts(doc_type)
    case doc_type
    when 'customer_invoiceline_gl_account'
      code = Setup::Type.fetch_value_from_types('faar','invoice_gl_acct')
    when 'customer_credit_invoice_gl_account'
      code = Setup::Type.fetch_value_from_types('FAAR','credit_gl_account_cd') 
    when 'customer_receipt_bank_code'
      code = Setup::Type.fetch_value_from_types('FAAR','bank_code')  
    end
    return code
  end
  
  def self.list_all_upload_path(schema_name)
    schema_name = schema_name+'/'
    #../images/jewe1112/
    sql = "SELECT type_cd, subtype_cd, 
	(Case When subtype_cd = 'REPORT_EXPORT'or subtype_cd = 'REPORT_PRINT' 
  	then
	concat(replace(value,'/public',''),'#{schema_name}')
        When subtype_cd = 'VIDEO'
 	then
        concat(replace(value,'/public','..'),'#{schema_name}')
	else
	concat(replace(value,'public','..'),'#{schema_name}')
	end ) as value, description
        FROM types 
        WHERE (types.trans_flag = 'A') AND (type_cd = 'UPLOAD_FOLDER' )"
    sql = convert_sql_to_db_specific(sql)
    active.find_by_sql [sql ]
  end
  
end

class Admin::UserCrud
  include General

  def  self.create(user_id)
    user = Admin::User.new(user_id)
    user.save
    user
  end

  def self.create_user_change(doc)#not in use
    user = add_user(doc)
    begin
      Admin::User.transaction() do
        user.save!
      end
    rescue Exception
      return user
    end
    user
  end

  def self.add_user(doc)
    user_doc = doc/:users/:user
    user_id =  parse_xml(user_doc/'id') if parse_xml(user_doc/'id')
    new_user = Admin::User.find_or_create(user_id)
    new_user.apply_attributes(user_doc)
 
    new_user.password = parse_xml(user_doc/'password') if (user_doc/'password').first
    new_user.password_confirmation = parse_xml(user_doc/'password_confirmation') if (user_doc/'password_confirmation').first
    new_user
  
  end

  def self.update_user(doc)
    user = update_user_params(doc)
    if user
      begin
        Admin::User.transaction() do
          user.save!
        end
      rescue ActiveRecord::StaleObjectError
        user.errors.add('This User has been modified by another process. Please retrieve again...') 
      rescue Exception
        return user
      end
    end
    user
  end

  def self.update_user_params(doc)
    user_doc = doc/:users
    user_id =  parse_xml(doc/'id') if (doc/'id').first
    user = Admin::User.find_by_id(user_id)  if user_id

    if user
      user.first_name = parse_xml(user_doc/'first_name') if (user_doc/'first_name').first
      user.last_name = parse_xml(user_doc/'last_name') if (user_doc/'last_name').first
      user.email = parse_xml(user_doc/'email') if (user_doc/'email').first
      user.password = parse_xml(user_doc/'password') if (user_doc/'password').first
      user.password_confirmation = parse_xml(user_doc/'password_confirmation') if (user_doc/'password_confirmation').first
      user.lock_version = parse_xml(user_doc/'lock_version') if (user_doc/'lock_version').first
    end
    user
  end
  
  def self.users_list(doc)
    criteria = doc/:criteria
    #if (doc/:criteria).empty?
    #Jayesh as in user RolePermission Script it always goes into Else part
    if criteria[0].children.empty?
      users = Admin::User.activeusers
    else
      criteria = Setup::Criteria.fill_criteria(doc/:criteria)
      users = find_user_list(criteria)
    end
    users
  end

  def self.find_user_list(criteria)
    Admin::User.find(:all,
      :conditions =>  ["login_type between ? and ? AND
                                    first_name between ? and ? AND
                                    login between ? and ? AND
                                    last_name between ? and ? 
        " ,criteria.str1[0,1],criteria.str2[0,1],
        criteria.str5,criteria.str6,
        criteria.str7,criteria.str8 ,
        criteria.str9, criteria.str10 ])


  end

  def self.update_user_last_moodule(doc)
    user_doc = doc/:users/:user
    user_id =  parse_xml(doc/'id') if (doc/'id').first
    user = Admin::User.find_by_id(user_id)  if user_id
    if user
      user.last_moodule_id = parse_xml(user_doc/'last_moodule_id') if (user_doc/'last_moodule_id').first
    end
    if user
      save_proc = Proc.new{
        user.save!
      }
      user.save_transaction(&save_proc)
    end
    return user
  end

  def self.update_successful_logins(user_id)
    user = Admin::User.find_by_id(user_id)  if user_id
    if user
      user.total_logins = user.total_logins + 1
    end
    if user
      save_proc = Proc.new{
        user.save!
      }
      user.save_transaction(&save_proc)
    end
  end

  def self.change_password(doc)
    user_doc = doc/:users/:user
    id =  parse_xml(user_doc/'id') if (user_doc/'id').first
    old_password = parse_xml(doc/'old_password') if (doc/'old_password').first
    new_password = parse_xml(doc/'new_password') if (doc/'new_password').first
    user = Admin::User.find_by_id(id)  if id
    return if !user
    if user.authenticated?(old_password)
      user.password = new_password
      user.password_confirmation = new_password
      user.total_logins = user.total_logins + 1
      save_proc = Proc.new{
        user.save!  
      }
      user.save_master(&save_proc)
    else
      user.errors.add( 'Error' ,"Old Password is wrong")
    end
    return user
  end

  def self.reset_password(doc)
    user_doc = doc/:users/:user
    login =  parse_xml(user_doc/'login') if (user_doc/'login').first
    user = Admin::User.find_by_login(login)  if login
    user.password = rand( 10 ** 10).to_s
    user.password_confirmation = user.password
    user.total_logins = 0
    email = Email::Email.send_email('Forgot Password',user)
    save_proc = Proc.new{
      user.save!  
      email.save!
    }
    user.save_master(&save_proc)
    return user
  end

  def self.company_list(default_company_id)
    #  Setup::Company.find_all_by_trans_flag('A')
    Setup::Company.find_by_sql ["select * from companies where id = ?",default_company_id]
  end

  def self.create_users(doc)
    users = []
    (doc/:users/:user).each{|doc_type|
      user = create_user(doc_type)
      users <<  user if user
    }
    users
  end

  def self.create_user(doc)
    user = add_or_modify_user(doc)
    return  if !user
    save_proc = Proc.new{
      if  user.save!
        (doc/:user_companies/:user_company).each{|doc_type|
          create_user_companies(doc_type,user)
        }
      end
    }
    user.save_master(&save_proc)
    return  user
  end

  def self.add_or_modify_user(doc)
    id =  parse_xml(doc/'id') if (doc/'id').first
    user = Admin::User.find_or_create(id)
    return if !user
    user.apply_attributes(doc)
    # Add a block to set details
    user.password = parse_xml(doc/'password') if parse_xml(doc/'password')
    user.password_confirmation = parse_xml(doc/'password_confirmation') if parse_xml(doc/'password_confirmation')
    return user
  end

  def self.create_user_companies(doc,user)
    id =  parse_xml(doc/'id') if (doc/'id').first
    user_company = Admin::UserCompany.find_or_create(id)
    return if !user_company
    user_company.apply_attributes(doc)
    user_company.company_id=parse_xml(doc/'default_company_id')
    user_company.user_id=user.id
    user_company.save
  end

  def self.list_users(doc)
    criteria = Setup::Criteria.fill_criteria(doc/:criteria)
    if (criteria.user_id == 1)
      user_list = Admin::User.find(:all,
        :select=>' distinct users.*',
        :joins=>"inner join companies on companies.id = users.default_company_id
                               or	isnull(users.default_company_id, '') = ''",
        :conditions => ["(users.login between ? and ? AND (0 =? )or (users.login in (?))) AND
                                       (users.first_name between ? and ? AND (0 =? )or (users.first_name in (?))) AND
                                       (users.last_name between ? and ? AND (0 =? )or (users.last_name in (?))) AND
                                       (users.date_format between ? and ? AND (0 =? )or (users.date_format in (?))) AND
                                       (companies.name between ? and ? AND (0 =? )or (companies.name in (?))) 
          " ,
          criteria.str1,           criteria.str2,              criteria.multiselect1.length,criteria.multiselect1,
          criteria.str3,           criteria.str4,              criteria.multiselect2.length,criteria.multiselect2,
          criteria.str5,           criteria.str6,              criteria.multiselect3.length,criteria.multiselect3,
          criteria.str7,           criteria.str8,              criteria.multiselect4.length,criteria.multiselect4,
          criteria.str9,           criteria.str10,              criteria.multiselect5.length,criteria.multiselect5,
        ],
        :order => "users.id"
      )
    else
      user_list = Admin::User.find(:all,
        :select=>' distinct users.*',
        :joins=>"inner join companies on companies.id = users.default_company_id
                               or	isnull(users.default_company_id, '') = ''",
        :conditions => ["(users.id = ? ) AND (users.login between ? and ? AND (0 =? )or (users.login in (?))) AND
                                       (users.first_name between ? and ? AND (0 =? )or (users.first_name in (?))) AND
                                       (users.last_name between ? and ? AND (0 =? )or (users.last_name in (?))) AND
                                       (users.date_format between ? and ? AND (0 =? )or (users.date_format in (?))) AND
                                       (companies.name between ? and ? AND (0 =? )or (companies.name in (?))) 
          ",criteria.user_id ,
          criteria.str1,           criteria.str2,              criteria.multiselect1.length,criteria.multiselect1,
          criteria.str3,           criteria.str4,              criteria.multiselect2.length,criteria.multiselect2,
          criteria.str5,           criteria.str6,              criteria.multiselect3.length,criteria.multiselect3,
          criteria.str7,           criteria.str8,              criteria.multiselect4.length,criteria.multiselect4,
          criteria.str9,           criteria.str10,              criteria.multiselect5.length,criteria.multiselect5,
        ],
        :order => "users.id"
      )
    end
    user_list
  end
  
  def self.show_user(id)
    Admin::User.find_all_by_id(id)
  end
  def self.user_lookup
    list = Admin::User.find_by_sql ["select id, user_cd , first_name  as name from users
                                    where trans_flag ='A'
                                    order by user_cd   "
    ]
    list
  end
end

class Admin::RoleCrud
  include General
  
  def self.roles_list(doc)
    criteria = Setup::Criteria.fill_criteria(doc/:criteria) if doc 
    criteria ? query_roles(criteria) :  Admin::Roles.activeroles
  end

  def self.query_roles(criteria)
    Admin::Role.find(:all,
      :conditions => ["code between ? and ? AND
                              role_name between ? and ? AND
                              trans_flag between ? and ?
        " ,criteria.str1,criteria.str2,
        criteria.str3, criteria.str4, criteria.str5[0,1], criteria.str6[0,1]],
      :order => "id",
      :limit => 100,
      :offset => 0
    )
  end

  def self.create_role(doc) 
    error_log = []
    roles = add_roles_values(doc)
    roles.each {|rol|
      begin
        if not rol.new_record?
          if rol.trans_flag == 'D' and (not rol.role_permissions.empty?)
            rol.errors.add_to_base('Cannot delete. Role Permissions already assigned for Role '+ rol.code )
            raise
          end 
        end
        Admin::Role.transaction() do
          rol.save!
        end
      rescue ActiveRecord::StaleObjectError
        rol.errors.add_to_base('Role ' + rol.code + ' : Please refresh --Attempt to access stale object-- ')
      rescue Exception
        error_log.push(rol.errors.on(:base)) 
      end
    }
    roles
  end

  def self.add_roles_values(doc)
    new_roles = []
    (doc/:roles/:role).each{|role|
      role_id =  parse_xml(role/'id') if (role/'id').first
      role_id.empty? ? role_new = Admin::Role.new : role_new = Admin::Role.find_by_id(role_id)

      role_new.apply_attributes(role)
      new_roles << role_new 
    }
    new_roles
  end
  
  
  def self.list_roles(doc)
    criteria = Setup::Criteria.fill_criteria_for_query(doc/:criteria)
    condition = "(roles.code between '#{criteria.str1}' and '#{criteria.str2}' AND (0 =#{criteria.multiselect1.length} )or (roles.code in ('#{criteria.multiselect1}')))"
    condition = convert_sql_to_db_specific(condition)
    Admin::Role.find_by_sql ["select CAST((
                                  select(select * from roles
                                  where #{condition} order by id
                                  FOR XML PATH('role'), TYPE,ELEMENTS XSINIL
                                  )FOR XML PATH('roles')) AS varchar(MAX)) as xmlcol"
    ]
  end
  
  #  #### start of new code
  #  def self.list_roles(doc)
  #    criteria = Setup::Criteria.fill_criteria(doc/:criteria)
  #    role_list = Admin::Role.find(:all,
  #      :conditions => ["(roles.code between ? and ? AND (0 =? )or (roles.code in (?)))
  #        " ,
  #        criteria.str1,  criteria.str2,   criteria.multiselect1.length,criteria.multiselect1,
  #      ],
  #      :order => "id"
  #    )
  #    role_list
  #  end

 
  def self.create_roles(doc)
    roles = [] 
    (doc/:roles/:role).each{|doc_type|
      role = create_role(doc_type)
      roles <<  role if role
    }
    roles
  end

  def self.create_role(doc)
    role = add_or_modify_role(doc) 
    return  if !role
    save_proc = Proc.new{
      role.save! 
    }
    role.save_master(&save_proc)
    return  role
  end

  def self.add_or_modify_role(doc)
    id =  parse_xml(doc/'id') if (doc/'id').first  
    role = Admin::Role.find_or_create(id) 
    return if !role
    role.apply_attributes(doc) 
    # Add a block to set details

    return role
  end

  def self.show_role(id)
    Admin::Role.find_all_by_id(id)
  end
  def self.role_lookup
    list = Admin::Role.find_by_sql ["select id, code,role_name as name from roles
                                    where trans_flag ='A' "
    ]
    list
  end
end

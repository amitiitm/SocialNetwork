class Admin::UserPermissionCrud
include General
  
def self.list_users_roles
  Admin::UserPermission.find(:all,
                      :joins =>"inner join users on users.id=user_permissions.user_id",
                      :conditions =>"user_permissions.trans_flag='A'",
                      :order => "users.id",
                      :offset => 0
    )
end

def self.list_user_roles(doc)
  user_id = parse_xml(doc/:criteria/:user_id)   if (doc/:criteria/:user_id).first 
  Admin::UserPermission.find_by_user_id(user_id)
end

#def self.create_user_permissions(doc)
#  error = 'F'
#  user_role = []
#  (doc/:user_roles/:user_role).each { |user_roles_doc|
#    user_role << add_user_role(user_roles_doc)
#    }
#  begin
#    Admin::UserPermission.transaction() do  
#      Admin::UserPermission.destroy_all 
#      user_role.each {|usr_rpm|
#        usr_rpm.save!  
#    }
#    end  
#    rescue Exception
#      error = 'T'
#  end  
#  error
#end

def self.add_user_role(user_roles_doc)
  role_id = parse_xml(user_roles_doc/'role_id') if (user_roles_doc/'role_id').first
  user_id = parse_xml(user_roles_doc/'user_id') if (user_roles_doc/'user_id').first
  company_id = parse_xml(user_roles_doc/'user_id') if (user_roles_doc/'company_id').first
  urp = Admin::UserPermission.new
  if urp.new_record?
    urp.role_id = role_id
    urp.company_id = company_id
    urp.user_id =  user_id   
  end
  urp
 end

def self.create_user_permissions(doc)
   (doc/:user_permissions/:user_permission).each{|doc_type|
   @user_permissions = create_user_permission(doc_type)
   }
   return @user_permissions
 end

 def self.create_user_permission(doc)
   user_permissions = []
   company_id=parse_xml(doc/'company_id')
   updated_by=parse_xml(doc/'updated_by')
   created_by=parse_xml(doc/'created_by')
   (doc/:user_roles/:user_role).each{|doc_type|
    user_permission = add_or_modify_user_permission(doc_type)
   return  if !user_permission
   user_permission.company_id=company_id
   user_permission.updated_by=updated_by
   user_permission.created_by=created_by
   user_permission.save
   user_permissions << user_permission
   }
  return  user_permissions
end

def self.add_or_modify_user_permission(doc)
   id =  parse_xml(doc/'id') if (doc/'id').first
   user_permission = Admin::UserPermission.find_or_create(id)
   return if !user_permission
   user_permission.apply_attributes(doc) 
   user_permission
end


end

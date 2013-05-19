xml.instruct! :xml, :version=>"1.0" 
xml.user_roles{
    for ur in @users_roles
    xml.user_role do
	xml.role_id(ur.role_id) 
	xml.id(ur.id)
	xml.lock_version(ur.lock_version)
	xml.user_id(ur.user_id) 
                 xml.name(ur.user.first_name ) if ur.user        
   end
 end
}

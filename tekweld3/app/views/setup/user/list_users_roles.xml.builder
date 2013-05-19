xml.instruct! :xml, :version=>"1.0" 
xml.users_roles{
    for ur in @users_roles
    xml.user_role do
	xml.role_id(ur.role_id) 
	xml.user_id(ur.user_id) 
        xml.user_name(ur.user.first_name + ' ' + ur.user.last_name ) if ur.user        
   end
 end
}

xml.instruct! :xml, :version=>"1.0" 
xml.role_permissions{
  @role_permissions.each{|rp|
      xml.role_permission do
      xml.permission_id(rp.id) 
      xml.role_id(rp.role_id) 
      xml.document_id(rp.document_id)   
      xml.menu_id(rp.menu_id) 
      xml.menu_name(rp.menu.menu_name)  if rp.menu
      xml.moodule_id(rp.moodule_id)
      xml.create_permission(rp.create_permission)
      xml.modify_permission(rp.create_permission)
      xml.view_permission(rp.create_permission)
      xml.lock_version(rp.lock_version)  
    end
  }
}


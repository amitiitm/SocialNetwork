
xml.instruct! :xml, :version=>"1.0" 
xml.rolepermissions{
  for rolepermission in @menu_list
    xml.rolepermission do
      xml.id(rolepermission.id)  
      xml.code(rolepermission.code) 
      xml.name(rolepermission.menu_name)   
      xml.moodule_id(rolepermission.moodule_id)
      xml.page_heading(rolepermission.page_heading)  
      #    xml.create_permission('Y')
      #    xml.modify_permission('Y')
      #    xml.view_permission('Y')
      xml.create_permission(rolepermission.create_permission)
      xml.modify_permission(rolepermission.modify_permission)
      xml.view_permission(rolepermission.view_permission)
      xml.menu_id(rolepermission.menu_id)
      xml.visible_flag(rolepermission.visible_flag)  ## newly added for making menu visible/invisible
      #    if rolepermission.document
      rolepermission.component_cd ? xml.component_cd(rolepermission.component_cd)  :  xml.component_cd('')
      rolepermission.document_id ? xml.document_id(rolepermission.document_id) : xml.document_id('') 
      #    else
      #      xml.component_cd('')
      #      xml.document_id('') 
      #    end        
    end  
  end
}

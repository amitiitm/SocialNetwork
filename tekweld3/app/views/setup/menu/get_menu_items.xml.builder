xml.instruct! :xml, :version=>"1.0" 
xml.menus{
  for menu in @main_menu
    xml.menu do     
      xml.menu_name(menu.menu_name)  
      xml.code(menu.code) 
      xml.id(menu.id) 
      xml.moodule_id(menu.moodule_id)
      xml.menu_type(menu.menu_type)
      xml.document_id(menu.document_id) if menu.document_id
      for sub_menu in menu.sub_menus.map 
#        if sub_menu.trans_flag == 'A'
          xml.sub_menu do
            xml.menu_name(sub_menu.menu_name)  
            xml.code(sub_menu.code) 
            xml.id(sub_menu.id)
            xml.moodule_id(sub_menu.moodule_id)
            xml.menu_type(sub_menu.menu_type)
            xml.document_id(sub_menu.document_id)
          end
#        end
      end
    end
 end
}


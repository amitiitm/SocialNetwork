xml.instruct! :xml, :version=>"1.0" 
xml.moodules{
  @moodules.each{|moodule|
    xml.moodule do     
      xml.moodule_name(moodule.moodule_name)  
      xml.moodule_code(moodule.code) 
      xml.moodule_id(moodule.id) 
      rp = Admin::RolePermission.find_all_by_role_id_and_moodule_id_and_document_id(@role_id,moodule.id,0)
      #      if not rp.empty?
      moodule.menus.each{|sub_menu|
        if sub_menu.menu_type == 'S' 
          rp = Admin::RolePermission.find_all_by_role_id_and_moodule_id_and_menu_id(@role_id,moodule.id,sub_menu.id)
          if  rp.empty?
            xml.sub_menu do
              xml.menu_name(sub_menu.menu_name)
              xml.menu_code(sub_menu.code)
              xml.menu_id(sub_menu.id)
              xml.document_id(sub_menu.document_id)
            end
          end
        end
      }
      #      end
    end
  }
}


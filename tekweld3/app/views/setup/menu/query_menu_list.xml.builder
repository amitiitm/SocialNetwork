xml.instruct! :xml, :version=>"1.0" 
xml.menus{
  for menu in @menus
      xml.menu do
      xml.id(menu.id) 
      xml.created_by(menu.created_by)
      xml.created_date(date_format(menu.created_at))
      xml.trans_flag(menu.trans_flag)  
      xml.code(menu.code) 
      xml.menu_name(menu.menu_name)   
      xml.moodule_code(menu.moodule_code)  
    end
 end
}


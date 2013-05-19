xml.instruct! :xml, :version=>"1.0" 
xml.root do
  xml.user do
    xml.user_id(@main_user.id)
    xml.user_cd(@main_user.user_cd)
    xml.login_type(@main_user.login_type)
    xml.type_id(@main_user.type_id)
    xml.login_flag(@main_user.login_flag)
    xml.user_flag(@main_user.user_flag)
    xml.first_name(@main_user.first_name)
    xml.last_name(@main_user.last_name)
    xml.last_moodule_id(@main_user.last_moodule_id)
    xml.date_format(@main_user.date_format)
    xml.total_logins(@main_user.total_logins)
    xml.default_company_id(@main_user.default_company_id)
    xml.login(@main_user.login)
    xml.menu_id(@main_user.menu_id)
  end
  xml.company do
    @company_list.attributes.each_pair{ |column_name,column_value|
      column_value = format_column(column_value)
      xml.tag!(column_name, column_value)
    }
  end
end

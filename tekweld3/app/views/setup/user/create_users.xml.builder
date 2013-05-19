xml.instruct! :xml, :version=>"1.0" 
xml.users{
  for user in @users
    xml.user {
      user.attributes.each_pair{ |column_name,column_value|
        column_value = format_column(column_value)
        xml.tag!(column_name, column_value)
      }
      xml.user_companies{    
        for user_company in user.user_companies 
          if user_company.trans_flag=='A'
            xml.user_company do
              user_company.attributes.each_pair{ |column_name,column_value|
                column_value = format_column(column_value)
                xml.tag!(column_name, column_value)
              }
              xml.default_company_id(user_company.company_id)
              xml.dummy1(user_company.company.name)
              xml.company_cd(user_company.company.company_cd)
            end
          end
        end
      }
    }
  end
}
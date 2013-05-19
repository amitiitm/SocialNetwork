xml.instruct! :xml, :version=>"1.0" 
xml.criterias{
  for criteria in @criterias
    xml.criteria do
      criteria.attributes.each_pair{ |column_name,column_value|
        column_value = format_column(column_value)
        xml.tag!(column_name, column_value)
#        for criteria_user in criteria.criteria_users
        
#        end
      }
#       xml.default_yn(criteria.criteria_users.default_yn)
    end
  end
}


# for criteria_user in criteria.criteria_users
#        
#        xml.default_yn(criteria_user.default_yn)
#          
#      end
xml.instruct! :xml, :version=>"1.0" 
xml.companies{
  for company in  @companies
    xml.company do
      company.attributes.each_pair{ |column_name,column_value|
        column_value = format_column(column_value)
        xml.tag!(column_name, column_value)
      }
      xml.code(company.company_cd) if company
      xml.user_companies{
        for user_company in company.user_companies
          if user_company.trans_flag == 'A'
            xml.user_company do
              user_company.attributes.each_pair{ |column_name,column_value|
                column_value = format_column(column_value)
                xml.tag!(column_name, column_value)
              }
              xml.user_cd(user_company.user.user_cd) if user_company.user
              xml.user_name(user_company.user.first_name) if user_company.user
              #              xml.user_id(user_company.user.id) if user_company.user
              #by minal              
            end
          end
        end
      }
      xml.user_books{
        seq_array=Setup::Sequence.find(:all,
                                          :conditions=>"company_id=#{company.id}")
        for seq in seq_array
          if seq.trans_flag == 'A'
            xml.sequence do
              seq.attributes.each_pair{ |column_name,column_value|
                column_value = format_column(column_value)
                xml.tag!(column_name, column_value)
              }
              #              xml.user_id(user_company.user.id) if user_company.user
              #by minal              
            end
          end
        end
      }
    end
  end
}

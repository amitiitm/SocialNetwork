xml.instruct! :xml, :version=>"1.0" 
xml.banks{
   for bank in @banks
    xml.bank do
       bank.attributes.each_pair{ |column_name,column_value|
        column_value = format_column(column_value)
        xml.tag!(column_name, column_value)
      }
      xml.current_balance(bank.current_balance)
      xml.bank_checks do
        bank.bank_checks.each{|line| 
          if line.trans_flag =='A'
            xml.bank_check do
              line.attributes.each_pair{ |column_name,column_value|
                column_value = format_column(column_value)
                xml.tag!(column_name, column_value)
              }
            end
        end
      }
      end
    end
 end
}


xml.instruct! :xml, :version=>"1.0" 
xml.account_years{
  for account_year in @accounts
    xml.account_year do
      account_year.attributes.each_pair{ |column_name,column_value|
        column_value = format_column(column_value)
        xml.tag!(column_name, column_value)
      }
    xml.account_periods{
   for account_period in account_year.account_periods
     if account_period.trans_flag == 'A'
        xml.account_period do
              account_period.attributes.each_pair{ |column_name,column_value|
                column_value = format_column(column_value)
                xml.tag!(column_name, column_value)
              } 
     end      
   end
   end
    }
 end
 end
}

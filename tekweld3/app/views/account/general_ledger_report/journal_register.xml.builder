xml.instruct! :xml, :version=>"1.0" 
xml.bank_transactions{
  for bank_transaction in @bank_transactions
    xml.bank_transaction do
      bank_transaction.attributes.each_pair{ |column_name,column_value|
#      bank_transaction.each_pair{ |column_name,column_value|
        column_value = format_column(column_value)
        column_value =  date_format(column_value) if (column_name =~ /(.*)date(.*)/ )
        xml.tag!(column_name, column_value)
      }
    end
  end
}

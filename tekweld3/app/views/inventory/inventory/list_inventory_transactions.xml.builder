xml.instruct! :xml, :version=>"1.0" 
xml.inventory_transactions{
   for inventory_transaction in @inventory_transactions
    xml.inventory_transaction do
       inventory_transaction.attributes.each_pair{ |column_name,column_value|
        column_value = format_column(column_value)
        xml.tag!(column_name, column_value)
      }
    end
 end
}

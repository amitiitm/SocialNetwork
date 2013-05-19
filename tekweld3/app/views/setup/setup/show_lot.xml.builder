xml.instruct! :xml, :version=>"1.0" 
xml.diamond_lots{
   for diamond_lot in  @diamond_lots
    xml.diamond_lot do
       diamond_lot.attributes.each_pair{ |column_name,column_value|
        column_value = format_column(column_value)
        xml.tag!(column_name, column_value)
      }
      xml.diamond_cert_flag(diamond_lot.cert_flag) if diamond_lot
    end
 end
}

xml.instruct! :xml, :version=>"1.0" 
xml.rows{
    for list in @data
    xml.row do
      list.attributes.each_pair{ |column_name,column_value|
        xml.tag!(column_name, column_value)
      }
   end
 end
}

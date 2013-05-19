xml.instruct! :xml, :version=>"1.0" 
xml.rows{
    for l in @list
    xml.row do
      l.attributes.each_pair{ |column_name,column_value|
        xml.tag!(column_name, column_value)
      }   
   end
 end
}

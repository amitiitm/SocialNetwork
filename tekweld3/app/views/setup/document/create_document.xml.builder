xml.instruct! :xml, :version=>"1.0" 
xml.documents{
  for document in @document
    xml.document do
      document.id ||= ''
      document.attributes.each_pair{ |column_name,column_value|
        column_value = format_column(column_value)
        xml.tag!(column_name, column_value)
      }   
    if !document.errors.empty?
            document.errors.each {|error,msg| 
              xml.error(error,msg) 
            }
           
      end      
    end
 end
}


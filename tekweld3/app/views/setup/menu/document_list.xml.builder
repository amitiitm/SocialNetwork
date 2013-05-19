xml.instruct! :xml, :version=>"1.0" 
xml.documents{
  for document in @documents
      xml.document do
        document.attributes.each_pair{ |column_name,column_value|
          column_value = format_column(column_value)
          xml.tag!(column_name, column_value)
        }    
    end
 end
}


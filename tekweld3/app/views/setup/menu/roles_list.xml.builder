xml.instruct! :xml, :version=>"1.0" 
xml.roles{
  for role in @roles
      xml.role do
        role.attributes.each_pair{ |column_name,column_value|
          column_value = format_column(column_value)
          xml.tag!(column_name, column_value)
        }   
    end
 end
}


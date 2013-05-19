xml.instruct! :xml, :version=>"1.0" 
xml.roles{
  for role in @rl
      xml.role do
      role.id ||= ''    
      role.attributes.each_pair{ |column_name,column_value|
        column_value = format_column(column_value)
        xml.tag!(column_name, column_value)
      }  
      xml.error(role.errors.on(:base))  if not role.errors.empty?
      xml.error('')  if role.errors.empty?
    end
 end
}


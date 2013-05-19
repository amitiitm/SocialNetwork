xml.instruct! :xml, :version=>"1.0" 
xml.metals{
  for metal in  @metals
    xml.metal do
      metal.attributes.each_pair{ |column_name,column_value|
        column_value = format_column(column_value)
        xml.tag!(column_name, column_value)
      }
      xml.metal_cert_flag(metal.cert_flag) if metal
    end
  end
}

xml.instruct! :xml, :version=>"1.0" 
xml.rows{
  xml.row{
    for packet_label in @label_mappings
      generic_col = ''
      value = ''
      packet_label.attributes.each_pair{ |column_name,column_value|
        generic_col = column_value if (column_name == 'generic_attribute_label') 
        value =  column_value if (column_name == 'specific_attribute_label' )             
      }
      xml.tag!(generic_col, value) if (generic_col && value)
    end
  }
}
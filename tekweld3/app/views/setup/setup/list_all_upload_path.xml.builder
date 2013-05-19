xml.instruct! :xml, :version=>"1.0" 
xml.rows{
  xml.row{
    for path in @patharray
      generic_col = ''
      value = ''
      path.attributes.each_pair{ |column_name,column_value|
        generic_col = column_value if (column_name == 'subtype_cd') 
        value =  column_value if (column_name == 'value' )             
      }
      xml.tag!(generic_col, value) if (generic_col && value)
    end
  }
}
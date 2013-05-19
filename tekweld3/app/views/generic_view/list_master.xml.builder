xml.instruct! :xml, :version=>"1.0" 
xml.tag!("#{@tag_level1}"){
  if @view_array 
    for view_row in @view_array
    xml.tag!("#{@tag_level2}") do
      view_row.attributes.each_pair{ |column_name,column_value|
        column_value = format_column(column_value)
        xml.tag!(column_name, column_value)
      }
    end
   end
  end
}

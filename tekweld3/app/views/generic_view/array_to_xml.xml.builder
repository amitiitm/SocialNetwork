xml.instruct! :xml, :version=>"1.0" 
xml.tag!("#{@tag_level1}"){
column_names = []
@data_rows[0].each {|column_name| column_names << column_name } if @data_rows[0]
 @data_rows.each_with_index {|row,index|
   xml.tag!("#{@tag_level2}") do
      row.each_with_index{|column,index|
        xml.tag!(column_names[index],column)
      }
   end if index > 0
 }
}

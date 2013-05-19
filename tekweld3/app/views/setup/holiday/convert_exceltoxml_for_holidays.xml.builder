xml.instruct! :xml, :version=>"1.0" 
xml.tag!("#{@tag_level1}"){
  column_names = []
  @data_rows[0].each {|column_name| column_names << column_name.downcase} if @data_rows[0]
  @data_rows.each_with_index {|row,index|
    msg=''
    xml.tag!("#{@tag_level2}") do
      row.each_with_index{|column,index|
        col_len=0
        column='' if !column
        column.each_byte do |ascii|
          if  (ascii<65 or ascii>90) and (ascii<97 or ascii>122)
            col_len+=1
          else
            break  
          end 
        end
        case index
        when 0
          if column
            holiday = Setup::Holiday.find_by_holiday_date(column)
            if holiday
              msg=msg+"Holiday Date Already Exists \\n"
            end
          end 
        when 1
          if (column and column.length > 50) 
            msg=msg+"Length Of Event should be less than 50 chars \\n"
          end                 
        end 
        xml.tag!(column_names[index],column)
      }    
      xml.message(msg)  
    end if index > 0
  }
}
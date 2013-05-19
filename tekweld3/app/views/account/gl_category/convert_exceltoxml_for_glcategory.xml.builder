xml.instruct! :xml, :version=>"1.0" 
xml.tag!("#{@tag_level1}"){
  column_names = []
  @data_rows[0].each {|column_name| column_names << column_name.downcase} if @data_rows[0]
  @data_rows.each_with_index {|row,index|
  msg=''
  xml.tag!("#{@tag_level2}") do
    row.each_with_index{|column,index|
      case index
      when 0
        if column
          if column.length < 25
            glcategory = GeneralLedger::GlCategory.find_by_code(column)
            if glcategory
              msg=msg+"Code Already exist \\n"  
            end
            else
              msg=msg+"Code can be of 25 chars \\n"
          end 
        else
          msg=msg+"Code Can't be Blank \\n"
        end
      when 1
        if column and column.length > 50
            msg=msg+"Name can be of 50 chars \\n"
        end  
      when 2
        if column and column.length > 2
            msg=msg+"Account type can be of 2 chars \\n"
        end        
      end
      xml.tag!(column_names[index],column)
    }
      xml.message(msg)  
    end if index > 0
  }
}
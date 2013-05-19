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
        if  (ascii > 47 and ascii < 58) or (ascii == 46) #to check ascii value between 0-9 and .
          col_len+=1
        else
          break  
        end 
      end       
      case index
      when 0
        if column
          if column.length < 25
            bank = GeneralLedger::Bank.find_by_code(column)
            if bank
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
        if column and column.length > 50 
            msg=msg+"Address1 can be of 50 chars \\n"
        end 
      when 3
        if  column and column.length > 50 
            msg=msg+"Address2 can be of 50 chars \\n"
        end
      when 4
        if column.length > 30
            msg=msg+"Account No can be of 30 chars \\n"
        else
          if column.length == col_len 
             column = column.to_i 
          end
        end
      when 5
        if column and column.length > 30
            msg=msg+"Contact Name can be of 30 chars \\n"
        end
      when 6
        if column and column.length > 20
            msg=msg+"City can be of 20 chars \\n"
        end
      when 7
        if column and column.length > 20
            msg=msg+"Country can be of 20 chars \\n"
        end
      when 8
        if column and column.length > 15
            msg=msg+"Zip can be of 15 chars \\n"
        else 
          column = column.to_i  if column and column != ''
        end
      when 9
        if column and column.length > 25
            msg=msg+"State can be of 25 chars \\n"
        end
      when 10
        glcategory = GeneralLedger::GlCategory.find_by_code(column) 
        if !glcategory
          msg=msg+"gl category not exist for this gl account \\n"
        else
          xml.gl_category_id(glcategory.id)
        end
      end

      xml.tag!(column_names[index],column)
    }
    
      xml.message(msg)  
    end if index > 0
  }
}
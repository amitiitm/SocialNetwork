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
            vendorcategory = Vendor::VendorCategory.find_by_code(column)
            if vendorcategory
             msg=msg+"Code Already exist \\n"  
            end
          else
            msg=msg+"Code can be of 25 chars \\n"
          end
        else
          msg=msg+"Code can't be Blank \\n"
        end 
      when 1
        if column and column.length > 50
            msg=msg+"Name can be of 50 chars \\n"
        end  
#      when 2
#        terms = Setup::Term.find_by_code(column) 
#        if !terms
#            msg=msg+"Terms not exist for this vendor category \\n"
##        else
##          xml.memo_term_id(terms.id)
#        end 
      when 2
        if column
          if column.length < 25
            if column.length == col_len 
              column = column.to_i 
            end
            column=column.to_s
            termcode = Setup::Term.find_by_code(column)
            if !termcode
              msg=msg+"Termcode not exist for this vendor category \\n"  
            end
          else
              msg=msg+"Term Code can be of 25 chars \\n"
          end 
        else
            msg=msg+"Term Code Can't be Blank \\n"
        end        
      end
      xml.tag!(column_names[index],column)
    }
      xml.message(msg)  
    end if index > 0
  }
}

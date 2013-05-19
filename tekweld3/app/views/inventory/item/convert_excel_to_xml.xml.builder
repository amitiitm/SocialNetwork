xml.instruct! :xml, :version=>"1.0" 
xml.tag!("#{@tag_level1}"){
  column_names = []
  @data_rows[0].each {|column_name| column_names << column_name } if @data_rows[0]
  @data_rows.each_with_index {|row,index|
  msg=''
  xml.tag!("#{@tag_level2}") do
    row.each_with_index{|column,index|
      #            col_value=Item::CatalogItem.find_by_sql ["select ? where ? like '0.%'  ",column,column]
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
        column=column.to_i.to_s if !(col_len < column.length)
      when 1
        column=column.to_i.to_s if !(col_len < column.length) and !(column.length==0)
        catalog_item=Item::CatalogItem.find_by_store_code(column)
        if !catalog_item
          msg=msg+"Item does not exist.please enter valid store code \\n "
        end        
      when 2..4,6..9,13
        if column.length>0
          column=column.to_i.to_s  if !(col_len < column.length) and !(column.length==0)
          types=Setup::Type.find_by_type_cd_and_value(column_names[index],column)
          if !types
            msg =msg + "invalid #{column_names[index]}.check it from application settings and correct it \\n "
          end
        end
        column=column.upcase if index==2 or index==3 or index==13
      when 5 
        if column.length>0
          column=column.to_i.to_s  if !(col_len < column.length) and !(column.length==0)
          types=Setup::Type.find_by_type_cd_and_value('stone_cut',column) if column_names[index]=='cut'
          if !types
            msg =msg + "invalid stone_cut.check it from application settings and correct it \\n "
          end
        end
      when 14,19
        if col_len<column.length 
          msg = msg + "#{column_names[index]} require integer data.please enter valid integer data \\n " 
        else 
          column=column.to_i                    
        end  
      when 15..18,20..28
        if col_len<column.length 
          msg = msg + "#{column_names[index]} require numeric data.please enter valid numeric data \\n " 
        end

        #                when 14,19
        #                   if column.length>0
        #                     if !col_value[0] || col_value[0]==''
        #                       msg = msg + "#{column_names[index]} require integer data data.please enter valid integer data..." if column.to_i ==0
        #                       column=column.to_i.to_s if column.to_i !=0
        #                     else
        #                       column=column.to_i.to_s  
        #                     end 
        #                   end
        #                when 15..18,20..28
        #                   if column.length>0
        #                     if !col_value[0] || col_value[0]==''
        #                       msg = msg + "#{column_names[index]} require numeric data.please enter valid numeric data..." if column.to_i ==0
        #                     end
        #                  end
      end
      xml.tag!(column_names[index],column)
    }
      xml.message(msg)  
    end if index > 0
  }
}
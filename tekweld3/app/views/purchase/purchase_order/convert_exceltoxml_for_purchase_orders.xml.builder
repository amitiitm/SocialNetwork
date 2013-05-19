xml.instruct! :xml, :version=>"1.0" 
xml.tag!("#{@tag_level1}"){
  column_names = []
  @data_rows[0].each {|column_name| column_names << column_name.downcase} if @data_rows[0]
  @data_rows.each_with_index {|row,index|
    msg = ''
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
          if !(column.length==0) and (column.length <= 18)
            column=column.to_i.to_s if !(col_len < column.length) 
            column_names[index] =  'catalog_item_code'
            catalog_item=Item::CatalogItem.find_by_store_code(column)
            if !catalog_item
              msg=msg+"item does not exist.please enter valid style \\n "
            else
              xml.catalog_item_id(catalog_item.id)
            end
          else 
            msg=msg+"item code can't be Blank or greater than 25 characters \\n"
          end
        when 1 
#          column_names[index] =  'item_description'
          if !(column.length <= 100) 
            msg=msg+"item description can't be greater than 100 characters \\n"
          end
        when 2
          column=column.to_i.to_s if !(col_len < column.length)
          if  !(/^[0-9]{1,8}$/=~column) 
            msg = msg + "#{column_names[index]} require integer data.please enter valid integer upto 99999999 \\n " 
          end   
        when 3
          if  !(/^[0-9]{1,8}\.[0-9]{1,2}$/ =~column)
            msg = msg + "#{column_names[index]} require numeric data.please enter valid number in decimal(10,2)\\n " 
          end 
        end
        xml.tag!(column_names[index],column)
      }
#      if vendor and trans_date != ''
#        terms = Setup::Term.fill_terms(vendor.invoice_term_code,trans_date.to_datetime) 
#        xml.term_code(terms.code) 
#        xml.due_date(terms.pay1_date)
#      end
      xml.message(msg)  
      xml.upload_flag('y')
    end if index > 0
  }
}
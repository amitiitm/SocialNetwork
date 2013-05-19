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
        if  (ascii > 47 and ascii < 58) or (ascii == 46)
          col_len+=1
        else
          break  
        end 
      end
      case index
      when 0
        if column
          if column.length < 25
            if column.length == col_len 
              column = column.to_i 
            end
            column=column.to_s
            customer = Customer::Customer.find_by_code(column)
            if customer
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
        if column and column.length > 50 
            msg=msg+"Address2 can be of 50 chars \\n"
        end 
      when 4
        if column and column.length > 25 
            msg=msg+"City can be of 25 chars \\n"
        end 
      when 5
        if column and column.length > 25 
            msg=msg+"State can be of 25 chars \\n"
        end 
      when 6
        if column and column.length > 15 
            msg=msg+"Zip can be of 15 chars \\n"
        else
          column = column.to_i if column.length != '0' and column != ''
        end 
      when 7
        if column and column.length > 20 
            msg=msg+"Country can be of 20 chars \\n"
        end 
      when 8
        if column
          if column.length < 50
            if column.length == col_len and column.length != '0' and column != ''
              column = column.to_i 
            end
          else
              msg=msg+"Phone1 can be of 50 chars \\n"
          end 
        end
      when 9
        if column
          if column.length < 50
            if column.length == col_len and column.length != '0' and column != ''
              column = column.to_i 
            end
          else
              msg=msg+"Phone2 can be of 50 chars \\n"
          end 
        end
      when 10
        if column
          if column.length < 50
            if column.length == col_len and column.length != '0' and column != ''
              column = column.to_i 
            end
          else
              msg=msg+"Fax can be of 50 chars \\n"
          end 
        end         
      when 12 #check customer category exist or not
        if column
          if column.length < 25
            if column.length == col_len and column.length != '0' and column != ''
              column = column.to_i 
            end
            column=column.to_s
            customercategory = Customer::CustomerCategory.find_by_code(column)
            if !customercategory
              msg=msg+"Category Not Exist Please Create Category First \\n"
            else
              xml.customer_category_id(customercategory.id)    
            end
          else
              msg=msg+"Category Code can be of 25 chars \\n"
          end 
        else
            msg=msg+"Category Can't be Blank \\n"
        end
      when 13
        if column and column != ''
          if column.length < 9
            if column.length == col_len and column.length != '0' and column != ''
              column = column.to_i 
            end
            column=column.to_s
            salesperson = Sales::Salesperson.find_by_code(column)
            if !salesperson
              msg=msg+"SalesPerson Not Exist.Please Create SalesPerson First \\n"
            else
              xml.salesperson_id(salesperson.id)    
            end
          else
              msg=msg+"Sales Person Code can be of 8 chars \\n"
          end 
        end
      when 14
        if column
          if column.length < 255
            if column.length == col_len and column.length != '0' and column != ''
              column = column.to_i 
            end
            column=column.to_s
            shipping = Setup::Shipping.find_by_code(column)
            if !shipping
              msg=msg+"Shipping Not Exist.Please Create Shipping First \\n"
            else
              xml.shipping_id(shipping.id)    
            end
          else
              msg=msg+"Shipping Code can be of 255 chars \\n"
          end 
        end
      when 16
        if column
          if column.length < 25
            if column.length == col_len and column.length != '0' and column != ''
              column = column.to_i 
            end
            column=column.to_s
            terms = Setup::Term.find_by_code(column)
            if !terms
              msg=msg+"Terms Not Exist.Please Enter Valid Term Code \\n"
            else
              xml.memo_term_id(terms.id)
            end
          else
              msg=msg+"Term Code can be of 25 chars \\n"
          end 
        else
          msg=msg+"Term Code Can't be Blank \\n"
        end
      when 17
        if column
          if column.length < 50
            if column.length == col_len and column.length != '0' and column != ''
              column = column.to_i 
            end
          else
              msg=msg+"Contact1 can be of 50 chars \\n"
          end 
        end        
      end        
      xml.tag!(column_names[index],column)
    }
    
      xml.message(msg)  
    end if index > 0
  }
}






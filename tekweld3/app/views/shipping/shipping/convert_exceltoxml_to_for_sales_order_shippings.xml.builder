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
        shipping_code = ""
        case index
        when 1
          if column and column.length > 50
            msg=msg+"Ship Name can be of 50 chars \\n"
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
            msg=msg+"Ship City can be of 25 chars \\n"
          end
        when 5
          column = column.upcase
          if column and column.length > 2
            msg=msg+"Ship State can be of 2 chars \\n"
          end
        when 6
          if column and column.length > 15
            msg=msg+"Ship Zip can be of 15 chars or should be numeric \\n"
          else
            column = column if column.length != '0' and column != ''
          end
        when 7
          column = column.upcase
          if column and column.length > 2
            msg=msg+"Ship Country can be of 2 chars \\n"
          end
        when 8
          if column and column.length < 50
            column = column.upcase
            shipping = Setup::Shipping.find_by_trans_flag_and_code('A',column)
            shipping_code = column
            if !shipping
              msg = msg + "Ship Provider does not exist. Please Enter valid Ship Provider \\n "
            end
          else
            msg = msg + "Ship Provider can be of 50 chars \\n"
          end
        when 9
          if (shipping_code != 'THIRDPARTY' and column and column.length > 0)
            msg = msg + "Account Number is Valid only for Third Party Shipping \\n"
          else
            column = column.to_i if (column.length != '0' and column != '')
          end
        when 10
          if column.length == 0
            msg = msg + 'Bill Transportation should not be blank'
          else
            if column =~ (/Shipper(.*)/)
              column = 'Shipper (TEKWELD)'
            elsif column =~ (/Third(.*)/)
              column = 'Third Party'
            elsif column =~ (/Receiver(.*)/)
              column = 'Receiver'
            else
              msg = msg + 'Please Enter Valid Bill Transportation'
            end
          end
        end
        xml.tag!(column_names[index],column)
      }
      xml.ship_qty (0)
      xml.ship_amt (0)
      xml.estimated_ship_date(Time.now.strftime("%Y/%m/%d"))
      xml.internal_ship_date(Time.now.strftime("%Y/%m/%d"))
      xml.message(msg)
    end if index > 0
  }
}
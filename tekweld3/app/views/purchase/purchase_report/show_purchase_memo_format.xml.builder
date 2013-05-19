xml.instruct! :xml, :version=>"1.0" 
xml.purchase_memos{
    for purchase_memo in @memos      
    subtotal_amt = 0  
    xml.purchase_memo do
      purchase_memo.attributes.each_pair{ |column_name,column_value|
          column_value = format_column(column_value) 
          column_value = sprintf( "%0.02f", column_value) if (column_name =~ /(.*)amt(.*)/ ) and column_value
          column_value = sprintf( "%0.00f", column_value) if (column_name =~ /(.*)qty(.*)/ ) and column_value
          xml.tag!(column_name, column_value)  if column_name != 'company_logo_file'            
          if (column_name =~ /(.*)company_logo_file(.*)/ )
          schemaname=session[:schema]
          filename=column_value 
          if filename.nil? then filename = '' end
          if filename.strip == '' then filename = 'blank.jpg' end
          if File.exist?("#{Dir.getwd}/public/images/#{schemaname}/#{filename}") == true
            filename = "http://#{request.env['HTTP_HOST']}/images/#{schemaname}/#{filename}"
          else
            filename = "http://#{request.env['HTTP_HOST']}/images/#{schemaname}/blank.jpg"
          end
          xml.company_logo_file(filename)
          end
        }
      xml.vendor{
         xml.name(purchase_memo.vendor.name)
         xml.code(purchase_memo.vendor.code)
         xml.address1(purchase_memo.vendor.address1)
         xml.address2(purchase_memo.vendor.address2)
         xml.phone(purchase_memo.vendor.phone)
         xml.zip(purchase_memo.vendor.zip)
         xml.country(purchase_memo.vendor.country)
         xml.city(purchase_memo.vendor.city)
         xml.state(purchase_memo.vendor.state)
         xml.fax(purchase_memo.vendor.fax)
       }      
      xml.company{
         xml.name(purchase_memo.company.name)
         xml.address1(purchase_memo.company.address1)
         xml.address2(purchase_memo.company.address2)
         xml.phone(purchase_memo.company.phone)
         xml.zip(purchase_memo.company.zip)
         xml.country(purchase_memo.company.country)
         xml.city(purchase_memo.company.city)
         xml.state(purchase_memo.company.state)
         xml.fax(purchase_memo.company.fax)
      }
     xml.purchase_memo_lines{
        @count = 1
        for purchase_memo_line in purchase_memo.purchase_memo_lines
          if purchase_memo_line.trans_flag == 'A'
            xml.purchase_memo_line do
              subtotal_amt = purchase_memo_line.item_amt + subtotal_amt
              xml.item_description(purchase_memo_line.item_description)
              xml.trans_no(purchase_memo_line.trans_no)
              xml.trans_date(purchase_memo_line.trans_date)
              xml.serial_no(purchase_memo_line.serial_no)
              discount_amt=sprintf( "%0.02f", purchase_memo_line.discount_amt) if purchase_memo_line.discount_amt
              xml.discount_amt(discount_amt)
              net_amt=sprintf( "%0.02f", purchase_memo_line.net_amt) if purchase_memo_line.net_amt
              xml.net_amt(net_amt)
              item_qty=sprintf( "%0.00f", purchase_memo_line.item_qty) if purchase_memo_line.item_qty
              xml.item_qty(item_qty)
              item_amt=sprintf( "%0.02f", purchase_memo_line.item_amt) if purchase_memo_line.item_amt
              xml.item_amt(item_amt)
              item_price=sprintf( "%0.02f", purchase_memo_line.item_price) if purchase_memo_line.item_price
              xml.item_price(item_price)
              xml.vendor_sku_no(purchase_memo_line.vendor_sku_no)
              order_qty=sprintf( "%0.00f", purchase_memo_line.ref_qty) if purchase_memo_line.ref_qty
              xml.order_qty(order_qty)
              xml.catalog_item_packet_code(purchase_memo_line.catalog_item_packet_code)
              xml.row_no(@count)
              xml.taxable(purchase_memo_line.catalog_item.taxable)
              xml.packet_require_yn(purchase_memo_line.catalog_item.packet_require_yn)
              xml.image_thumnail(purchase_memo_line.catalog_item.image_thumnail)
              xml.item_code(purchase_memo_line.catalog_item.store_code)
              xml.item_name(purchase_memo_line.catalog_item.name)
            end
            @count = @count + 1
          end         
        end
      }
      xml.subtotal_amt(subtotal_amt) 
      end
    end
}
xml.instruct! :xml, :version=>"1.0" 
xml.purchase_credit_invoices{
    for purchase_credit_invoice in @creditinvoices      
    subtotal_amt = 0  
    xml.purchase_credit_invoice do
      purchase_credit_invoice.attributes.each_pair{ |column_name,column_value|
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
         xml.name(purchase_credit_invoice.vendor.name)
         xml.code(purchase_credit_invoice.vendor.code)
         xml.address1(purchase_credit_invoice.vendor.address1)
         xml.address2(purchase_credit_invoice.vendor.address2)
         xml.phone(purchase_credit_invoice.vendor.phone)
         xml.country(purchase_credit_invoice.vendor.country)
         xml.city(purchase_credit_invoice.vendor.city)
         xml.zip(purchase_credit_invoice.vendor.zip)
         xml.state(purchase_credit_invoice.vendor.state)
         xml.fax(purchase_credit_invoice.vendor.fax)
       }      
      xml.company{
         xml.name(purchase_credit_invoice.company.name)
         xml.address1(purchase_credit_invoice.company.address1)
         xml.address2(purchase_credit_invoice.company.address2)
         xml.phone(purchase_credit_invoice.company.phone)
         xml.zip(purchase_credit_invoice.company.zip)
         xml.country(purchase_credit_invoice.company.country)
         xml.city(purchase_credit_invoice.company.city)
         xml.state(purchase_credit_invoice.company.state)
         xml.fax(purchase_credit_invoice.company.fax)
      }
     xml.purchase_credit_invoice_lines{
        @count = 1
        for purchase_credit_invoice_line in purchase_credit_invoice.purchase_credit_invoice_lines
          if purchase_credit_invoice_line.trans_flag == 'A'
            xml.purchase_credit_invoice_line do
              subtotal_amt = purchase_credit_invoice_line.item_amt + subtotal_amt
              xml.item_description(purchase_credit_invoice_line.item_description)
              xml.trans_no(purchase_credit_invoice_line.trans_no)
              xml.trans_date(purchase_credit_invoice_line.trans_date)
              xml.serial_no(purchase_credit_invoice_line.serial_no)
              discount_amt=sprintf( "%0.02f", purchase_credit_invoice_line.discount_amt) if purchase_credit_invoice_line.discount_amt
              xml.discount_amt(discount_amt)
              net_amt=sprintf( "%0.02f", purchase_credit_invoice_line.net_amt) if purchase_credit_invoice_line.net_amt
              xml.net_amt(net_amt)
              item_qty=sprintf( "%0.00f", purchase_credit_invoice_line.item_qty) if purchase_credit_invoice_line.item_qty
              xml.item_qty(item_qty)
              item_amt=sprintf( "%0.02f", purchase_credit_invoice_line.item_amt) if purchase_credit_invoice_line.item_amt
              xml.item_amt(item_amt)
              item_price=sprintf( "%0.02f", purchase_credit_invoice_line.item_price) if purchase_credit_invoice_line.item_price
              xml.item_price(item_price)
              xml.vendor_sku_no(purchase_credit_invoice_line.vendor_sku_no)
              order_qty=sprintf( "%0.00f", purchase_credit_invoice_line.ref_qty) if purchase_credit_invoice_line.ref_qty
              xml.order_qty(order_qty)
              xml.catalog_item_packet_code(purchase_credit_invoice_line.catalog_item_packet_code)
              xml.row_no(@count)
              xml.taxable(purchase_credit_invoice_line.catalog_item.taxable)
              xml.packet_require_yn(purchase_credit_invoice_line.catalog_item.packet_require_yn)
              xml.image_thumnail(purchase_credit_invoice_line.catalog_item.image_thumnail)
              xml.item_code(purchase_credit_invoice_line.catalog_item.store_code)
              xml.item_name(purchase_credit_invoice_line.catalog_item.name)
            end
            @count = @count + 1
          end         
        end
      }
      xml.subtotal_amt(subtotal_amt) 
      end
    end
}
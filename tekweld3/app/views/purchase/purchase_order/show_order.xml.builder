xml.instruct! :xml, :version=>"1.0" 
xml.purchase_orders{
  for purchase_order in @orders
    xml.purchase_order do
      purchase_order.attributes.each_pair{ |column_name,column_value|
        column_value = format_column(column_value)
        xml.tag!(column_name, column_value)
      }
      xml.vendor_name(purchase_order.vendor.name)
      xml.purchase_order_lines{
        for purchase_order_line in purchase_order.purchase_order_lines
          if purchase_order_line.trans_flag == 'A'
            xml.purchase_order_line do
              purchase_order_line.attributes.each_pair{ |column_name,column_value|
                column_value = format_column(column_value)
                xml.tag!(column_name, column_value)
              }
              if purchase_order_line.catalog_item
                xml.taxable(purchase_order_line.catalog_item.taxable)
                xml.packet_require_yn(purchase_order_line.catalog_item.packet_require_yn)
                xml.image_thumnail(purchase_order_line.catalog_item.image_thumnail)
                filename = purchase_order_line.catalog_item.image_thumnail
                if filename.nil? then filename = '' end
                if filename.strip == '' then filename = 'blank.jpg' end
                if File.exist?("#{Dir.getwd}/public/images/catalog/#{filename}") == true
                  filename = "http://#{request.env['HTTP_HOST']}/images/catalog/#{filename}"
                else
                  filename = "http://#{request.env['HTTP_HOST']}/images/catalog/blank.jpg"
                end
                xml.item_photo_url(filename)
              end
            end
          end
        end
      }
    end
  end
}

xml.instruct! :xml, :version=>"1.0"

xml.sales_orders{
  for sales_order in @orders
    xml.sales_order do
      sales_order.attributes.each_pair{ |column_name,column_value|
        column_value = format_column(column_value)
        xml.tag!(column_name, column_value)
      }
      xml.customer_name(sales_order.customer.name)
      #      xml.customer_code(sales_order.customer.code)
      sales_order_line = Sales::SalesOrderLine.find_by_sales_order_id_and_line_type_and_item_type(sales_order.id,'M','I')
      xml.thread_company(sales_order_line.thread_company)
      xml.thread_color(sales_order_line.thread_color)
      xml.thread_number(sales_order_line.thread_number)
      xml.stitch_count(sales_order_line.stitch_count)
      xml.receive_digitization_flag(sales_order_line.receive_digitization_flag)
      xml.reject_from_imposition_flag(sales_order_line.reject_from_imposition_flag)
      xml.film_flag(sales_order_line.film_flag)
      xml.imposition_reject_reason(sales_order_line.imposition_reject_reason)
      xml.sales_order_lines{
        for sales_order_line in sales_order.sales_order_lines
          if sales_order_line.trans_flag == 'A'
            #            if sales_order_line.line_type == 'M' and sales_order_line.item_type == 'I'
            xml.sales_order_line do
              sales_order_line.attributes.each_pair{ |column_name,column_value|
                column_value = format_column(column_value)
                xml.tag!(column_name, column_value)
              }
              if sales_order_line.catalog_item
                xml.unit(sales_order_line.catalog_item.unit)
                xml.taxable(sales_order_line.catalog_item.taxable)
                xml.packet_require_yn(sales_order_line.catalog_item.packet_require_yn)
                xml.image_thumnail(sales_order_line.catalog_item.image_thumnail)
                filename = sales_order_line.catalog_item.image_thumnail
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
            #            end
          end
        end
      }

      xml.sales_order_attributes_values{
        for sales_order_attributes_value in sales_order.sales_order_attributes_values
          if sales_order_attributes_value.trans_flag =='A'
            xml.sales_order_attributes_value do
              sales_order_attributes_value.attributes.each_pair{ |column_name,column_value|
                column_value = format_column(column_value)
                xml.tag!(column_name, column_value)
              }
            end
          end
        end
      }
      xml.sales_order_threads{
        for thread in sales_order.sales_order_threads.active
          xml.sales_order_thread do
            thread.attributes.each_pair{ |column_name,column_value|
              column_value = format_column(column_value)
              xml.tag!(column_name, column_value)
            }
          end
        end
      }

      xml.sales_order_artworks{
        for sales_order_artwork in sales_order.sales_order_artworks
          if (sales_order_artwork.trans_flag =='A' and (!sales_order_artwork.artwork_version.match(/Customer PO(.*)/) and !sales_order_artwork.artwork_version.match(/Customer Art(.*)/)))
            xml.sales_order_artwork do
              sales_order_artwork.attributes.each_pair{ |column_name,column_value|
                column_value = format_column(column_value)
                xml.tag!(column_name, column_value)
              }
            end
          end
        end
      }
    end
  end
}

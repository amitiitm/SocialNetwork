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

      xml.sales_order_lines{
        sales_order_lines = Sales::SalesOrderLine.find_by_sql ["select * from sales_order_lines where trans_flag = 'A' and item_type = 'I' and line_type = 'M' and sales_order_id = #{sales_order.id}"]
        sales_order_lines.each{|sales_order_line|
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
              #              filename = sales_order_line.catalog_item.image_thumnail
              #              if filename.nil? then filename = '' end
              #              if filename.strip == '' then filename = 'blank.jpg' end
              #              if File.exist?("#{Dir.getwd}/public/images/catalog/#{filename}") == true
              #                filename = "http://#{request.env['HTTP_HOST']}/images/catalog/#{filename}"
              #              else
              #                filename = "http://#{request.env['HTTP_HOST']}/images/catalog/blank.jpg"
              #              end
              #              xml.item_photo_url(filename)
            end
            ## to fetch sales_order_attributes_values for multiple items
            if sales_order.trans_type == 'S' || sales_order.trans_type == 'E' || sales_order.trans_type == 'F'
              xml.sales_order_attributes_values{
                for sales_order_attributes_value in sales_order.sales_order_attributes_values
                  if (sales_order_attributes_value.trans_flag == 'A' and sales_order_attributes_value.catalog_item_id == sales_order_line.catalog_item_id)
                    xml.sales_order_attributes_value do
                      sales_order_attributes_value.attributes.each_pair{ |column_name,column_value|
                        column_value = format_column(column_value)
                        xml.tag!(column_name, column_value)
                      }
                    end
                  end
                end
              }
            else
              xml.sales_order_attributes_values{
                for sales_order_attributes_value in sales_order_line.sales_order_attributes_values
                  ## in case of sample and virtual order multiple items have multiple attributes and item can repeat so by storing line id of catalog_item in sales_order_line_id of SOAV we can distinguish
                  if (sales_order_attributes_value.trans_flag == 'A' and sales_order_attributes_value.catalog_item_id == sales_order_line.catalog_item_id and sales_order_attributes_value.sales_order_line_id.to_i == sales_order_line.id.to_i)
                    xml.sales_order_attributes_value do
                      sales_order_attributes_value.attributes.each_pair{ |column_name,column_value|
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
      }

      
      xml.sales_order_artworks{
        for sales_order_artwork in sales_order.sales_order_artworks
          if (sales_order_artwork.trans_flag =='A' and !sales_order_artwork.artwork_version.match(/Customer PO(.*)/) and !sales_order_artwork.artwork_version.match(/Customer Art(.*)/))
            xml.sales_order_artwork do
              sales_order_artwork.attributes.each_pair{ |column_name,column_value|
                column_value = format_column(column_value)
                xml.tag!(column_name, column_value)
              }
            end
          end
        end
      }

      xml.sales_order_transaction_activities{
        sales_order_transaction_activities = Sales::SalesOrderTransactionActivity.find_by_sql ["select * from sales_order_transaction_activities where trans_flag = 'A' and sales_order_id = #{sales_order.id}"]
        sales_order_transaction_activities.each{|sales_order_transaction_activity|
          xml.sales_order_transaction_activity do
            sales_order_transaction_activity.attributes.each_pair{ |column_name,column_value|
              column_value = format_column(column_value)
              xml.tag!(column_name, column_value) if column_name != 'activity_date'
            }
            #              puts sales_order_transaction_activity.activity_date.strftime('%Y-%m-%d %H:%M:%S')
            xml.activity_date(sales_order_transaction_activity.activity_date.localtime.strftime('%Y-%m-%d %H:%M:%S'))
            user = Sales::SalesOrderTransactionActivity.find_by_sql("select email,first_name,last_name from users where id = #{sales_order_transaction_activity.user_id}") if sales_order_transaction_activity.user_id
            xml.user_name(user.first.first_name + ' '+ user.first.last_name) if user.first
            xml.user_email(user.first.email) if user.first
          end
        }
      }

      xml.queries{
        for query in sales_order.queries.active
          xml.query do
            query.attributes.each_pair{ |column_name,column_value|
              column_value = format_column(column_value)
              xml.tag!(column_name, column_value)
            }
          end
        end
      }
    end
  end
}

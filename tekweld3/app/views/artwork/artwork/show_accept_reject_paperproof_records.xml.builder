xml.instruct! :xml, :version=>"1.0" 

xml.sales_orders{
  for sales_order in @orders
    xml.sales_order do
      sales_order.attributes.each_pair{ |column_name,column_value|
        column_value = format_column(column_value)
        xml.tag!(column_name, column_value)
      }
      xml.customer_name(sales_order.customer.name)
      sales_order_lines = Sales::SalesOrderLine.find_by_sql ["select * from sales_order_lines where trans_flag = 'A' and sales_order_id = ?",sales_order.id]
      sales_order_lines.each { |sales_order_line|
        xml.distributed_by_flag_item(sales_order_line.catalog_item.distributed_by_flag) if (sales_order_line.item_type == 'I' and sales_order_line.catalog_item)
      }
      xml.sales_order_lines{
        sales_order_lines.each { |sales_order_line|
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
            end
          end
        }
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
      xml.sales_order_shippings{
        for sales_order_shipping in sales_order.sales_order_shippings
          if sales_order_shipping.trans_flag =='A'
            xml.sales_order_shipping do
              sales_order_shipping.attributes.each_pair{ |column_name,column_value|
                column_value = format_column(column_value)
                xml.tag!(column_name, column_value)
              }
            end
          end
        end
      }
      xml.sales_order_artworks{
        for sales_order_artwork in sales_order.sales_order_artworks
          if sales_order_artwork.trans_flag =='A' and sales_order_artwork.select_yn == 'Y'
            xml.sales_order_artwork do
              sales_order_artwork.attributes.each_pair{ |column_name,column_value|
                column_value = format_column(column_value)
                xml.tag!(column_name, column_value)
              }
            end
          end
        end
      }
      #      xml.sales_order_transaction_activities{
      #        for sales_order_transaction_activity in sales_order.sales_order_transaction_activities
      #          if sales_order_transaction_activity.trans_flag =='A'
      #            xml.sales_order_transaction_activity do
      #              sales_order_transaction_activity.attributes.each_pair{ |column_name,column_value|
      #                column_value = format_column(column_value)
      #                xml.tag!(column_name, column_value) if column_name != 'activity_date'
      #              }
      #              xml.activity_date(sales_order_transaction_activity.activity_date.localtime.strftime('%Y-%m-%d %H:%M:%S'))
      #              user = Sales::SalesOrderTransactionActivity.find_by_sql("select email,first_name,last_name from users where id = #{sales_order_transaction_activity.user_id}") if sales_order_transaction_activity.user_id
      #              xml.user_name(user.first.first_name + ' '+ user.first.last_name) if user.first
      #              xml.user_email(user.first.email) if user.first
      #            end
      #          end
      #        end
      #      }

      xml.sales_order_transaction_activities{
        sales_order_transaction_activities = Sales::SalesOrderTransactionActivity.find_by_sql ["
        select (users.first_name + ' ' + users.last_name) as user_name,users.email as user_email,sota.activity_date,sota.sales_order_stage_code
        from sales_order_transaction_activities  sota
        inner join users on users.id = sota.user_id
        where sota.trans_flag = 'A' and sota.sales_order_id = #{sales_order.id}"]
        sales_order_transaction_activities.each{|sales_order_transaction_activity|
          xml.sales_order_transaction_activity {
            xml.sales_order_stage_code(sales_order_transaction_activity.sales_order_stage_code)
            xml.activity_date(sales_order_transaction_activity.activity_date)
            xml.user_name(sales_order_transaction_activity.user_name)
            xml.user_email(sales_order_transaction_activity.user_email)
          }
        }
      }

      ## This Will Give the total no. of notes corresponding to one order and can be shown as popup on orders screen
      xml.notes{
        note = Sales::SalesOrderTransactionActivity.find_by_sql("select COUNT(*) as count from notes where trans_id = #{sales_order.id}") if sales_order.id
        xml.note do
          xml.count(note.first.count)
        end  
      }
      ## This Will Give the total no. of attachments corresponding to one order and can be shown as popup on orders screen
      xml.attachments{
        attachment = Sales::SalesOrderTransactionActivity.find_by_sql("select COUNT(*) as count from attachments where trans_id = #{sales_order.id}") if sales_order.id
        xml.attachment do
          xml.count(attachment.first.count)
        end  
      }
    end
  end
}

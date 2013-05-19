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
      
      #      seq_no = Sales::SalesOrder.find_by_sql("select sequence_no from order_master_stages where stage_code = '#{sales_order.order_status}'")
      #      order_stages = Sales::SalesOrder.find_by_sql("select stage_code from order_master_stages where main_stage_flag = 'Y' AND sequence_no < #{seq_no[0].sequence_no}") if seq_no[0]
      #      order_stages = [] if !seq_no[0]
      #      xml.order_stages{
      #        for order_stage in order_stages
      #          xml.order_stage do
      #          xml.stage_code(order_stage.stage_code)
      #          end
      #        end
      #      }
      xml.values{
        order_stages = find_order_stages(sales_order.id)
        order_stages[0].attributes.each_pair{ |column_name,column_value|
          xml.value(column_value) if column_value != ''
        }
      }
      xml.sales_order_transaction_activities{
        for sales_order_transaction_activity in sales_order.sales_order_transaction_activities
          if sales_order_transaction_activity.trans_flag =='A'
            xml.sales_order_transaction_activity do
              sales_order_transaction_activity.attributes.each_pair{ |column_name,column_value|
                column_value = format_column(column_value) 
                xml.tag!(column_name, column_value) if column_name != 'activity_date'
              }
              xml.activity_date(sales_order_transaction_activity.activity_date.strftime('%Y-%m-%d %H:%M:%S'))
              user = Sales::SalesOrderTransactionActivity.find_by_sql("select email,first_name,last_name from users where id = #{sales_order_transaction_activity.user_id}") if sales_order_transaction_activity.user_id
              xml.user_name(user.first.first_name + ' '+ user.first.last_name) if user.first
              xml.user_email(user.first.email) if user.first
            end
          end
        end
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

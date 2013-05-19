xml.instruct! :xml, :version=>"1.0"

xml.sales_orders{
  for sales_order in @orders
    xml.sales_order do
      sales_order.attributes.each_pair{ |column_name,column_value|
        column_value = format_column(column_value)
        xml.tag!(column_name, column_value)
      }
      xml.customer_name(sales_order.customer.name)
      xml.customer_profile_code(sales_order.customer.customer_profile_code)
      xml.cust_phone(sales_order.customer.phone1)
      xml.default_customer_third_party_account_number(sales_order.customer.third_party_account_number)
      xml.default_customer_bill_transportation_to(sales_order.customer.bill_transportation_to)
      xml.default_customer_shipping_code(sales_order.customer.shipping_code)
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
              ## to fetch sales_order_attributes_values for multiple items
              #              xml.sales_order_attributes_values{
              #                for sales_order_attributes_value in sales_order.sales_order_attributes_values
              #                  ## serial_no is compared with ref_serial_no bcos in case of sample and virtual order multiple items have multiple attributes and item can repeat so by storing serial_no of catalog_item in ref_serial_no of SOAV we can distinguish
              #                  if (sales_order_attributes_value.trans_flag == 'A' and sales_order_attributes_value.catalog_item_id == sales_order_line.catalog_item_id and sales_order_attributes_value.ref_serial_no.to_i == sales_order_line.serial_no.to_i)
              #                    xml.sales_order_attributes_value do
              #                      sales_order_attributes_value.attributes.each_pair{ |column_name,column_value|
              #                        column_value = format_column(column_value)
              #                        xml.tag!(column_name, column_value)
              #                      }
              #                    end
              #                  end
              #                end
              #              }

              xml.sales_order_attributes_values{
                for sales_order_attributes_value in sales_order_line.sales_order_attributes_values
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
            #            end
          end
        end
      }
      xml.sales_order_shippings{
        sales_order_shippings = Sales::SalesOrderShipping.find_by_sql ["select * from sales_order_shippings where trans_flag = 'A' and sales_order_id = #{sales_order.id}"]
        sales_order_shippings.each{|sales_order_shipping|
          xml.sales_order_shipping do
            sales_order_shipping.attributes.each_pair{ |column_name,column_value|
              column_value = format_column(column_value)
              xml.tag!(column_name, column_value)
            }
            xml.sales_order_shipping_packages{
              sales_order_shipping_packages = Sales::SalesOrderShippingPackage.find_by_sql ["select * from sales_order_shipping_packages where trans_flag = 'A' and sales_order_shipping_id = #{sales_order_shipping.id}"]
              sales_order_shipping_packages.each{|sales_order_shipping_package|
                xml.sales_order_shipping_package do
                  sales_order_shipping_package.attributes.each_pair{ |column_name,column_value|
                    column_value = format_column(column_value)
                    xml.tag!(column_name, column_value)
                  }
                end
              }
            }
          end
        }
      }
      xml.sales_order_artworks{
        for sales_order_artwork in sales_order.sales_order_artworks
          if sales_order_artwork.trans_flag =='A'
            xml.sales_order_artwork do
              sales_order_artwork.attributes.each_pair{ |column_name,column_value|
                column_value = format_column(column_value)
                xml.tag!(column_name, column_value)
              }
            end
          end
        end
      }
      xml.payment_transactions{
        for payment_transaction in sales_order.customer_payment_transactions
          if payment_transaction.trans_flag =='A'
            xml.payment_transaction do
              payment_transaction.attributes.each_pair{ |column_name,column_value|
                column_value = format_column(column_value)
                xml.tag!(column_name, column_value)
              }
            end
          end
        end
      }
      xml.queries{
        for query in sales_order.queries.active
          xml.query do
            query.attributes.each_pair{ |column_name,column_value|
              column_value = format_column(column_value) if column_name != 'date_added'
              xml.tag!(column_name, column_value) if column_name != 'date_added'
              xml.date_added(column_value.localtime.strftime('%Y-%m-%d %H:%M:%S')) if column_name == 'date_added'
            }

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
      #              xml.user_name(user.first.first_name + ' '+user.first.last_name) if user
      #              xml.user_email(user.first.email) if user
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

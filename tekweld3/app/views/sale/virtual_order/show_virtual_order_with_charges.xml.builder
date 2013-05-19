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

      xml.sales_order_lines{
        sales_order_lines = Sales::SalesOrderLine.find_by_sql ["select * from sales_order_lines where trans_flag = 'A' and sales_order_id = #{sales_order.id}"]
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
              xml.has_expired_date_flag(sales_order_line.catalog_item.has_expired_date_flag)
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
        }
      }
      ## to fetch sales_order_attributes_values for specific item inside line
      sales_order_main_lines = Sales::SalesOrderLine.find_by_sql ["select * from sales_order_lines where trans_flag = 'A' and item_type = 'I' and line_type = 'M' and id = #{@ref_virtual_line_id}"]
      xml.sales_order_attributes_values{
        sales_order_attributes_values = Sales::SalesOrderAttributesValue.find_by_sql ["select * from sales_order_attributes_values where trans_flag = 'A' and catalog_item_id = #{sales_order_main_lines[0].catalog_item_id} and sales_order_line_id = #{@ref_virtual_line_id}"]
        sales_order_attributes_values.each{|sales_order_attributes_value|
          xml.sales_order_attributes_value do
            sales_order_attributes_value.attributes.each_pair{ |column_name,column_value|
              column_value = format_column(column_value)
              xml.tag!(column_name, column_value)
            }
            xml.sales_order_attributes_multiple_values{
              if sales_order_attributes_value.catalog_attribute_value_code == 'MULTI'
                sales_order_attributes_multiple_values = Sales::SalesOrderAttributesMultipleValue.find_by_sql ["select * from sales_order_attributes_multiple_values where trans_flag = 'A' and sales_order_attributes_value_id = #{sales_order_attributes_value.id}"]
                sales_order_attributes_multiple_values.each{|sales_order_attributes_multiple_value|
                  xml.sales_order_attributes_multiple_value do
                    sales_order_attributes_multiple_value.attributes.each_pair{ |column_name,column_value|
                      column_value = format_column(column_value)
                      xml.tag!(column_name, column_value)
                    }
                  end
                }
              end
            }
          end
        }
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
      xml.sales_order_transaction_activities{
        for sales_order_transaction_activity in sales_order.sales_order_transaction_activities
          if sales_order_transaction_activity.trans_flag =='A'
            xml.sales_order_transaction_activity do
              sales_order_transaction_activity.attributes.each_pair{ |column_name,column_value|
                column_value = format_column(column_value)
                xml.tag!(column_name, column_value) if column_name != 'activity_date'
              }
              xml.activity_date(sales_order_transaction_activity.activity_date.localtime.strftime('%Y-%m-%d %H:%M:%S'))
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
      ## this will give the customer specific prices for all attribute codes and there values if inventory item exists in sales_order_lines
      if @ref_virtual_line_id ## this will give the line of virtual order for which we are making reorder
        #        sales_order_lines = Sales::SalesOrderLine.find_by_sql ["select * from sales_order_lines where trans_flag = 'A' and item_type = 'I' and line_type = 'M' and id = #{sales_order.ref_virtual_line_id}"]
        xml.catalog_items do
          if sales_order_main_lines[0] and sales_order.customer_id
            @customer_id = sales_order.customer_id
            @catalog_items,@cust_prices = Item::PriceUtility.fetch_cust_specific_price(sales_order_main_lines[0].catalog_item_id ,@customer_id)
            xml << render(:template => 'setup/setup/item_detail')
          end
        end
      end
      ## this will give the customer specific default order setup price
      catalog_item = Item::CatalogItem.find_by_store_code('SETUP')
      @default_setup_items,@customer_prices = Item::PriceUtility.fetch_cust_specific_setup_item_price(catalog_item.id,sales_order.customer_id)
      xml << render(:template => 'setup/setup/fetch_default_setup_item')
    end
  end
}


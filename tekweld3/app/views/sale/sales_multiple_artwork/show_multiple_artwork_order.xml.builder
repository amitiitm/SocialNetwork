xml.instruct! :xml, :version=>"1.0"

xml.sales_orders{
  for sales_order in @orders
    xml.sales_order do
      sales_order.attributes.each_pair{ |column_name,column_value|
        column_value = format_column(column_value)
        xml.tag!(column_name, column_value)
      }
      xml.customer_name(sales_order.customer.name)
      xml.cust_phone(sales_order.customer.phone1)
      xml.customer_profile_code(sales_order.customer.customer_profile_code)
      xml.default_customer_third_party_account_number(sales_order.customer.third_party_account_number)
      xml.default_customer_bill_transportation_to(sales_order.customer.bill_transportation_to)
      xml.default_customer_shipping_code(sales_order.customer.shipping_code)
      xml.sales_order_lines{
        sales_order_lines = Sales::SalesOrderLine.find_by_sql ["select sales_order_lines.*,ci.unit,ci.taxable,ci.image_thumnail,ci.has_expired_date_flag
                                                                from sales_order_lines
                                                                left outer join catalog_items ci on ci.id = sales_order_lines.catalog_item_id
                                                                where sales_order_lines.trans_flag = 'A' and sales_order_id = #{sales_order.id}"]
        sales_order_lines.each{|sales_order_line|
          xml.sales_order_line do
            sales_order_line.attributes.each_pair{ |column_name,column_value|
              column_value = format_column(column_value)
              xml.tag!(column_name, column_value)
            }
          end
        }
      }

      xml.sales_order_attributes_values{
        sales_order_attributes_values = Sales::SalesOrderAttributesValue.find_by_sql ["select * from sales_order_attributes_values where trans_flag = 'A' and sales_order_id = #{sales_order.id}"]
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
      xml.sales_order_artworks{
        sales_order_artworks = Sales::SalesOrderArtwork.find_by_sql ["select * from sales_order_artworks where trans_flag = 'A' and sales_order_id = #{sales_order.id}"]
        sales_order_artworks.each{|sales_order_artwork|
          xml.sales_order_artwork do
            sales_order_artwork.attributes.each_pair{ |column_name,column_value|
              column_value = format_column(column_value)
              xml.tag!(column_name, column_value)
            }
          end
        }
      }
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
      ## this will give the customer specific prices for all attribute codes and there values if inventory item exists in sales_order_lines
      sales_order_lines = Sales::SalesOrderLine.find_by_sql ["select * from sales_order_lines where trans_flag = 'A' and item_type = 'I' and line_type = 'M' and sales_order_id = #{sales_order.id}"]
      xml.catalog_items do
        if sales_order_lines[0] and sales_order.customer_id
          @customer_id = sales_order.customer_id
          @catalog_items,@cust_prices = Item::PriceUtility.fetch_cust_specific_price(sales_order_lines[0].catalog_item_id ,@customer_id)
          if (sales_order.ref_type == 'Q' and sales_order.ref_trans_no != '' and sales_order.ref_trans_bk == 'SQ01')
            @cust_prices = Quotation::SalesQuotationLine.find_by_id(sales_order.ref_virtual_line_id)
          end
          xml << render(:template => 'setup/setup/item_detail')
        end
      end
      xml.default_setup_lines{}
      xml.thirdpartyshippingcharge{}
    end
  end
}



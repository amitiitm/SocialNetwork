xml.instruct! :xml, :version=>"1.0" 

xml.sales_orders{
  for sales_order in @orders
    xml.sales_order do
      sales_order.attributes.each_pair{ |column_name,column_value|
        column_value = format_column(column_value)
        xml.tag!(column_name, column_value)
      }
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
          end
        }
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
    end
  end
}



xml.instruct! :xml, :version=>"1.0"

xml.sales_order_shippings{
  for shipping in @shippings
    xml.sales_order_shipping do
      shipping.attributes.each_pair{ |column_name,column_value|
        column_value = format_column(column_value)
        xml.tag!(column_name, column_value)
      }
      ###### this sql is used bcos we need to calculate ship amount from api and for insured value front end needs column1 value
      order = Sales::SalesOrder.find_by_sql ["select distinct special_instructions,cip.column1,sol.catalog_item_id
                                              from sales_order_shippings sos
                                              inner join sales_orders so on so.id = sos.sales_order_id
                                              inner join sales_order_lines sol on (sol.sales_order_id = so.id and sol.item_type = 'I' and sol.trans_flag = 'A')
                                              inner join catalog_items ci on ci.id = sol.catalog_item_id
                                              inner join catalog_item_prices cip on (cip.catalog_item_id = ci.id and cip.trans_flag = 'A')
                                              where sos.trans_flag = 'A' and sos.id = #{shipping.id}"]
      xml.special_instructions(order[0].special_instructions)
      xml.column1(order[0].column1)
      xml.catalog_item_id(order[0].catalog_item_id)
      xml.sales_order_shipping_packages{
        for shipping_package in shipping.sales_order_shipping_packages.active
          if shipping_package.update_flag == 'Y'
            xml.sales_order_shipping_package do
              shipping_package.attributes.each_pair{ |column_name,column_value|
                column_value = format_column(column_value)
                xml.tag!(column_name, column_value)
              }
            end
          end
        end
      }
      xml.sales_order_shipping_truck_packages{
        for truck_package in shipping.sales_order_shipping_truck_packages.active
          xml.sales_order_shipping_truck_package do
            truck_package.attributes.each_pair{ |column_name,column_value|
              column_value = format_column(column_value)
              xml.tag!(column_name, column_value)
            }
          end
        end
      }
    end
  end
}


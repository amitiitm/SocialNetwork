xml.instruct! :xml, :version=>"1.0"

xml.sales_quotations{
  for sales_quotation in @quotations
    xml.sales_quotation do
      sales_quotation.attributes.each_pair{ |column_name,column_value|
        column_value = format_column(column_value)
        xml.tag!(column_name, column_value)
      }
      xml.sales_quotation_lines{
        sales_quotation_lines = Quotation::SalesQuotationLine.find_by_sql ["select * from sales_quotation_lines where trans_flag = 'A' and sales_quotation_id = #{sales_quotation.id}"]
        sales_quotation_lines.each{|sales_quotation_line|
          xml.sales_quotation_line do
            sales_quotation_line.attributes.each_pair{ |column_name,column_value|
              column_value = format_column(column_value)
              xml.tag!(column_name, column_value)
            }
            if sales_quotation_line.catalog_item
              xml.unit(sales_quotation_line.catalog_item.unit)
              xml.taxable(sales_quotation_line.catalog_item.taxable)
              xml.image_thumnail(sales_quotation_line.catalog_item.image_thumnail)
              xml.tier1(sales_quotation_line.catalog_item.column1)
              xml.tier2(sales_quotation_line.catalog_item.column2)
              xml.tier3(sales_quotation_line.catalog_item.column3)
              xml.tier4(sales_quotation_line.catalog_item.column4)
              xml.tier5(sales_quotation_line.catalog_item.column5)
              xml.tier6(sales_quotation_line.catalog_item.column6)
              xml.tier7(sales_quotation_line.catalog_item.column7)
              xml.tier8(sales_quotation_line.catalog_item.column8)
              xml.tier9(sales_quotation_line.catalog_item.column9)
              xml.tier10(sales_quotation_line.catalog_item.column10)
              xml.tier11(sales_quotation_line.catalog_item.column11)
              xml.tier12(sales_quotation_line.catalog_item.column12)
              xml.tier13(sales_quotation_line.catalog_item.column13)
              xml.tier14(sales_quotation_line.catalog_item.column14)
              xml.tier15(sales_quotation_line.catalog_item.column15)
            end
            xml.sales_quotation_attributes_values{
              for sales_quotation_attributes_value in sales_quotation_line.sales_quotation_attributes_values
                if (sales_quotation_attributes_value.trans_flag == 'A' and sales_quotation_attributes_value.catalog_item_id == sales_quotation_line.catalog_item_id and sales_quotation_attributes_value.sales_quotation_line_id.to_i == sales_quotation_line.id.to_i)
                  xml.sales_quotation_attributes_value do
                    sales_quotation_attributes_value.attributes.each_pair{ |column_name,column_value|
                      column_value = format_column(column_value)
                      xml.tag!(column_name, column_value)
                    }
                  end
                end
              end
            }
            xml.sales_quotation_line_charges{
              sales_quotation_line_charges = Quotation::SalesQuotationLineCharge.find_by_sql ["select * from sales_quotation_line_charges where trans_flag = 'A' and sales_quotation_line_id = #{sales_quotation_line.id}"]
              sales_quotation_line_charges.each{|sales_quotation_line_charge|
                xml.sales_quotation_line_charge do
                  sales_quotation_line_charge.attributes.each_pair{ |column_name,column_value|
                    column_value = format_column(column_value)
                    xml.tag!(column_name, column_value)
                  }
                end
              }
            }
          end
        }
      }

      xml.sales_quotation_shippings{
        sales_quotation_shippings = Quotation::SalesQuotationShipping.find_by_sql ["select * from sales_quotation_shippings where trans_flag = 'A' and sales_quotation_id = #{sales_quotation.id}"]
        sales_quotation_shippings.each{|sales_quotation_shipping|
          xml.sales_quotation_shipping do
            sales_quotation_shipping.attributes.each_pair{ |column_name,column_value|
              column_value = format_column(column_value)
              xml.tag!(column_name, column_value)
            }
          end
        }
      }
      xml.sales_quotation_transaction_activities{
        sales_quotation_transaction_activities = Quotation::SalesQuotationTransactionActivity.find_by_sql ["select * from sales_quotation_transaction_activities where trans_flag = 'A' and sales_quotation_id = #{sales_quotation.id}"]
        sales_quotation_transaction_activities.each{|sales_quotation_transaction_activity|
          xml.sales_quotation_transaction_activity do
            sales_quotation_transaction_activity.attributes.each_pair{ |column_name,column_value|
              column_value = format_column(column_value)
              xml.tag!(column_name, column_value) if column_name != 'activity_date'
            }
            xml.activity_date(sales_quotation_transaction_activity.activity_date.localtime.strftime('%Y-%m-%d %H:%M:%S'))
            user = Quotation::SalesQuotationTransactionActivity.find_by_sql("select email,first_name,last_name from users where id = #{sales_quotation_transaction_activity.user_id}") if sales_quotation_transaction_activity.user_id
            xml.user_name(user.first.first_name + ' '+ user.first.last_name) if user
          end
        }
      }
      ## this will give the customer specific default order setup price
      catalog_item = Item::CatalogItem.find_by_store_code('SETUP')
      @default_setup_items,@customer_prices = Item::PriceUtility.fetch_cust_specific_setup_item_price(catalog_item.id,sales_quotation.customer_id)
      xml << render(:template => 'setup/setup/fetch_default_setup_item')
      ## this will give third party shipping charges
      catalog_item = Item::CatalogItem.find_by_store_code('THIRDPARTYSHIPPINGCHARGE')
      @default_shipping_items,@customer_shipping_prices = Item::PriceUtility.fetch_cust_specific_setup_item_price(catalog_item.id,sales_quotation.customer_id)
      xml << render(:template => 'setup/setup/fetch_third_party_shipping_charge')
    end
  end
}


xml.instruct! :xml, :version=>"1.0"
xml.discount_coupons{
  for discount_coupon in @coupons
    xml.discount_coupon do
      if !discount_coupon.catalog_item_id.blank? and !discount_coupon.discount_type.blank?
        discount_coupon = fetch_discount_specific_prices(discount_coupon)
        if !discount_coupon.blank?
          discount_coupon.attributes.each_pair{ |column_name,column_value|
            column_value = format_column(column_value)
            xml.tag!(column_name, column_value)
          }
        else
          discount_coupon = @coupons[0]
          discount_coupon.attributes.each_pair{ |column_name,column_value|
            column_value = format_column(column_value)
            xml.tag!(column_name, column_value)
          }
        end
      else
        discount_coupon.attributes.each_pair{ |column_name,column_value|
          column_value = format_column(column_value)
          xml.tag!(column_name, column_value)
        }
      end
      xml.discount_coupon_charges{
        discount_coupon.discount_coupon_charges.each{|discount_coupon_charge|
          if discount_coupon_charge.trans_flag == 'A'
            xml.discount_coupon_charge do
              discount_coupon_charge.attributes.each_pair{ |column_name,column_value|
                column_value = format_column(column_value)
                xml.tag!(column_name, column_value)
              }
            end
          end
        }
      }

      xml.catalog_items do
        if !discount_coupon.catalog_item_id.blank?
          @catalog_items,@cust_prices = Item::PriceUtility.fetch_cust_specific_price(discount_coupon.catalog_item_id ,discount_coupon.customer_id)
          xml << render(:template => 'setup/setup/item_detail_sample_order')
        end
      end
    end 
  end
}
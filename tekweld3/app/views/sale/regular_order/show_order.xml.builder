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
      purchase_orders = Purchase::PurchaseOrder.find_by_sql ["select trans_no from purchase_orders where trans_flag = 'A' and trans_type = 'O' and ref_trans_no = #{sales_order.trans_no}"]
      xml.ref_po_no(purchase_orders[0].trans_no) if purchase_orders[0]
      discount_coupons = Setup::DiscountCoupon.find_by_sql("select COUNT(*) as count from discount_coupons where customer_id = #{sales_order.customer.id} AND
                                                            trans_flag ='A' AND ((no_of_uses - no_of_used) <> 0) AND approval_flag = 'Y' AND
                                                           (CONVERT(date,GETDATE(),101) between CONVERT(date,from_date,101) and CONVERT(date,to_date,101))") if sales_order.customer
      xml.coupon_count(discount_coupons.first.count) if discount_coupons[0]
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
            #            if sales_order_line.catalog_item
            #              xml.unit(sales_order_line.catalog_item.unit)
            #              xml.taxable(sales_order_line.catalog_item.taxable)
            #              xml.image_thumnail(sales_order_line.catalog_item.image_thumnail)
            #              xml.has_expired_date_flag(sales_order_line.catalog_item.has_expired_date_flag)
            #            end
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
      xml.discount_coupons{
        if !sales_order.coupon_code.blank?
          discount_coupons =  Setup::DiscountCoupon.find_by_sql ["select * from discount_coupons where trans_flag = 'A' and coupon_code = '#{sales_order.coupon_code}'"]
          discount_coupons.each{|discount_coupon|
            xml.discount_coupon do
              discount_coupon.attributes.each_pair{ |column_name,column_value|
                column_value = format_column(column_value)
                xml.tag!(column_name, column_value)
              }
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
            end
          }
        end
      }

      #      xml.sales_order_transaction_activities{
      #        sales_order_transaction_activities = Sales::SalesOrderTransactionActivity.find_by_sql ["select * from sales_order_transaction_activities where trans_flag = 'A' and sales_order_id = #{sales_order.id}"]
      #        sales_order_transaction_activities.each{|sales_order_transaction_activity|
      #          xml.sales_order_transaction_activity do
      #            sales_order_transaction_activity.attributes.each_pair{ |column_name,column_value|
      #              column_value = format_column(column_value)
      #              xml.tag!(column_name, column_value) if column_name != 'activity_date'
      #            }
      #            xml.activity_date(sales_order_transaction_activity.activity_date.localtime.strftime('%Y-%m-%d %H:%M:%S'))
      #            user = Sales::SalesOrderTransactionActivity.find_by_sql("select email,first_name,last_name from users where id = #{sales_order_transaction_activity.user_id}") if sales_order_transaction_activity.user_id
      #            xml.user_name(user.first.first_name + ' '+ user.first.last_name) if user
      #            xml.user_email(user.first.email) if user
      #          end
      #        }
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

      xml.sales_invoices{
        sales_invoices = Sales::SalesInvoice.find_by_sql ["select * from sales_invoices where ref_trans_no = #{sales_order.trans_no}"]
        sales_invoices.each{|sales_invoice|
          xml.sales_invoice do
            sales_invoice.attributes.each_pair{ |column_name,column_value|
              column_value = format_column(column_value)
              xml.tag!(column_name, column_value)
            }
          end
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
      ## this will give the customer specific default order setup price
      catalog_item = Item::CatalogItem.find_by_store_code('SETUP')
      @default_setup_items,@customer_prices = Item::PriceUtility.fetch_cust_specific_setup_item_price(catalog_item.id,sales_order.customer_id)
      xml << render(:template => 'setup/setup/fetch_default_setup_item')
      ## this will give third party shipping charges
      catalog_item = Item::CatalogItem.find_by_store_code('THIRDPARTYSHIPPINGCHARGE')
      @default_shipping_items,@customer_shipping_prices = Item::PriceUtility.fetch_cust_specific_setup_item_price(catalog_item.id,sales_order.customer_id)
      xml << render(:template => 'setup/setup/fetch_third_party_shipping_charge')
    end
  end
}



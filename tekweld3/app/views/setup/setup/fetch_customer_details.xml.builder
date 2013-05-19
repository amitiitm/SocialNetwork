xml.instruct! :xml, :version=>"1.0" 

xml.customers{
  for customer in @customers
    xml.customer do
      customer.attributes.each_pair{ |column_name,column_value|
        column_value = format_column(column_value)
        xml.tag!(column_name, column_value)
      }
      discount_coupons = Setup::DiscountCoupon.find_by_sql("select COUNT(*) as count from discount_coupons where customer_id = #{customer.id} AND
                                                            trans_flag ='A' AND ((no_of_uses - no_of_used) <> 0) AND
                                                            approval_flag = 'Y' AND
                                                           (CONVERT(date,GETDATE(),101) between CONVERT(date,from_date,101) and CONVERT(date,to_date,101))")
      xml.coupon_count(discount_coupons.first.count) if discount_coupons[0]
      customer_contact = Customer::CustomerContact.find_by_sql ["select (first_name + ' ' + last_name) as contact_name,business_phone,manager_phone,home_phone,cell_phone from customer_contacts where trans_flag = 'A' and default_contact_flag = 'Y' and customer_id = ?",customer.id]
      xml.contact_name(customer_contact[0].contact_name) if customer_contact[0]
      xml.business_phone(customer_contact[0].business_phone) if customer_contact[0]
      xml.cell_phone(customer_contact[0].cell_phone) if customer_contact[0]
      xml.term_code(customer.invoice_term_code) if @trans_type =='I'
      xml.term_code(customer.memo_term_code) if @trans_type =='M'
      if not customer.customer_shippings.blank?
        shipping = customer.customer_shippings.first
      else
        shipping = customer
      end 
      xml.shipping_code(customer.shipping.code) if customer.shipping 
      xml.customer_shipping_id(shipping.id)
      xml.customer_shipping_code(shipping.code) 
      xml.ship_name(shipping.name)
      xml.ship_address1(shipping.address1)
      xml.ship_address2(shipping.address2)
      xml.ship_city(shipping.city)
      xml.ship_state(shipping.state)
      xml.ship_zip(shipping.zip)
      xml.ship_country(shipping.country)
      xml.ship_phone(shipping.phone1)
      xml.ship_fax(shipping.fax1)
      xml.bill_address1(customer.address1)
      xml.bill_address2(customer.address2)
      xml.bill_city(customer.city)
      xml.bill_state(customer.state)
      xml.bill_zip(customer.zip)
      xml.bill_country(customer.country)
      xml.bill_phone(customer.phone1)
      xml.bill_fax(customer.fax1)
      xml.default_customer_third_party_account_number(customer.third_party_account_number)
      xml.default_customer_bill_transportation_to(customer.bill_transportation_to)
      xml.default_customer_shipping_code(customer.shipping_code)
      ## this will give the customer specific default order setup price
      catalog_item = Item::CatalogItem.find_by_store_code('SETUP')
      @default_setup_items,@customer_prices = Item::PriceUtility.fetch_cust_specific_setup_item_price(catalog_item.id,customer.id)
      xml << render(:template => 'setup/setup/fetch_default_setup_item')
      ## this will give third party shipping charges
      catalog_item = Item::CatalogItem.find_by_store_code('THIRDPARTYSHIPPINGCHARGE')
      @default_shipping_items,@customer_shipping_prices = Item::PriceUtility.fetch_cust_specific_setup_item_price(catalog_item.id,customer.id)
      xml << render(:template => 'setup/setup/fetch_third_party_shipping_charge')
    end
  end
}

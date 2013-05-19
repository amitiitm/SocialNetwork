xml.instruct! :xml, :version=>"1.0" 

xml.customer_shippings{
    for shipping in @shippings
    xml.customer_shippings do
      xml.shipping_code(shipping.code) 
      xml.customer_shipping_id(shipping.id)
      xml.ship_name(shipping.name)
      xml.ship_address1(shipping.address1)
      xml.ship_address2(shipping.address2)
      xml.ship_city(shipping.city)
      xml.ship_state(shipping.state)
      xml.ship_zip(shipping.zip)
      xml.ship_country(shipping.country)
      xml.ship_phone(shipping.phone1)
      xml.ship_fax(shipping.fax1)
   end
 end
}

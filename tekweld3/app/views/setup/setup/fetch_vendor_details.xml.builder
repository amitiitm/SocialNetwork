xml.instruct! :xml, :version=>"1.0" 

xml.vendors{
    for vendor in @vendors
    xml.vendor do
      vendor.attributes.each_pair{ |column_name,column_value|
        column_value = format_column(column_value)
        xml.tag!(column_name, column_value)
      }
      xml.term_code(vendor.invoice_term_code) if @trans_type =='I'
      xml.term_code(vendor.memo_term_code) if @trans_type =='M'
      #xml.shipping_code(vendor.shipping.code) if vendor.shipping 
      xml.vendor_shipping_id(vendor.id)
      xml.vendor_shipping_code(vendor.shipping_code) 
      xml.ship_name(vendor.name)
      xml.ship_address1(vendor.address1)
      xml.ship_address2(vendor.address2)
      xml.ship_city(vendor.city)
      xml.ship_state(vendor.state)
      xml.ship_zip(vendor.zip)
      xml.ship_country(vendor.country)
      xml.ship_phone(vendor.phone)
      xml.ship_fax(vendor.fax)
      xml.bill_address1(vendor.address1)
      xml.bill_address2(vendor.address2)
      xml.bill_city(vendor.city)
      xml.bill_state(vendor.state)
      xml.bill_zip(vendor.zip)
      xml.bill_country(vendor.country)
      xml.bill_phone(vendor.phone)
      xml.bill_fax(vendor.fax)
   end
 end
}

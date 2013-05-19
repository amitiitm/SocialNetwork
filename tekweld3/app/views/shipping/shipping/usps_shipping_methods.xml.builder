xml.instruct! :xml, :version=>"1.0"
xml.shipping_methods{
  count = 0
    @usps_shipping_methods.each{ |code|
      service_code = code.gsub(' ','_')
      insured_charge = 0.00
      negotiated_price = @usps_method_rates[count]
      xml.shipping_method{
        xml.service_code(service_code.upcase)
        xml.service_name(code)
        xml.negotiated_charge(@usps_method_rates[count])
        xml.delivery_date(@inhand_dates[count])
        xml.currency('USD')
        xml.insured_charge(insured_charge)
        type = Setup::Type.find_by_type_cd_and_subtype_cd('ship','shipping_markup')
        xml.price(negotiated_price.to_f + insured_charge.to_f + (negotiated_price.to_f * (type.value.to_f))/100)
        count = count + 1
      }
    }
}
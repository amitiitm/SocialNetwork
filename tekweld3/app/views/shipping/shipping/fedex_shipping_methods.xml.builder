xml.instruct! :xml, :version=>"1.0"
xml.shipping_methods{
  if @fedex_shipping_methods
    insured_charge = 0.0
    (@fedex_shipping_methods/'soapenv:Envelope'/'soapenv:Body'/'v10:RateReply'/'v10:RateReplyDetails').each{|shipping_method|
      service_code = parse_xml(shipping_method/'v10:ServiceType')
      delivery_timestamp = parse_xml(shipping_method/'v10:DeliveryTimestamp')
      delivery_timestamp = delivery_timestamp.gsub("-","/") if delivery_timestamp
      delivery_timestamp = delivery_timestamp.gsub("T"," ")if delivery_timestamp
      delivery_date = delivery_timestamp.to_date if delivery_timestamp
      delivery_date = delivery_date.strftime("%Y/%m/%d") if delivery_date
      currency = parse_xml(shipping_method/'v10:RatedShipmentDetails'/'v10:ShipmentRateDetail'/'v10:TotalNetCharge'/'v10:Currency')
      negotiated_price = parse_xml(shipping_method/'v10:RatedShipmentDetails'/'v10:ShipmentRateDetail'/'v10:TotalNetCharge'/'v10:Amount')
      (shipping_method/'v10:RatedShipmentDetails'/'v10:ShipmentRateDetail'/'v10:Surcharges').each{|surcharge|
        surcharge_type = parse_xml(surcharge/'v10:Surchargetype')
        if surcharge_type == 'INSURED_VALUE'
          insured_charge = parse_xml(surcharge/'v10:Amount'/'v10:Amount').to_f
        end
      }
      xml.shipping_method{
        xml.negotiated_charge(negotiated_price)
        xml.service_name(service_code)
        xml.service_code(service_code)
        xml.delivery_date(delivery_date) if delivery_date
        xml.currency(currency)
        type = Setup::Type.find_by_type_cd_and_subtype_cd('ship','shipping_markup')
        xml.price(negotiated_price.to_f + insured_charge.to_f + (negotiated_price.to_f * (type.value.to_f))/100)
        xml.insured_charge(insured_charge)
        if service_code == 'FEDEX_GROUND'
          transit_time = parse_xml(shipping_method/'v10:CommitDetails'/'v10:TransitTime')
          if(transit_time =~ /(.*)ONE(.*)/)
            delivery_date = @estimated_ship_date.advance(:days =>  1).strftime("%Y/%m/%d")
          elsif(transit_time =~ /(.*)TWO(.*)/)
            delivery_date = @estimated_ship_date.advance(:days =>  2).strftime("%Y/%m/%d")
          elsif(transit_time =~ /(.*)THREE(.*)/)
            delivery_date = @estimated_ship_date.advance(:days =>  3).strftime("%Y/%m/%d")
          elsif(transit_time =~ /(.*)FOUR(.*)/)
            delivery_date = @estimated_ship_date.advance(:days =>  4).strftime("%Y/%m/%d")
          elsif(transit_time =~ /(.*)FIVE(.*)/)
            delivery_date = @estimated_ship_date.advance(:days =>  5).strftime("%Y/%m/%d")
          elsif(transit_time =~ /(.*)SIX(.*)/)
            delivery_date = @estimated_ship_date.advance(:days =>  6).strftime("%Y/%m/%d")
          elsif(transit_time =~ /(.*)SEVEN(.*)/)
            delivery_date = @estimated_ship_date.advance(:days =>  7).strftime("%Y/%m/%d")
          elsif(transit_time =~ /(.*)EIGHT(.*)/)
            delivery_date = @estimated_ship_date.advance(:days =>  8).strftime("%Y/%m/%d")
          elsif(transit_time =~ /(.*)NINE(.*)/)
            delivery_date = @estimated_ship_date.advance(:days =>  9).strftime("%Y/%m/%d")
          else
            delivery_date = @estimated_ship_date.advance(:days =>  10).strftime("%Y/%m/%d")
          end
          xml.delivery_date(delivery_date)
        end
      }
    }
  end
}




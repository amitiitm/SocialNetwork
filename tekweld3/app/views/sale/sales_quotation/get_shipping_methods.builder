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
        ## in estimate there is no use of inhand date we can remove this if we want
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
elsif @ups_shipping_methods
  (@ups_shipping_methods/:RatingServiceSelectionResponse/:RatedShipment).each{|shipping_method|
    #      delivery_days = parse_xml(shipping_method/'GuaranteedDaysToDelivery')
    #      delivery_time = parse_xml(shipping_method/'ScheduledDeliveryTime')
    #      total_charge = parse_xml(shipping_method/:TotalCharges/'MonetaryValue')
    #      currency_code = parse_xml(shipping_method/:TotalCharges/'CurrencyCode')
    insured_charge = parse_xml(shipping_method/:ServiceOptionsCharges/'MonetaryValue') || 0
    #      insured_currency_code = parse_xml(shipping_method/:ServiceOptionsCharges/'CurrencyCode')
    negotiated_charge = parse_xml(shipping_method/:NegotiatedRates/:NetSummaryCharges/:GrandTotal/'MonetaryValue') || 0
    negotiated_currency_code = parse_xml(shipping_method/:NegotiatedRates/:NetSummaryCharges/:GrandTotal/'CurrencyCode')
    service_code = parse_xml(shipping_method/:Service/'Code')
    type = Setup::Type.find_by_type_cd_and_subtype_cd('ship','shipping_markup')
    xml.shipping_method{
      xml.service_code(service_code)
      xml.service_name("UPS Next Day Air") if service_code.to_i == 01
      xml.service_name("UPS Second Day Air") if service_code.to_i == 02
      xml.service_name("UPS Ground") if service_code.to_i == 03
      xml.service_name("UPS Worldwide Express") if service_code.to_i == 07
      xml.service_name("UPS Worldwide Expedited") if service_code.to_i == 8
      xml.service_name("UPS Standard") if service_code.to_i == 11
      xml.service_name("UPS Three-Day Select") if service_code.to_i == 12
      xml.service_name("UPS Next Day Air Saver") if service_code.to_i == 13
      xml.service_name("UPS Next Day Air Early A.M.") if service_code.to_i == 14
      xml.service_name("UPS Worldwide Express Plus") if service_code.to_i == 54
      xml.service_name("UPS Second Day Air A.M.") if service_code.to_i == 59
      xml.service_name("UPS Saver") if service_code.to_i == 65
      xml.service_name( "UPS Today Standard") if service_code.to_i == 82
      xml.service_name("UPS Today Dedicated Courier") if service_code.to_i == 83
      xml.service_name("UPS Today Intercity") if service_code.to_i == 84
      xml.service_name("UPS Today Express") if service_code.to_i == 85
      xml.service_name("UPS Today Express Saver") if service_code.to_i == 86
      xml.negotiated_charge((negotiated_charge.to_f))
      xml.insured_charge((insured_charge.to_f))
      xml.price(negotiated_charge.to_f + insured_charge.to_f + (negotiated_charge.to_f * (type.value.to_f))/100)
      xml.currency(negotiated_currency_code)
      #xml.delivery_date(Time.now.to_date + delivery_days.to_i.days) if service_code.to_i != 03
      xml.total_price("")
    }
  }
  elsif(@usps_shipping_methods and @usps_shipping_methods.to_s != '')
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
end
}



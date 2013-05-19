xml.instruct! :xml, :version=>"1.0" ## not in use 4 july by amit pandey
xml.shipping_methods{
  if @fedex_shipping_methods
    for fedex in @fedex_shipping_methods
      xml.shipping_method{
        xml.price((fedex.price)/100.00)
        xml.service_name(fedex.service_name)
        xml.delivery_date(fedex.delivery_date.to_date) if fedex.delivery_date
        xml.currency(fedex.currency)
        xml.service_code(fedex.service_code)
        xml.total_price(fedex.total_price)
        xml.negotiated_charge(0.00)
        xml.insured_charge(0.00)
      }
    end
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
      #      xml.shipping_method{
      #        xml.service_code(service_code)
      #        xml.service_name("UPS Next Day Air") if service_code.to_i == 01
      #        xml.service_name("UPS Second Day Air") if service_code.to_i == 02
      #        xml.service_name("UPS Ground") if service_code.to_i == 03
      #        xml.service_name("UPS Worldwide Express") if service_code.to_i == 07
      #        xml.service_name("UPS Worldwide Expedited") if service_code.to_i == 8
      #        xml.service_name("UPS Standard") if service_code.to_i == 11
      #        xml.service_name("UPS Three-Day Select") if service_code.to_i == 12
      #        xml.service_name("UPS Next Day Air Saver") if service_code.to_i == 13
      #        xml.service_name("UPS Next Day Air Early A.M.") if service_code.to_i == 14
      #        xml.service_name("UPS Worldwide Express Plus") if service_code.to_i == 54
      #        xml.service_name("UPS Second Day Air A.M.") if service_code.to_i == 59
      #        xml.service_name("UPS Saver") if service_code.to_i == 65
      #        xml.service_name( "UPS Today Standard") if service_code.to_i == 82
      #        xml.service_name("UPS Today Dedicated Courier") if service_code.to_i == 83
      #        xml.service_name("UPS Today Intercity") if service_code.to_i == 84
      #        xml.service_name("UPS Today Express") if service_code.to_i == 85
      #        xml.service_name("UPS Today Express Saver") if service_code.to_i == 86
      #        xml.negotiated_charge((negotiated_charge.to_f))
      #        xml.insured_charge((insured_charge.to_f))
      #        xml.price(negotiated_charge.to_f + insured_charge.to_f + (negotiated_charge.to_f * (type.value.to_f))/100)
      #        xml.currency(negotiated_currency_code)
      #        xml.delivery_date(Time.now.to_date + delivery_days.to_i.days) if service_code.to_i != 03
      #        xml.total_price("")
      (@ups_time_in_transit/:TimeInTransitResponse/:TransitResponse/:ServiceSummary).each{ |transit|
        code = parse_xml(transit/:Service/'Code')
        date = parse_xml(transit/:EstimatedArrival/'Date')
        if code.to_s == 'GND' and service_code.to_i == 03
          xml.shipping_method{
            xml.delivery_date(date.to_date.strftime('%Y/%m/%d'))
            xml.service_name("UPS Ground")
            xml.service_code(service_code)
            xml.total_price("")
            xml.negotiated_charge((negotiated_charge.to_f))
            xml.insured_charge((insured_charge.to_f))
            xml.price(negotiated_charge.to_f + insured_charge.to_f + (negotiated_charge.to_f * (type.value.to_f))/100)
            xml.currency(negotiated_currency_code)
          }
          break
        elsif code.to_s == '1DA' and service_code.to_i == 01
          xml.shipping_method{
            xml.delivery_date(date.to_date.strftime('%Y/%m/%d'))
            xml.service_name("UPS Next Day Air")
            xml.service_code(service_code)
            xml.total_price("")
            xml.negotiated_charge((negotiated_charge.to_f))
            xml.insured_charge((insured_charge.to_f))
            xml.price(negotiated_charge.to_f + insured_charge.to_f + (negotiated_charge.to_f * (type.value.to_f))/100)
            xml.currency(negotiated_currency_code)
          }
          break
        elsif code.to_s == '2DA' and service_code.to_i == 02
          xml.shipping_method{
            xml.delivery_date(date.to_date.strftime('%Y/%m/%d'))
            xml.service_name("UPS Second Day Air")
            xml.service_code(service_code)
            xml.total_price("")
            xml.negotiated_charge((negotiated_charge.to_f))
            xml.insured_charge((insured_charge.to_f))
            xml.price(negotiated_charge.to_f + insured_charge.to_f + (negotiated_charge.to_f * (type.value.to_f))/100)
            xml.currency(negotiated_currency_code)
          }
          break
        elsif code.to_s == '3DS' and service_code.to_i == 12
          xml.shipping_method{
            xml.delivery_date(date.to_date.strftime('%Y/%m/%d'))
            xml.service_name("UPS Three-Day Select")
            xml.service_code(service_code)
            xml.total_price("")
            xml.negotiated_charge((negotiated_charge.to_f))
            xml.insured_charge((insured_charge.to_f))
            xml.price(negotiated_charge.to_f + insured_charge.to_f + (negotiated_charge.to_f * (type.value.to_f))/100)
            xml.currency(negotiated_currency_code)
          }
          break
        elsif code.to_s == '1DP' and service_code.to_i == 13
          xml.shipping_method{
            xml.delivery_date(date.to_date.strftime('%Y/%m/%d'))
            xml.service_name("UPS Next Day Air Saver")
            xml.service_code(service_code)
            xml.total_price("")
            xml.negotiated_charge((negotiated_charge.to_f))
            xml.insured_charge((insured_charge.to_f))
            xml.price(negotiated_charge.to_f + insured_charge.to_f + (negotiated_charge.to_f * (type.value.to_f))/100)
            xml.currency(negotiated_currency_code)
          }
          break
        elsif code.to_s == '1DM' and service_code.to_i == 14
          xml.shipping_method{
            xml.delivery_date(date.to_date.strftime('%Y/%m/%d'))
            xml.service_name("UPS Next Day Air Early A.M.")
            xml.service_code(service_code)
            xml.total_price("")
            xml.negotiated_charge((negotiated_charge.to_f))
            xml.insured_charge((insured_charge.to_f))
            xml.price(negotiated_charge.to_f + insured_charge.to_f + (negotiated_charge.to_f * (type.value.to_f))/100)
            xml.currency(negotiated_currency_code)
          }
          break
        elsif code.to_s == '2DM' and service_code.to_i == 59
          xml.shipping_method{
            xml.delivery_date(date.to_date.strftime('%Y/%m/%d'))
            xml.service_name("UPS Second Day Air A.M.")
            xml.service_code(service_code)
            xml.total_price("")
            xml.negotiated_charge((negotiated_charge.to_f))
            xml.insured_charge((insured_charge.to_f))
            xml.price(negotiated_charge.to_f + insured_charge.to_f + (negotiated_charge.to_f * (type.value.to_f))/100)
            xml.currency(negotiated_currency_code)
          }
          break
          #          else
          #            xml.delivery_date(Time.now.to_date + 7.days)
          #            break
        end
      }
      #      }
    }
  end
}



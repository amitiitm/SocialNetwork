xml.instruct! :xml, :version=>"1.0"
xml.shipping_methods{
  if @ups_shipping_methods
    (@ups_shipping_methods/:RatingServiceSelectionResponse/:RatedShipment).each{|shipping_method|
      insured_charge = parse_xml(shipping_method/:ServiceOptionsCharges/'MonetaryValue') || 0
      #      insured_currency_code = parse_xml(shipping_method/:ServiceOptionsCharges/'CurrencyCode')
      negotiated_charge = parse_xml(shipping_method/:NegotiatedRates/:NetSummaryCharges/:GrandTotal/'MonetaryValue') || 0
      negotiated_currency_code = parse_xml(shipping_method/:NegotiatedRates/:NetSummaryCharges/:GrandTotal/'CurrencyCode')
      service_code = parse_xml(shipping_method/:Service/'Code')
      type = Setup::Type.find_by_type_cd_and_subtype_cd('ship','shipping_markup')
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
        end
      }
    }
  end
}
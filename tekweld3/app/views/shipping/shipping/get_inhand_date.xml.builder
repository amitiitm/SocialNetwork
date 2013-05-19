xml.instruct! :xml, :version=>"1.0"
if @ups_time_in_transit
  (@ups_time_in_transit/:TimeInTransitResponse/:TransitResponse/:ServiceSummary).each{ |transit|
    code = parse_xml(transit/:Service/'Code')
    date = parse_xml(transit/:EstimatedArrival/'Date')
    if code.to_s == 'GND' and @ship_method_code.to_i == 03
      xml.inhand_date(date.to_date.strftime('%Y/%m/%d'))
      break
    elsif code.to_s == '1DA' and @ship_method_code.to_i == 01
      xml.inhand_date(date.to_date.strftime('%Y/%m/%d'))
      break
    elsif code.to_s == '2DA' and @ship_method_code.to_i == 02
      xml.inhand_date(date.to_date.strftime('%Y/%m/%d'))
      break
    elsif code.to_s == '3DS' and @ship_method_code.to_i == 12
      xml.inhand_date(date.to_date.strftime('%Y/%m/%d'))
      break
    elsif code.to_s == '1DP' and @ship_method_code.to_i == 13
      xml.inhand_date(date.to_date.strftime('%Y/%m/%d'))
      break
    elsif code.to_s == '1DM' and @ship_method_code.to_i == 14
      xml.inhand_date(date.to_date.strftime('%Y/%m/%d'))
      break
    elsif code.to_s == '2DM' and @ship_method_code.to_i == 59
      xml.inhand_date(date.to_date.strftime('%Y/%m/%d'))
      break
#    else
#      xml.inhand_date(Time.now.to_date + 7.days)
#      break
    end
  }
end
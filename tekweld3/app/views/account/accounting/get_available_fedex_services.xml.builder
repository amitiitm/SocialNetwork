xml.instruct! :xml, :version=>"1.0" 

xml.fedex_services{
  for fedex in @orders
    #    xml.fedex_service do
    #      fedex.attributes.each_pair{ |column_name,column_value|
    #        column_value = format_column(column_value)
    #        xml.tag!(column_name, column_value)
    #      }
    #    end
    
    
    xml.fedex_service{
      xml.price(fedex.price)
      xml.service_name(fedex.service_name)
      xml.delivery_date(fedex.delivery_date.to_date)
      xml.currency(fedex.currency)
      xml.service_code(fedex.service_code)
      xml.total_price(fedex.total_price)
    }  
  end
}

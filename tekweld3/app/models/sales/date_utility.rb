class Sales::DateUtility
  include General
  
  ##################### Ship Date Change in Sales Order Shipping Logic ##########################
  ## function which fires email with attachment whenever ship date is changed
  def self.check_ship_date_change(doc,order,schema_name,url_with_port)
    begin
      (doc/:sales_order_shippings/:sales_order_shipping).each{|shipping|
        ship_id =  parse_xml(shipping/'id') if (shipping/'id').first
        internal_ship_date =  parse_xml(shipping/'internal_ship_date') if (shipping/'internal_ship_date').first
        if ship_id.to_i > 0 and internal_ship_date != ''
          shipping_order_line = Sales::SalesOrderShipping.find_by_id(ship_id)
          if  (shipping_order_line.internal_ship_date and (shipping_order_line.internal_ship_date.to_date.strftime("%Y-%m-%d 00:00:00") != internal_ship_date.to_date.strftime("%Y-%m-%d 00:00:00")))
            pdf_file_name_path = generate_shipdate_change_pdf(order.id,ship_id,schema_name,internal_ship_date)
            email = Email::Email.send_email('SHIPDATEALERT',order)
            email.file_name_path = pdf_file_name_path
            email.save!
            activity_message = Artwork::ArtworkCrud.create_activity_message(order,'SHIP DATE CHANGED')
            activity = order.create_sales_order_transaction_activity(activity_message)
            activity.save!
            break
          end
        end
      }
    rescue Exception => ex
      return ex
    end
  end

  def self.generate_shipdate_change_pdf(order_id,shipping_id,schema_name,internal_ship_date)
    pdf = Prawn::Document.new
    logopath = "#{Rails.root}/public/images/#{schema_name}/blank.jpg"
    pdf.image logopath, :width => 200, :height => 60
    pdf.draw_text("SHIP DATE ALERT!",:at=>[250,680],:size => 32,:style => :bold)
    pdf.move_down(20)
    sales_order = Sales::SalesOrder.find_by_id(order_id)
    sales_order_shipping = Sales::SalesOrderShipping.find_by_id(shipping_id)
    return if !sales_order_shipping
    customer_po = sales_order.ext_ref_no
    trans_no = sales_order.trans_no
    pdf.table( [["ORDER", "#{trans_no}"]],:cell_style => { :width => 120,:align=> :center,:font_style => :bold }) do
      style(column(0), :background_color => 'C0C0C0',:border_right_width => 2)
    end
    pdf.move_down(5)
    pdf.table( [["CUSTOMER PO#", "#{customer_po}"]],:cell_style => { :width => 120,:align=> :center,:font_style => :bold  }) do
      style(column(0), :background_color => 'C0C0C0',:border_right_width => 2)
    end
    pdf.move_down(5)
    pdf.table([ ["NEW SHIP DATE", "#{internal_ship_date.to_date}"]],:cell_style => { :width => 120,:align=> :center,:font_style => :bold }) do
      style(column(0), :background_color => 'C0C0C0',:border_right_width => 2)
    end
    pdf.move_down(5)
    pdf.table( [ ["SHIP METHOD", "#{sales_order_shipping.ship_method}"]],:cell_style => { :width => 120,:align=> :center,:font_style => :bold }) do
      style(column(0), :background_color => 'C0C0C0',:border_right_width => 2)
    end
    pdf.move_down(5)
    pdf.text_box("Please note: Production time is 3 business
                           days from approved artwork.
                           Changes in ship date can occur due to Credit
                           Hold,Ackowledgement Hold,orArtwork Hold.
                           Please contact customer service at
                           631-694-5503 if an explanation is requried.", :at => [250,630],:align => :center,:style =>:bold)
    path = Setup::Type.find(:first, :conditions=>['type_cd = ? and subtype_cd = ?','UPLOAD_FOLDER','REPORT_PRINT'])
    if path
      directory =  "#{Dir.getwd}" + path.value + schema_name
    end
    filename = "#{Time.now().strftime('%Y%m%d%H%M%S')}"
    absolute_filename = File.join(directory, filename)+ "." + "pdf"
    pdf.render_file "#{absolute_filename}"
    return absolute_filename
  end




  ##################### Estimated Ship Dates and InHand Dates Calculation Logic ########
  def self.calculate_estimated_ship_date_and_inhand_dates(doc)
    catalog_item_id  = parse_xml(doc/:sales_order/'catalog_item_id')
    company_id = parse_xml(doc/:sales_order/'company_id')
    ext_ref_date  = parse_xml(doc/:sales_order/'ext_ref_date')
    customer_id  = parse_xml(doc/:sales_order/'customer_id')
    item_qty  = parse_xml(doc/:sales_order/'item_qty')
    rushday  = parse_xml(doc/:sales_order/'rushday')
    next_day_flag  = parse_xml(doc/:sales_order/'next_day_flag')
    paper_proof_flag  = parse_xml(doc/:sales_order/'paper_proof_flag')
    blank_order_flag = parse_xml(doc/:sales_order/'blank_order_flag')
    estimated_ship_date = calculate_estimated_ship_date(catalog_item_id,ext_ref_date,customer_id,item_qty,rushday,next_day_flag,paper_proof_flag,blank_order_flag)
    calculate_inhand_dates(doc,estimated_ship_date,catalog_item_id,company_id)
  end

  def self.calculate_inhand_dates(doc,estimated_ship_date,catalog_item_id,company_id)
    xml = ""
    (doc/:sales_order/:sales_order_shippings/:sales_order_shipping).each{|shipping|
      unique_no = parse_xml(shipping/'unique_no')
      shipping_code = parse_xml(shipping/'shipping_code')
      ship_method_code = parse_xml(shipping/'ship_method_code')
      ship_state = parse_xml(shipping/'ship_state')
      ship_zip = parse_xml(shipping/'ship_zip')
      ship_country = parse_xml(shipping/'ship_country')
      if ship_method_code != ''
        if shipping_code == 'UPS'
          response,result = get_ups_inhand_dates(unique_no,ship_zip,ship_country,ship_state,estimated_ship_date,ship_method_code,catalog_item_id,company_id)
          return response if result == 'error'
        elsif shipping_code == 'FEDEX'
          response,result = get_fedex_inhand_dates(shipping,unique_no,ship_zip,ship_country,ship_state,estimated_ship_date,ship_method_code,catalog_item_id,company_id)
          return response if result == 'error'
        elsif shipping_code == 'USPS'
          response,result = get_usps_inhand_dates(unique_no,ship_method_code,ship_zip,estimated_ship_date,catalog_item_id,company_id)
          return response if result == 'error'
        end
        xml = xml + response
      else
        xml = xml + "<sales_order_shipping><unique_no>#{unique_no}</unique_no><estimated_ship_date>#{estimated_ship_date}</estimated_ship_date><estimated_arrival_date/></sales_order_shipping>"
      end
    }
    "<sales_order_shippings>#{xml}</sales_order_shippings>"
  end

  def self.get_ups_inhand_dates(unique_no,ship_zip,ship_country,ship_state,estimated_ship_date,ship_method_code,catalog_item_id,company_id)
    xml = ""
    inhand_date_xml = "<params><zip_code>#{ship_zip}</zip_code><country>#{ship_country}</country><state>#{ship_state}</state><estimated_ship_date>#{estimated_ship_date}</estimated_ship_date><catalog_item_id>#{catalog_item_id}</catalog_item_id><company_id>#{company_id}</company_id></params>"
    doc = Hpricot::XML(inhand_date_xml)
    response_doc,text = Shipping::Ups.get_ups_time_in_transit(doc)
    if text == 'error'
      return "<errors><error>#{response_doc}</error></errors>",'error'
    else
      ups_time_in_transit = Hpricot::XML(response_doc)
      response_status_code = parse_xml(ups_time_in_transit/:TimeInTransitResponse/:Response/'ResponseStatusCode')  if parse_xml(ups_time_in_transit/:TimeInTransitResponse/:Response/'ResponseStatusCode').first
      if response_status_code.to_i == 1
        estimated_inhand_date = match_inhand_date_with_ship_method(ups_time_in_transit,ship_method_code)
        xml = xml + "<sales_order_shipping><unique_no>#{unique_no}</unique_no><estimated_ship_date>#{estimated_ship_date}</estimated_ship_date><estimated_arrival_date>#{estimated_inhand_date}</estimated_arrival_date></sales_order_shipping>"
        return xml,'success'
      else
        error_description = parse_xml(ups_time_in_transit/:TimeInTransitResponse/:Response/:Error/'ErrorDescription')  if parse_xml(ups_time_in_transit/:TimeInTransitResponse/:Response/:Error/'ErrorDescription').first
        return "<errors><error>#{error_description}</error></errors>",'error'
      end
    end
  end

  def self.get_fedex_inhand_dates(sales_order_shipping,unique_no,ship_zip,ship_country,ship_state,estimated_ship_date,ship_method_code,catalog_item_id,company_id)
    package_xml = "<sales_order_shipping_packages>"
    xml = ""
    (sales_order_shipping/:sales_order_shipping_packages/:sales_order_shipping_package).each {|package|
      carton_wt = parse_xml(package/'carton_wt').to_i
      carton_length = parse_xml(package/'carton_length').to_i
      carton_width = parse_xml(package/'carton_width').to_i
      carton_height = parse_xml(package/'carton_height').to_i
      xml = xml + "<sales_order_shipping_package>
                                       <carton_wt>#{carton_wt}</carton_wt>
                                       <carton_length>#{carton_length}</carton_length>
                                       <carton_width>#{carton_width}</carton_width>
                                       <carton_height>#{carton_height}</carton_height>
                                       <insured_charge>100</insured_charge>
                                    </sales_order_shipping_package>"
    }
    package_xml = package_xml + xml + "</sales_order_shipping_packages>"

    fedex_inhand_date_xml = %{
                              <params>
                                <zip_code>#{ship_zip}</zip_code>
                                <country>#{ship_country}</country>
                                <state>#{ship_state}</state>
                                <estimated_ship_date>#{estimated_ship_date}</estimated_ship_date>
                                <catalog_item_id>#{catalog_item_id}</catalog_item_id>
                                <company_id>#{company_id}</company_id>
                                <packagexml>#{package_xml}</packagexml>
                              </params>
    }
    doc = Hpricot::XML(fedex_inhand_date_xml)
    response_doc,message = Shipping::Fedex.get_fedex_methods_xml(doc)
    return "<errors><error>#{response_doc}</error></errors>",'error' if message != 'success'
    if response_doc
      estimated_inhand_date = ''
      xml = ''
      (response_doc/'soapenv:Envelope'/'soapenv:Body'/'v10:RateReply'/'v10:RateReplyDetails').each{|shipping_method|
        service_code = parse_xml(shipping_method/'v10:ServiceType')
        if service_code == ship_method_code.to_s
          estimated_ship_date = estimated_ship_date.to_date
          delivery_timestamp = parse_xml(shipping_method/'v10:DeliveryTimestamp')
          delivery_timestamp = delivery_timestamp.gsub("-","/") if delivery_timestamp
          delivery_timestamp = delivery_timestamp.gsub("T"," ")if delivery_timestamp
          delivery_date = delivery_timestamp.to_date if delivery_timestamp
          estimated_inhand_date = delivery_date.strftime("%Y/%m/%d") if delivery_date
          if service_code == 'FEDEX_GROUND'
            transit_time = parse_xml(shipping_method/'v10:CommitDetails'/'v10:TransitTime')
            if(transit_time =~ /(.*)ONE(.*)/)
              delivery_date = estimated_ship_date.advance(:days =>  1).strftime("%Y/%m/%d")
            elsif(transit_time =~ /(.*)TWO(.*)/)
              delivery_date = estimated_ship_date.advance(:days =>  2).strftime("%Y/%m/%d")
            elsif(transit_time =~ /(.*)THREE(.*)/)
              delivery_date = estimated_ship_date.advance(:days =>  3).strftime("%Y/%m/%d")
            elsif(transit_time =~ /(.*)FOUR(.*)/)
              delivery_date = estimated_ship_date.advance(:days =>  4).strftime("%Y/%m/%d")
            elsif(transit_time =~ /(.*)FIVE(.*)/)
              delivery_date = estimated_ship_date.advance(:days =>  5).strftime("%Y/%m/%d")
            elsif(transit_time =~ /(.*)SIX(.*)/)
              delivery_date = estimated_ship_date.advance(:days =>  6).strftime("%Y/%m/%d")
            elsif(transit_time =~ /(.*)SEVEN(.*)/)
              delivery_date = estimated_ship_date.advance(:days =>  7).strftime("%Y/%m/%d")
            elsif(transit_time =~ /(.*)EIGHT(.*)/)
              delivery_date = estimated_ship_date.advance(:days =>  8).strftime("%Y/%m/%d")
            elsif(transit_time =~ /(.*)NINE(.*)/)
              delivery_date = estimated_ship_date.advance(:days =>  9).strftime("%Y/%m/%d")
            else
              delivery_date = estimated_ship_date.advance(:days =>  10).strftime("%Y/%m/%d")
            end
            estimated_inhand_date = delivery_date
          end
          break
        end
      }
      xml = xml + "<sales_order_shipping><unique_no>#{unique_no}</unique_no><estimated_ship_date>#{estimated_ship_date}</estimated_ship_date><estimated_arrival_date>#{estimated_inhand_date}</estimated_arrival_date></sales_order_shipping>"
      return xml,'success'
    end
  end

  ## we are making this dummy package xml for fedex bcos we dont have packages while calculating inhand dates.
  def self.get_fedex_dummy_package_xml
    fedex_inhand_date_xml = %{
                                  <sales_order_shipping>
                                    <sales_order_shipping_packages>
                                        <sales_order_shipping_package>
                                          <carton_wt>5</carton_wt>
                                          <carton_length>5</carton_length>
                                          <carton_width>5</carton_width>
                                          <carton_height>5</carton_height>
                                        </sales_order_shiping_package>
                                    </sales_order_shipping_packages>
                               </sales_order_shipping>                            
    }
    return fedex_inhand_date_xml
  end

  def self.get_usps_inhand_dates(unique_no,ship_method,zip_destination,estimated_ship_date,catalog_item_id,company_id)
    shipfrom_name,shipfrom_address1,shipfrom_address2,shipfrom_city,shipfrom_state,shipfrom_zip,shipfrom_phone,shipfrom_country = Shipping::ShippingCrud.get_ship_from_address(catalog_item_id,company_id)
    xml = ""
    @config = YAML::load(File.open("#{Rails.root}/config/settings.yml"))
    userid = @config["usps_userid"]
    ship_date = estimated_ship_date.to_date.strftime("%d-%b-%Y")
    if(ship_method =~ /(.*)Express(.*)/i)
      request_name = 'ExpressMailCommitment'
    elsif(ship_method =~ /(.*)Priority(.*)/i)
      request_name = 'PriorityMail'
    elsif(ship_method =~ /(.*)First(.*)/i)
      request_name = 'FirstClass'
    else
      request_name = 'StandardB'
    end
    shipfrom_zip = shipfrom_zip[0..4]
    xml_string = "<#{request_name}Request USERID='#{userid}'>"
    xml_string = xml_string + "<OriginZIP>#{shipfrom_zip}</OriginZIP>"
    xml_string = xml_string + "<DestinationZIP>#{zip_destination}</DestinationZIP>"
    xml_string = xml_string + "<Date>#{ship_date}</Date>"
    xml_string = xml_string + "</#{request_name}Request>"
    path = "http://production.shippingapis.com/ShippingAPI.dll"
    query = "API=#{request_name}&XML=#{xml_string}"
    uri = URI.parse path
    http = Net::HTTP.new(uri.host,uri.port)
    response =  http.post(uri.path,query)
    response_body = response.body
    response_doc = Hpricot::XML(response_body)
    error_description = parse_xml(response_doc/'Error'/'Description') if parse_xml(response_doc/'Error'/'Description')
    if error_description
      return "<errors><error>#{error_description}</error></errors>",'error'
    else
      if(ship_method =~ /(.*)Express(.*)/i)
        days = parse_xml(response_doc/'ExpressMailCommitmentResponse'/'Commitment'/'CommitmentName')
      else
        days = parse_xml(response_doc/"#{request_name}Response"/'Days') if parse_xml(response_doc/"#{request_name}Response"/'Days')
      end
      if(days =~ /(.*)1(.*)/ || days =~ /(.*)Next(.*)/ || days =~ /(.*)One(.*)/ )
        estimated_inhand_date = estimated_ship_date.to_date.advance(:days =>  1).strftime("%Y/%m/%d")
      elsif(days =~ /(.*)2(.*)/  || days =~ /(.*)Two(.*)/ )
        estimated_inhand_date = estimated_ship_date.to_date.advance(:days =>  2).strftime("%Y/%m/%d")
      elsif(days =~ /(.*)3(.*)/  || days =~ /(.*)Three(.*)/ )
        estimated_inhand_date = estimated_ship_date.to_date.advance(:days =>  3).strftime("%Y/%m/%d")
      elsif(days =~ /(.*)4(.*)/  || days =~ /(.*)Four(.*)/ )
        estimated_inhand_date = estimated_ship_date.to_date.advance(:days =>  4).strftime("%Y/%m/%d")
      elsif(days =~ /(.*)5(.*)/  || days =~ /(.*)Five(.*)/ )
        estimated_inhand_date = estimated_ship_date.to_date.advance(:days =>  5).strftime("%Y/%m/%d")
      elsif(days =~ /(.*)6(.*)/  || days =~ /(.*)Six(.*)/ )
        estimated_inhand_date = estimated_ship_date.to_date.advance(:days =>  6).strftime("%Y/%m/%d")
      elsif(days =~ /(.*)7(.*)/  || days =~ /(.*)Seven(.*)/ )
        estimated_inhand_date = estimated_ship_date.to_date.advance(:days =>  7).strftime("%Y/%m/%d")
      elsif(days =~ /(.*)8(.*)/  || days =~ /(.*)Eight(.*)/ )
        estimated_inhand_date = estimated_ship_date.to_date.advance(:days =>  8).strftime("%Y/%m/%d")
      elsif(days =~ /(.*)9(.*)/  || days =~ /(.*)Nine(.*)/ )
        estimated_inhand_date = estimated_ship_date.to_date.advance(:days =>  9).strftime("%Y/%m/%d")
      else
        estimated_inhand_date = estimated_ship_date.to_date.advance(:days =>  10).strftime("%Y/%m/%d")
      end
      xml = xml + "<sales_order_shipping><unique_no>#{unique_no}</unique_no><estimated_ship_date>#{estimated_ship_date}</estimated_ship_date><estimated_arrival_date>#{estimated_inhand_date}</estimated_arrival_date></sales_order_shipping>"
    end
    return xml , 'success'
  end

  def self.match_inhand_date_with_ship_method(ups_time_in_transit,ship_method_code)
    (ups_time_in_transit/:TimeInTransitResponse/:TransitResponse/:ServiceSummary).each{ |transit|
      code = parse_xml(transit/:Service/'Code')
      date = parse_xml(transit/:EstimatedArrival/'Date')
      if code.to_s == 'GND' and ship_method_code.to_i == 03
        return (date.to_date.strftime('%Y/%m/%d'))
      elsif code.to_s == '1DA' and ship_method_code.to_i == 01
        return (date.to_date.strftime('%Y/%m/%d'))
      elsif code.to_s == '2DA' and ship_method_code.to_i == 02
        return (date.to_date.strftime('%Y/%m/%d'))
      elsif code.to_s == '3DS' and ship_method_code.to_i == 12
        return(date.to_date.strftime('%Y/%m/%d'))
      elsif code.to_s == '1DP' and ship_method_code.to_i == 13
        return(date.to_date.strftime('%Y/%m/%d'))
      elsif code.to_s == '1DM' and ship_method_code.to_i == 14
        return(date.to_date.strftime('%Y/%m/%d'))
      elsif code.to_s == '2DM' and ship_method_code.to_i == 59
        return(date.to_date.strftime('%Y/%m/%d'))
      end
    }
  end

  ##################### Estimated Ship Date Calculation Logic ##########################
  def self.calculate_estimated_ship_date_and_packages(doc)
    catalog_item_id  = parse_xml(doc/:params/'catalog_item_id')
    ext_ref_date  = parse_xml(doc/:params/'ext_ref_date')
    customer_id  = parse_xml(doc/:params/'customer_id')
    item_qty  = parse_xml(doc/:params/'item_qty')
    ship_qty  = parse_xml(doc/:params/'ship_qty')
    rushday  = parse_xml(doc/:params/'rushday')
    next_day_flag  = parse_xml(doc/:params/'next_day_flag')
    paper_proof_flag  = parse_xml(doc/:params/'paper_proof_flag')
    blank_order_flag  = parse_xml(doc/:params/'blank_order_flag')
    estimated_ship_date = calculate_estimated_ship_date(catalog_item_id,ext_ref_date,customer_id,item_qty,rushday,next_day_flag,paper_proof_flag,blank_order_flag)
    #calculate item ship packages
    if (catalog_item_id and ship_qty)
      catalog_item_packages = Item::CatalogItemPackage.find_by_sql ["select * from catalog_item_packages where catalog_item_id = ? and trans_flag = 'A' order by pcs_per_carton",catalog_item_id]
      if !catalog_item_packages[0]
        "<estimated_ship_date>#{estimated_ship_date}</estimated_ship_date><sales_order_shipping_packages></sales_order_shipping_packages>"
      else
        packaging_xml = create_shipping_package_xml(ship_qty,catalog_item_packages)
        "<estimated_ship_date>#{estimated_ship_date}</estimated_ship_date><sales_order_shipping_packages>#{packaging_xml}</sales_order_shipping_packages>"
      end
    end
  end


  def self.calculate_estimated_ship_date(catalog_item_id,ext_ref_date,customer_id,item_qty,rushday,next_day_flag,paper_proof_flag,blank_order_flag)
    # Determine the production days (production item , rush order, sample item)
    if (catalog_item_id and customer_id and item_qty and ext_ref_date and catalog_item_id != '' and blank_order_flag != 'Y')
      if (rushday == '' || rushday == nil)
        production_days =  fetch_production_days(catalog_item_id,customer_id,item_qty.to_i)
      else ## this code will run only when item does not contain production day and bucket by default we have taken production day as 2.
        production_days = rushday =~ (/RUSHDAY1(.*)/) ? 1 : rushday =~ (/RUSHDAY2(.*)/) ? 2 : 0
      end
    else ## this else is for sample orders bcos there are multiple items with qty 1 so for which item production day should calculate we dont know and regular blank orders(no production in blank orders)
      production_days =  1
    end
    paper_proof_days = paper_proof_flag == 'Y'? 1 : 0
    next_day = next_day_flag == 'Y'? 1 : 0
    total_holidays = fetch_holidays(ext_ref_date,(production_days+paper_proof_days+next_day))
    estimated_ship_date = ext_ref_date.to_date + (production_days + total_holidays + paper_proof_days + next_day).to_i.days
    estimated_ship_date = calculate_holidays(estimated_ship_date)
    estimated_ship_date = estimated_ship_date.strftime('%Y/%m/%d')
  end


  def self.fetch_holidays(ext_ref_date,production_days)
    total_holidays_obj = Setup::Holiday.find_by_sql ["select COUNT(*) as total_holiday from holidays where trans_flag = 'A' and holiday_date between CONVERT(VARCHAR(10),'#{ext_ref_date}',101) and dateadd(dd,#{production_days.to_i},'#{ext_ref_date}') "]
    total_holidays_obj[0].total_holiday.to_i
  end

  def self.calculate_holidays(estimated_ship_date)
    begin
      holidays = Setup::Holiday.find_by_sql ["select COUNT(*) as total_holiday from holidays where trans_flag = 'A' and  holiday_date between CONVERT(VARCHAR(10),'#{estimated_ship_date}',101) and CONVERT(VARCHAR(10),'#{estimated_ship_date}',101) "]
      estimated_ship_date = (estimated_ship_date.to_date + 1.days) if holidays[0].total_holiday != 0
    end while holidays[0].total_holiday != 0
    return estimated_ship_date
  end

  def self.fetch_production_days(catalog_item_id,customer_id,item_qty)
    production_days = fetch_customer_specific_production_days(catalog_item_id,customer_id,item_qty)
    production_days = fetch_item_production_days(catalog_item_id,item_qty) if production_days == 0
    production_days == 0 ? 3 : production_days
  end

  def self.fetch_customer_specific_production_days(catalog_item_id,customer_id,item_qty)
    customer_item_production_days = Customer::CustomerItemProductionDay.find_by_sql ["select * from customer_item_production_days where catalog_item_id = #{catalog_item_id} AND customer_id = #{customer_id} AND trans_flag = 'A'"]
    if !customer_item_production_days[0]
      all_item_id = Item::CatalogItem.find_by_store_code('ALL')
      if all_item_id ; item_id = all_item_id.id.to_i ; else ; item_id = 0 ; end
      customer_item_production_days = Customer::CustomerItemProductionDay.find_by_sql ["select * from customer_item_production_days where catalog_item_id = #{item_id} AND customer_id = #{customer_id} AND trans_flag = 'A'"]
    end
    if customer_item_production_days[0]
      match_bucket_size(item_qty,catalog_item_id,customer_item_production_days[0])
    else
      0
    end
  end

  def self.fetch_item_production_days(catalog_item_id,item_qty)
    item_production_days = Item::CatalogItemProductionDay.active.find_by_catalog_item_id(catalog_item_id)
    match_bucket_size(item_qty,catalog_item_id,item_production_days)
  end

  def self.match_bucket_size(item_qty,catalog_item_id,production_days_obj)
    item_bucket = Item::CatalogItem.find_by_id(catalog_item_id)
    if production_days_obj
      if (item_qty <= item_bucket.column1)
        return production_days_obj.production_day1
      elsif (item_qty <= item_bucket.column2)
        return production_days_obj.production_day2
      elsif item_qty <= item_bucket.column3
        return production_days_obj.production_day3
      elsif (item_qty <= item_bucket.column4)
        return production_days_obj.production_day4
      elsif (item_qty <= item_bucket.column5)
        return production_days_obj.production_day5
      elsif (item_qty <= item_bucket.column6)
        return production_days_obj.production_day6
      elsif (item_qty <= item_bucket.column7)
        return production_days_obj.production_day7
      elsif (item_qty <= item_bucket.column8)
        return production_days_obj.production_day8
      elsif (item_qty <= item_bucket.column9)
        return production_days_obj.production_day9
      elsif (item_qty <= item_bucket.column10)
        return production_days_obj.production_day10
      elsif (item_qty <= item_bucket.column11)
        return production_days_obj.production_day11
      elsif (item_qty <= item_bucket.column12)
        return production_days_obj.production_day12
      elsif (item_qty <= item_bucket.column13)
        return production_days_obj.production_day13
      elsif (item_qty <= item_bucket.column14)
        return production_days_obj.production_day14
      elsif (item_qty <= item_bucket.column15)
        return production_days_obj.production_day15
      else
        0
      end
    else
      0
    end
  end
  
  def self.create_shipping_package_xml(qty,catalog_item_packages)
    remaining_qty = qty.to_i
    carton_size_arr = []
    while remaining_qty > 0
      carton_obj = get_carton_size(remaining_qty,catalog_item_packages)
      if (remaining_qty < carton_obj.pcs_per_carton)
        carton_obj.pcs_per_carton = remaining_qty
      end
      carton_obj1 = carton_obj.dup
      carton_size_arr << carton_obj1
      remaining_qty = remaining_qty - carton_obj.pcs_per_carton
    end
    xml = get_package_xml(carton_size_arr)
  end

  def self.get_carton_size(qty,catalog_item_packages)
    min_package = ''
    max_package = ''
    catalog_item_packages.each{|package|
      if package.pcs_per_carton.to_i <= qty.to_i
        min_package = package
        break if package.pcs_per_carton.to_i == qty.to_i
      else
        max_package = package
        break
      end
    }
    return max_package if max_package != ''
    return min_package if min_package
  end

  def self.get_package_xml(carton_size_arr)
    xml = ""
    carton_size_arr.each{|carton|
      xml = xml + "<sales_order_shipping_package>
        <carton_wt>#{carton.carton_wt}</carton_wt>
        <carton_length>#{carton.carton_length}</carton_length>
        <carton_width>#{carton.carton_width}</carton_width>
        <carton_height>#{carton.carton_height}</carton_height>
        <pcs_per_carton>#{carton.pcs_per_carton}</pcs_per_carton>
    </sales_order_shipping_package>"
    }
    return xml
  end

  ### PROMO PORTAL Service that generates xml to call Sales::DateUtility.calculate_inhand_date ###
  def self.get_sales_order_xml(shipping)
    shipping_packages = Sales::SalesOrderShippingPackage.find_by_sql ["Select * from sales_order_shipping_packages where (trans_flag = 'A' and sales_order_shipping_id =#{shipping.id}) "]
    shipping_packages_xml = "<sales_order_shipping_packages>"
    package_xml = ""
    shipping_packages.each{|package|
      xml = "<sales_order_shipping_package>
          <carton_wt>#{package.carton_wt}</carton_wt>
          <carton_length>#{package.carton_length}</carton_length>
          <carton_width>#{package.carton_width}</carton_width>
          <carton_height>#{package.carton_height}</carton_height>
        </sales_order_shiping_package>"
      package_xml = package_xml + xml
    }

    shipping_packages_xml = shipping_packages_xml + package_xml + "</sales_order_shipping_packages>"
    order_xml = "<sales_order>
                    <sales_order_shippings>
                        <sales_order_shipping>
                            <unique_no>unique_no</unique_no>
                            <shipping_code>#{shipping.shipping_code}</shipping_code>
                            <ship_method_code>#{shipping.ship_method_code}</ship_method_code>
                            <ship_country>#{shipping.ship_country}</ship_country>
                            <ship_state>#{shipping.ship_state}</ship_state>
                            <ship_zip>#{shipping.ship_zip}</ship_zip>
                              #{shipping_packages_xml}
                        </sales_order_shipping>
                    </sales_order_shippings>
                 </sales_order>"
    return order_xml
  end
end
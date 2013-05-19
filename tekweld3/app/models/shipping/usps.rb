class Shipping::Usps
  include General
  include ActiveMerchant::Shipping

  def self.get_usps_methods_xml(doc)
    zip_code = parse_xml(doc/:params/'zip_code')
    country = parse_xml(doc/:params/'country')
    state = parse_xml(doc/:params/'state')
    company_id = parse_xml(doc/:params/'company_id')
    catalog_item_id = parse_xml(doc/:params/'catalog_item_id')
    estimated_ship_date = parse_xml(doc/:params/'estimated_ship_date').to_date
    if (country != '' and country.length > 2)
      return '','','Country Code Should Be of 2 char.','error'
    elsif (state != '' and state.length > 2)
      return '','',"State Code Should Be of 2 char.",'error'
    elsif (zip_code != '' and zip_code.length > 5 and zip_code.length < 3)
      return '','',"Zip Code Should Be of length 3 to 5 characters.",'error'
    end
    if (zip_code and country and state)
      package_xml = create_usps_shipping_package_xml(doc,zip_code)
      if package_xml == 'error'
        return '','',"USPS shipment can handle atmost 25 packages.",'error'
      end
      @config = YAML::load(File.open("#{Rails.root}/config/settings.yml"))
      userid = @config["usps_userid"]
      xml_req_string = "<RateV4Request USERID='#{userid}'>
                              <Revision/>
                              #{package_xml}

            </RateV4Request>"
      query = "API=RateV4&XML=#{xml_req_string}"
      path = "http://production.shippingapis.com/ShippingAPI.dll"
      uri = URI.parse(path)
      http = Net::HTTP.new(uri.host,uri.port)
      response =  http.post(uri.path,query)
      response_body = response.body
      response_doc = Hpricot::XML(response_body)
      error_description = parse_xml(response_doc/'RateV4Response'/'Package'/'Error'/'Description') if parse_xml(response_doc/'RateV4Response'/'Package'/'Error'/'Description')
      if error_description
        return '','',error_description,'error'
      else
        available_services = []
        rate = []
        package_count = 1
        (response_doc/'RateV4Response'/'Package').each{|package|
          service_count = 0
          (package/'Postage').each {|postage|
            service_rate = parse_xml(postage/'Rate').to_f
            service_name = parse_xml(postage/'MailService') if parse_xml(postage/'MailService')
            service_name = service_name.gsub(';','') if service_name
            service_name = service_name.gsub('&','') if service_name
            service_name = service_name.gsub('gt','') if service_name
            service_name = service_name.gsub('lt','') if service_name
            service_name = service_name.gsub('sup','') if service_name
            service_name = service_name.gsub('/','') if service_name
            service_name = service_name.gsub('amp','') if service_name
            service_name = service_name.gsub('reg','') if service_name
            service_name = service_name.gsub('-',' ') if service_name
            if(service_name and (service_name == 'Express Mail' || service_name == 'Priority Mail' || service_name == 'First Class Mail') )
              if(package_count == 1)
                rate[service_count] = service_rate.to_f
                available_services[service_count] = service_name.to_s
                service_count = service_count + 1
              else
                available_services[service_count] = service_name
                rate[service_count] = rate[service_count] + service_rate
                service_count = service_count + 1
              end
            elsif(service_name and (service_name == 'Library Mail' || service_name == 'Media Mail' || service_name == 'Parcel Post'))
              if(package_count == 1)
                rate[service_count] = service_rate.to_f
                available_services[service_count] = service_name.to_s
                service_count = service_count + 1
              else
                available_services[service_count] = service_name
                rate[service_count] = rate[service_count] + service_rate
                service_count = service_count + 1
              end
            end

          }
          package_count = package_count + 1
        }
      end
      inhand_dates , text = usps_time_in_transit(available_services,zip_code,estimated_ship_date,catalog_item_id,company_id)
      if text == 'success'
        return available_services,rate,inhand_dates,'sucess'
      else
        return '','',inhand_dates,'error'
      end
    else
      return '','','Please provide sufficient data','error'
    end
  rescue Exception => ex
    return '','',ex,'error'
  end

  def self.create_usps_shipping_package_xml(doc,zip_code)
    catalog_item_id = parse_xml(doc/:params/'catalog_item_id')
    company_id = parse_xml(doc/:params/'company_id')
    shipfrom_name,shipfrom_address1,shipfrom_address2,shipfrom_city,shipfrom_state,shipfrom_zip,shipfrom_phone,shipfrom_country = Shipping::ShippingCrud.get_ship_from_address(catalog_item_id,company_id)
    size = 'REGULAR'
    package_xml = ''
    package_count = 1
    (doc/:params/:packagexml/:sales_order_shipping_packages/:sales_order_shipping_package).each{|package|
      if package_count > 25
        package_xml = 'error'
        return package_xml
      end
      carton_wt = parse_xml(package/'carton_wt').to_f
      carton_length =  parse_xml(package/'carton_length').to_i
      carton_width = parse_xml(package/'carton_width').to_i
      carton_height = parse_xml(package/'carton_height').to_i
      carton_girth = parse_xml(package/'carton_height').to_i
      if (carton_length > 12 || carton_width > 12 || carton_height > 12 || carton_girth > 12)
        size = 'LARGE'
      else
        size = 'REGULAR'
      end
      shipfrom_zip = shipfrom_zip[0..4]
      package_xml = package_xml +  "<Package ID='#{package_count}'>
                          <Service>ALL</Service>
                          <ZipOrigination>#{shipfrom_zip}</ZipOrigination>
                          <ZipDestination>#{zip_code}</ZipDestination>
                          <Pounds>#{carton_wt}</Pounds>
                          <Ounces>32</Ounces>
                          <Container/>
                          <Size>#{size}</Size>
                          <Width>#{carton_width}</Width>
                          <Length>#{carton_length}</Length>
                          <Height>#{carton_height}</Height>
                          <Girth>#{carton_girth}</Girth>
                          <Machinable>true</Machinable>
                        </Package>"
      package_count = package_count + 1
    }
    return package_xml
  end

  def self.usps_time_in_transit(available_services,zip_destination,estimated_ship_date,catalog_item_id,company_id)
    shipfrom_name,shipfrom_address1,shipfrom_address2,shipfrom_city,shipfrom_state,shipfrom_zip,shipfrom_phone,shipfrom_country = Shipping::ShippingCrud.get_ship_from_address(catalog_item_id,company_id)
    ship_date = estimated_ship_date.strftime("%d-%b-%Y")
    inhand_dates = []
    available_services.each{|service|
      if(service =~ /(.*)Express(.*)/i)
        request_name = 'ExpressMailCommitment'
      elsif(service =~ /(.*)Priority(.*)/i)
        request_name = 'PriorityMail'
      elsif(service =~ /(.*)First(.*)/i)
        request_name = 'FirstClass'
      else
        request_name = 'StandardB'
      end
      @config = YAML::load(File.open("#{Rails.root}/config/settings.yml"))
      userid = @config["usps_userid"]
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
        return error_description , 'error'
      else
        if(service =~ /(.*)Express(.*)/i)
          days = parse_xml(response_doc/'ExpressMailCommitmentResponse'/'Commitment'/'CommitmentName')
        else
          days = parse_xml(response_doc/"#{request_name}Response"/'Days') if parse_xml(response_doc/"#{request_name}Response"/'Days')
        end
        if(days =~ /(.*)1(.*)/ || days =~ /(.*)Next(.*)/ || days =~ /(.*)One(.*)/ )
          delivery_date = estimated_ship_date.advance(:days =>  1).strftime("%Y/%m/%d")
        elsif(days =~ /(.*)2(.*)/  || days =~ /(.*)Two(.*)/ )
          delivery_date = estimated_ship_date.advance(:days =>  2).strftime("%Y/%m/%d")
        elsif(days =~ /(.*)3(.*)/  || days =~ /(.*)Three(.*)/ )
          delivery_date = estimated_ship_date.advance(:days =>  3).strftime("%Y/%m/%d")
        elsif(days =~ /(.*)4(.*)/  || days =~ /(.*)Four(.*)/ )
          delivery_date = estimated_ship_date.advance(:days =>  4).strftime("%Y/%m/%d")
        elsif(days =~ /(.*)5(.*)/  || days =~ /(.*)Five(.*)/ )
          delivery_date = estimated_ship_date.advance(:days =>  5).strftime("%Y/%m/%d")
        elsif(days =~ /(.*)6(.*)/  || days =~ /(.*)Six(.*)/ )
          delivery_date = estimated_ship_date.advance(:days =>  6).strftime("%Y/%m/%d")
        elsif(days =~ /(.*)7(.*)/  || days =~ /(.*)Seven(.*)/ )
          delivery_date = estimated_ship_date.advance(:days =>  7).strftime("%Y/%m/%d")
        elsif(days =~ /(.*)8(.*)/  || days =~ /(.*)Eight(.*)/ )
          delivery_date = estimated_ship_date.advance(:days =>  8).strftime("%Y/%m/%d")
        elsif(days =~ /(.*)9(.*)/  || days =~ /(.*)Nine(.*)/ )
          delivery_date = estimated_ship_date.advance(:days =>  9).strftime("%Y/%m/%d")
        else
          delivery_date = estimated_ship_date.advance(:days =>  10).strftime("%Y/%m/%d")
        end
        inhand_dates <<  delivery_date.to_s
      end
    }
    return inhand_dates , 'success'
  end

  def self.print_usps_multipackage_label(shipping,schema_name)
    begin
      return 'Shipping Method Code Doesnot Exists','error' if (!shipping.ship_method_code || shipping.ship_method_code == '')
      order = Sales::SalesOrder.find_by_id(shipping.sales_order_id)
      flag = false
      tracking_flag = false
      package_count = 0
      shipping_packages = Sales::SalesOrderShippingPackage.find_by_sql ["select * from sales_order_shipping_packages where trans_flag = 'A' and sales_order_shipping_id = #{shipping.id}"]
      shipping_packages.each{|package|
        if (package.carton_length == 0 || package.carton_width == 0 || package.carton_height == 0 || package.carton_wt == 0)
          return "Length, Width, Height and Weight of Package can't be ZERO",'error'
          break
        end
        if(package.tracking_no and package.tracking_no != '' )
          tracking_flag = true
        else
          tracking_flag = false
        end
        flag = true
        package_count = package_count + 1
      }
      tracking_flag = false if shipping.generate_new_label_flag == 'Y'
      return "Please Provide Atleast one Package for Shipping",'error' if flag == false
      return "#{order.trans_no}_#{order.ext_ref_no}_#{shipping.serial_no}.html",'label_exists' if tracking_flag == true
      @config = YAML::load(File.open("#{Rails.root}/config/settings.yml"))
      userid = @config["usps_userid"]
      url = "https://secure.shippingapis.com/ShippingAPI.dll"
      uri = URI.parse url
      http = Net::HTTP.new uri.host, uri.port
      if uri.port == 443
        http.use_ssl	= true
        http.verify_mode = OpenSSL::SSL::VERIFY_NONE
      end
      tracking_no_array = []
      shipping_packages.each{|package|
        package_wt = 16 * package.carton_wt.to_i
        image_type ,query = get_xml_for_usps_label(order,shipping,userid,package_wt)
        response =  http.post(uri.path, query)
        doc = response.body
        doc = Hpricot::XML(doc)
        error_description = parse_xml(doc/'Error'/'Description') if parse_xml(doc/'Error'/'Description')
        if error_description
          return error_description , 'error'
        else
          if(shipping.ship_method =~ /(.*)Express(.*)/)
            tracking_no = parse_xml(doc/'EMConfirmationNumber')
            graphic_image = parse_xml(doc/'EMLabel')
          else
            tracking_no = parse_xml(doc/'DeliveryConfirmationNumber')
            graphic_image = parse_xml(doc/'DeliveryConfirmationLabel')
          end
          path = Setup::Type.find(:first, :conditions=>['type_cd = ? and subtype_cd = ?','UPLOAD_FOLDER','UPS_LABEL'])
          if path
            directory =  "#{Dir.getwd}" + '/'+ path.value + schema_name
          end
          FileUtils.mkdir_p(File.dirname(directory+'/'+'testfile'))
          File.open("#{directory}/label"+"#{tracking_no}"+".#{image_type.downcase}", 'wb') do|f|
            f.write(Base64.decode64(graphic_image))
          end
          img =  Magick::Image.read("#{directory}/label"+"#{tracking_no}"+".#{image_type.downcase}").first
          img.crop!(0, 0, 2000,1010,true)
          img.write("#{directory}/label"+"#{tracking_no}"+".gif")
          package.update_attributes!(:tracking_no => tracking_no)
          tracking_no_array << tracking_no
        end
      }
      shipping.update_attributes!(:tracking_no=> tracking_no_array[0],:generate_new_label_flag => 'N')
      activity_message = Artwork::ArtworkCrud.create_activity_message(order,"#{shipping.ship_method} LABEL PRINTED")
      activity = order.create_sales_order_transaction_activity(activity_message)
      activity.save!
      return tracking_no_array,'success'
    rescue Exception => ex
      return ex,'error'
    end
  end

  def self.get_xml_for_usps_label(order,shipping,userid,package_wt)
    if(shipping.ship_method =~ /(.*)Express(.*)/)
      request_name = 'ExpressMailLabel'
      api_name = 'ExpressMailLabel'
      image_type = 'GIF'
    else
      request_name = 'DeliveryConfirmationV3.0'
      api_name = 'DeliveryConfirmationV3'
      image_type = 'TIF'
    end
    if(shipping.ship_method =~ /(.*)Priority(.*)/)
      ship_method = 'Priority'
    elsif(shipping.ship_method =~ /(.*)First(.*)/)
      ship_method = 'First Class'
    elsif(shipping.ship_method =~ /(.*)Parcel(.*)/)
      ship_method = 'Parcel Post'
    elsif(shipping.ship_method =~ /(.*)Library(.*)/)
      ship_method = 'Library Mail'
    elsif(shipping.ship_method =~ /(.*)Media(.*)/)
      ship_method = 'Media Mail'
    end
    express_mail_req_string = "<#{request_name}Request USERID='#{userid}'>
                                  <Option />
                                    <Revision />
                                    <EMCAAccount />
                                    <EMCAPassword />
                                    <ImageParameters />
                                    <FromFirstName>#{order.bill_name}</FromFirstName>
                                    <FromLastName></FromLastName>
                                    <FromFirm>#{order.bill_name}</FromFirm>
                                    <FromAddress1>#{order.bill_address2}</FromAddress1>
                                    <FromAddress2>#{order.bill_address2}</FromAddress2>
                                    <FromCity>#{order.bill_city}</FromCity>
                                    <FromState>#{order.bill_state}</FromState>
                                    <FromZip5>#{order.bill_zip}</FromZip5>
                                    <FromZip4 />
                                    <FromPhone>#{order.bill_phone}</FromPhone>
                                    <ToFirstName>#{shipping.ship_name}</ToFirstName>
                                    <ToLastName></ToLastName>
                                    <ToFirm>#{shipping.ship_name}</ToFirm>
                                    <ToAddress1>#{shipping.ship_address2}</ToAddress1>
                                    <ToAddress2>#{shipping.ship_address1}</ToAddress2>
                                    <ToCity>#{shipping.ship_city}</ToCity>
                                    <ToState>#{shipping.ship_state}</ToState>
                                    <ToZip5>#{shipping.ship_zip}</ToZip5>
                                    <ToZip4></ToZip4>
                                    <ToPhone>#{shipping.ship_phone}</ToPhone>
                                    <WeightInOunces>#{package_wt}</WeightInOunces>
                                    <StandardizeAddress>false</StandardizeAddress>
                                    <WaiverOfSignature>false</WaiverOfSignature>
                                    <POZipCode />
                                    <ImageType>#{image_type}</ImageType>
                                    <CustomerRefNo>CustomerRefNo0</CustomerRefNo>
                                  </#{request_name}Request>"
    other_services_req_string = "<#{request_name}Request USERID='#{userid}'>
                          <Option>1</Option>
                          <ImageParameters></ImageParameters>
                          <FromName>#{order.bill_name}</FromName>
                          <FromFirm></FromFirm>
                          <FromAddress1>#{order.bill_address2}</FromAddress1>
                          <FromAddress2>#{order.bill_address1}</FromAddress2>
                          <FromCity>#{order.bill_city}</FromCity>
                          <FromState>#{order.bill_state}</FromState>
                          <FromZip5>#{order.bill_zip}</FromZip5>
                          <FromZip4></FromZip4>
                          <ToName>#{shipping.ship_name}</ToName>
                          <ToFirm>#{shipping.ship_name}</ToFirm>
                          <ToAddress1></ToAddress1>
                          <ToAddress2>#{shipping.ship_address1}</ToAddress2>
                          <ToCity>#{shipping.ship_city}</ToCity>
                          <ToState>#{shipping.ship_state}</ToState>
                          <ToZip5>#{shipping.ship_zip}</ToZip5>
                          <ToZip4></ToZip4>
                          <WeightInOunces>#{package_wt}</WeightInOunces>
                          <ServiceType>#{ship_method}</ServiceType>
                          <SeparateReceiptPage>true</SeparateReceiptPage>
                          <POZipCode>#{shipping.ship_zip}</POZipCode>
                          <ImageType>TIF</ImageType>
                          <LabelDate></LabelDate>
                          <CustomerRefNo>#{order.trans_no}</CustomerRefNo>
                          <AddressServiceRequested></AddressServiceRequested>
                          </#{request_name}Request>"
    if(shipping.ship_method =~ /(.*)Express(.*)/)
      xml_req_string = express_mail_req_string
    else
      xml_req_string = other_services_req_string
    end
    query = "API=#{api_name}&XML=#{xml_req_string}"
    return image_type , query
  end

  def self.make_usps_label_html(doc,labels,schema_name)
    begin
      shipping_id = parse_xml(doc/:params/'id')
      shipping = Sales::SalesOrderShipping.find_by_id(shipping_id)
      sales_order = Sales::SalesOrder.find_by_id(shipping.sales_order_id)
      path = Setup::Type.find(:first, :conditions=>['type_cd = ? and subtype_cd = ?','UPLOAD_FOLDER','UPS_LABEL'])
      if path
        directory =  "#{Dir.getwd}" + '/'+ path.value + schema_name
      end
      spacing = "<br/><br/><hr/><br/><br/>"
      count = 0
      record ="<!DOCTYPE html><html><body>"
      labels.each {|label|
        count = count + 1
        record= record +     "<table border='0' cellpadding='0' cellspacing='0' width='650' align = 'center'><tr>
          <td align='left' valign='top'>
            <IMG SRC=/ups_label/#{schema_name}/label#{label}.gif height=392 width=651/>
          </td>
        </tr></table>#{spacing if labels.size != count}"
      }
      record = record +"</body></html>"
      file_name = "#{sales_order.trans_no}_#{sales_order.ext_ref_no}_#{shipping.serial_no}.html"
      #      File.delete(File.dirname(file_name)) if FileTest.exists?(File.dirname(file_name))
      File.open("#{directory}/#{file_name}", 'w+') do|f|
        f.write(record)
      end
      return file_name,'success'
    rescue Exception => ex
      return ex,'error'
    end
  end
end
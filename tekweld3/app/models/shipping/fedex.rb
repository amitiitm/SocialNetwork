class Shipping::Fedex
  include General
  include ActiveMerchant::Shipping

  def self.get_fedex_methods_xml(doc)
    begin
      zip_code = parse_xml(doc/:params/'zip_code')
      country = parse_xml(doc/:params/'country')
      state = parse_xml(doc/:params/'state')
      catalog_item_id = parse_xml(doc/:params/'catalog_item_id')
      company_id = parse_xml(doc/:params/'company_id')
      estimated_ship_date = parse_xml(doc/:params/'estimated_ship_date').to_date
      ship_timestamp = estimated_ship_date.strftime("%Y-%m-%dT%H:%M:%S")
      if (country != '' and country.length > 2)
        return "Country Code Should Be of 2 char.",'error'
      elsif (state != '' and state.length > 2)
        return "State Code Should Be of 2 char.",'error'
      end
      if (zip_code and country and state)
        package_xml,total_wt,package_count = create_fedex_shipping_package_xml(doc)
        header_xml = create_fedex_shipping_header_xml(zip_code,country,state,ship_timestamp,total_wt,catalog_item_id,company_id)
        xml_req = "#{header_xml}
          <RateRequestTypes>ACCOUNT</RateRequestTypes>
                <PackageCount>#{package_count}</PackageCount>
                #{package_xml}
                </RequestedShipment>
                </RateRequest>
                </SOAP-ENV:Body>
                </SOAP-ENV:Envelope>"
        path = "https://gatewaybeta.fedex.com:443/web-services"
        url = URI.parse(path)
        http = Net::HTTP.new(url.host,url.port)
        http.use_ssl = true
        http.verify_mode = OpenSSL::SSL::VERIFY_NONE
        response =  http.post(url.path, xml_req)
        response_body = response.body
        response_doc = Hpricot::XML(response_body)
        ## some times it gives warning bcos some methods are unavailable so we checked severity
        severity = parse_xml(response_doc/'soapenv:Envelope'/'soapenv:Body'/'v10:RateReply'/'v10:Notifications'/'v10:Severity')
        code = parse_xml(response_doc/'soapenv:Envelope'/'soapenv:Body'/'v10:RateReply'/'v10:Notifications'/'v10:Code')
        error_msg = parse_xml(response_doc/'soapenv:Envelope'/'soapenv:Body'/'v10:RateReply'/'v10:Notifications'/'v10:Message')
        if code.to_i == 0 || severity != 'ERROR'
          return response_doc,'success'
        elsif error_msg
          return error_msg,'error'
        else
          return "Please Provide Sufficient Data",'error'
        end
      end
    rescue Exception => ex
      return ex,'error'
    end
  end

  def self.create_fedex_shipping_header_xml(zip_code,country,state,ship_timestamp,total_wt,catalog_item_id,company_id)
    @config = YAML::load(File.open("#{Rails.root}/config/settings.yml"))
    fedex_account_number = @config["fedex_account_number"]
    fedex_meter_number = @config["fedex_meter_number"]
    fedex_api_transaction_key = @config["fedex_api_transaction_key"]
    fedex_password = @config["fedex_password"]
    shipfrom_name,shipfrom_address1,shipfrom_address2,shipfrom_city,shipfrom_state,shipfrom_zip,shipfrom_phone,shipfrom_country = Shipping::ShippingCrud.get_ship_from_address(catalog_item_id,company_id)
    xml_header = "<SOAP-ENV:Envelope xmlns:SOAP-ENV='http://schemas.xmlsoap.org/soap/envelope/' xmlns:SOAP-ENC='http://schemas.xmlsoap.org/soap/encoding/' xmlns:xsi='http://www.w3.org/2001/XMLSchema-instance' xmlns:xsd='http://www.w3.org/2001/XMLSchema' xmlns='http://fedex.com/ws/rate/v10'>
                 <SOAP-ENV:Body>
                   <RateRequest>
                      <WebAuthenticationDetail>
                        <UserCredential>
                          <Key>#{fedex_api_transaction_key}</Key>
                          <Password>#{fedex_password}</Password>
                        </UserCredential>
                      </WebAuthenticationDetail>
                      <ClientDetail>
                        <AccountNumber>#{fedex_account_number}</AccountNumber>
                        <MeterNumber>#{fedex_meter_number}</MeterNumber>
                        <ClientProductId>123456789</ClientProductId>
                      </ClientDetail>
                      <TransactionDetail>
                        <CustomerTransactionId>123456789</CustomerTransactionId>
                      </TransactionDetail>
                      <Version>
                        <ServiceId>crs</ServiceId>
                        <Major>10</Major>
                        <Intermediate>0</Intermediate>
                        <Minor>0</Minor>
                      </Version>
                    <ReturnTransitAndCommit>true</ReturnTransitAndCommit>
                    <RequestedShipment>
                    <ShipTimestamp>#{ship_timestamp}</ShipTimestamp>
                    <PackagingType>YOUR_PACKAGING</PackagingType>
                    <TotalWeight>
                      <Units>LB</Units>
                      <Value>#{total_wt}</Value>
                    </TotalWeight>
                    <Shipper>
                      <Contact>
                        <CompanyName>#{shipfrom_name}</CompanyName>
                        <PhoneNumber>#{shipfrom_phone}</PhoneNumber>
                      </Contact>
                      <Address>
                        <StreetLines>#{shipfrom_address1}</StreetLines>
                        <StateOrProvinceCode>#{shipfrom_state}</StateOrProvinceCode>
                        <PostalCode>#{shipfrom_zip}</PostalCode>
                        <CountryCode>#{shipfrom_country}</CountryCode>
                      </Address>
                    </Shipper>
                    <Recipient>
                      <Contact>
                          <PhoneNumber>7323458888</PhoneNumber>
                      </Contact>
                      <Address>
                          <StateOrProvinceCode>#{state}</StateOrProvinceCode>
                          <PostalCode>#{zip_code}</PostalCode>
                          <CountryCode>#{country}</CountryCode>
                     </Address>
                    </Recipient>
    "
    return xml_header
  end

  def self.create_fedex_shipping_package_xml(doc)
    sequence_number = 1
    package_xml = ''
    total_wt = 0.0
    package_count = 1
    (doc/:params/:packagexml/:sales_order_shipping_packages/:sales_order_shipping_package).each{|package|
      carton_wt = parse_xml(package/'carton_wt').to_f
      carton_length =  parse_xml(package/'carton_length').to_i
      carton_width = parse_xml(package/'carton_width').to_i
      carton_height = parse_xml(package/'carton_height').to_i
      insured_charge = parse_xml(package/'insured_charge').to_f
      package_xml = package_xml +  "<RequestedPackageLineItems>
                <SequenceNumber>#{sequence_number}</SequenceNumber>
                <GroupPackageCount>1</GroupPackageCount>
                <InsuredValue>
                <Currency>USD</Currency>
                <Amount>#{insured_charge}</Amount>
                </InsuredValue>
                <Weight>
                <Units>LB</Units>
                <Value>#{carton_wt}</Value>
                </Weight>
                <Dimensions>
                <Length>#{carton_length}</Length>
                <Width>#{carton_width}</Width>
                <Height>#{carton_height}</Height>
                <Units>IN</Units>
                </Dimensions>
                </RequestedPackageLineItems>"
      total_wt = total_wt + carton_wt
      package_count = package_count + 1
      sequence_number = sequence_number + 1
    }
    return package_xml,total_wt,package_count
  end

  ### fedex shipping label generation xml ###
  def self.print_fedex_multipackage_label(shipping,schema_name)
    begin
      #      shipping_id = parse_xml(doc/:params/'id')
      #      shipping = Sales::SalesOrderShipping.active.find_by_id(shipping_id)
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
      master_package_id = shipping_packages[0].id if shipping_packages[0]
      master_tracking_number = 0
      tracking_id_type = ''
      tracking_flag = false if shipping.generate_new_label_flag == 'Y'
      return "Please Provide Atleast one Package for Shipping",'error' if flag == false
      return "#{order.trans_no}_#{order.ext_ref_no}_#{shipping.serial_no}.html",'label_exists' if tracking_flag == true
      @config = YAML::load(File.open("#{Rails.root}/config/settings.yml"))
      fedex_account_number = @config["fedex_account_number"]
      fedex_meter_number = @config["fedex_meter_number"]
      fedex_api_transaction_key = @config["fedex_api_transaction_key"]
      fedex_password = @config["fedex_password"]
      url = 'https://gatewaybeta.fedex.com:443/web-services'
      uri = URI.parse url
      http = Net::HTTP.new uri.host, uri.port
      if uri.port == 443
        http.use_ssl	= true
        http.verify_mode = OpenSSL::SSL::VERIFY_NONE
      end
      ship_timestamp = shipping.internal_ship_date.strftime("%Y-%m-%dT%H:%M:%S")
      service_type = shipping.ship_method_code if shipping.ship_method_code
      payment_type = shipping.bill_transportation_to if shipping.bill_transportation_to
      account_number = shipping.shipvia_accountnumber if shipping.shipvia_accountnumber
      sequence_number = 1
      if(payment_type =~ (/(.*)Shipper(.*)/))
        payment_type = 'SENDER'
        account_number = fedex_account_number
      elsif(payment_type =~ (/(.*)Third Party(.*)/))
        payment_type = 'THIRD_PARTY'
      elsif (payment_type =~ (/(.*)Receiver(.*)/))
        payment_type = 'RECIPIENT'
      end
      tracking_no_array = []
      shipping_packages.each{|package|
        xml_req_header = " <soapenv:Envelope xmlns:soapenv='http://schemas.xmlsoap.org/soap/envelope/' xmlns='http://fedex.com/ws/ship/v10' xmlns:xsd='http://www.w3.org/2001/XMLSchema' xmlns:xsi='http://www.w3.org/2001/XMLSchema-instance'>
                <soapenv:Body>
                <ProcessShipmentRequest xmlns='http://fedex.com/ws/ship/v10'>
                      <WebAuthenticationDetail>
                        <UserCredential>
                          <Key>#{fedex_api_transaction_key}</Key>
                          <Password>#{fedex_password}</Password>
                        </UserCredential>
                      </WebAuthenticationDetail>
                      <ClientDetail>
                       <AccountNumber>#{fedex_account_number}</AccountNumber>
                       <MeterNumber>#{fedex_meter_number}</MeterNumber>
                      </ClientDetail>
                      <TransactionDetail>
                        <CustomerTransactionId>#{order.trans_no}#{order.ext_ref_no}</CustomerTransactionId>
                      </TransactionDetail>
                      <Version>
                        <ServiceId>ship</ServiceId>
                        <Major>10</Major>
                        <Intermediate>0</Intermediate>
                        <Minor>0</Minor>
                      </Version>
                      <RequestedShipment>
                         <ShipTimestamp>#{ship_timestamp}</ShipTimestamp>
                          <DropoffType>REGULAR_PICKUP</DropoffType>
                        <ServiceType>#{service_type}</ServiceType>
                        <PackagingType>YOUR_PACKAGING</PackagingType>
                        <Shipper>
                          <Contact>
                            <PersonName>#{order.bill_name}</PersonName>
                             <PhoneNumber>#{order.bill_phone}</PhoneNumber>
                          </Contact>
                          <Address>
                            <StreetLines>#{order.bill_address1} #{order.bill_address2}</StreetLines>
                            <City>#{order.bill_city}</City>
                            <StateOrProvinceCode>#{order.bill_state}</StateOrProvinceCode>
                            <PostalCode>#{order.bill_zip}</PostalCode>
                            <CountryCode>#{order.bill_country}</CountryCode>
                            <Residential>true</Residential>
                         </Address>
                      </Shipper>
                      <Recipient>
                        <Contact>
                          <PersonName>#{shipping.ship_name}</PersonName>
                          <PhoneNumber>#{shipping.ship_phone}</PhoneNumber>
                        </Contact>
                        <Address>
                          <StreetLines>#{shipping.ship_address1},#{shipping.ship_address2}</StreetLines>
                          <City>#{shipping.ship_city}</City>
                          <StateOrProvinceCode>#{shipping.ship_state}</StateOrProvinceCode>
                          <PostalCode>#{shipping.ship_zip}</PostalCode>
                          <CountryCode>#{shipping.ship_country}</CountryCode>
                        </Address>
                      </Recipient>
                      <ShippingChargesPayment>
                        <PaymentType>#{payment_type}</PaymentType>
                        <Payor>
                          <AccountNumber>#{account_number}</AccountNumber>
                          <CountryCode>US</CountryCode>
                        </Payor>
                      </ShippingChargesPayment>
                      <LabelSpecification>
                        <LabelFormatType>COMMON2D</LabelFormatType>
                        <ImageType>PNG</ImageType>
                        <LabelStockType>PAPER_4X6</LabelStockType>
                        <LabelRotation>LEFT</LabelRotation>
                      </LabelSpecification>
                      <RateRequestTypes>ACCOUNT</RateRequestTypes>"
        xml_req_footer = "<PackageCount>#{package_count}</PackageCount>
                      #{get_package_xml_for_fedex_label(package, sequence_number,order)}
                      </RequestedShipment>
                   </ProcessShipmentRequest>
                    </soapenv:Body>
                  </soapenv:Envelope>"
        xml_req_master_tag = "<MasterTrackingId>
                            <TrackingIdType>#{tracking_id_type}</TrackingIdType>
                            <TrackingNumber>#{master_tracking_number}</TrackingNumber>
                            </MasterTrackingId>
        "
        if package.id == master_package_id
          xml_req = xml_req_header + xml_req_footer
        else
          xml_req = xml_req_header + xml_req_master_tag + xml_req_footer
        end
        @response_plain = http.post(uri.path, xml_req).body
        doc = Hpricot::XML(@response_plain)
        severity = parse_xml(doc/'v10:ProcessShipmentReply'/'v10:Notifications'/'v10:Severity')
        error_code = parse_xml(doc/'v10:ProcessShipmentReply'/'v10:Notifications'/'v10:Code')
        error_description = parse_xml(doc/'v10:ProcessShipmentReply'/'v10:Notifications'/'v10:Message')
        master_tracking_number = parse_xml(doc/'v10:ProcessShipmentReply'/'v10:CompletedShipmentDetail'/'v10:MasterTrackingId'/'v10:TrackingNumber')
        tracking_id_type = parse_xml(doc/'v10:ProcessShipmentReply'/'v10:CompletedShipmentDetail'/'v10:MasterTrackingId'/'v10:TrackingIdType')
        return error_description,'error' if error_code.to_i != 0
        return 'response-failure','error' if severity == 'ERROR'
        path = Setup::Type.find(:first, :conditions=>['type_cd = ? and subtype_cd = ?','UPLOAD_FOLDER','UPS_LABEL'])
        if path
          directory =  "#{Dir.getwd}" + '/'+ path.value + schema_name
        end
        FileUtils.mkdir_p(File.dirname(directory+'/'+'testfile'))
        tracking_no = parse_xml(doc/'v10:ProcessShipmentReply'/'v10:CompletedShipmentDetail'/'v10:CompletedPackageDetails'/'v10:TrackingIds'/'v10:TrackingNumber')
        graphic_image = parse_xml(doc/'v10:ProcessShipmentReply'/'v10:CompletedShipmentDetail'/'v10:CompletedPackageDetails'/'v10:Label'/'v10:Parts'/'v10:Image')
        File.open("#{directory}/label"+tracking_no+".gif", 'wb') do|f|
          f.write(Base64.decode64(graphic_image))
        end
        shipping.update_attributes!(:tracking_no=> master_tracking_number,:generate_new_label_flag => 'N')
        package.update_attributes!(:tracking_no => tracking_no)
        sequence_number = sequence_number + 1
        tracking_no_array << tracking_no
      }
      if !shipping_packages[1]
        shipping.update_attributes!(:tracking_no=> tracking_no_array[0],:generate_new_label_flag => 'N')
      end
      activity_message = Artwork::ArtworkCrud.create_activity_message(order,"#{shipping.ship_method} LABEL PRINTED")
      activity = order.create_sales_order_transaction_activity(activity_message)
      activity.save!
      return tracking_no_array,'success'
    rescue Exception => ex
      return ex,'error'
    end
  end

  def self.get_package_xml_for_fedex_label(shipping_package,sequence_number,order)
    xml = ""
    xml = xml +"<RequestedPackageLineItems>
                  <SequenceNumber>#{sequence_number}</SequenceNumber>
                  <Weight>
                  <Units>LB</Units>
                  <Value>#{shipping_package.carton_wt}</Value>
                   </Weight>
                  <Dimensions>
                  <Length>#{shipping_package.carton_length}</Length>
                   <Width>#{shipping_package.carton_width}</Width>
                  <Height>#{shipping_package.carton_height}</Height>
                  <Units>IN</Units>
                  </Dimensions>
                  <PhysicalPackaging>BOX</PhysicalPackaging>
                  <CustomerReferences>
                      <CustomerReferenceType>CUSTOMER_REFERENCE</CustomerReferenceType>
                      <Value>#{order.trans_no}</Value>
                  </CustomerReferences>
                  <CustomerReferences>
                      <CustomerReferenceType>P_O_NUMBER</CustomerReferenceType>
                      <Value>#{order.ext_ref_no}</Value>
                 </CustomerReferences>
                </RequestedPackageLineItems>"
    return xml
  end

  def self.make_fedex_label_html(doc,labels,schema_name)
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
class Shipping::Ups
  include General
  include ActiveMerchant::Shipping

  def self.get_ups_shipping_methods(doc)
    begin
      #      item_id = parse_xml(doc/:params/'catalog_item_id')
      #      trans_no = parse_xml(doc/:params/'trans_no')
      #      qty = parse_xml(doc/:params/'qty')
      zip_code = parse_xml(doc/:params/'zip_code')
      country = parse_xml(doc/:params/'country')
      state = parse_xml(doc/:params/'state')
      catalog_item_id = parse_xml(doc/:params/'catalog_item_id')
      company_id = parse_xml(doc/:params/'company_id')
      if (country != '' and country.length > 2)
        return "Country Code Should Be of 2 char.",'error'
      elsif (state != '' and state.length > 2)
        return "State Code Should Be of 2 char.",'error'
      end
      if (zip_code and country and state)
        #        catalog_item_packages = Item::CatalogItemPackage.find_by_sql ["select * from catalog_item_packages where catalog_item_id = ? and trans_flag = 'A' order by pcs_per_carton",item_id]
        #        return "Please Define Item Packages",'error' if !catalog_item_packages[0]
        xml_req = "
          #{header_xml = create_shipping_header_xml(zip_code,country,state,catalog_item_id,company_id)}
          #{xml = generate_ups_package_xml(doc)}

  <ShipmentServiceOptions />
  </Shipment>
</RatingServiceSelectionRequest>"
        path = "https://wwwcie.ups.com/ups.app/xml/Rate"
        url = URI.parse(path)
        http = Net::HTTP.new(url.host,url.port)
        http.use_ssl = true
        http.verify_mode = OpenSSL::SSL::VERIFY_NONE
        response =  http.post(url.path, xml_req)
        response_body = response.body
        return response_body,'success'
      else
        return "Please Provide Sufficient Data",'error'
      end
    rescue Exception => ex
      return ex,'error'
    end
  end

  def self.create_shipping_header_xml(zip_code,country,state,catalog_item_id,company_id)
    @config = YAML::load(File.open("#{Rails.root}/config/settings.yml"))
    ups_license_number = @config["ups_license_number"]
    ups_user_id = @config["ups_user_id"]
    ups_password = @config["ups_password"]
    ups_shipper_number = @config["ups_shipper_number"]
    shipfrom_name,shipfrom_address1,shipfrom_address2,shipfrom_city,shipfrom_state,shipfrom_zip,shipfrom_phone,shipfrom_country = Shipping::ShippingCrud.get_ship_from_address(catalog_item_id,company_id)
    xml_req = "<?xml version='1.0' ?>
<AccessRequest xml:lang='en-US'>
  <AccessLicenseNumber>#{ups_license_number}</AccessLicenseNumber>
  <UserId>#{ups_user_id}</UserId>
  <Password>#{ups_password}</Password>
</AccessRequest>

<?xml version='1.0' ?>
<RatingServiceSelectionRequest>
  <Request>
    <TransactionReference>
      <CustomerContext>Rating and Service</CustomerContext>
      <XpciVersion>1.0</XpciVersion>
    </TransactionReference>
    <RequestAction>Rate</RequestAction>
    <RequestOption>Shop</RequestOption>
  </Request>

  <Shipment>
    <RateInformation>
      <NegotiatedRatesIndicator/>
    </RateInformation>

    <Shipper>
      <ShipperNumber>#{ups_shipper_number}</ShipperNumber>
      <Address>

      </Address>
    </Shipper>
    <ShipTo>
      <CompanyName>Tekweld</CompanyName>
      <PhoneNumber>7777778978</PhoneNumber>
      <Address>
        <StateProvinceCode>#{state}</StateProvinceCode>
        <PostalCode>#{zip_code}</PostalCode>
        <CountryCode>#{country}</CountryCode>
      </Address>
    </ShipTo>
    <ShipFrom>
      <CompanyName>#{shipfrom_name}</CompanyName>
      <PhoneNumber>#{shipfrom_phone}</PhoneNumber>
      <Address>
        <StateProvinceCode>#{shipfrom_state}</StateProvinceCode>
        <PostalCode>#{shipfrom_zip}</PostalCode>
        <CountryCode>#{shipfrom_country}</CountryCode>
      </Address>
    </ShipFrom>"
    return xml_req
  end

  def self.generate_ups_package_xml(doc)
    xml = ""
    (doc/:params/:packagexml/:sales_order_shipping_packages/:sales_order_shipping_package).each{|package|
      carton_wt = parse_xml(package/'carton_wt')
      carton_length =  parse_xml(package/'carton_length')
      carton_width = parse_xml(package/'carton_width')
      carton_height = parse_xml(package/'carton_height')
      insured_charge = parse_xml(package/'insured_charge')
      xml = xml + "<Package>
      <PackageServiceOptions>
        <InsuredValue>
          <CurrencyCode>USD</CurrencyCode>
          <MonetaryValue>#{insured_charge.to_f}</MonetaryValue>
        </InsuredValue>
      </PackageServiceOptions>
      <PackagingType>
        <Code>00</Code>
        <Description></Description>
      </PackagingType>
        <Description>Rate</Description>
      <PackageWeight>
        <UnitOfMeasurement>
          <Code>LBS</Code>
        </UnitOfMeasurement>
        <Weight>#{carton_wt}</Weight>
      </PackageWeight>
      <Dimensions>
        <UnitOfMeasurement>
          <Code>IN</Code>
        </UnitOfMeasurement>
        <Length>#{carton_length}</Length>
        <Width>#{carton_width}</Width>
        <Height>#{carton_height}</Height>
      </Dimensions>
    </Package>"
    }
    return xml
  end

  def self.get_ups_time_in_transit(doc)
    begin
      zip_code = parse_xml(doc/:params/'zip_code')
      country = parse_xml(doc/:params/'country')
      state = parse_xml(doc/:params/'state')
      estimated_ship_date = parse_xml(doc/:params/'estimated_ship_date')
      catalog_item_id = parse_xml(doc/:params/'catalog_item_id')
      company_id = parse_xml(doc/:params/'company_id')
      shipfrom_name,shipfrom_address1,shipfrom_address2,shipfrom_city,shipfrom_state,shipfrom_zip,shipfrom_phone,shipfrom_country = Shipping::ShippingCrud.get_ship_from_address(catalog_item_id,company_id)
      @config = YAML::load(File.open("#{Rails.root}/config/settings.yml"))
      ups_license_number = @config["ups_license_number"]
      ups_user_id = @config["ups_user_id"]
      ups_password = @config["ups_password"]
      xml_req = "<?xml version='1.0' ?>
<AccessRequest xml:lang='en-US'>
  <AccessLicenseNumber>#{ups_license_number}</AccessLicenseNumber>
  <UserId>#{ups_user_id}</UserId>
  <Password>#{ups_password}</Password>
</AccessRequest>
    <?xml version='1.0' ?>
      <TimeInTransitRequest xml:lang='en-US'>
        <Request>
            <TransactionReference>
                <CustomerContext>anything can be written</CustomerContext>
                <XpciVersion>1.0002</XpciVersion>
            </TransactionReference>
            <RequestAction>TimeInTransit</RequestAction>
        </Request>
      <TransitFrom>
          <AddressArtifactFormat>
              <CountryCode>#{shipfrom_country}</CountryCode>
              <PoliticalDivision1>#{shipfrom_state}</PoliticalDivision1>
              <PoliticalDivision2>#{shipfrom_city}</PoliticalDivision2>
              <PostcodePrimaryLow>#{shipfrom_zip}</PostcodePrimaryLow>
          </AddressArtifactFormat>
      </TransitFrom>
      <TransitTo>
          <AddressArtifactFormat>
              <CountryCode>#{country}</CountryCode>
              <PoliticalDivision1>#{state}</PoliticalDivision1>
              <PostcodePrimaryLow>#{zip_code}</PostcodePrimaryLow>
          </AddressArtifactFormat>
      </TransitTo>
      <PickupDate>#{estimated_ship_date.to_date.strftime('%Y%m%d')}</PickupDate>
      <DocumentsOnlyIndicator />
</TimeInTransitRequest>"
      ## Shipment Date Query cannot exceed 35 days into the past or 60 days into the future. Format: YYYYMMDD
      ## TNT_D Origin Country Code
      path = "https://wwwcie.ups.com/ups.app/xml/TimeInTransit"
      url = URI.parse(path)
      http = Net::HTTP.new(url.host,url.port)
      http.use_ssl = true
      http.verify_mode = OpenSSL::SSL::VERIFY_NONE
      response =  http.post(url.path, xml_req)
      response_body = response.body
      return response_body,'success'
    rescue Exception => ex
      return ex,'error'
    end
  end

  def self.calculate_inhand_date(shipping,estimated_ship_date)
    begin
      xml = "<params>
              <zip_code>#{shipping.ship_zip}</zip_code>
              <country>#{shipping.ship_country}</country>
              <state>#{shipping.ship_state}</state>
              <estimated_ship_date>#{estimated_ship_date}</estimated_ship_date>
           </params>"
      doc = Hpricot::XML(xml)
      response_doc,text = get_ups_time_in_transit(doc)
      if text == 'error'
        return response_doc,'error'
      else
        ups_time_in_transit = Hpricot::XML(response_doc)
        response_status_code = parse_xml(ups_time_in_transit/:TimeInTransitResponse/:Response/'ResponseStatusCode')  if parse_xml(ups_time_in_transit/:TimeInTransitResponse/:Response/'ResponseStatusCode').first
        if response_status_code.to_i == 1
          (ups_time_in_transit/:TimeInTransitResponse/:TransitResponse/:ServiceSummary).each{ |transit|
            code = parse_xml(transit/:Service/'Code')
            date = parse_xml(transit/:EstimatedArrival/'Date')
            if code.to_s == 'GND' and shipping.ship_method_code.to_i == 03
              inhand_date = (date.to_date.strftime('%Y/%m/%d'))
              return inhand_date,'success'
            elsif code.to_s == '1DA' and shipping.ship_method_code.to_i == 01
              inhand_date = (date.to_date.strftime('%Y/%m/%d'))
              return inhand_date,'success'
            elsif code.to_s == '2DA' and shipping.ship_method_code.to_i == 02
              inhand_date = (date.to_date.strftime('%Y/%m/%d'))
              return inhand_date,'success'
            elsif code.to_s == '3DS' and shipping.ship_method_code.to_i == 12
              inhand_date = (date.to_date.strftime('%Y/%m/%d'))
              return inhand_date,'success'
            elsif code.to_s == '1DP' and shipping.ship_method_code.to_i == 13
              inhand_date = (date.to_date.strftime('%Y/%m/%d'))
              return inhand_date,'success'
            elsif code.to_s == '1DM' and shipping.ship_method_code.to_i == 14
              inhand_date = (date.to_date.strftime('%Y/%m/%d'))
              return inhand_date,'success'
            elsif code.to_s == '2DM' and shipping.ship_method_code.to_i == 59
              inhand_date = (date.to_date.strftime('%Y/%m/%d'))
              return inhand_date,'success'
            end
          }
        else
          error_description = parse_xml(ups_time_in_transit/:TimeInTransitResponse/:Response/:Error/'ErrorDescription')  if parse_xml(ups_time_in_transit/:TimeInTransitResponse/:Response/:Error/'ErrorDescription').first
          return error_description,'error'
        end
      end
    rescue Exception => ex
      return ex,'error'
    end
  end

  def self.print_ups_multipackage_label(shipping,schema_name)
    begin
      #      shipping_id = parse_xml(doc/:params/'id')
      #      shipping = Sales::SalesOrderShipping.find_by_id(shipping_id)
      return 'Shipping Method Code Doesnot Exists','error' if (!shipping.ship_method_code || shipping.ship_method_code == '')
      order = Sales::SalesOrder.find_by_id(shipping.sales_order_id)
      flag = false
      tracking_flag = false
      shipping_packages = Sales::SalesOrderShippingPackage.find_by_sql ["select * from sales_order_shipping_packages where trans_flag = 'A' and update_flag = 'Y' and sales_order_shipping_id = #{shipping.id}"]
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
      }
      tracking_flag = false if shipping.generate_new_label_flag == 'Y'
      return "Please Provide Atleast one Package for Shipping",'error' if flag == false
      return "#{order.trans_no}_#{order.ext_ref_no}_#{shipping.serial_no}.html",'label_exists' if tracking_flag == true
      @config = YAML::load(File.open("#{Rails.root}/config/settings.yml"))
      ups_license_number = @config["ups_license_number"]
      ups_user_id = @config["ups_user_id"]
      ups_password = @config["ups_password"]
      ups_shipper_number = @config["ups_shipper_number"]
      url = 'https://wwwcie.ups.com/ups.app/xml/ShipConfirm'
      ##url = 'https://onlinetools.ups.com/ups.app/xml/ShipConfirm'
      uri = URI.parse url
      http = Net::HTTP.new uri.host, uri.port
      if uri.port == 443
        http.use_ssl	= true
        http.verify_mode = OpenSSL::SSL::VERIFY_NONE
      end
      xml_req = "<?xml version='1.0'?>
                  <AccessRequest xml:lang='en-US'>
                    <AccessLicenseNumber>#{ups_license_number}</AccessLicenseNumber>
                    <UserId>#{ups_user_id}</UserId>
                    <Password>#{ups_password}</Password>
                  </AccessRequest>

                  <?xml version='1.0'?>
                  <ShipmentConfirmRequest xml:lang='en-US'>
                    <Request>
                      <TransactionReference>
                        <CustomerContext>Customer Comment</CustomerContext>
                        <XpciVersion/>
                      </TransactionReference>
                      <RequestAction>ShipConfirm</RequestAction>
                      <RequestOption>validate</RequestOption>
                    </Request>
                    <LabelSpecification>
                      <LabelPrintMethod>
                        <Code>GIF</Code>
                        <Description>gif file</Description>
                      </LabelPrintMethod>
                      <HTTPUserAgent>Mozilla/4.5</HTTPUserAgent>
                      <LabelImageFormat>
                        <Code>GIF</Code>
                        <Description>gif</Description>
                      </LabelImageFormat>
                    </LabelSpecification>
                    <Shipment>
                     <RateInformation>
                        <NegotiatedRatesIndicator/>
                      </RateInformation>
                    <Description/>
                      <Shipper>
                        <Name>#{order.bill_name}</Name>
                        <PhoneNumber>#{order.bill_phone}</PhoneNumber>
                        <ShipperNumber>#{ups_shipper_number}</ShipperNumber>

                        <Address>
                        <AddressLine1>#{order.bill_address1},#{order.bill_address2}</AddressLine1>
                        <City>#{order.bill_city}</City>
                        <StateProvinceCode>#{order.bill_state}</StateProvinceCode>
                        <PostalCode>#{order.bill_zip}</PostalCode>
                        <PostcodeExtendedLow></PostcodeExtendedLow>
                        <CountryCode>#{order.bill_country}</CountryCode>
                       </Address>
                      </Shipper>
                    <ShipTo>
                        <CompanyName>#{shipping.ship_name}</CompanyName>
                        <AttentionName>#{shipping.attention}</AttentionName>
                        <PhoneNumber>#{shipping.ship_phone}</PhoneNumber>
                        <Address>
                          <AddressLine1>#{shipping.ship_address1}</AddressLine1>
                          <City>#{shipping.ship_city}</City>
                          <StateProvinceCode>#{shipping.ship_state}</StateProvinceCode>
                          <PostalCode>#{shipping.ship_zip}</PostalCode>
                          <CountryCode>#{shipping.ship_country}</CountryCode>
                        </Address>
                      </ShipTo>
                      <ShipFrom>
                        <CompanyName>#{order.bill_name}</CompanyName>
                        <AttentionName>#{order.bill_name}</AttentionName>
                        <PhoneNumber>#{order.bill_phone}</PhoneNumber>
                      <TaxIdentificationNumber></TaxIdentificationNumber>
                        <Address>
                          <AddressLine1>#{order.bill_address1},#{order.bill_address2}</AddressLine1>
                          <City>#{order.bill_city}</City>
                        <StateProvinceCode>#{order.bill_state}</StateProvinceCode>
                        <PostalCode>#{order.bill_zip}</PostalCode>
                        <CountryCode>#{order.bill_country}</CountryCode>
                        </Address>
                      </ShipFrom>
                       <PaymentInformation>
                        #{payment_xml = get_shipping_payment_account(shipping,ups_shipper_number)}
                      </PaymentInformation>
                      <Service>
                        <Code>#{shipping.ship_method_code}</Code>
                        <Description></Description>
                      </Service>
                  #{xml = get_package_xml_for_ups_label(order,shipping)}
                    </Shipment>
                  </ShipmentConfirmRequest>"
      @response_plain = http.post(uri.path, xml_req).body
      doc = Hpricot::XML(@response_plain)
      error_code = parse_xml(doc/:ShipmentConfirmResponse/:Response/'ResponseStatusCode')
      error_description = parse_xml(doc/:ShipmentConfirmResponse/:Response/'ErrorDescription')
      return error_description,'error' if error_code.to_i == 0
      digest = (doc/:ShipmentConfirmResponse/:ShipmentDigest).first.innerHTML
      #    url = 'https://onlinetools.ups.com/ups.app/xml/ShipAccept'
      url = 'https://wwwcie.ups.com/ups.app/xml/ShipAccept'
      uri = URI.parse url
      http = Net::HTTP.new uri.host, uri.port
      if uri.port == 443
        http.use_ssl	= true
        http.verify_mode = OpenSSL::SSL::VERIFY_NONE
      end

      @data = %{<?xml version='1.0'?>
                <AccessRequest xml:lang='en-US'>
                  <AccessLicenseNumber>#{ups_license_number}</AccessLicenseNumber>
                  <UserId>#{ups_user_id}</UserId>
                  <Password>#{ups_password}</Password>
                </AccessRequest>
                <?xml version='1.0'?>
                <ShipmentAcceptRequest>
                <Request>
                <TransactionReference>
                <CustomerContext>guidlikesubstance</CustomerContext>
                <XpciVersion>1.0001</XpciVersion>
                </TransactionReference>
                <RequestAction>ShipAccept</RequestAction>
                </Request>
                <ShipmentDigest>#{digest}</ShipmentDigest>
                </ShipmentAcceptRequest>}
      path = Setup::Type.find(:first, :conditions=>['type_cd = ? and subtype_cd = ?','UPLOAD_FOLDER','UPS_LABEL'])
      if path
        directory =  "#{Dir.getwd}" + '/'+ path.value + schema_name
      end
      FileUtils.mkdir_p(File.dirname(directory+'/'+'testfile'))
      @response_plain = http.post(uri.path, @data).body
      doc = Hpricot::XML(@response_plain)
      tracking_no_array = []
      (doc/:ShipmentAcceptResponse/:ShipmentResults/:PackageResults/:TrackingNumber).each{|tracking_no|
        tracking_no_array << tracking_no.innerHTML
      }
      tracking_count = 0
      (doc/:ShipmentAcceptResponse/:ShipmentResults/:PackageResults/:LabelImage).each{|label|
        graphic_image = (label/:GraphicImage).first.innerHTML
        #        html_code = (label/:HTMLImage).first.innerHTML
        File.open("#{directory}/label"+tracking_no_array[tracking_count]+".gif", 'wb') do|f|
          f.write(Base64.decode64(graphic_image))
        end
        #        File.open("#{directory}/#{tracking_no_array[tracking_count]}.html", 'wb') do|f|
        #          f.write(Base64.decode64(html_code))
        #        end
        tracking_count = tracking_count + 1
      }
      tracking_count = 0
      shipping_packages.each{|package|
        package.update_attributes!(:tracking_no => tracking_no_array[tracking_count])
        tracking_count = tracking_count + 1
      }
      shipping.update_attributes!(:tracking_no => tracking_no_array[0],:generate_new_label_flag => 'N')
      activity_message = Artwork::ArtworkCrud.create_activity_message(order,"#{shipping.ship_method} LABEL PRINTED")
      activity = order.create_sales_order_transaction_activity(activity_message)
      activity.save!
      return tracking_no_array,'success'
    rescue Exception => ex
      return ex,'error'
    end
  end

  def self.get_shipping_payment_account(shipping,ups_shipper_number)
    if shipping.bill_transportation_to == 'Shipper (TEKWELD)'
      xml = "<Prepaid>
                <BillShipper>
                  <AccountNumber>#{ups_shipper_number}</AccountNumber>
                </BillShipper>
             </Prepaid>"
    elsif(shipping.bill_transportation_to == 'Third Party')
      xml = "<BillThirdParty>
                <BillThirdPartyShipper>
                  <AccountNumber>0Y765V</AccountNumber>
                  <ThirdParty>
                    <Address>
                      <PostalCode>11735</PostalCode>
                      <CountryCode>US</CountryCode>
                    </Address>
                  </ThirdParty>
                </BillThirdPartyShipper>
              </BillThirdParty>"
    elsif(shipping.bill_transportation_to == 'Receiver')
      xml = "<FreightCollect>
                <BillReceiver>
                  <AccountNumber>0Y765V</AccountNumber>
                  <Address>
                      <PostalCode>11735</PostalCode>
                      <CountryCode>US</CountryCode>
                    </Address>
                </BillReceiver>
             </FreightCollect>"
    end
    return xml
  end


  def self.get_package_xml_for_ups_label(order,shipping)
    xml = ""
    shipping.sales_order_shipping_packages.active.each{|shipping_package|
      if shipping_package.update_flag == 'Y'
            xml = xml + "<Package>
          <ReferenceNumber>
            <Code>02</Code>
            <Value>#{order.ext_ref_no}</Value>
          </ReferenceNumber>
          <ReferenceNumber>
            <Code>02</Code>
            <Value>#{order.trans_no}</Value>
          </ReferenceNumber>

          <PackageServiceOptions>
            <InsuredValue>
              <CurrencyCode>USD</CurrencyCode>
              <MonetaryValue>1000</MonetaryValue>
            </InsuredValue>
          </PackageServiceOptions>
          <PackagingType>
            <Code>00</Code>
            <Description></Description>
          </PackagingType>
            <Description>Rate</Description>
          <PackageWeight>
            <UnitOfMeasurement>
              <Code>LBS</Code>
            </UnitOfMeasurement>
            <Weight>#{shipping_package.carton_wt}</Weight>
          </PackageWeight>
          <Dimensions>
            <UnitOfMeasurement>
              <Code>IN</Code>
            </UnitOfMeasurement>
            <Length>#{shipping_package.carton_length}</Length>
            <Width>#{shipping_package.carton_width}</Width>
            <Height>#{shipping_package.carton_height}</Height>
          </Dimensions>
        </Package>"
      end
    }
    return xml
  end
  
  def self.make_ups_label_html(doc,labels,schema_name)
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
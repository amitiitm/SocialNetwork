class Quotation::SalesQuotationCrud
  include General
  include ActiveMerchant::Shipping

  def self.list_quotations(doc)
    criteria = Setup::Criteria.fill_criteria_for_query(doc/:criteria)
    condition = "( sales_quotations.company_id = #{criteria.company_id}) AND
                     (customer_code between '#{criteria.str1}' and '#{criteria.str2}' AND (0 =#{criteria.multiselect1.length} or customer_code in ('#{criteria.multiselect1}'))) AND
                     (trans_no between '#{criteria.str3}' and '#{criteria.str4}' AND (0 =#{criteria.multiselect2.length} or trans_no in ('#{criteria.multiselect2}'))) AND
                     (trans_date between '#{criteria.dt1}' and '#{criteria.dt2}' ) AND
                     (account_period_code between '#{criteria.str5[0,8]}' and '#{criteria.str6[0,8]}' AND (0 =#{criteria.multiselect3.length} or account_period_code in ('#{criteria.multiselect3}')))  AND
                     (ext_ref_no between '#{criteria.str9}' and '#{criteria.str10}' AND (0 =#{criteria.multiselect5.length} or ext_ref_no in ('#{criteria.multiselect5}')))
                     AND sales_quotations.trans_flag = 'A'"
    condition = convert_sql_to_db_specific(condition)
    Quotation::SalesQuotation.find_by_sql ["select CAST((
                                  select(select *
                                  from sales_quotations
                                  where #{condition}
                                  FOR XML PATH('sales_quotation'), TYPE,ELEMENTS XSINIL
                                  )FOR XML PATH('sales_quotations')) AS varchar(MAX)) as xmlcol"
    ]
  end

  def self.show_quotation(id)
    Quotation::SalesQuotation.find_all_by_id(id)
  end

  def self.create_quotations(doc)
    quotations = []
    (doc/:sales_quotations/:sales_quotation).each{|sales_quotation_doc|
      quotation = create_quotation(sales_quotation_doc)
      quotations <<  quotation if quotation
    }
    quotations
  end

  def self.create_quotation(doc)
    quotation = add_or_modify_quotation(doc)
    return  if !quotation
    quotation.generate_trans_no('SAQIOD') if quotation.new_record?
    quotation.apply_header_fields_to_lines
    if quotation.new_record?
      quotation.create_sales_quotation_transaction_activity('NEW ESTIMATE')
    end
    save_proc = Proc.new{
      if quotation.new_record?
        quotation.save!
      else
        quotation.save!
        quotation.save_lines
        quotation.sales_quotation_lines.each{|line|
          line.sales_quotation_line_charges.each{|charge|
            charge.save!
          }
        }
        quotation.sales_quotation_lines.each{|line|
          line.sales_quotation_attributes_values.each{|value|
            value.save!
          }
        }
      end
    }
    quotation.save_transaction(&save_proc)
    return quotation
  end

  def self.add_or_modify_quotation(doc)
    id =  parse_xml(doc/'id') if (doc/'id').first
    quotation = Quotation::SalesQuotation.find_or_create(id)
    return if !quotation
    quotation.apply_attributes(doc)
    quotation.fill_default_header_values() if quotation.new_record?
    quotation.run_block do
      quotation.max_serial_no = quotation.sales_quotation_lines.maximum_serial_no
      quotation.build_lines(doc/:sales_quotation_lines/:sales_quotation_line)
      quotation.max_serial_no = quotation.sales_quotation_shippings.maximum_serial_no
      quotation.build_lines(doc/:sales_quotation_shippings/:sales_quotation_shipping)
    end
    return quotation
  end

  #shipping methods
  def self.get_ups_shipping_methods(doc)
    begin
      catalog_item_id = parse_xml(doc/:params/'catalog_item_id')
      company_id = parse_xml(doc/:params/'company_id')
      trans_no = parse_xml(doc/:params/'trans_no')
      qty = parse_xml(doc/:params/'qty')
      zip_code = parse_xml(doc/:params/'zip_code')
      country = parse_xml(doc/:params/'country')
      state = parse_xml(doc/:params/'state')
      ship_method_code = parse_xml(doc/:params/'ship_method_code')
      return "Please select the ship method available.",'error'  if ship_method_code.to_s==''
      if (country != '' and country.length > 2)
        return "Country Code Should Be of 2 char.",'error'
      elsif (state != '' and state.length > 2)
        return "State Code Should Be of 2 char.",'error'
      end
      if (zip_code and country and state)
        catalog_item_packages = Item::CatalogItemPackage.find_by_sql ["select * from catalog_item_packages where catalog_item_id = ? and trans_flag = 'A' order by pcs_per_carton",catalog_item_id]
        return "Please Define Item Packages",'error' if !catalog_item_packages[0]
        xml_req = "
          #{header_xml = create_shipping_header_xml(zip_code,country,state,ship_method_code,catalog_item_id,company_id)}
          #{xml = Setup::ShippingUtility.create_shipping_package_xml(catalog_item_id,qty,trans_no,catalog_item_packages)}
  <ShipmentServiceOptions />
  </Shipment>
</RatingServiceSelectionRequest>"
        puts xml_req
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

  def self.get_fedex_shipping_methods(doc)
    begin
      item_id = parse_xml(doc/:params/'catalog_item_id')
      company_id = parse_xml(doc/:params/'company_id')
      qty = parse_xml(doc/:params/'qty')
      zip_code = parse_xml(doc/:params/'zip_code')
      country = parse_xml(doc/:params/'country')
      state = parse_xml(doc/:params/'state')
      ship_method_code = parse_xml(doc/:params/'ship_method_code')
      return "Please select the ship method available.",'error'  if ship_method_code.to_s==''
      if (country != '' and country.length > 2)
        return "Country Code Should Be of 2 char.",'error'
      elsif (state != '' and state.length > 2)
        return "State Code Should Be of 2 char.",'error'
      end
      if (zip_code and country and state)
        catalog_item_packages = Item::CatalogItemPackage.find_by_sql ["select * from catalog_item_packages where catalog_item_id = ? and trans_flag = 'A' order by pcs_per_carton",item_id]
        return "Please Define Item Packages",'error' if !catalog_item_packages[0]
        sales_quotation_packages = Setup::ShippingUtility.create_shipping_packages(qty,catalog_item_packages)
        doc = Setup::ShippingUtility.create_shipping_xml(zip_code,country,state,ship_method_code,sales_quotation_packages,item_id,company_id)
        doc = Hpricot::XML(doc)
        response_doc ,text = Shipping::Fedex.get_fedex_methods_xml(doc)
        return response_doc , text
      end
    rescue Exception => ex
      return ex,'error'
    end
  end

  def self.get_usps_shipping_methods(doc)
    begin
      item_id = parse_xml(doc/:params/'catalog_item_id')
      company_id = parse_xml(doc/:params/'company_id')
      qty = parse_xml(doc/:params/'qty')
      zip_code = parse_xml(doc/:params/'zip_code')
      country = parse_xml(doc/:params/'country')
      state = parse_xml(doc/:params/'state')
      ship_method_code = parse_xml(doc/:params/'ship_method_code')
      return "Please select the ship method available.",'error'  if ship_method_code.to_s==''
      if (country != '' and country.length > 2)
        return "Country Code Should Be of 2 char.",'error'
      elsif (state != '' and state.length > 2)
        return "State Code Should Be of 2 char.",'error'
      end
      if (zip_code and country and state)
        catalog_item_packages = Item::CatalogItemPackage.find_by_sql ["select * from catalog_item_packages where catalog_item_id = ? and trans_flag = 'A' order by pcs_per_carton",item_id]
        return "Please Define Item Packages",'error' if !catalog_item_packages[0]
        sales_quotation_packages = Setup::ShippingUtility.create_shipping_packages(qty,catalog_item_packages)
        doc = Setup::ShippingUtility.create_shipping_xml(zip_code,country,state,ship_method_code,sales_quotation_packages,item_id,company_id)
        doc = Hpricot::XML(doc)
        available_services,rate,inhand_dates,text = Shipping::Usps.get_usps_methods_xml(doc)
        return available_services,rate,inhand_dates,text
      end
    rescue Exception => ex
      return ex,'error'
    end
  end

  def self.create_shipping_header_xml(zip_code,country,state,ship_method_code,catalog_item_id,company_id)
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
    <RequestOption>Rate</RequestOption>
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
    </ShipFrom>
<Service><Code>#{ship_method_code}</Code></Service>
    "
    return xml_req
  end

  def self.generate_sales_estimate_pdf(estimate_id,schema_name,url_with_port,flag)
    begin
      sales_quotations = Quotation::SalesQuotation.find_by_sql ["select * from sales_quotations  where trans_flag = 'A' and id = ?",estimate_id]
      sales_quotation_shippings = Quotation::SalesQuotationShipping.find_by_sql ["select * from  sales_quotation_shippings where trans_flag='A' and sales_quotation_id = ?",estimate_id]
      sales_quotation_lines = Quotation::SalesQuotationLine.find_by_sql ["select * from sales_quotation_lines where trans_flag='A' and sales_quotation_id = ?",estimate_id]
      pdf = Prawn::Document.new(:page_size=>"A4",:left_margin=>15)
      Sales::PrawnPdfCrud.generate_estimate_pdf_header(pdf,sales_quotations, sales_quotation_shippings,schema_name)
      Sales::PrawnPdfCrud.generate_estimate_pdf_body(pdf, sales_quotation_lines)
      Sales::PrawnPdfCrud.generate_estimate_pdf_footer(pdf)
      path = Setup::Type.find(:first, :conditions=>['type_cd = ? and subtype_cd = ?','UPLOAD_FOLDER','REPORT_PRINT'])
      if path
        directory =  "#{Dir.getwd}" + path.value + schema_name
      end
      filename = "#{Time.now().strftime('%Y%m%d%H%M%S')}"
      absolute_filename = File.join(directory, filename)+ "." + "pdf"
      pdf.render_file "#{absolute_filename}"
      if flag == true
        email = Email::Email.send_email('SENDESTIMATE',sales_quotations[0])
        email.file_name_path = absolute_filename
        email.save!
        activity_message=create_activity_message(sales_quotations,"ESTIMATE SENT TO #{sales_quotations[0].corr_dept_email}")
        activity=sales_quotations.first.create_sales_quotation_transaction_activity(activity_message)
        activity.save!
      end
      return true,absolute_filename
    rescue Exception => ex
      return false,ex
    end
  end


  def self.create_activity_message(sales_quotations,activity_code)
    result = Quotation::SalesQuotation.find_by_sql ["select count(*) as activity_count from sales_quotation_transaction_activities
                                                    where sales_quotation_id=#{sales_quotations.first.id} and trans_flag='A' and
                                                    sales_quotation_stage_code like ?",activity_code+'%']
    if result[0].activity_count.to_i == 0
      activity_code
    else
      return "#{activity_code} #{result[0].activity_count.to_i+1} TIMES"
    end
  end

  def self.list_estimates_for_sales_order(doc)
    criteria = Setup::Criteria.fill_criteria_for_query(doc/:criteria)
    Quotation::SalesQuotation.find_by_sql ["select CAST((
                                  select(select distinct sq.trans_no,sq.trans_bk,sq.id as order_id,sq.trans_date,sq.ext_ref_no,sql.id,
                                                sql.catalog_item_code,sql.item_description,sql.id as ref_virtual_line_id,types.value as order_type
                                                from sales_quotations sq
                                                inner join sales_quotation_lines sql on sql.sales_quotation_id = sq.id
                                                left outer join types on (
                                                  types.type_cd = 'trans_type'
                                                  and types.subtype_cd = 'so'
                                                  and sq.trans_type = types.value
                                                )
                                                where
                                                DATEDIFF(day,sq.trans_date,GETDATE()) <= 30 AND
                                                sq.trans_flag = 'A' AND sq.company_id = ? AND
                                                (sq.customer_id between ? AND ?)
                                                order by sq.trans_no
                                   FOR XML PATH('sales_quotation'), TYPE,ELEMENTS XSINIL
                                  )FOR XML PATH('sales_quotations')) AS varchar(MAX)) as xmlcol",criteria.company_id,criteria.int1,criteria.int2
    ]
  end

  def self.generate_order_xml_from_quotation(order_doc)
    id = parse_xml(order_doc/'id')
    ref_trans_bk = parse_xml(order_doc/'ref_trans_bk')
    ref_type = parse_xml(order_doc/'ref_type')
    ref_trans_no = parse_xml(order_doc/'ref_trans_no')
    ref_quotation_line_id = parse_xml(order_doc/'ref_virtual_line_id')
    if (id == '' and ref_type == TRANS_TYPE_QUOTATION_ORDER and ref_trans_no != '' and ref_trans_bk == 'SQ01')
      created_by = parse_xml(order_doc/'created_by')
      company_id = parse_xml(order_doc/'company_id')
      sales_order_xml = generate_order_xml(order_doc)
      sales_order_artwork_xml = parse_xml(order_doc/'sales_order_artworks')
      sales_order_line_xml = generate_order_line_xml_from_quotation(ref_quotation_line_id,created_by,company_id)
      sales_order_shipping_xml = generate_shipping_line_xml_from_quotation(ref_trans_no,created_by,company_id)
      sales_order_attributes_xml = generate_order_attributes_xml_from_quotation(ref_quotation_line_id,created_by,company_id)
      sales_order_line_accessories_service_charge_xml = generate_order_line_accessories_and_service_charge_xml_from_quotation(ref_quotation_line_id,created_by,company_id)

      order_doc = "<sales_orders>"
      order_doc = order_doc + sales_order_xml
      order_doc = order_doc + '<sales_order_artworks>' +  sales_order_artwork_xml + '</sales_order_artworks>'
      order_doc = order_doc + '<sales_order_lines>' +  sales_order_line_xml + sales_order_line_accessories_service_charge_xml + '</sales_order_lines>'
      order_doc = order_doc +  sales_order_shipping_xml
      order_doc = order_doc +  sales_order_attributes_xml
      order_doc = order_doc + '</sales_order></sales_orders>'
      order_doc = Hpricot::XML(order_doc)
      return order_doc
    else
      return order_doc
    end
  end

  def self.generate_order_xml(order_doc)
    order_xml = order_doc.to_s.split('<sales_order_artworks>')
    sales_order_xml = order_xml[0].to_s
    return sales_order_xml
  end

  def self.generate_order_line_xml_from_quotation(ref_quotation_line_id,created_by,company_id)
    quotation_line = Quotation::SalesQuotationLine.find_by_id(ref_quotation_line_id)
    catalog_item = Item::CatalogItem.find(quotation_line.catalog_item_id)
    sales_order_line_xml = "<sales_order_line>
              <catalog_item_id>#{quotation_line.catalog_item_id}</catalog_item_id>
              <catalog_item_code>#{quotation_line.catalog_item_code}</catalog_item_code>
              <unit />
              <item_qty>#{catalog_item.column1}</item_qty>
              <item_price>#{quotation_line.column1}</item_price>
              <item_type>I</item_type>
              <line_type>M</line_type>
              <item_amt>#{quotation_line.column1_amt}</item_amt>
              <item_description>#{quotation_line.item_description}</item_description>
              <trans_flag>A</trans_flag>
              <trans_bk />
              <trans_date>#{Time.now.to_date}</trans_date>
              <serial_no />
              <image_thumnail/>
              <company_id>#{company_id}</company_id>
              <updated_by/>
              <created_by>#{created_by}</created_by>
              <id />
              <lock_version>0</lock_version> 
           </sales_order_line>"
    return sales_order_line_xml

  end

  def self.generate_shipping_line_xml_from_quotation(ref_trans_no,created_by,company_id)
    quotation = Quotation::SalesQuotation.find_by_trans_no(ref_trans_no)
    quotation_shipping = Quotation::SalesQuotationShipping.find_by_sales_quotation_id(quotation.id)
    sales_order_shipping_xml =  "
                                <sales_order_shippings>
                                  <sales_order_shipping>
                                    <pre_prod_flag>#{quotation_shipping.pre_prod_flag}</pre_prod_flag>
                                    <ship_qty>0</ship_qty>
                                    <customer_shipping_id>#{quotation_shipping.customer_shipping_id}</customer_shipping_id>
                                    <customer_shipping_code>#{quotation_shipping.customer_shipping_code}</customer_shipping_code>
                                    <ship_name>#{quotation_shipping.ship_name}</ship_name>
                                    <attention />
                                    <ship_address1>#{quotation_shipping.ship_address1}</ship_address1>
                                    <ship_address2>#{quotation_shipping.ship_address2}</ship_address2>
                                    <ship_city>#{quotation_shipping.ship_city}</ship_city>
                                    <ship_state>#{quotation_shipping.ship_state}</ship_state>
                                    <ship_zip>#{quotation_shipping.ship_zip}</ship_zip>
                                    <ship_country>#{quotation_shipping.ship_country}</ship_country>
                                    <ship_phone>#{quotation_shipping.ship_phone}</ship_phone>
                                    <ship_fax>#{quotation_shipping.ship_fax}</ship_fax>
                                    <serial_no/>
                                    <estimated_ship_date>#{Time.now.to_date}</estimated_ship_date>
                                    <estimated_arrival_date/>
                                    <bill_transportation_to>#{quotation_shipping.bill_transportation_to}</bill_transportation_to>
                                    <shipping_code>#{quotation_shipping.shipping_code}</shipping_code>
                                    <ship_method>#{quotation_shipping.ship_method}</ship_method>
                                    <ship_method_code>#{quotation_shipping.ship_method_code}</ship_method_code>
                                    <shipvia_accountnumber>#{quotation_shipping.shipvia_accountnumber}</shipvia_accountnumber>
                                    <ship_date />
                                    <inhand_date />
                                    <ship_amt>0.00</ship_amt>
                                    <internal_ship_date>#{Time.now.to_date}</internal_ship_date>
                                    <internal_inhand_date/>
                                    <company_id>#{company_id}</company_id>
                                    <updated_by />
                                    <created_by>#{created_by}</created_by>
                                    <id />
                                    <lock_version>0</lock_version>
                                 </sales_order_shipping>
                               </sales_order_shippings>"
    return sales_order_shipping_xml
  end

  def self.generate_order_attributes_xml_from_quotation(ref_quotation_line_id,created_by,company_id)
    quotation_attributes = Quotation::SalesQuotationAttributesValue.find_all_by_sales_quotation_line_id_and_trans_flag(ref_quotation_line_id,'A')
    sales_order_attributes_xml = ""
    quotation_attributes.each{|quotation_attribute|
      quotation_attribute_xml = "<sales_order_attributes_value>
                                    <catalog_attribute_code>#{quotation_attribute.catalog_attribute_code}</catalog_attribute_code>
                                    <remarks />
                                    <catalog_attribute_value_code>#{quotation_attribute.catalog_attribute_value_code}</catalog_attribute_value_code>
                                    <company_id>#{company_id}</company_id>
                                    <updated_by/>
                                    <created_by>#{created_by}</created_by>
                                    <id />
                                    <lock_version>0</lock_version>
                                    <catalog_item_id>#{quotation_attribute.catalog_item_id}</catalog_item_id>
                                 </sales_order_attributes_value>"
      sales_order_attributes_xml = sales_order_attributes_xml + quotation_attribute_xml
    }
    sales_order_attributes_xml = "<sales_order_attributes_values>#{sales_order_attributes_xml}</sales_order_attributes_values>"
    return sales_order_attributes_xml
  end

  def self.generate_order_line_accessories_and_service_charge_xml_from_quotation(ref_quotation_line_id,created_by,company_id)
    quotation_line_charges = Quotation::SalesQuotationLineCharge.find_all_by_sales_quotation_line_id_and_trans_flag(ref_quotation_line_id,'A')
    sales_order_line_xml = ""
    quotation_line_charges.each{|quotation_line_charge|
      quotation_line_xml = "<sales_order_line>
                              <catalog_item_id>#{quotation_line_charge.catalog_item_id}</catalog_item_id>
                              <catalog_item_code>#{quotation_line_charge.catalog_item_code}</catalog_item_code>
                              <unit>Pcs</unit>
                              <item_qty>#{quotation_line_charge.item_qty}</item_qty>
                              <item_price>#{quotation_line_charge.item_price}</item_price>
                              <item_type>#{quotation_line_charge.item_type}</item_type>
                              <line_type>#{quotation_line_charge.line_type}</line_type>
                              <item_amt>#{quotation_line_charge.item_amt}</item_amt>
                              <item_description>#{quotation_line_charge.item_description}</item_description>
                              <trans_flag>A</trans_flag>
                              <trans_bk />
                              <trans_no />
                              <trans_date />
                              <serial_no/>
                              <image_thumnail />
                              <company_id>#{company_id}</company_id>
                              <updated_by />
                              <created_by>#{created_by}</created_by>
                              <id />
                              <lock_version>0</lock_version>
                              <updated_by_code>ADMIN</updated_by_code>
                            </sales_order_line>"
      sales_order_line_xml = sales_order_line_xml + quotation_line_xml
    }
    return sales_order_line_xml
  end

  def self.find_quotation_item_price(ref_trans_no,catalog_item_id)
    quotation = Quotation::SalesQuotation.find_by_trans_no(ref_trans_no)
    quotation_lines = Quotation::SalesQuotationLine.find_by_sql ["select column1,column2,column3,column4,column5,column6,column7,column8,
                                                                         column9,column10,column11,column12,column13,column14,column15
                                                                         from sales_quotation_lines
                                                                         where trans_flag = 'A' and catalog_item_id = ? and
                                                                         sales_quotation_id = ?",catalog_item_id,quotation.id]
    quotation_lines
  end
  private_class_method :create_quotation, :add_or_modify_quotation

end

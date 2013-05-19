class Setup::ShippingUtility
  include General
  include ActiveMerchant::Shipping


  ## All these function are used to calculate shipping from sales estimate ##
  def self.create_shipping_package_xml(item_id,qty,trans_no,catalog_item_packages) 
    #    catalog_item_packages = Item::CatalogItemPackage.find_all_by_catalog_item_id_and_trans_flag(item_id,'A')
    remaining_qty = qty.to_i
    carton_size_arr = []
    while remaining_qty > 0
      carton_obj = get_carton_size(remaining_qty,catalog_item_packages)
      carton_size_arr << carton_obj
      remaining_qty = remaining_qty - carton_obj.pcs_per_carton
    end
    xml = get_package_xml(item_id,carton_size_arr,trans_no,qty)
  end

  def self.get_carton_size(qty,catalog_item_packages)
    min_package = ''
    max_package = ''
    catalog_item_packages.each{|package|
      if package.pcs_per_carton.to_i <= qty.to_i
        #        min_qty = package.pcs_per_carton
        min_package = package
        break if package.pcs_per_carton.to_i == qty.to_i
      else
        #        max_qty = package.pcs_per_carton
        max_package = package
        break
      end
    }
    return max_package if max_package != ''
    return min_package if min_package
  end

  def self.get_package_xml(item_id,carton_size_arr,trans_no,qty) 
    item_price = Item::CatalogItemPrice.find_by_catalog_item_id_and_trans_flag(item_id,'A')
    xml = ""
    carton_size_arr.each{|carton|
      xml = xml + "<Package>
      <PackageServiceOptions>
        <InsuredValue>
          <CurrencyCode>USD</CurrencyCode>
          <MonetaryValue>#{item_price.column1.to_f * carton.pcs_per_carton.to_i}</MonetaryValue>
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
        <Weight>#{carton.carton_wt}</Weight>
      </PackageWeight>
      <Dimensions>
        <UnitOfMeasurement>
          <Code>IN</Code>
        </UnitOfMeasurement>
        <Length>#{carton.carton_length}</Length>
        <Width>#{carton.carton_width}</Width>
        <Height>#{carton.carton_height}</Height>
      </Dimensions>
    </Package>"
    }
    return xml
  end

  #  def self.generate_fedex_package_xml(doc)
  #    packages = []
  #    (doc/:params/:packagexml/:sales_order_shipping_packages/:sales_order_shipping_package).each{|package|
  #      carton_wt = parse_xml(package/'carton_wt')
  #      carton_length =  parse_xml(package/'carton_length')
  #      carton_width = parse_xml(package/'carton_width')
  #      carton_height = parse_xml(package/'carton_height')
  #      packages << Package.new((carton_wt.to_i), [carton_length.to_i, carton_width.to_i,carton_height.to_i], :units => :imperial)
  #    }
  #    return packages
  #  end

  #  def self.get_fedex_shipping_methods(doc)
  #    #    item_id = parse_xml(doc/:params/'catalog_item_id')
  #    #    trans_no = parse_xml(doc/:params/'trans_no')
  #    #    qty = parse_xml(doc/:params/'qty')
  #    zip_code = parse_xml(doc/:params/'zip_code')
  #    country = parse_xml(doc/:params/'country')
  #    state = parse_xml(doc/:params/'state')
  #    if (country != '' and country.length > 2)
  #      return "Country Code Should Be of 2 char.",'error'
  #    elsif (state != '' and state.length > 2)
  #      return "State Code Should Be of 2 char.",'error'
  #    end
  #    begin
  #      if (zip_code and country and state)
  #        #        catalog_item_packages = Item::CatalogItemPackage.find_by_sql ["select * from catalog_item_packages where catalog_item_id = ? and trans_flag = 'A' order by pcs_per_carton",item_id]
  #        #        return "Please Define Item Packages",'error' if !catalog_item_packages[0]
  #        packages = generate_fedex_package_xml(doc)
  #        origin = Location.new(:country => 'US',:zip => '08817')
  #        destination = Location.new(:country => country,:postal_code => zip_code)#K1P 1J1
  #        fedex = FedEx.new(:login => '100074504', :password => 'dqlTvWtuKHxwEPklo1Y9qaMyZ', :key => 'IXI35n6RpDQXQga8', :account => '510087526', :meter => '100074504',:test => true)
  #        response = fedex.find_rates(origin, destination, packages)
  #        shipping_methods = response.rates
  #        return shipping_methods,'success'
  #      else
  #        return "Please Provide Sufficient Data",'error'
  #      end
  #    rescue Exception => ex
  #      return ex,'error'
  #    end
  #  end

  #  def self.create_shipping_package_fedex(item_id,qty,trans_no,catalog_item_packages)
  #    remaining_qty = qty.to_i
  #    carton_size_arr = []
  #    while remaining_qty > 0
  #      carton_obj = get_carton_size(remaining_qty,catalog_item_packages)
  #      carton_size_arr << carton_obj
  #      remaining_qty = remaining_qty - carton_obj.pcs_per_carton
  #    end
  #    xml = get_package_fedex(item_id,carton_size_arr,trans_no,qty)
  #  end

  #  def self.get_package_fedex(item_id,carton_size_arr,trans_no,qty)
  #    packages = []
  #    carton_size_arr.each{|carton|
  #      packages << Package.new((carton.carton_wt.to_i), [carton.carton_length, carton.carton_width,carton.carton_height], :units => :imperial)
  #    }
  #    return packages
  #  end

  ## create shipping packages as we don't have packages for sales quotation
  def self.create_shipping_packages(qty,catalog_item_packages)
    remaining_qty = qty.to_i
    carton_size_arr = []
    while remaining_qty > 0
      carton_obj = get_carton_size(remaining_qty,catalog_item_packages)
      carton_size_arr << carton_obj
      remaining_qty = remaining_qty - carton_obj.pcs_per_carton
    end
    return carton_size_arr
  end

  ## create fedex_xml for sales quotation rates
  def self.create_shipping_xml(zip_code,country,state,ship_method_code,sales_quotation_packages,catalog_item_id,company_id)
    catalog_item_price = Item::CatalogItemPrice.active.find_by_catalog_item_id(catalog_item_id)
    column1_price = catalog_item_price.column1
    package_xml = "<packagexml>
                        <sales_order_shipping_packages>"
    sales_quotation_packages.each{|package|
      pcs_per_carton = package.pcs_per_carton.to_i
      insured_charge = pcs_per_carton * column1_price
      package_xml = package_xml + "<sales_order_shipping_package>
                                            <carton_wt>#{package.carton_wt}</carton_wt>
                                          <carton_length>#{package.carton_length}</carton_length>
                                          <carton_width>#{package.carton_width}<carton_width>
                                          <carton_height>#{package.carton_height}</carton_height>
                                          <insured_charge>#{insured_charge}</insured_charge>
                                       </sales_order_shipping_package>"
    }
    package_xml = package_xml + "</sales_order_shipping_packages>"
    xml = "<params>
                  <company_id>#{company_id}</company_id>
                  <catalog_item_id>#{catalog_item_id}</catalog_item_id>
                  <zip_code>#{zip_code}</zip_code>
                  <country>#{country}</country>
                  <state>#{state}</state>
                  <ship_method_code>#{ship_method_code}</ship_method_code>
                  <estimated_ship_date>#{Time.now.to_date}</estimated_ship_date>
                  #{package_xml}
               </params>"
    return xml
  end
end

class Setup::SetupController < ApplicationController
  require 'hpricot'
  include General
  include ClassMethods
  include Accounts::GenerateCheckNumber


  def fetch_info_for_action
    doc = Hpricot::XML(request.raw_post)
    action =  parse_xml(doc/'action')  if (doc/'action').first
    #    action = 'fetch_thread_colors'
    case action
      ############ AUTHORIZE.NET FUNCTIONS ##########################
    when 'create_customer_profile'
      result = Customer::CustomerCrud.create_customer_profile(doc)
      render :xml => "<result>#{result}</result>"

    when 'create_customer_payment_profile' ### not in use
      result = Customer::CustomerCrud.create_customer_payment_profile(doc)
      render :xml => "<result>#{result}</result>"

    when 'delete_customer_payment_profile'
      result = Customer::CustomerCrud.delete_customer_payment_profile(doc)
      render :xml => "<result>#{result}</result>"

    when 'get_customer_payment_profile' ## not in use
      customer_id = parse_xml(doc/'customer_id')  if (doc/'customer_id').first
      @payment_profiles = Payment::CustomerPaymentProfile.find(:all,:conditions => ["trans_flag = 'A' and customer_id =?",customer_id])
      respond_to_action('get_customer_payment_profile')

    when 'authorize_customer_payment'
      result = Payment::PaymentCrud.authorize_payment(doc)
      render :xml => "<result>#{result}</result>"
      #############################################

    when 'preview_artwork_ack'
      schema_name = session[:schema]
      artwork_id = parse_xml(doc/:params/'artwork_id')
      artwork_obj = Sales::SalesOrderArtwork.find_by_id(artwork_id)
      order = Sales::SalesOrder.find_by_id(artwork_obj.sales_order_id)
      order_line = Sales::SalesOrderLine.active.find_by_sales_order_id_and_item_type_and_line_type(order.id,'I','M')
      path = Setup::Type.find_by_type_cd_and_subtype_cd('UPLOAD_FOLDER','ATTACHMENT')
      if path
        directory =  "#{Dir.getwd}" + "/" + path.value + schema_name
      end
      artwork_filename = File.join(directory,artwork_obj.artwork_file_name)
      absolute_filename,text = Artwork::ArtworkCrud.generate_artwork_acknowledgment_pdf(artwork_obj,order,artwork_filename,order_line,schema_name)
      if text == 'error'
        render :xml => "<errors><error>#{absolute_filename}</error></errors>"
      else
        filename = absolute_filename.split('/').last
        render :xml =>"<url><result>#{filename}</result></url>"
      end

      ######### fetch thread colors for receive digitization screen
    when 'fetch_thread_colors'
      thread_company = parse_xml(doc/'thread_company')  if (doc/'thread_company').first
      thread_category = parse_xml(doc/'thread_category')  if (doc/'thread_category').first
      @colors = Production::ThreadColor.find_by_sql ["select CAST((
                                  select(select *  from thread_colors where thread_company = '#{thread_company}' and thread_category = '#{thread_category}'
                                  FOR XML PATH('thread_color'), TYPE,ELEMENTS XSINIL
                                  )FOR XML PATH('thread_colors')) AS varchar(MAX)) as xmlcol"]
      #      render :xml=>'<encoded>'+Base64.encode64(Zlib::Deflate.deflate(@colors[0].xmlcol))+'</encoded>'
      render :xml=>@colors[0].xmlcol
    when 'fetch_customer_contact_detail'
      contact_name = parse_xml(doc/'contact_name')  if (doc/'contact_name').first
      customer_id = parse_xml(doc/'customer_id')  if (doc/'customer_id').first
      first_name = contact_name.split(" ")[0]
      last_name = contact_name.split(" ")[1]
      @customer_contacts = Customer::CustomerContact.find_by_sql ["select CAST((
                                  select(select business_phone,manager_phone,home_phone,cell_phone from customer_contacts where trans_flag = 'A' and first_name = ? and last_name = ? and customer_id = ? 
                                   FOR XML PATH('customer_contact'), TYPE,ELEMENTS XSINIL
                                  )FOR XML PATH('customer_contacts')) AS varchar(MAX)) as xmlcol",first_name,last_name,customer_id]
      render :xml=>@customer_contacts[0].xmlcol

    when 'fetch_setup_charge_for_item_option_value' ## NOT IN USE
      old_catalog_attribute_value_code  = parse_xml(doc/:params/'old_catalog_attribute_value_code')
      new_catalog_attribute_value_code  = parse_xml(doc/:params/'new_catalog_attribute_value_code')
      puts doc
      customer_id  = parse_xml(doc/:params/'customer_id')
      @catalog_items,@cust_prices = Item::CatalogItemCrud.fetch_setup_charge_for_item_option_value(old_catalog_attribute_value_code,customer_id)
      @new_catalog_items,@new_cust_prices = Item::CatalogItemCrud.fetch_setup_charge_for_item_option_value(new_catalog_attribute_value_code,customer_id)
      respond_to_action('fetch_setup_charge_for_item_option_value')

    when 'fetch_setup_charge_for_item_option_code' ## NOT IN USE
      catalog_attribute_code  = parse_xml(doc/:params/'catalog_attribute_code')
      customer_id  = parse_xml(doc/:params/'customer_id')
      @catalog_items,@cust_prices = Item::CatalogItemCrud.fetch_setup_charge_for_item_option_code(catalog_attribute_code,customer_id)
      respond_to_action('fetch_setup_charge_for_item_option_code')

    when 'accountperiod'
      trans_dt = parse_xml(doc/'id')  if (doc/'id').first
      #trans_dt = params[:id]
      account_period = Setup::AccountPeriod.period_from_date(trans_dt)
      respond_to do |wants|
        wants.xml {render :xml => account_period.to_xml() }
      end
    when 'termchange'
      code =  parse_xml(doc/'code')   if  (doc/'code').first  
      trans_date =  parse_xml(doc/'trans_date').to_datetime   if (doc/'trans_date').first 
      @terms = []
      @terms << Setup::Term.fill_terms(code,trans_date)    
      if @terms
        respond_to_action('termchange')
      else
        render :text => 'Terms not found'
      end
    when 'bankchangepaym'
      trans_type = PAYMENTS
      fetch_data_for_bank(trans_type,doc)
    when 'paymenttypechange'
      trans_type = PAYMENTS
      fetch_check_no(trans_type,doc)
    when 'customershippings'
      shipping_id  = parse_xml(doc/:params/'id')
      @shippings = Customer::CustomerList.show_customer_shipping(shipping_id)
      respond_to_action('show_customer_shippings')
   
    when 'paymentbank'  
      trans_type = PAYMENTS
      fetch_data_for_bank(trans_type,doc)
    when 'depositbank'  
      trans_type = DEPOSITS
      fetch_data_for_bank(trans_type,doc)
    when 'transferbank'  
      trans_type = BANKTRANSFER
      fetch_data_for_bank(trans_type,doc)
    when 'companystoreinfo'
      company_store_id = parse_xml(doc/'id')  if (doc/'id').first
      @company_store = []
      company_store = Setup::Company.find_by_id(company_store_id)
      @company_store << company_store
      render_view( @company_store,'company_stores','L')
    when 'vendorinfo'
      vendor_id = parse_xml(doc/'id')  if (doc/'id').first
      @vendors = Vendor::VendorCrud.show_vendor(vendor_id)
      render_view( @vendors,'vendors','L')
    when 'customerinfo'
      customer_id = parse_xml(doc/'id')  if (doc/'id').first
      @customers = Customer::CustomerCrud.show_customer(customer_id)
      render_view( @customers,'customers','L')
    when 'iteminfo'
      item_id = parse_xml(doc/'item_id')  if (doc/'item_id').first
      trans_date =  parse_xml(doc/'trans_date').to_datetime   if (doc/'trans_date').first 
      #       trans_date = '17/08/2010'.to_datetime   if (doc/'trans_date').first 
      @catalog_items = Item::CatalogItemCrud.show_catalog_item_with_price(item_id,trans_date)
      render_view( @catalog_items,'catalog_items','L')
    when 'customerdetail'
      customer_id  = parse_xml(doc/:params/'id')
      @trans_type =  parse_xml(doc/:params/'trans_type')
      @customers = Customer::CustomerCrud.show_customer(customer_id)
      respond_to_action('fetch_customer_details')
      ## new added on 29 july 2011 by amit
    when 'customerdetail_bycode'
      customer_code  = parse_xml(doc/:params/'code')
      @trans_type =  parse_xml(doc/:params/'trans_type')
      @customers = Customer::CustomerCrud.show_customer_by_code(customer_code)
      respond_to_action('fetch_customer_details')
    when 'vendordetail'
      vendor_id  = parse_xml(doc/:params/'id')
      @trans_type =  parse_xml(doc/:params/'trans_type')
      @vendors = Vendor::VendorCrud.show_vendor(vendor_id)
      respond_to_action('fetch_vendor_details')
    when 'packetinfo'
      trans_date =  parse_xml(doc/'trans_date').to_datetime   if (doc/'trans_date').first 
      packet_code = parse_xml(doc/'packet_code')  if (doc/'packet_code').first
      stock_check = parse_xml(doc/'stock_check')  if (doc/'stock_check').first
      @packet = Item::CatalogItemPacketCrud.show_catalog_item_packet_with_price(packet_code,trans_date,stock_check)
      render_view( @packet,'packets','L')
    when 'packetinfovalidate'
      item_code = parse_xml(doc/'item_code')  if (doc/'item_code').first
      packet_code = parse_xml(doc/'packet_code')  if (doc/'packet_code').first
      stock_check = parse_xml(doc/'stock_check')  if (doc/'stock_check').first
      @packet = Item::CatalogItemPacketCrud.validate_catalog_item_by_packet(item_code,packet_code,stock_check)
      render_view( @packet,'packets','L')
    when 'diamondpacketinfo'
      #       diamond_packet_no='test'
      diamond_packet_no = parse_xml(doc/'diamond_packet_no')  if (doc/'diamond_packet_no').first
      stock_check = parse_xml(doc/'stock_check')  if (doc/'stock_check').first
      @diamond_packet =Diamond::DiamondPacketCrud.search_all_by_diamond_packet_no(diamond_packet_no,stock_check)
      respond_to_action('show_diamond_packet_info')
    when 'diamondpacketinfovalidate'
      lot_number = parse_xml(doc/'lot_number')  if (doc/'lot_number').first
      stock_check = parse_xml(doc/'stock_check')  if (doc/'stock_check').first
      @diamond_packet = Diamond::DiamondPacketCrud.validate_diamond_packet_by_lot_no(lot_number,stock_check)
      render_view( @diamond_packet,'packets','L')
    when 'diamondlotinfo'
      #      diamond_lot_id=100
      diamond_lot_id = parse_xml(doc/'diamond_lot_id')  if (doc/'diamond_lot_id').first
      @diamond_lots= Diamond::DiamondCrud.show_lot(diamond_lot_id)
      #      render_view( @diamond_lots,'diamond_lots','L')   
      respond_to_action('show_lot')
    when 'packetlabelinfo'
      @label_mappings = Setup::PacketLabelMapping.find(:all)
      respond_to_action('show_packet_label')
    when 'generate_packet_code'
      packet_code=''
      check_packet_flag = Setup::Type.find(:first, :conditions=>['type_cd = ? and subtype_cd = ?','invn','generate_packet'])
      if  check_packet_flag.value=='A'
        catalog_item_packet = Item::CatalogItemPacket.new
        packet_code = catalog_item_packet.generate_packet_no('PK01','PKTSEQ') || ''
      end
      render :text=>packet_code
    when 'item_category_attributes_info'
      catalog_item_category_id  = parse_xml(doc/'id')
      @catalog_item_category_attributes = Item::CatalogItemCrud.list_catalog_item_category_attributes(catalog_item_category_id)
      respond_to_action('list_catalog_item_category_attributes')
    when 'get_unassigned_menus'
      @role_id=parse_xml(doc/:params/'role_id')
      @moodules = Admin::RolePermissionCrud.get_unassigned_menus
      respond_to_action('get_unassigned_menus')
    when 'get_menu_role_permissions'
      role_id=parse_xml(doc/:params/'id')
      @role_permissions = Admin::RolePermissionCrud.get_role_submenus(role_id)
      respond_to_action('get_menu_role_permissions')
    when 'get_assigned_user_role_list'
      @users_roles = Admin::UserPermissionCrud.list_users_roles
      respond_to_action('get_assigned_user_role_list')
    when 'jewelry_unit_conversion'
      @jewelry_unit = Jewelry::JewelryUnitConversionCrud.list_jewelry_unit_conversion
      render_view( @jewelry_unit,'jewelry','L')  
    when 'jewelry_detail'
      catalog_item_id  = parse_xml(doc/:params/'item_id')
      @catalog_item = Item::CatalogItemCrud.show_catalog_item(catalog_item_id)  
      render :template => "item/show_catalog_item_for_item_packet"
    when 'labor'
      labor_id  = parse_xml(doc/:params/'id')
      @labor = Inventory::LaborCrud.show_labor(labor_id)  
      render_view( @labor,'labors','L')
    when 'spo_details'
      trans_no  = parse_xml(doc/:params/'trans_no')
      @pos_orders = PointOfSale::PosOrderCrud.fetch_spo_details(trans_no)  
      render :template => "point_of_sale/show_pos_orders"
    when 'spo_repair_details'
      trans_no  = parse_xml(doc/:params/'trans_no')
      @pos = PointOfSale::PosOrderCrud.fetch_spo_repair_details(trans_no)  
      render :template => "point_of_sale/show_pos_order_repair"
    when 'item_detail_for_spo_workbag'
      catalog_item_id  = parse_xml(doc/:params/'id')
      @catalog_items = Item::CatalogItemCrud.show_catalog_item(catalog_item_id)  
      render :template => "item/show_catalog_item"
    when 'workbag_details'
      trans_no  = parse_xml(doc/:params/'trans_no')
      @workbag = Production::WorkbagCrud.fetch_workbag_details(trans_no)
      render_view( @workbag,'workbags','L')      
      #      render :xml=> @workbag, :template => "production/show_workbag"
    when 'checkvalidity'
      #      lookupname  = 'Customer'
      #      value  = '0'
      #      column_name  = 'name'
      lookupname  = parse_xml(doc/:params/'lookup_name')
      value  = parse_xml(doc/:params/'value')
      column_name  = parse_xml(doc/:params/'data_field')
      @field2  = parse_xml(doc/:params/'field2')
      filter_key_name  = parse_xml(doc/:params/'filter_key_name')
      filter_key_value  = parse_xml(doc/:params/'filter_key_value')
      if filter_key_name.length != 0
        condition = " and #{filter_key_name} = #{filter_key_value}"
      else
        condition = ""
      end
      tablename,@result=Setup::CheckValidityCrud.get_table_name(lookupname,column_name,value,filter_key_name,filter_key_value)
      @result = Vendor::Vendor.find_by_sql ["select * from #{tablename} where trans_flag='A' and #{column_name} = ? #{condition}",value] if (lookupname!='ItemSpecificAccessoriesItem' and lookupname!='GLBankAccount' and lookupname!='CatalogOrderStatus' and lookupname!='Lab' and lookupname!='UserStoreAccess' and lookupname!='Customer' and lookupname!='RetailCustomer' and lookupname!='CustomerShipping' and lookupname!='RetailCustomerShipping' and lookupname!='CustomerContact' and lookupname!='CustomerWholesale' and lookupname != 'ItemSpecificAccessoriesItem' and lookupname != 'ImprintType' and lookupname!='OrderStatus' and lookupname!='DiscountCoupons' and lookupname!='ServiceCharges')
      respond_to_action('checkvalidity') 
    when 'limitedlookup'
      #      lookupname  = 'Customer'
      #      value  = '0'
      #      column_name  = 'name'
      lookupname  = parse_xml(doc/:params/'lookup_name')
      value  = parse_xml(doc/:params/'value')
      filter_key_name  = parse_xml(doc/:params/'filter_key_name')
      filter_key_value  = parse_xml(doc/:params/'filter_key_value')
      @data=Setup::CheckValidityCrud.get_limited_lookup(lookupname,value,filter_key_name,filter_key_value)
      render :xml => '<encoded>'+Base64.encode64(Zlib::Deflate.deflate(@data[0].xmlcol))+'</encoded>'
      #      respond_to_action('limitedlookup')
    when 'meltingpacketinfo'
      trans_no = parse_xml(doc/'trans_no')  if (doc/'trans_no').first
      @packet_request = Metal::MeltingCrud.getmeltingpacketinfo(trans_no) 
      render_view(@packet_request,'packet_requests','L')
    when 'item_detail'
      catalog_item_id = parse_xml(doc/'id')  if (doc/'id').first
      customer_id = parse_xml(doc/'customer_id')  if (doc/'customer_id').first
      ref_trans_no = parse_xml(doc/'ref_trans_no')  if (doc/'ref_trans_no').first
      ref_type = parse_xml(doc/'ref_type')  if (doc/'ref_type').first
      @customer_id = customer_id
      if catalog_item_id == ''
        render :text => "error"
      else
        #        puts "Service Started at #{Time.now.to_f*1000}"
        @catalog_items,@cust_prices = Item::PriceUtility.fetch_cust_specific_price(catalog_item_id,customer_id)
        if (ref_type == TRANS_TYPE_QUOTATION_ORDER and ref_trans_no != '')
          quotation_lines = Quotation::SalesQuotationCrud.find_quotation_item_price(ref_trans_no,catalog_item_id)
          @cust_prices = quotation_lines[0] if quotation_lines[0]
        end
        respond_to_action('item_detail')
      end
    when 'item_detail_sales_quotation'
      catalog_item_id = parse_xml(doc/'id')  if (doc/'id').first
      customer_id = parse_xml(doc/'customer_id')  if (doc/'customer_id').first
      @customer_id = customer_id
      if catalog_item_id == ''
        render :text => "error"
      else
        #        puts "Service Started at #{Time.now.to_f*1000}"
        @catalog_items,@cust_prices = Item::PriceUtility.fetch_cust_specific_price(catalog_item_id,customer_id)
        respond_to_action('item_detail_sales_quotation')
      end
    when 'customer_specific_shippings' ## not in use
      customer_id = parse_xml(doc/'id')  if (doc/'id').first
      @customer_shippings = Customer::CustomerList.list_customer_specific_shipping(customer_id) 
      render_view(@customer_shippings,'customer_shippings','L')
    when 'item_column_detail'
      catalog_item_id = parse_xml(doc/'id')  if (doc/'id').first
      @catalog_items = Item::CatalogItemCrud.show_catalog_item(catalog_item_id)
      render_view(@catalog_items,'catalog_items','L')
    when 'item_detail_sample_order'
      catalog_item_id = parse_xml(doc/'id')  if (doc/'id').first
      customer_id = parse_xml(doc/'customer_id')  if (doc/'customer_id').first
      #      blank_good_flag = parse_xml(doc/'blank_good_flag')  if (doc/'blank_good_flag').first
      if catalog_item_id == ''
        render :text => "error"
      else
        @catalog_items,@cust_prices = Item::PriceUtility.fetch_cust_specific_price(catalog_item_id,customer_id)
        respond_to_action('item_detail_sample_order')
      end
    when 'accessories_item_detail'
      catalog_item_id = parse_xml(doc/:params/'catalog_item_id')  if (doc/:params/'catalog_item_id').first
      if catalog_item_id == ''
        render :text => "error"
      else
        @catalog_items = Item::CatalogItemCrud.show_catalog_item(catalog_item_id)
        respond_to_action('accessories_item_detail')
      end
    when 'show_shipped_order_dtls'
      sales_order_id = parse_xml(doc/'id')  if (doc/'id').first
      trans_no = parse_xml(doc/'trans_no')  if (doc/'trans_no').first
      @ref_virtual_line_id = parse_xml(doc/'ref_virtual_line_id')  if (doc/'ref_virtual_line_id').first
      @orders = Sales::SalesOrderCrud.show_shipped_order_dtls(sales_order_id,trans_no)
      if @orders[0] and (@orders[0].trans_type == 'S' or @orders[0].trans_type == 'E' or @orders[0].trans_type == 'F')
        render :template => "sale/regular_order/show_order"
      elsif @orders[0] and (@orders[0].trans_type == 'V' or @orders[0].trans_type == 'P')
        render :template => "sale/virtual_order/show_virtual_order_with_charges"
      else

      end
    when 'fetch_shipvia_methods'
      code = parse_xml(doc/'code')  if (doc/'code').first
      @shipvias = Sales::SalesOrderCrud.fetch_shipvia_methods(code)
      render :xml=>@shipvias[0].xmlcol
    when 'fetch_cust_specific_setup_item_price'
      catalog_item_id = parse_xml(doc/'id')  if (doc/'id').first
      customer_id = parse_xml(doc/'customer_id')  if (doc/'customer_id').first
      if catalog_item_id == ''
        render :text => "error"
      else
        @catalog_items,@cust_prices = Item::PriceUtility.fetch_cust_specific_setup_item_price(catalog_item_id,customer_id)
        respond_to_action('fetch_cust_specific_setup_item_price')
      end
    when 'fetch_invn_and_setup_item'
      @catalog_items = Item::CatalogItem.find_by_sql ["select CAST((
                        select(select id as catalog_item_id,store_code as catalog_item_code,name as catalog_item_name,item_type from catalog_items where item_type in ('I','S')
                        FOR XML PATH('catalog_item'), TYPE,ELEMENTS XSINIL
                        )FOR XML PATH('catalog_items')) AS varchar(MAX)) as xmlcol"]
      render :xml=>@catalog_items[0].xmlcol

    when 'fetch_default_setup_item' ## used in sample order
      customer_id = parse_xml(doc/'customer_id')  if (doc/'customer_id').first
      catalog_item = Item::CatalogItem.find_by_store_code('SETUP')
      @default_setup_items,@customer_prices  = Item::PriceUtility.fetch_cust_specific_setup_item_price(catalog_item.id,customer_id)
      respond_to_action('fetch_default_setup_item')
    when 'check_valid_indigo_no' ## not in use
      indigo_code = parse_xml(doc/'indigo_code')  if (doc/'indigo_code').first
      doc_code = parse_xml(doc/'doc_code')  if (doc/'doc_code').first
      @code = Sales::SalesOrderLine.find_by_sql ["select indigo_code from sales_order_lines where indigo_code = '#{indigo_code}'"] if (indigo_code and indigo_code != 'null') 
      @code = Sales::SalesOrderLine.find_by_sql ["select doc_code from sales_order_lines where doc_code = '#{doc_code}'"] if (doc_code and doc_code != 'null')
      if @code != nil and @code[0]
        render :xml=>"<rows><row>Exist</row></rows>"
      else
        render :xml=>"<rows><row>NotExist</row></rows>"
      end
    when 'fetch_default_rush_setup_item' ## 25 january NOT IN USE check item controller for replacement service
      #      customer_id = parse_xml(doc/'customer_id')  if (doc/'customer_id').first
      #      catalog_item = Item::CatalogItem.find_by_store_code('RUSHDAY1')
      #      if customer_id == ''
      #        render :text => "error"
      #      else
      @catalog_items = Item::CatalogItem.find_by_sql ["select catalog_items.* from catalog_items
                                                        inner join catalog_item_categories cic on
                                                        cic.id = catalog_items.catalog_item_category_id
                                                        where cic.code = 'RUSHITEM'"]
      respond_to_action('fetch_default_rush_setup_item')
      #      end

    when 'fetch_default_change_with_proof_setup_item'
      customer_id = parse_xml(doc/'customer_id')  if (doc/'customer_id').first
      catalog_item = Item::CatalogItem.find_by_store_code('CHANGEWITHPROOF')
      @default_setup_items,@customer_prices = Item::PriceUtility.fetch_cust_specific_setup_item_price(catalog_item.id,customer_id)
      respond_to_action('fetch_default_setup_item')
    when 'fetch_customers'
      value = parse_xml(doc/'value')  if (doc/'value').first
      @customer_contacts = Customer::Customer.find_by_sql ["select CAST((
                                  select(select id,code,name from customers where trans_flag = 'A' and name like ?
                                   FOR XML PATH('customer_contact'), TYPE,ELEMENTS XSINIL
                                  )FOR XML PATH('customer_contacts')) AS varchar(MAX)) as xmlcol",value+'%']
      render :xml=>@customer_contacts[0].xmlcol
    when 'catalog_attribute_value_lookup'
      @attribute = Item::CatalogItemCrud.catalog_attribute_value_lookup
      render_view( @attribute,'catalog_attribute','L')
    when 'attribute_info'
      attribute_id = parse_xml(doc/'attribute_id')  if (doc/'attribute_id').first
      attribute_code = parse_xml(doc/'attribute_code')  if (doc/'attribute_code').first
      @attribute = Item::CatalogItemCrud.attribute_details(attribute_id,attribute_code)
      render_view( @attribute,'catalog_attribute','L')
    when 'user_lookup'
      @user = Admin::UserCrud.user_lookup
      render_view( @user,'user','L')
      
    when 'role_lookup'
      @role = Admin::RoleCrud.role_lookup
      render_view( @role,'role','L')
    when 'customer_shipping_details'
      customer_shipping_id = parse_xml(doc/'shipping_id')  if (doc/'shipping_id').first
      @customer_shippings =  Customer::CustomerShipping.find_by_sql ["SELECT CAST((SELECT (select * from customer_shippings
                                                                    WHERE	trans_flag ='A' and id = #{customer_shipping_id}
                                                                    FOR XML PATH('customer_shipping'),ELEMENTS XSINIL,TYPE
                                                                    )FOR XML PATH('customer_shippings')) AS XML) AS xmlcol"]
      render :xml=>@customer_shippings[0].xmlcol
      
    when 'void_bounce_info'
      bank_id =  parse_xml(doc/'bank_id')  if (doc/'bank_id').first
      check_no = parse_xml(doc/'check_no')  if (doc/'check_no').first
      trans_type = parse_xml(doc/'ref_trans_type')  if (doc/'ref_trans_type').first
      trans_no = parse_xml(doc/'ref_trans_no')  if (doc/'ref_trans_no').first
      find_flag = parse_xml(doc/'fetch_type')  if (doc/'fetch_type').first
      @info = GeneralLedger::BankBounceCheckCrud.list_unapplied_uncleared_bank_transactions(bank_id,check_no,trans_type,trans_no,find_flag)
      render :xml=> @info
   
    when 'bankreconciliationfromdate'
      render :xml => GeneralLedger::BankReconciliation.find_by_sql("SELECT CAST((
                                                                              SELECT
                                                                                      (
                                                                                              SELECT  ISNULL(MAX(to_date)+1 ,'19900101') AS from_date
                                                                                              FROM bank_reconciliations
                                                                                              WHERE	bank_id =#{parse_xml(doc/'bank_id')}
                                                                                              AND   trans_flag = 'A'
                                                                                              FOR XML PATH('result'), TYPE
                                                                                      )
                                                                              FOR XML PATH('results')
                                                                              )as XML) xmlcol")[0].xmlcol

    when 'bank_check_info'
      if(parse_xml(doc/'type').to_s.upcase == 'PAYMENT')
        bank = GeneralLedger::GlSetup.find_by_sql("SELECT TOP 1 faap_bank_id AS id FROM gl_setups WHERE trans_flag='A'")[0]
        if bank
          @check_no,@deposit_slip_no,@payment_type,@check_no_flag,@bank_id,@bank_code,@bank_name= GeneralLedger::BankTransactionCrud.fetch_defaults_for_bank(PAYMENTS,bank.id.to_i ,nil)
          if(parse_xml(doc/'payment_type'))#because of bydefault check in pay_bills(vivek sir told to set check bydefault for pay_bills)
            @check_no = Accounts::GenerateCheckNumber.generate_check_no(PAYMENTS, bank.id , parse_xml(doc/'payment_type'))
            @payment_type = parse_xml(doc/'payment_type')
          end
        end
      elsif(parse_xml(doc/'type').to_s.upcase == 'RECEIPT')
        bank = GeneralLedger::GlSetup.find_by_sql("SELECT TOP 1 faar_bank_id AS id, faar_bank_code AS code FROM gl_setups WHERE trans_flag='A'")[0]
        if bank
          @bank_id = bank.id
          @bank_code = bank.code
        end
      end
      bank_charges_info = GeneralLedger::GlSetup.find_by_sql("SELECT TOP 1 bank_charge_account_id as id,bank_charge_account_code as code FROM gl_setups WHERE trans_flag='A'")[0]
      if bank_charges_info
        @bank_charge_account_id = bank_charges_info.id
        @bank_charge_account_code = bank_charges_info.code
      end
      respond_to_action('fetch_defaults_for_bank')
      
    when 'paymentbankinbox'
      trans_type = PAYMENTS
      fetch_data_for_bank_inbox(trans_type,doc)
    when 'get_coupons_details'
      @coupons,message = Setup::DiscountCouponCrud.get_coupons_details(doc)
      if message != 'success'
        render :xml => "<errors><error>#{@coupons}</error></errors>"
      else
        render :template => "setup/discount_coupon/show_discount_coupon"
      end
    end
  end  

  def fetch_customers
    doc = Hpricot::XML(request.raw_post)
    value = parse_xml(doc/'value')  if (doc/'value').first
    @customer_contacts = Customer::Customer.find_by_sql ["select CAST((
                                  select(select id,code,name from customers where trans_flag = 'A' and name like ?
                                   FOR XML PATH('customer_contact'), TYPE,ELEMENTS XSINIL
                                  )FOR XML PATH('customer_contacts')) AS varchar(MAX)) as xmlcol",value+'%']
    render :xml=>@customer_contacts[0].xmlcol
  end
  ## this service is used to validate the uniqueness of given column.
  def validate_uniqueness
    doc = Hpricot::XML(request.raw_post)
    value = parse_xml(doc/'value')  if (doc/'value').first
    column_name = parse_xml(doc/'column_name')  if (doc/'column_name').first
    table_name = parse_xml(doc/'table_name')  if (doc/'table_name').first
    customer_id = parse_xml(doc/'customer_id')  if (doc/'customer_id').first
    if customer_id.length != 0
      condition = "and customer_id = #{customer_id}"
    else
      condition = ""
    end
    @result = Sales::SalesOrder.find_by_sql ["select #{column_name} from #{table_name} where #{column_name} = '#{value}' #{condition}"] if (column_name and table_name)
    if @result != nil and @result[0]
      render :xml=>"<result>Exist</result>"
    else
      render :xml=>"<result>NotExist</result>"
    end
  end
  
  def fetch_data_for_bank(trans_type,doc)
    bank_id = parse_xml(doc/'bank_id').to_i  if (doc/'bank_id').first
    trans_date =  parse_xml(doc/'trans_date').to_datetime  if (doc/'trans_date').first
    if bank_transfer?(trans_type)
      @check_no,@deposit_slip_no,@payment_type,@check_no_flag,@bank_id ,@bank_code,@bank_name = GeneralLedger::BankTransactionCrud.fetch_max_check_no(bank_id) if bank_id
    else
      @check_no,@deposit_slip_no,@payment_type,@check_no_flag,@bank_id ,@bank_code,@bank_name= GeneralLedger::BankTransactionCrud.fetch_defaults_for_bank(trans_type,bank_id,trans_date) if bank_id
    end
    respond_to_action('fetch_defaults_for_bank')
  end
  
  def fetch_data_for_bank_inbox(trans_type,doc)
    bank_id = parse_xml(doc/'bank_code')  if (doc/'bank_code').first
    trans_date =  parse_xml(doc/'trans_date').to_datetime  if (doc/'trans_date').first
    @check_no,@deposit_slip_no,@payment_type,@check_no_flag,@bank_id ,@bank_code,@bank_name= GeneralLedger::BankTransactionCrud.fetch_defaults_for_bank_inbox(trans_type,bank_id,trans_date) if bank_id
    respond_to_action('fetch_defaults_for_bank')
  end
  
  def fetch_check_no(trans_type,doc)
    bank_id = parse_xml(doc/'bank_id').to_i  if (doc/'bank_id').first
    payment_type =  parse_xml(doc/'payment_type')  if (doc/'payment_type').first
    check_no = Accounts::GenerateCheckNumber.generate_check_no(trans_type, bank_id, payment_type)
    @check_no = check_no
    @deposit_slip_no = ''
    @payment_type = payment_type
    @check_no_flag = 'N'
    respond_to_action('fetch_defaults_for_bank')
  end
  
  def convert_exceltoxml
    uploaded_file = params[:Filedata]
    uploaded_file_name = params[:Filename]
    extension = uploaded_file.original_filename.split(".").last
    table_name = params[:table_name]
    #    IO::FileIO.save_xslx(uploaded_file) if extension=='xlsx'
    #    error_text,workbook = IO::FileIO.openexcelXfile(uploaded_file,uploaded_file_name) if extension=='xlsx'
    #    error_text,workbook = IO::FileIO.openexcelfile(uploaded_file,uploaded_file_name) if extension=='xls'
    #    if error_text
    #      render :text => error_text
    #      return
    #    end
    @data_rows = IO::FileIO.data_of_excel(uploaded_file)
    @tag_level1 = table_name.pluralize
    @tag_level2 = table_name.singularize
    render :template => "generic_view/array_to_xml"
  end

  def export_xml_to_excel
    doc = Hpricot::XML(request.raw_post) 
    doc = Zlib::Inflate.inflate(Base64.decode64((doc/"encoded")[0].inner_html))
    #    doc = Hpricot::XML(doc[4..(doc.length-1)])
    doc = Hpricot::XML(doc[doc.index('<')..(doc.length-1)])      
    #    msgtext = IO::FileIO.write_to_excel(doc,session[:schema])
    msgtext = IO::FileIO.create_report_export(doc,session[:schema])
    render :text=> msgtext
  end
end

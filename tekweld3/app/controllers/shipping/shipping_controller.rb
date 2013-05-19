class Shipping::ShippingController < ApplicationController
  require 'hpricot'
  include General
  include ClassMethods
  require 'hpricot'
  require 'open-uri'
  require 'net/http'
  require 'base64'
  #  require 'shipping'

  def list_shipping_inbox
    doc = Hpricot::XML(request.raw_post)
    doc = doc.to_s.gsub("&amp;","&")
    doc = Hpricot::XML(doc)
    @orders = Shipping::ShippingCrud.list_shipping_inbox(doc)
    render :xml=>'<encoded>'+Base64.encode64(Zlib::Deflate.deflate(@orders[0].xmlcol))+'</encoded>'
  end

  def create_shipping_inboxes
    doc = Hpricot::XML(request.raw_post)
    doc = doc.to_s.gsub("&amp;","&")
    doc = Hpricot::XML(doc)
    message,text = Shipping::ShippingCrud.create_shipping_inboxes(doc)
    if text == 'error'
      render :xml => "<errors><error>#{message}</error></errors>"
    else
      render :text => message
    end
  end

  def list_sample_orders_shipping_inbox
    doc = Hpricot::XML(request.raw_post)
    doc = doc.to_s.gsub("&amp;","&")
    doc = Hpricot::XML(doc)
    @orders = Shipping::ShippingCrud.list_sample_order_shipping_inbox(doc)
    render :xml=>'<encoded>'+Base64.encode64(Zlib::Deflate.deflate(@orders[0].xmlcol))+'</encoded>'
  end


  ## Tekweld Standard/Regular AND ReOrder Order Services
  def list_order_shipping_and_packages
    doc = Hpricot::XML(request.raw_post)
    doc = doc.to_s.gsub("&amp;","&")
    doc = Hpricot::XML(doc)
    @shippings = Shipping::ShippingCrud.list_order_shipping_and_packages(doc)
    render :xml=>'<encoded>'+Base64.encode64(Zlib::Deflate.deflate(@shippings[0].xmlcol))+'</encoded>'
  end

  def show_order_shipping_and_package
    doc = Hpricot::XML(request.raw_post)
    shipping_id  = parse_xml(doc/:params/'id')
    @shippings = Shipping::ShippingCrud.show_order_shipping_and_package(shipping_id)
    respond_to do |wants|
      wants.xml
    end
  end


  def create_order_shipping_and_packages
    doc = Hpricot::XML(request.raw_post)
    doc = doc.to_s.gsub("&amp;","&")
    doc = Hpricot::XML(doc)
    @shippings = Shipping::ShippingCrud.create_order_shipping_and_packages(doc)
    order =  @shippings.first if !@shippings.empty?
    if order.errors.empty?
      respond_to_action('show_order_shipping_and_package')
    else
      respond_to_errors(order.errors)
    end
  end

  def take_picture
    file_data = params[:fileData]
    file_name = params[:fileName]
    trans_no = params[:trans_no]
    path = Setup::Type.find(:first, :conditions=>['type_cd = ? and subtype_cd = ?','UPLOAD_FOLDER','UPS_LABEL'])
    if path
      directory =  "#{Dir.getwd}" + '/'+ path.value + session[:schema]
    end
    FileUtils.mkdir_p(File.dirname(directory+'/'+'testfile'))
    data = Base64.decode64(file_data.to_s)
    filename = File.join(directory, file_name)
    File.open(filename, "wb") { |f| f.write(data) }
    order = Sales::SalesOrder.find_by_trans_no(trans_no)
    order.update_attributes!(:finished_product_image=>file_name)
    render :text => 'success'
  end

  def fetch_multioptions
    doc = Hpricot::XML(request.raw_post)
    trans_no = parse_xml(doc/'trans_no')
    orders = Shipping::ShippingCrud.fetch_multioptions(trans_no)
    render :xml=>orders[0].xmlcol
  end

  #  def get_inhand_date
  #    doc = Hpricot::XML(request.raw_post)
  #    response_doc,text = Shipping::Ups.get_ups_time_in_transit(doc)
  #    if text == 'error'
  #      render :xml=>"<errors><error>#{response_doc}</error></errors>"
  #    else
  #      @ups_time_in_transit = Hpricot::XML(response_doc)
  #      response_status_code = parse_xml(@ups_time_in_transit/:TimeInTransitResponse/:Response/'ResponseStatusCode')  if parse_xml(@ups_time_in_transit/:TimeInTransitResponse/:Response/'ResponseStatusCode').first
  #      if response_status_code.to_i == 1
  #        @ship_method_code = parse_xml(doc/:params/'ship_method_code')
  #        render :template => "shipping/shipping/get_inhand_date"
  #      else
  #        error_description = parse_xml(@ups_time_in_transit/:TimeInTransitResponse/:Response/:Error/'ErrorDescription')  if parse_xml(@ups_time_in_transit/:TimeInTransitResponse/:Response/:Error/'ErrorDescription').first
  #        render :xml=>"<errors><error>#{error_description}</error></errors>"
  #      end
  #    end
  #  end

  def get_inhand_date
    doc = Hpricot::XML(request.raw_post)
    shipping_code = parse_xml(doc/:params/'shipping_code')
    estimated_ship_date = parse_xml(doc/:params/'estimated_ship_date').to_date
    zip_code = parse_xml(doc/:params/'zip_code')
    ship_method_code = parse_xml(doc/:params/'ship_method_code')
    country = parse_xml(doc/:params/'country')
    state = parse_xml(doc/:params/'state')
    catalog_item_id = parse_xml(doc/:params/'catalog_item_id')
    company_id = parse_xml(doc/:params/'company_id')
    if(shipping_code == 'USPS')
      service = []
      service << ship_method_code
      inhand_date ,text = Shipping::Usps.usps_time_in_transit(service,zip_code,estimated_ship_date,catalog_item_id,company_id)
      if text == 'error'
        render :xml=>"<errors><error>#{inhand_date}</error></errors>"
      else
        @usps_time_in_transit = inhand_date[0]
        render :template => "shipping/shipping/get_usps_inhand_date"
      end
    elsif(shipping_code == 'UPS')
      response_doc,text = Shipping::Ups.get_ups_time_in_transit(doc)
      if text == 'error'
        render :xml=>"<errors><error>#{response_doc}</error></errors>"
      else
        @ups_time_in_transit = Hpricot::XML(response_doc)
        response_status_code = parse_xml(@ups_time_in_transit/:TimeInTransitResponse/:Response/'ResponseStatusCode')  if parse_xml(@ups_time_in_transit/:TimeInTransitResponse/:Response/'ResponseStatusCode').first
        if response_status_code.to_i == 1
          @ship_method_code = parse_xml(doc/:params/'ship_method_code')
          render :template => "shipping/shipping/get_inhand_date"
        else
          error_description = parse_xml(@ups_time_in_transit/:TimeInTransitResponse/:Response/:Error/'ErrorDescription')  if parse_xml(@ups_time_in_transit/:TimeInTransitResponse/:Response/:Error/'ErrorDescription').first
          render :xml=>"<errors><error>#{error_description}</error></errors>"
        end
      end
    elsif(shipping_code == 'FEDEX')
      fedex_doc = Sales::DateUtility.get_fedex_dummy_package_xml
      fedex_doc = Hpricot::XML(fedex_doc)
      response_doc,text = Sales::DateUtility.get_fedex_inhand_dates(fedex_doc,'unique_no',zip_code,country,state,estimated_ship_date,ship_method_code,catalog_item_id,company_id)
      if text == 'error'
        render :xml=>"<errors><error>#{response_doc}</error></errors>"
      else
        doc = Hpricot::XML(response_doc)
        @fedex_inhand_date = parse_xml(doc/:sales_order_shipping/'estimated_arrival_date').to_date.strftime("%Y/%m/%d")
        render :template => "shipping/shipping/get_fedex_inhand_date"
      end
    end
  end

  def calculate_estimated_ship_date_and_packages
    doc = Hpricot::XML(request.raw_post)
    estimated_ship_date = Sales::DateUtility.calculate_estimated_ship_date_and_packages(doc)
    render :xml=>"<result>#{estimated_ship_date}</result>"
  end

  ### this function is called from link button on order screen to calculate estimated ship date and then get In hand date from API.
  def calculate_estimated_ship_date_and_inhand_dates
    doc = Hpricot::XML(request.raw_post)
    result = Sales::DateUtility.calculate_estimated_ship_date_and_inhand_dates(doc)
    render :xml=>"#{result}"
  end

  def get_shipping_methods
    doc = Hpricot::XML(request.raw_post)
    doc = doc.to_s.gsub("&amp;","&")
    doc = Hpricot::XML(doc)
    shipping_code = parse_xml(doc/:params/'shipping_code')
    if shipping_code == 'UPS'
      response_doc,text = Shipping::Ups.get_ups_shipping_methods(doc)
      if text == 'error'
        render :xml=>"<errors><error>#{response_doc}</error></errors>"
      else
        @ups_shipping_methods = Hpricot::XML(response_doc)
        response_status_code = parse_xml(@ups_shipping_methods/:RatingServiceSelectionResponse/:Response/'ResponseStatusCode')  if parse_xml(@ups_shipping_methods/:RatingServiceSelectionResponse/:Response/'ResponseStatusCode').first
        #          negptiated_rate = parse_xml(@ups_shipping_methods/:RatingServiceSelectionResponse/:RatedShipment/'GuaranteedDaysToDelivery')
        rate = parse_xml(@ups_shipping_methods/:RatingServiceSelectionResponse/:RatedShipment/'NegotiatedRates')
        if rate.blank?
          render :xml=>"<errors><error>Negotiated Rates not found. Please Contact System Administrator.</error></errors>"
        elsif(response_status_code.to_i == 1)
          response_doc,text = Shipping::Ups.get_ups_time_in_transit(doc)
          if text == 'error'
            render :xml=>"<errors><error>#{response_doc}</error></errors>"
          else
            @ups_time_in_transit = Hpricot::XML(response_doc)
            response_status_code = parse_xml(@ups_time_in_transit/:TimeInTransitResponse/:Response/'ResponseStatusCode')  if parse_xml(@ups_time_in_transit/:TimeInTransitResponse/:Response/'ResponseStatusCode').first
            if response_status_code.to_i == 1
              render :template => "shipping/shipping/ups_shipping_methods"
            else
              error_description = parse_xml(@ups_time_in_transit/:TimeInTransitResponse/:Response/:Error/'ErrorDescription')  if parse_xml(@ups_time_in_transit/:TimeInTransitResponse/:Response/:Error/'ErrorDescription').first
              render :xml=>"<errors><error>#{error_description}</error></errors>"
            end
          end
        else
          render :xml=>"<errors><error>UPS API ERROR FOUND. Please Contact System Administrator.</error></errors>"
        end
      end
    elsif shipping_code == 'FEDEX'
      @estimated_ship_date = parse_xml(doc/:params/'estimated_ship_date').to_date
      @fedex_shipping_methods,text = Shipping::Fedex.get_fedex_methods_xml(doc)
      if text == 'error'
        render :xml=>"<errors><error>#{@fedex_shipping_methods}.</error></errors>"
      else
        render :template => "shipping/shipping/fedex_shipping_methods"
      end
    elsif shipping_code == 'USPS'
      @usps_shipping_methods,@usps_method_rates,@inhand_dates,text = Shipping::Usps.get_usps_methods_xml(doc)
      if text == 'error'
        render :xml=>"<errors><error>#{@inhand_dates}.</error></errors>"
      else
        render :template => "shipping/shipping/usps_shipping_methods"
      end
    else
      render :xml=>"<errors><error>No Methods Available For #{shipping_code}</error></errors>"
    end
  end

  def print_multipackage_label
    doc = Hpricot::XML(request.raw_post)
    shipping_id = parse_xml(doc/:params/'id')
    shipping = Sales::SalesOrderShipping.find_by_id(shipping_id)
    if shipping.shipping_code == 'UPS'
      labels,text = Shipping::Ups.print_ups_multipackage_label(shipping,session[:schema])
    elsif(shipping.shipping_code == 'FEDEX')
      labels,text = Shipping::Fedex.print_fedex_multipackage_label(shipping,session[:schema])
    elsif(shipping.shipping_code == 'USPS')
      labels,text = Shipping::Usps.print_usps_multipackage_label(shipping,session[:schema])
    else
      render :xml => "<errors><error>Shipping Label cannot generate for #{shipping.shipping_code}</error></errors>"
      return
    end
    if text == 'error'
      render :text => "<errors><error>#{labels}</error></errors>"
    elsif text == 'label_exists'
      render :xml => "<results><result>#{labels}</result></results>"
    else
      @message,text = Shipping::Ups.make_ups_label_html(doc,labels,session[:schema]) if shipping.shipping_code == 'UPS'
      @message,text = Shipping::Fedex.make_fedex_label_html(doc,labels,session[:schema]) if(shipping.shipping_code == 'FEDEX')
      @message,text = Shipping::Usps.make_usps_label_html(doc,labels,session[:schema]) if(shipping.shipping_code == 'USPS')
      if text == 'error'
        render :xml => "<errors><error>Some error occured #{@message}</error></errors>"
      else
        respond_to_action('print_multipackage_label')
      end
    end
  end

  def send_package_tracking_info
    doc = Hpricot::XML(request.raw_post)
    order_id = parse_xml(doc/:params/'id')
    message = Shipping::ShippingCrud.send_package_tracking_info(order_id)
    render :text => message
  end

  def list_vendor_shipping_inbox
    doc = Hpricot::XML(request.raw_post)
    doc = doc.to_s.gsub("&amp;","&")
    doc = Hpricot::XML(doc)
    @orders = Shipping::ShippingCrud.list_vendor_shipping_inbox(doc)
    render :xml=>'<encoded>'+Base64.encode64(Zlib::Deflate.deflate(@orders[0].xmlcol))+'</encoded>'
  end

  def create_vendor_shipping_inboxes
    doc = Hpricot::XML(request.raw_post)
    doc = doc.to_s.gsub("&amp;","&")
    doc = Hpricot::XML(doc)
    message,text = Shipping::ShippingCrud.create_vendor_shipping_inboxes(doc)
    if text == 'error'
      render :xml => "<errors><error>#{message}</error></errors>"
    else
      render :text => message
    end
  end

  def print_ups_label_for_vendor_shipping
    doc = Hpricot::XML(request.raw_post)
    labels,text = Shipping::ShippingCrud.print_ups_label_for_vendor_shipping(doc,session[:schema])
    if text == 'error'
      render :text => "<errors><error>#{labels}</error></errors>"
    else
      render :xml => "<results><result>#{labels}</result></results>"
    end
  end

  ##### BEGIN Functions which are called as web services through PromoPortal approve AW through email ###############
  #  def calculate_inhand_date
  #    doc = Hpricot::XML(request.raw_post)
  #    ship_id = parse_xml(doc/:params/'ship_id')
  #    estimated_ship_date = parse_xml(doc/:params/'estimated_ship_date')
  #    shipping = Sales::SalesOrderShipping.find_by_id(ship_id)
  #    result,text = Shipping::Ups.calculate_inhand_date(shipping,estimated_ship_date)
  #    render :xml=>"<calculate_inhand_date><result>#{result}</result><text>#{text}</text></calculate_inhand_date>"
  #  end

  def calculate_inhand_date
    doc = Hpricot::XML(request.raw_post)
    ship_id = parse_xml(doc/:params/'ship_id')
    estimated_ship_date = parse_xml(doc/:params/'estimated_ship_date')
    shipping = Sales::SalesOrderShipping.find_by_id(ship_id)
    sales_order_line = Sales::SalesOrderLine.where("trans_flag = 'A' AND sales_order_id = ? AND item_type = 'I'",shipping.sales_order_id).first
    catalog_item_id = sales_order_line.catalog_item_id
    order_doc = Sales::DateUtility.get_sales_order_xml(shipping)
    doc = Hpricot::XML(order_doc)
    response = Sales::DateUtility.calculate_inhand_dates(doc,estimated_ship_date,catalog_item_id,shipping.company_id)
    doc = Hpricot::XML(response)
    error = parse_xml(doc/:errors/'error')
    if error
      #      render :text => "<errors><error>#{error}</error></errors>"
      render :xml=>"<calculate_inhand_date><result>#{error}</result><text>error</text></calculate_inhand_date>"
    else
      inhand_date = parse_xml(doc/:sales_order_shippings/:sales_order_shipping/'estimated_arrival_date')
      if !inhand_date
        inhand_date = shipping.internal_inhand_date.to_date.strftime("%Y/%m/%d")
      else
        inhand_date = inhand_date.to_date.strftime("%Y/%m/%d")
      end
      render :xml=>"<calculate_inhand_date><result>#{inhand_date}</result><text>success</text></calculate_inhand_date>"
    end
  end
  ######## END Function Promo Portal #############
  
  def convert_exceltoxml_to_for_sales_order_shippings
    uploaded_file = params[:Filedata]
    table_name = params[:table_name]
    @data_rows = IO::FileIO.data_of_excel(uploaded_file)
    @tag_level1 = table_name.pluralize
    @tag_level2 = table_name.singularize
    render :template => "shipping/shipping/convert_exceltoxml_to_for_sales_order_shippings"
  end
end

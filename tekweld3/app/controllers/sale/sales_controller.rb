class Sale::SalesController < ApplicationController
  require 'hpricot'
  include General
  include ClassMethods

  ## Tekweld ReOrder services
  def list_shipped_order_hdrs
    doc = Hpricot::XML(request.raw_post)
    doc = doc.to_s.gsub("&amp;","&")
    doc = Hpricot::XML(doc)
    @orders = Sales::SalesReorderCrud.list_shipped_order_hdrs(doc)
    render :xml=>@orders[0].xmlcol
  end

  def list_shipped_order_dtls
    doc = Hpricot::XML(request.raw_post)
    doc = doc.to_s.gsub("&amp;","&")
    doc = Hpricot::XML(doc)
    @orders = Sales::SalesReorderCrud.list_shipped_order_dtls(doc)
    render :xml=>@orders[0].xmlcol
  end
   
  ## Tekweld PickOrder services
  def list_pick_orders
    doc = Hpricot::XML(request.raw_post)
    doc = doc.to_s.gsub("&amp;","&")
    doc = Hpricot::XML(doc)
    @orders = Sales::SalesOrderCrud.list_pick_orders(doc)
    render :xml=>'<encoded>'+Base64.encode64(Zlib::Deflate.deflate(@orders[0].xmlcol))+'</encoded>'
  end
  
  def hold_pick_order
    doc = Hpricot::XML(request.raw_post)
    doc = doc.to_s.gsub("&amp;","&")
    doc = Hpricot::XML(doc)    
    message,text = Sales::SalesOrderCrud.hold_pick_order(doc)
    if text == 'error'
      render :xml=>"<errors><error>#{message}</error></errors>"
    else
      render :text => "successfull"
    end
  end

  ## Tekweld Quality Check Order services
  def list_quality_check_orders
    doc = Hpricot::XML(request.raw_post)
    doc = doc.to_s.gsub("&amp;","&")
    doc = Hpricot::XML(doc)
    @orders = Sales::SalesOrderCrud.list_quality_check_orders(doc)
    render :xml=>'<encoded>'+Base64.encode64(Zlib::Deflate.deflate(@orders[0].xmlcol))+'</encoded>'
  end

  ## TEKWELD ASSIGNED ARTWORKS AND ORDERS LIST SERVICES ONLY USER SPECIFIC DATA IS LISTED
  def list_assigned_orders
    doc = Hpricot::XML(request.raw_post)
    doc = doc.to_s.gsub("&amp;","&")
    doc = Hpricot::XML(doc)
    @orders = Sales::SalesOrderCrud.list_assigned_orders(doc)
    render :xml=>'<encoded>'+Base64.encode64(Zlib::Deflate.deflate(@orders[0].xmlcol))+'</encoded>'
  end
  
  
  ## Tekweld Revert Order Stages List Service
  def list_all_orders
    doc = Hpricot::XML(request.raw_post)
    doc = doc.to_s.gsub("&amp;","&") 
    doc = Hpricot::XML(doc)    
    @orders = Sales::SalesOrderCrud.list_all_orders(doc)
    render :xml=>'<encoded>'+Base64.encode64(Zlib::Deflate.deflate(@orders[0].sales_orders))+'</encoded>'
  end  
  
  def show_all_order
    doc = Hpricot::XML(request.raw_post)
    order_id  = parse_xml(doc/:params/'id')
    @orders = Sales::SalesRegularOrderCrud.show_order(order_id)
    respond_to do |wants|
      wants.xml
    end
  end
  def create_revert_order_stages
    doc = Hpricot::XML(request.raw_post)
    doc = doc.to_s.gsub("&amp;","&")
    doc = Hpricot::XML(doc)
    @orders = Sales::RevertOrderLocation.create_revert_order_stages(doc)
    order =  @orders.first if !@orders.empty?
    if(order.errors[:base].empty?  and order.errors[''].empty?)
      respond_to_action('show_all_order')
    else
      render :xml => "<errors><error>#{order.errors[:base][0]}</error></errors>"
    end
  end
  
  def resend_order_acknowledgment
    doc = Hpricot::XML(request.raw_post)
    order_id  = parse_xml(doc/:params/'id')
    url_with_port = ''
    sales_order = Sales::SalesOrder.find_by_id(order_id)
    result,absolute_file_name = Sales::SalesOrderCrud.generate_regular_order_pdf(sales_order,session[:schema],url_with_port,true)
    if result == true
      render :text => "Acknowledgment Sent Successfully"
    else
      render :text => "#{absolute_file_name}-Some Error Occured.Please Contact System Administrator."
    end
  end
  
  def show_order_and_artwork_flow
    doc = Hpricot::XML(request.raw_post)
    order_id  = parse_xml(doc/:params/'id')
    @orders = Sales::SalesOrderCrud.show_order_and_artwork_flow(order_id)
    render :xml=>@orders[0].xmlcol
  end
  
  def show_order_trail
    doc = Hpricot::XML(request.raw_post)
    trans_no  = parse_xml(doc/:params/'trans_no')
    @orders = Sales::SalesOrderCrud.show_order_trail(trans_no)
    render :xml=>@orders[0].xmlcol
  end

  ##### BEGIN- Functions which are called as web services through PromoPortal for finding workflow location ###############
  def find_order_status
    doc = Hpricot::XML(request.raw_post)
    trans_no  = parse_xml(doc/:params/'trans_no')
    status = Sales::CurrentLocationLogic.find_order_status(trans_no)
    render :xml=>"<workflow_location>#{status}</workflow_location>"
  end
end

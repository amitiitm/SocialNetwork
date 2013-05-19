class Sale::RegularOrderController < ApplicationController
  require 'hpricot'
  include General
  include ClassMethods
  
  ## Tekweld Standard/Regular AND ReOrder Order Services
  def list_orders
    doc = Hpricot::XML(request.raw_post)
    doc = doc.to_s.gsub("&amp;","&") 
    doc = Hpricot::XML(doc)    
    @orders = Sales::SalesRegularOrderCrud.list_orders(doc)
    render :xml=>'<encoded>'+Base64.encode64(Zlib::Deflate.deflate(@orders[0].sales_orders))+'</encoded>'
  end  

  def show_order
    doc = Hpricot::XML(request.raw_post)
    order_id  = parse_xml(doc/:params/'id')
    @orders = Sales::SalesRegularOrderCrud.show_order(order_id)
    respond_to do |wants|
      wants.xml   
    end
  end  

  def create_orders
    doc = Hpricot::XML(request.raw_post)
    doc = doc.to_s.gsub("&amp;","&")
    doc = Hpricot::XML(doc)
    url_with_port = ''
    @orders= Sales::SalesRegularOrderCrud.create_orders(doc,session[:schema],url_with_port)
    order =  @orders.first if !@orders.empty?
    if order.errors.empty?
      respond_to_action('show_order')
    else
      respond_to_errors(order.errors)
    end
  end
  
  #Sales Standard/Regular AND ReOrder Quick Order services
  def list_quick_regular_and_reorders
    doc = Hpricot::XML(request.raw_post)
    doc = doc.to_s.gsub("&amp;","&") 
    doc = Hpricot::XML(doc)    
    @orders = Sales::SalesRegularOrderCrud.list_quick_regular_and_reorders(doc)
    render :xml=>'<encoded>'+Base64.encode64(Zlib::Deflate.deflate(@orders[0].sales_orders))+'</encoded>'
  end
end

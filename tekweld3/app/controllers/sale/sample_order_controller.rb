class Sale::SampleOrderController < ApplicationController
  require 'hpricot'
  include General
  include ClassMethods
  
  ## Tekweld Sample Order services
  def list_sample_orders
    doc = Hpricot::XML(request.raw_post)
    doc = doc.to_s.gsub("&amp;","&")
    doc = Hpricot::XML(doc)
    @orders = Sales::SalesSampleOrderCrud.list_sample_orders(doc)
    render :xml=>'<encoded>'+Base64.encode64(Zlib::Deflate.deflate(@orders[0].sales_orders))+'</encoded>'
  end
  
  def show_sample_order
    doc = Hpricot::XML(request.raw_post)
    order_id  = parse_xml(doc/:params/'id')
    @orders = Sales::SalesSampleOrderCrud.show_sample_order(order_id)
    respond_to do |wants|
      wants.xml
    end
  end

  def create_sample_orders
    doc = Hpricot::XML(request.raw_post)
    doc = doc.to_s.gsub("&amp;","&")
    doc = Hpricot::XML(doc)
    url_with_port = ''
    @orders= Sales::SalesSampleOrderCrud.create_sample_orders(doc,session[:schema],url_with_port)
    order =  @orders.first if !@orders.empty?
    if order.errors.empty?
      respond_to_action('show_sample_order')
    else
      respond_to_errors(order.errors)
    end
  end
end

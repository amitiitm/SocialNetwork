class Sale::SalesMultipleArtworkController < ApplicationController
  require 'hpricot'
  include General
  include ClassMethods


  def list_multiple_artwork_orders
    doc = Hpricot::XML(request.raw_post)
    doc = doc.to_s.gsub("&amp;","&")
    doc = Hpricot::XML(doc)
    orders = Sales::SalesMultipleArtworkCrud.list_multiple_artwork_orders(doc)
    render :xml=>'<encoded>'+Base64.encode64(Zlib::Deflate.deflate(orders[0].sales_orders))+'</encoded>'
  end

  def show_multiple_artwork_order
    doc = Hpricot::XML(request.raw_post)
    order_id  = parse_xml(doc/:params/'id')
    @orders = Sales::SalesMultipleArtworkCrud.show_multiple_artwork_order(order_id)
    respond_to do |wants|
      wants.xml
    end
  end

  def create_multiple_artwork_orders
    doc = Hpricot::XML(request.raw_post)
    doc = doc.to_s.gsub("&amp;","&")
    doc = Hpricot::XML(doc)
    url_with_port = ''
    @orders= Sales::SalesMultipleArtworkCrud.create_multiple_artwork_orders(doc,session[:schema],url_with_port)
    order =  @orders.first if !@orders.empty?
    if order.errors.empty?
      respond_to_action('show_multiple_artwork_order')
    else
      respond_to_errors(order.errors)
    end
  end
end

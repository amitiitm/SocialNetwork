class Sale::ReorderController < ApplicationController
  require 'hpricot'
  include General
  include ClassMethods
  
  ## Tekweld ReOrder Order Services  
  def list_sales_reorders
    doc = Hpricot::XML(request.raw_post)
    doc = doc.to_s.gsub("&amp;","&") 
    doc = Hpricot::XML(doc)    
    @orders = Sales::SalesReorderCrud.list_sales_reorders(doc)
    render :xml=>'<encoded>'+Base64.encode64(Zlib::Deflate.deflate(@orders[0].sales_orders))+'</encoded>'
  end 
  
  def show_reorder
    doc = Hpricot::XML(request.raw_post)
    order_id  = parse_xml(doc/:params/'id')
    @orders = Sales::SalesReorderCrud.show_reorder(order_id)
    respond_to do |wants|
      wants.xml   
    end
  end  

  def create_reorders
    doc = Hpricot::XML(request.raw_post)   
    doc = doc.to_s.gsub("&amp;","&")
    doc = Hpricot::XML(doc)
    url_with_port = request.host_with_port
    @orders= Sales::SalesReorderCrud.create_reorders(doc,session[:schema],url_with_port)
    order =  @orders.first if !@orders.empty?
    if order.errors.empty?
      #    render_view( @orders,'orders','C') 
      respond_to_action('show_reorder')
    else
      respond_to_errors(order.errors)
    end
  end
end

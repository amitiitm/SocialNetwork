class Sale::CancelOrderController < ApplicationController
  require 'hpricot'
  include General
  include ClassMethods
  
  ## Tekweld Cancel Order services
  def list_orders_to_cancel
    doc = Hpricot::XML(request.raw_post)
    doc = doc.to_s.gsub("&amp;","&")
    doc = Hpricot::XML(doc)
    @orders = Sales::SalesCancelOrderCrud.list_orders_to_cancel(doc)
    render :xml=>'<encoded>'+Base64.encode64(Zlib::Deflate.deflate(@orders[0].xmlcol))+'</encoded>'
  end
  
  def create_cancel_orders
    doc = Hpricot::XML(request.raw_post)
    @orders = Sales::SalesCancelOrderCrud.create_cancel_orders(doc)
    order =  @orders.first if !@orders.empty?
    if(order.errors[:base].empty?  and order.errors[''].empty?)
      render :text => 'Order Cancelled Successfully'
    else
      render :xml => "<errors><error>#{order.errors[:base][0]}</error></errors>"
    end
  end
  ## Tekweld Cancel Order services
  def list_cancelled_orders
    doc = Hpricot::XML(request.raw_post)
    doc = doc.to_s.gsub("&amp;","&")
    doc = Hpricot::XML(doc)
    @orders = Sales::SalesCancelOrderCrud.list_cancelled_orders(doc)
    render :xml=>@orders[0].xmlcol
  end
end

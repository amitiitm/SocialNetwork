class Promocustomer::PromoCustomerController < ApplicationController
  require 'hpricot'
  include General
  include ClassMethods

  def list_open_and_history_orders
    doc = Hpricot::XML(request.raw_post)
    @orders = PromoCustomer::PromoCustomerCrud.list_open_and_history_orders(doc)
    render :xml=>'<encoded>'+Base64.encode64(Zlib::Deflate.deflate(@orders[0].xmlcol))+'</encoded>'
  end

  def show_order
    doc = Hpricot::XML(request.raw_post)
    order_id  = parse_xml(doc/:params/'id')
    @orders = PromoCustomer::PromoCustomerCrud.show_order(order_id)
    respond_to do |wants|
      wants.xml
    end
  end 

  def update_shipping_info
    doc = Hpricot::XML(request.raw_post)
    @shippings = PromoCustomer::PromoCustomerCrud.update_shipping_info(doc)
    shipping =  @shippings.first if !@shippings.empty?
    if shipping.errors.empty?
      render_view(@shippings,'sales_order_shippings','L')
    else
      respond_to_errors(shipping.errors)
    end
  end
end

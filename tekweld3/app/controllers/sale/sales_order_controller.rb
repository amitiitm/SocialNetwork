class Sale::SalesOrderController < ApplicationController
  require 'hpricot'
  include General
  include ClassMethods

  def list_open_standard_orders
    doc = Hpricot::XML(request.raw_post)
    doc = doc.to_s.gsub("&amp;","&")
    doc = Hpricot::XML(doc)
    @orders = Sales::SalesOrderCrud.list_open_standard_orders(doc)
    render :xml=>@orders[0].xmlcol
  end

  def list_open_standard_orders_hdr
    doc = Hpricot::XML(request.raw_post)
    doc = doc.to_s.gsub("&amp;","&")
    doc = Hpricot::XML(doc)
    @orders = Sales::SalesOrderCrud.list_open_standard_orders_hdr(doc)
    render :xml=>@orders[0].xmlcol
  end

  def list_open_standard_order_lines
    doc = Hpricot::XML(request.raw_post)
    doc = doc.to_s.gsub("&amp;","&")
    doc = Hpricot::XML(doc)
    @orders = Sales::SalesOrderCrud.list_open_standard_order_lines(doc)
    render :xml=>@orders[0].xmlcol
  end

end

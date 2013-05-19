class Sale::PreProductionOrderController < ApplicationController
  require 'hpricot'
  include General
  include ClassMethods

  def list_pre_production_orders
    doc = Hpricot::XML(request.raw_post)
    doc = doc.to_s.gsub("&amp;","&")
    doc = Hpricot::XML(doc)
    @orders = Sales::SalesPreProductionOrderCrud.list_pre_production_orders(doc)
    render :xml=>'<encoded>'+Base64.encode64(Zlib::Deflate.deflate(@orders[0].xmlcol))+'</encoded>'
  end

  def approve_pre_production_orders
    doc = Hpricot::XML(request.raw_post)
    doc = doc.to_s.gsub("&amp;","&")
    doc = Hpricot::XML(doc)
    message,text = Sales::SalesPreProductionOrderCrud.approve_pre_production_orders(doc,session[:schema])
    if text == 'error'
      render :xml=>"<errors><error>#{message}</error></errors>"
    else
      render :text => 'successfull'
    end
  end
end

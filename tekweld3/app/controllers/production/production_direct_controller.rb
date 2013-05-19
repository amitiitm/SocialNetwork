class Production::ProductionDirectController < ApplicationController
  require 'hpricot'
  include General
  include ClassMethods
  
  def direct_pad_film_inbox
    doc = Hpricot::XML(request.raw_post)
    doc = doc.to_s.gsub("&amp;","&") 
    doc = Hpricot::XML(doc)    
    @orders = Production::ProductionDirectCrud.direct_pad_film_inbox(doc)
    render :xml=>'<encoded>'+Base64.encode64(Zlib::Deflate.deflate(@orders[0].xmlcol))+'</encoded>'
    #    render :xml=>@orders[0].xmlcol
  end

  def direct_pad_print_inbox
    doc = Hpricot::XML(request.raw_post)
    doc = doc.to_s.gsub("&amp;","&")
    doc = Hpricot::XML(doc)
    @orders = Production::ProductionDirectCrud.direct_pad_print_inbox(doc)
    render :xml=>'<encoded>'+Base64.encode64(Zlib::Deflate.deflate(@orders[0].xmlcol))+'</encoded>'
    #    render :xml=>@orders[0].xmlcol
  end

  def direct_pad_print_option_inbox
    doc = Hpricot::XML(request.raw_post)
    doc = doc.to_s.gsub("&amp;","&")
    doc = Hpricot::XML(doc)
    @orders = Production::ProductionDirectCrud.direct_pad_print_option_inbox(doc)
    render :xml=>'<encoded>'+Base64.encode64(Zlib::Deflate.deflate(@orders[0].xmlcol))+'</encoded>'
    #    render :xml=>@orders[0].xmlcol
  end

  def show_direct_film_inbox
    doc = Hpricot::XML(request.raw_post)
    order_id  = parse_xml(doc/:params/'id')
    @orders = Production::ProductionCrud.show_production_inbox(order_id)
    respond_to do |wants|
      wants.xml
    end
  end

  def create_production_film_inboxes
    doc = Hpricot::XML(request.raw_post)
    doc = doc.to_s.gsub("&amp;","&")
    doc = Hpricot::XML(doc)
    @orders = Production::ProductionCrud.create_production_film_inboxes(doc)
    order =  @orders.first if !@orders.empty?
    if order.errors.empty?
      respond_to_action('show_direct_film_inbox')
    else
      respond_to_errors(order.errors)
    end
  end

  def direct_print_inbox
    doc = Hpricot::XML(request.raw_post)
    doc = doc.to_s.gsub("&amp;","&") 
    doc = Hpricot::XML(doc)    
    @orders = Production::ProductionDirectCrud.direct_print_inbox(doc)
    render :xml=>'<encoded>'+Base64.encode64(Zlib::Deflate.deflate(@orders[0].xmlcol))+'</encoded>'
    #    render :xml=>@orders[0].xmlcol
  end

  def production_inbox
    doc = Hpricot::XML(request.raw_post)
    doc = doc.to_s.gsub("&amp;","&")
    doc = Hpricot::XML(doc)
    @orders = Production::ProductionDirectCrud.production_inbox(doc)
    render :xml=>'<encoded>'+Base64.encode64(Zlib::Deflate.deflate(@orders[0].xmlcol))+'</encoded>'
    #    render :xml=>@orders[0].xmlcol
  end

  def production_option_inbox
    doc = Hpricot::XML(request.raw_post)
    doc = doc.to_s.gsub("&amp;","&")
    doc = Hpricot::XML(doc)
    @orders = Production::ProductionDirectCrud.production_option_inbox(doc)
    render :xml=>'<encoded>'+Base64.encode64(Zlib::Deflate.deflate(@orders[0].xmlcol))+'</encoded>'
    #    render :xml=>@orders[0].xmlcol
  end

  def create_direct_production_inbox
    doc = Hpricot::XML(request.raw_post)
    doc = doc.to_s.gsub("&amp;","&")
    doc = Hpricot::XML(doc)
    message,text = Production::ProductionDirectCrud.create_direct_production_inbox(doc)
    if text == 'error'
      render :xml=>"<errors><error>#{message}</error></errors>"
    else
      render :text => "successfull"
    end
  end
end

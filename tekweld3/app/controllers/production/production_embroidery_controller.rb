class Production::ProductionEmbroideryController < ApplicationController
  require 'hpricot'
  include General
  include ClassMethods
  
  def embroidery_send_digitization_inbox
    doc = Hpricot::XML(request.raw_post)
    doc = doc.to_s.gsub("&amp;","&") 
    doc = Hpricot::XML(doc)    
    @orders = Production::ProductionEmbroideryCrud.embroidery_send_digitization_inbox(doc)
    render :xml=>'<encoded>'+Base64.encode64(Zlib::Deflate.deflate(@orders[0].xmlcol))+'</encoded>'
    #    render :xml=>@orders[0].xmlcol
  end 
  
  def embroidery_receive_digitization_inbox
    doc = Hpricot::XML(request.raw_post)
    doc = doc.to_s.gsub("&amp;","&") 
    doc = Hpricot::XML(doc)    
    @orders = Production::ProductionEmbroideryCrud.embroidery_receive_digitization_inbox(doc)
    render :xml=>'<encoded>'+Base64.encode64(Zlib::Deflate.deflate(@orders[0].xmlcol))+'</encoded>'
    #    render :xml=>@orders[0].xmlcol
  end 
  
  def embroidery_stitch_inbox
    doc = Hpricot::XML(request.raw_post)
    doc = doc.to_s.gsub("&amp;","&") 
    doc = Hpricot::XML(doc)    
    @orders = Production::ProductionEmbroideryCrud.embroidery_stitch_inbox(doc)
    render :xml=>'<encoded>'+Base64.encode64(Zlib::Deflate.deflate(@orders[0].xmlcol))+'</encoded>'
    #    render :xml=>@orders[0].xmlcol
  end

  def list_embroidery_threads
    doc = Hpricot::XML(request.raw_post)
    @threads = Production::ProductionEmbroideryCrud.list_embroidery_threads(doc)
    render :xml => @threads[0].xmlcol
  end

  def send_for_estimation_inbox
    doc = Hpricot::XML(request.raw_post)
    @orders = Production::ProductionEmbroideryCrud.send_for_estimation_inbox(doc)
    render :xml=>'<encoded>'+Base64.encode64(Zlib::Deflate.deflate(@orders[0].xmlcol))+'</encoded>'
  end

  def create_send_for_estimation_inbox
    doc = Hpricot::XML(request.raw_post)
    message,text = Production::ProductionEmbroideryCrud.create_send_for_estimation_inbox(doc)
    if text == 'error'
      render :xml=>"<errors><error>#{message}</error></errors>"
    else
      render :text => "successfull"
    end
  end

  def receive_stitch_estimation_inbox
    doc = Hpricot::XML(request.raw_post)
    @orders = Production::ProductionEmbroideryCrud.receive_stitch_estimation_inbox(doc)
    render :xml=>'<encoded>'+Base64.encode64(Zlib::Deflate.deflate(@orders[0].xmlcol))+'</encoded>'
  end

  def create_receive_stitch_estimation_inbox
    doc = Hpricot::XML(request.raw_post)
    url_with_port = ''
    message,text = Production::ProductionEmbroideryCrud.create_receive_stitch_estimation_inbox(doc,session[:schema],url_with_port)
    if text == 'error'
      render :xml=>"<errors><error>#{message}</error></errors>"
    else
      render :text => "successfull"
    end
  end

  def customer_stitch_approval_inbox
    doc = Hpricot::XML(request.raw_post)
    @orders = Production::ProductionEmbroideryCrud.customer_stitch_approval_inbox(doc)
    render :xml=>'<encoded>'+Base64.encode64(Zlib::Deflate.deflate(@orders[0].xmlcol))+'</encoded>'
  end

  def create_customer_stitch_approval_inbox
    doc = Hpricot::XML(request.raw_post)
    message,text = Production::ProductionEmbroideryCrud.create_customer_stitch_approval_inbox(doc)
    if text == 'error'
      render :xml=>"<errors><error>#{message}</error></errors>"
    else
      render :text => "successfull"
    end
  end

  def show_receive_digitized_job
    doc = Hpricot::XML(request.raw_post)
    order_id  = parse_xml(doc/:params/'id')
    @orders = Production::ProductionCrud.show_production_inbox(order_id)
    respond_to do |wants|
      wants.xml
    end
  end

  def create_production_send_digitization_inboxes
    doc = Hpricot::XML(request.raw_post)
    doc = doc.to_s.gsub("&amp;","&")
    doc = Hpricot::XML(doc)
    message,text = Production::ProductionEmbroideryCrud.create_production_send_digitization_inboxes(doc)
    if text == 'error'
      render :xml=>"<errors><error>#{message}</error></errors>"
    else
      render :text => "successfull"
    end
  end

  def create_production_receive_digitization_inboxes
    doc = Hpricot::XML(request.raw_post)
    doc = doc.to_s.gsub("&amp;","&")
    doc = Hpricot::XML(doc)
    url_with_port = request.host_with_port
    @orders = Production::ProductionEmbroideryCrud.create_production_receive_digitization_inboxes(doc,session[:schema],url_with_port)
    order =  @orders.first if !@orders.empty?
    if order.errors.empty?
      respond_to_action('show_receive_digitized_job')
    else
      respond_to_errors(order.errors)
    end
  end

  def resend_artwork_for_embroidery_estimation
    doc = Hpricot::XML(request.raw_post)
    message,text = Production::ProductionEmbroideryCrud.resend_artwork_for_embroidery_estimation(doc)
    render :text => message
  end

end

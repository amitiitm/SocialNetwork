class Production::ProductionController < ApplicationController
  require 'hpricot'
  include General
  include ClassMethods
  
  ## Tekweld Production generate indigo code service
  def generate_indigo_code
    doc = Hpricot::XML(request.raw_post)
    doc = doc.to_s.gsub("&amp;","&")
    doc = Hpricot::XML(doc)
    message,indigo_code = Production::ProductionIndigoCrud.generate_indigo_codes(doc)
    if message == 'success'
      render :text => indigo_code.to_i
    else
      render :text => ''
    end
  end
  
  def create_accept_reject_imposition_sheets
    doc = Hpricot::XML(request.raw_post)
    doc = doc.to_s.gsub("&amp;","&")
    doc = Hpricot::XML(doc)
    @orders = Production::ProductionIndigoCrud.create_accept_reject_imposition_sheets(doc)
    respond_to_action('show_production_inbox')
  end

  def create_imposition_sheets
    doc = Hpricot::XML(request.raw_post)
    doc = doc.to_s.gsub("&amp;","&")
    doc = Hpricot::XML(doc)
    message = Production::ProductionIndigoCrud.create_imposition_sheets(doc)
    render :text => message
  end
  def list_imposition_sheets
    doc = Hpricot::XML(request.raw_post)
    indigo_code  = parse_xml(doc/:params/'indigo_code')
    @indigo_imposition = Production::ProductionIndigoCrud.list_imposition_sheets(indigo_code)
  end
  
  
  ## Tekweld Production Inboxes Show Services
  def show_production_inbox
    doc = Hpricot::XML(request.raw_post)
    order_id  = parse_xml(doc/:params/'id')
    @orders = Production::ProductionCrud.show_production_inbox(order_id)
    respond_to do |wants|
      wants.xml   
    end
  end  
   
  def list_all_production_data
    doc = Hpricot::XML(request.raw_post)
    doc = doc.to_s.gsub("&amp;","&") 
    doc = Hpricot::XML(doc)    
    @orders = Production::ProductionCrud.list_all_production_data(doc)
    render :xml=>'<encoded>'+Base64.encode64(Zlib::Deflate.deflate(@orders[0].xmlcol))+'</encoded>'
    #    render :xml=>@orders[0].xmlcol
  end 

  def water_inbox
    doc = Hpricot::XML(request.raw_post)
    doc = doc.to_s.gsub("&amp;","&") 
    doc = Hpricot::XML(doc)    
    @orders = Production::ProductionWaterCrud.water_inbox(doc)
    render :xml=>'<encoded>'+Base64.encode64(Zlib::Deflate.deflate(@orders[0].xmlcol))+'</encoded>'
    #    render :xml=>@orders[0].xmlcol
  end 

  def mimaki_print_inbox
    doc = Hpricot::XML(request.raw_post)
    doc = doc.to_s.gsub("&amp;","&")
    doc = Hpricot::XML(doc)
    @orders = Production::ProductionMimakiCrud.mimaki_print_inbox(doc)
    render :xml=>'<encoded>'+Base64.encode64(Zlib::Deflate.deflate(@orders[0].xmlcol))+'</encoded>'
    #    render :xml=>@orders[0].xmlcol
  end

  def create_mimaki_print_inboxes
    doc = Hpricot::XML(request.raw_post)
    doc = doc.to_s.gsub("&amp;","&")
    doc = Hpricot::XML(doc)
    @orders = Production::ProductionMimakiCrud.create_mimaki_print_inboxes(doc)
    render :text => "Successfull"
  end

  def create_production_imposition_inboxes
    doc = Hpricot::XML(request.raw_post)
    doc = doc.to_s.gsub("&amp;","&") 
    doc = Hpricot::XML(doc)    
    message,text = Production::ProductionCrud.create_production_imposition_inboxes(doc)
    if text == 'error'
      render :xml=>"<errors><error>#{message}</error></errors>"
    else
      render :text => "successfull"
    end
  end
  
  def create_production_print_inboxes
    doc = Hpricot::XML(request.raw_post)
    doc = doc.to_s.gsub("&amp;","&") 
    doc = Hpricot::XML(doc)    
    message,text = Production::ProductionCrud.create_production_print_inboxes(doc)
    if text == 'error'
      render :xml=>"<errors><error>#{message}</error></errors>"
    else
      render :text => "successfull"
    end
  end 
  
  def create_production_stitch_inboxes
    doc = Hpricot::XML(request.raw_post)
    doc = doc.to_s.gsub("&amp;","&") 
    doc = Hpricot::XML(doc)    
    message,text = Production::ProductionCrud.create_production_stitch_inboxes(doc)
    if text == 'error'
      render :xml=>"<errors><error>#{message}</error></errors>"
    else
      render :text => "successfull"
    end
  end
  
  def create_production_cut_inboxes
    doc = Hpricot::XML(request.raw_post)
    doc = doc.to_s.gsub("&amp;","&") 
    doc = Hpricot::XML(doc)    
    message,text = Production::ProductionCrud.create_production_cut_inboxes(doc)
    if text == 'error'
      render :xml=>"<errors><error>#{message}</error></errors>"
    else
      render :text => "successfull"
    end
  end
  
  def packaging_inbox
    doc = Hpricot::XML(request.raw_post)
    doc = doc.to_s.gsub("&amp;","&") 
    doc = Hpricot::XML(doc)    
    @orders = Production::ProductionPackagingCrud.packaging_inbox(doc)
    render :xml=>'<encoded>'+Base64.encode64(Zlib::Deflate.deflate(@orders[0].xmlcol))+'</encoded>'
  end
  def create_packaging_inboxes
    doc = Hpricot::XML(request.raw_post)
    doc = doc.to_s.gsub("&amp;","&") 
    doc = Hpricot::XML(doc)    
    message,text = Production::ProductionPackagingCrud.create_packaging_inboxes(doc)
    if text == 'error'
      render :xml=>"<errors><error>#{message}</error></errors>"
    else
      render :text => "successfull"
    end
  end

  ### services for vendor to receive water labels
  def vendor_inbox
    doc = Hpricot::XML(request.raw_post)
    doc = doc.to_s.gsub("&amp;","&")
    doc = Hpricot::XML(doc)
    @orders = Production::ProductionPackagingCrud.vendor_inbox(doc)
    render :xml=>'<encoded>'+Base64.encode64(Zlib::Deflate.deflate(@orders[0].xmlcol))+'</encoded>'
  end

  def create_vendor_inboxes
    doc = Hpricot::XML(request.raw_post)
    doc = doc.to_s.gsub("&amp;","&")
    doc = Hpricot::XML(doc)
    message = Production::ProductionPackagingCrud.create_vendor_inboxes(doc)
    if message != 'success'
      render :xml=>"<errors><error>#{message}</error></errors>"
    else
      render :text => "successfull"
    end
  end
end

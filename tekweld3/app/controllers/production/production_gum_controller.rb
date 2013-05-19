class Production::ProductionGumController < ApplicationController
  require 'hpricot'
  include General
  include ClassMethods

  ## Tekweld Production generate indigo code service
  def generate_gum_doc_code
    doc = Hpricot::XML(request.raw_post)
    message,doc_code = Production::ProductionGumCrud.generate_gum_doc_codes(doc)
    if message == 'success'
      render :text => doc_code.to_i
    else
      render :text => ''
    end
  end

  def create_gum_imposition_sheets
    doc = Hpricot::XML(request.raw_post)
    doc = doc.to_s.gsub("&amp;","&")
    doc = Hpricot::XML(doc)
    message = Production::ProductionGumCrud.create_gum_imposition_sheets(doc)
    render :text => message
  end
  def list_gum_imposition_sheets
    doc = Hpricot::XML(request.raw_post)
    doc_code  = parse_xml(doc/:params/'doc_code')
    @gum_imposition = Production::ProductionGumCrud.list_gum_imposition_sheets(doc_code)
  end
  ## Tekweld Production Inboxes Services
  def gum_imposition_inbox
    doc = Hpricot::XML(request.raw_post)
    doc = doc.to_s.gsub("&amp;","&") 
    doc = Hpricot::XML(doc)    
    @orders = Production::ProductionGumCrud.gum_imposition_inbox(doc)
    render :xml=>'<encoded>'+Base64.encode64(Zlib::Deflate.deflate(@orders[0].xmlcol))+'</encoded>'
    #    render :xml=>@orders[0].xmlcol
  end 
  
  def gum_print_inbox
    doc = Hpricot::XML(request.raw_post)
    doc = doc.to_s.gsub("&amp;","&") 
    doc = Hpricot::XML(doc)    
    @orders = Production::ProductionGumCrud.gum_print_inbox(doc)
    render :xml=>'<encoded>'+Base64.encode64(Zlib::Deflate.deflate(@orders[0].xmlcol))+'</encoded>'
    #    render :xml=>@orders[0].xmlcol
  end
  
  def cut_inbox
    doc = Hpricot::XML(request.raw_post)
    doc = doc.to_s.gsub("&amp;","&") 
    doc = Hpricot::XML(doc)    
    @orders = Production::ProductionGumCrud.cut_inbox(doc)
    render :xml=>'<encoded>'+Base64.encode64(Zlib::Deflate.deflate(@orders[0].xmlcol))+'</encoded>'
    #    render :xml=>@orders[0].xmlcol
  end
end

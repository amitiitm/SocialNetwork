class Purchase::PurchasePackingSlipController < ApplicationController
  require 'hpricot'
  include General
  include ClassMethods
  
  def list_packing_slips
    doc = Hpricot::XML(request.raw_post)   
    doc = doc.to_s.gsub("&amp;","&") 
    doc = Hpricot::XML(doc)
    @ps = Purchase::PurchasePackingSlipCrud.list_packing_slips(doc)
    render :xml=>@ps[0].xmlcol
  end  

  def show_packing_slips
    doc = Hpricot::XML(request.raw_post)
    memo_return_id  = parse_xml(doc/:params/'id')
    @ps = Purchase::PurchasePackingSlipCrud.show_packing_slips(memo_return_id)
    respond_to do |wants|
      wants.xml   
    end
  end  

  def create_packing_slips
    doc = Hpricot::XML(request.raw_post)   
    doc = doc.to_s.gsub("&amp;","&") 
    doc = Hpricot::XML(doc)
    @ps= Purchase::PurchasePackingSlipCrud.create_packing_slips(doc)
    ps =  @ps.first if !@ps.empty?
    if ps.errors.empty?
      respond_to_action('show_packing_slips')
    else
      respond_to_errors(ps.errors)
    end
  end
  
  #packingslip fetch services for memo
  
  def list_open_packing_slip_hdr_for_memo
    doc = Hpricot::XML(request.raw_post)
    doc = doc.to_s.gsub("&amp;","&") 
    doc = Hpricot::XML(doc)    
    @ps = Purchase::PurchasePackingSlipCrud.list_open_ps_hdr_for_memo(doc)
    render :xml=>@ps[0].xmlcol
  end  

  def list_open_packing_slip_lines_for_memo
    doc = Hpricot::XML(request.raw_post)  
    doc = doc.to_s.gsub("&amp;","&") 
    doc = Hpricot::XML(doc)    
    @ps = Purchase::PurchasePackingSlipCrud.list_open_ps_lines_for_memo(doc)
    render :xml=>@ps[0].xmlcol
  end 
  
  def list_open_packing_slip_for_memo
    doc = Hpricot::XML(request.raw_post) 
    doc = doc.to_s.gsub("&amp;","&") 
    doc = Hpricot::XML(doc)    
    @ps = Purchase::PurchasePackingSlipCrud.list_open_ps_for_memo(doc)
    render :xml=>@ps[0].xmlcol
  end 
  
  #packingslip fetch services for invoice
  
  def list_open_packing_slip_hdr
    doc = Hpricot::XML(request.raw_post)
    doc = doc.to_s.gsub("&amp;","&") 
    doc = Hpricot::XML(doc)    
    @ps = Purchase::PurchasePackingSlipCrud.list_open_ps_hdr(doc)
    #    respond_to_action('list_orders')
    render :xml=>@ps[0].xmlcol
  end  

  def list_open_packing_slip_lines
    doc = Hpricot::XML(request.raw_post)  
    doc = doc.to_s.gsub("&amp;","&") 
    doc = Hpricot::XML(doc)    
    @ps = Purchase::PurchasePackingSlipCrud.list_open_ps_lines(doc)
    #    render_view( @orders,'purchase_orders','L') 
    render :xml=>@ps[0].xmlcol
  end 
  
  def list_open_packing_slip
    doc = Hpricot::XML(request.raw_post) 
    doc = doc.to_s.gsub("&amp;","&") 
    doc = Hpricot::XML(doc)    
    @ps = Purchase::PurchasePackingSlipCrud.list_open_ps(doc)
    render :xml=>@ps[0].xmlcol
  end 
end

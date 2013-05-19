class Purchase::PurchaseIndentController < ApplicationController
  require 'hpricot'
  include General
  include ClassMethods
  
  #PurchaseIndent Services
  def list_purchase_indents
    doc = Hpricot::XML(request.raw_post) 
    doc = doc.to_s.gsub("&amp;","&") 
    doc = Hpricot::XML(doc)
    @purchase_indents = Purchase::PurchaseIndentCrud.list_purchase_indents(doc)
    render :xml=>'<encoded>'+Base64.encode64(Zlib::Deflate.deflate(@purchase_indents[0].xmlcol))+'</encoded>'
  end  

  def show_purchase_indent
    doc = Hpricot::XML(request.raw_post)
    purchase_indent_id  = parse_xml(doc/:params/'id')
    @purchase_indent = Purchase::PurchaseIndentCrud.show_purchase_indent(purchase_indent_id)
    respond_to do |wants|
      wants.xml   
    end
  end  

  def create_purchase_indents
    doc = Hpricot::XML(request.raw_post) 
    doc = doc.to_s.gsub("&amp;","&") 
    doc = Hpricot::XML(doc)  
    @purchase_indent = Purchase::PurchaseIndentCrud.create_purchase_indents(doc)
    purchase_indent =  @purchase_indent.first if !@purchase_indent.empty?
    if purchase_indent.errors.empty?
      respond_to_action('show_purchase_indent')
    else
      respond_to_errors(purchase_indent.errors)
    end
  end 
 
  # PurchaseIndent Approval Services
  def list_indent_approvals
    doc = Hpricot::XML(request.raw_post) 
    doc = doc.to_s.gsub("&amp;","&") 
    doc = Hpricot::XML(doc)
    @indent_approvals = Purchase::PurchaseIndentApprovalCrud.list_indent_approvals(doc)
    render :xml=>'<encoded>'+Base64.encode64(Zlib::Deflate.deflate(@indent_approvals[0].xmlcol))+'</encoded>'
  end  
 
  def create_indent_approvals
    doc = Hpricot::XML(request.raw_post)   
    doc = doc.to_s.gsub("&amp;","&") 
    doc = Hpricot::XML(doc)
    @indent_approvals = Purchase::PurchaseIndentApprovalCrud.create_indent_approvals(doc)
    indent_approvals =  @indent_approvals.first if !@indent_approvals.empty?
    if indent_approvals.errors.empty?
      respond_to_action('show_indent_approval')
    else
      respond_to_errors(indent_approvals.errors)
    end   
  end
end

class Sale::CustomerReceiptController < ApplicationController
  require 'hpricot'
  include General
  include ClassMethods
  
  def list_receipts
    doc = Hpricot::XML(request.raw_post) 
    doc = doc.to_s.gsub("&amp;","&") 
    doc = Hpricot::XML(doc)  
    @customer_receipts = Customer::CustomerReceiptCrud.list_receipts(doc)
    render :xml=>'<encoded>'+Base64.encode64(Zlib::Deflate.deflate(@customer_receipts[0].xmlcol))+'</encoded>'
  end
 
  def show_receipts
    doc = Hpricot::XML(request.raw_post)   
    receipt_id = parse_xml(doc/:params/'id') 
    @customer_receipt = Customer::CustomerReceiptCrud.show_receipts(receipt_id,'R')
    respond_to do |format|
      format.html
      format.xml 
    end
  end
 
  def create_receipts
    #    doc = Hpricot::XML(request.raw_post)
    #    doc = doc.to_s.gsub("&amp;","&")
    #    doc = Hpricot::XML(doc)
    doc = EncodeDecode.decode(request.raw_post)
    @customer_receipt = Customer::CustomerReceiptCrud.create_receipts(doc,'R')
    receipt =  @customer_receipt.first if !@customer_receipt.empty?
    if receipt.errors.empty?
      respond_to_action("show_receipts") 
    else
      respond_to_errors(receipt.errors)
    end    
  end
  
  def list_apply_receipts
    doc = Hpricot::XML(request.raw_post)   
    doc = doc.to_s.gsub("&amp;","&") 
    doc = Hpricot::XML(doc)
    @customer_receipts = Customer::CustomerReceiptCrud.list_receipts(doc)
    render :xml=>'<encoded>'+Base64.encode64(Zlib::Deflate.deflate(@customer_receipts[0].xmlcol))+'</encoded>'
  end
  
  def show_apply_receipts
    doc = Hpricot::XML(request.raw_post)   
    receipt_id = parse_xml(doc/:params/'id') 
    @customer_receipt = Customer::CustomerReceiptCrud.show_receipts(receipt_id,'A')
    respond_to_action("show_receipts")
  end
 
  def create_apply_receipts
    #    doc = Hpricot::XML(request.raw_post)
    #    doc = doc.to_s.gsub("&amp;","&")
    #    doc = Hpricot::XML(doc)
    doc = EncodeDecode.decode(request.raw_post)
    @customer_receipt = Customer::CustomerReceiptCrud.create_receipts(doc,'A')
    receipt =  @customer_receipt.first if !@customer_receipt.empty?
    if receipt.errors.empty?
      respond_to_action("show_receipts") 
    else
      respond_to_errors(receipt.errors)
    end    
  end
end

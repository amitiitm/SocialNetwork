class Purchase::VendorPaymentController < ApplicationController
  require 'hpricot'
  include General
  include ClassMethods
  
  def list_payments
    doc = Hpricot::XML(request.raw_post)
    doc = doc.to_s.gsub("&amp;","&") 
    doc = Hpricot::XML(doc)
    @vendor_payments = Vendor::VendorPaymentCrud.list_payments(doc)
    render :xml=>'<encoded>'+Base64.encode64(Zlib::Deflate.deflate(@vendor_payments[0].xmlcol))+'</encoded>'
  end
 
  def show_payments
    doc = Hpricot::XML(request.raw_post)   
    payment_id = parse_xml(doc/'id') 
    @vendor_payment = Vendor::VendorPaymentCrud.show_payments(payment_id,'P')
    respond_to do |format|
      format.html
      format.xml 
    end
  end
 
  def create_payments
    doc = Hpricot::XML(request.raw_post)
    doc = doc.to_s.gsub("&amp;","&") 
    doc = Hpricot::XML(doc)
    @vendor_payment = Vendor::VendorPaymentCrud.create_payments(doc,'P')  
    payment =  @vendor_payment.first if !@vendor_payment.empty?
    if payment.errors.empty?
      respond_to_action("show_payments") 
    else
      respond_to_errors(payment.errors)
    end    
  end
  
  def list_apply_payments
    doc = Hpricot::XML(request.raw_post) 
    doc = doc.to_s.gsub("&amp;","&") 
    doc = Hpricot::XML(doc)  
    @vendor_payments = Vendor::VendorPaymentCrud.list_payments(doc)
    render :xml=>'<encoded>'+Base64.encode64(Zlib::Deflate.deflate(@vendor_payments[0].xmlcol))+'</encoded>'
  end
  
  def show_apply_payments
    doc = Hpricot::XML(request.raw_post)   
    payment_id = parse_xml(doc/'id')  if (doc/'id').first
    @vendor_payment = Vendor::VendorPaymentCrud.show_payments(payment_id,'A')
    respond_to_action("show_payments")
  end
 
  def create_apply_payments
    doc = Hpricot::XML(request.raw_post)
    doc = doc.to_s.gsub("&amp;","&") 
    doc = Hpricot::XML(doc)
    @vendor_payment = Vendor::VendorPaymentCrud.create_payments(doc,'A')  
    payment =  @vendor_payment.first if !@vendor_payment.empty?
    if payment.errors.empty?
      respond_to_action("show_payments") 
    else
      respond_to_errors(payment.errors)
    end    
  end
end

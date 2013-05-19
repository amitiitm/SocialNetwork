class Purchase::VendorInvoiceController < ApplicationController
  require 'hpricot'
  include General
  include ClassMethods
  
  def list_invoices
    doc = Hpricot::XML(request.raw_post) 
    doc = doc.to_s.gsub("&amp;","&") 
    doc = Hpricot::XML(doc)  
    @vendor_invoices = Vendor::VendorInvoiceCrud.list_invoices(doc)
    render :xml=>'<encoded>'+Base64.encode64(Zlib::Deflate.deflate(@vendor_invoices[0].xmlcol))+'</encoded>'
  end
 
  def show_invoices
    doc = Hpricot::XML(request.raw_post)   
    invoice_id = parse_xml(doc/'id') 
    @vendor_invoice = Vendor::VendorInvoiceCrud.show_invoices(invoice_id)
    respond_to_action("show_invoices") 
  end
 
  def create_invoices
    doc = Hpricot::XML(request.raw_post) 
    doc = doc.to_s.gsub("&amp;","&") 
    doc = Hpricot::XML(doc)  
    @vendor_invoice = Vendor::VendorInvoiceCrud.create_invoices(doc)  
    invoice =  @vendor_invoice.first if !@vendor_invoice.empty?
    if invoice.errors.empty?
      respond_to_action("show_invoices") 
    else
      respond_to_errors(invoice.errors)
    end    
  end
  
  def fetch_lines_for_invoice
    doc = Hpricot::XML(request.raw_post)   
    id =  parse_xml(doc/'id')   if  parse_xml(doc/'id').first    
    @vendor_invoice = Vendor::VendorInvoiceCrud.fetch_lines_for_invoice(id)
    respond_to_action("show_invoices") 
  end
  
  def fetch_invoices_for_payments   
    doc = Hpricot::XML(request.raw_post)   
    id =  parse_xml(doc/'id')   if  (doc/'id').first    
    @vendor_payment = Vendor::VendorPaymentCrud.fetch_invoices_for_vendor(id.to_i,'P')
    respond_to_action("show_payments") 
  end
  
   
  def list_credit_invoices
    doc = Hpricot::XML(request.raw_post)
    doc = doc.to_s.gsub("&amp;","&") 
    doc = Hpricot::XML(doc)
    @credit_invoices = Vendor::VendorPaymentCrud.list_credit_invoices(doc)
    render :xml=>'<encoded>'+Base64.encode64(Zlib::Deflate.deflate(@credit_invoices[0].xmlcol))+'</encoded>'
  end
 
  def show_credit_invoices
    doc = Hpricot::XML(request.raw_post)   
    payment_id = parse_xml(doc/'id')   if (doc/'id').first
    @vendor_payment = Vendor::VendorPaymentCrud.show_payments(payment_id,'C')
    respond_to_action("show_payments") 
  end
 
  def create_credit_invoice
    doc = Hpricot::XML(request.raw_post)
    doc = doc.to_s.gsub("&amp;","&") 
    doc = Hpricot::XML(doc)
    @vendor_payment = Vendor::VendorPaymentCrud.create_payments(doc,'C')  
    payment =  @vendor_payment.first if !@vendor_payment.empty?
    if payment.errors.empty?
      respond_to_action("show_payments") 
    else
      respond_to_errors(payment.errors)
    end   
  end
  
  def fetch_invoices_for_credit_invoice  
    doc = Hpricot::XML(request.raw_post)   
    id =  parse_xml(doc/'id')   if (doc/'id').first    
    @vendor_payment = Vendor::VendorPaymentCrud.fetch_invoices_for_vendor(id.to_i,'C')
    respond_to_action("show_payments")     
  end
  
  def list_apply_credit_invoices
    doc = Hpricot::XML(request.raw_post)
    doc = doc.to_s.gsub("&amp;","&") 
    doc = Hpricot::XML(doc)
    @credit_invoices = Vendor::VendorPaymentCrud.list_credit_invoices(doc)
    render :xml=>'<encoded>'+Base64.encode64(Zlib::Deflate.deflate(@credit_invoices[0].xmlcol))+'</encoded>'
  end
 
  def show_apply_credit_invoice
    doc = Hpricot::XML(request.raw_post)   
    payment_id = parse_xml(doc/'id')          if (doc/'id').first
    @vendor_payment = Vendor::VendorPaymentCrud.show_payments(payment_id,'CA')
    respond_to_action("show_payments") 
  end
 
  def create_apply_credit_invoice
    doc = Hpricot::XML(request.raw_post)
    doc = doc.to_s.gsub("&amp;","&") 
    doc = Hpricot::XML(doc)
    @vendor_payment = Vendor::VendorPaymentCrud.create_payments(doc,'CA')  
    payment =  @vendor_payment.first if !@vendor_payment.empty?
    if payment.errors.empty?
      respond_to_action("show_payments") 
    else
      respond_to_errors(payment.errors)
    end   
  end
  
  def convert_exceltoxml_for_vendor_invoices
    uploaded_file = params[:Filedata]
    table_name = params[:table_name]
    @data_rows = IO::FileIO.data_of_excel(uploaded_file)
    @tag_level1 = table_name.pluralize
    @tag_level2 = table_name.singularize
    columns_format = ['invoice_no','invoice_date','vendor_code','inv_type','inv_amt','term_code','due_date','ref_no','ref_date','description']
    column_names = []
    @data_rows[0].each {|column_name| column_names << column_name.downcase} if @data_rows[0]
   if columns_format == column_names
      render :template => "purchase/vendor_invoice/convert_exceltoxml_for_vendor_invoices"
    else
      @error_msg = "Uploaded excel is of incorrect format.Please check sample format and update your excel. "
      render :template => "generic_view/wrong_excel_format"
    end
  end
end

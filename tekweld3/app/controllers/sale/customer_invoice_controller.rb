class Sale::CustomerInvoiceController < ApplicationController
  require 'hpricot'
  include General
  include ClassMethods
  
  def list_invoices
    doc = Hpricot::XML(request.raw_post)   
    doc = doc.to_s.gsub("&amp;","&") 
    doc = Hpricot::XML(doc)
    @customer_invoices = Customer::CustomerInvoiceCrud.list_invoices(doc)
    render :xml=>'<encoded>'+Base64.encode64(Zlib::Deflate.deflate(@customer_invoices[0].xmlcol))+'</encoded>'
  end
 
  def show_invoice
    doc = Hpricot::XML(request.raw_post) 
    invoice_id  = parse_xml(doc/:params/'id')    
    @customer_invoice = Customer::CustomerInvoiceCrud.show_invoices(invoice_id)    
    respond_to do |format|
      format.xml 
    end  
  end
 
  def fetch_invoice_header_details
    doc = Hpricot::XML(request.raw_post)  
    id =  parse_xml(doc/:criteria/'id')   if  parse_xml(doc/:criteria/'id').first   
    @customer_invoice = Customer::CustomerInvoiceCrud.fetch_invoice_header_details(id.to_i)  
    respond_to_action("show_invoice") 
  end

  
  def create_invoices
    #    doc = Hpricot::XML(request.raw_post)
    #    doc = doc.to_s.gsub("&amp;","&")
    #    doc = Hpricot::XML(doc)
    doc = EncodeDecode.decode(request.raw_post)
    @customer_invoice = Customer::CustomerInvoiceCrud.create_invoices(doc)  if doc
    invoice =  @customer_invoice.first if !@customer_invoice.empty?
    if invoice.errors.empty?
      respond_to_action("show_invoice") 
    else
      respond_to_errors(invoice.errors)
    end
  end
  
  def fetch_invoices_for_receipts   
    doc = Hpricot::XML(request.raw_post)   
    id =  parse_xml(doc/:criteria/'id')   if  parse_xml(doc/:criteria/'id').first    #parent_id to be given here
    @customer_receipt = Customer::CustomerReceiptCrud.fetch_invoices_for_customer(id.to_i,'R')
    respond_to_action("show_receipts") 
  end
  
   
  def list_credit_invoices
    doc = Hpricot::XML(request.raw_post)   
    doc = doc.to_s.gsub("&amp;","&") 
    doc = Hpricot::XML(doc)
    @credit_invoices = Customer::CustomerReceiptCrud.list_credit_invoices(doc)
    render :xml=>'<encoded>'+Base64.encode64(Zlib::Deflate.deflate(@credit_invoices[0].xmlcol))+'</encoded>'
  end
 
  def show_credit_invoice
    doc = Hpricot::XML(request.raw_post)   
    receipt_id = parse_xml(doc/:params/'id') 
    @customer_receipt = Customer::CustomerReceiptCrud.show_receipts(receipt_id,'C')
    respond_to_action("show_receipts") 
  end
 
  def create_credit_invoice
    #    doc = Hpricot::XML(request.raw_post)
    #    doc = doc.to_s.gsub("&amp;","&")
    #    doc = Hpricot::XML(doc)
    doc = EncodeDecode.decode(request.raw_post)
    @customer_receipt = Customer::CustomerReceiptCrud.create_receipts(doc,'C')  
    receipt =  @customer_receipt.first if !@customer_receipt.empty?
    if receipt.errors.empty?
      respond_to_action("show_receipts") 
    else
      respond_to_errors(receipt.errors)
    end   
  end
  
  def list_apply_credit_invoices
    doc = Hpricot::XML(request.raw_post)
    doc = doc.to_s.gsub("&amp;","&") 
    doc = Hpricot::XML(doc)   
    @credit_invoices = Customer::CustomerReceiptCrud.list_credit_invoices(doc)
    render :xml=>'<encoded>'+Base64.encode64(Zlib::Deflate.deflate(@credit_invoices[0].xmlcol))+'</encoded>'
  end
 
  def show_apply_credit_invoice
    doc = Hpricot::XML(request.raw_post)   
    receipt_id = parse_xml(doc/:params/'id') 
    @customer_receipt = Customer::CustomerReceiptCrud.show_receipts(receipt_id,'CA')
    respond_to_action("show_receipts") 
  end
 
  def create_apply_credit_invoice
    #    doc = Hpricot::XML(request.raw_post)
    #    doc = doc.to_s.gsub("&amp;","&")
    #    doc = Hpricot::XML(doc)
    doc = EncodeDecode.decode(request.raw_post)
    @customer_receipt = Customer::CustomerReceiptCrud.create_receipts(doc,'CA')  
    receipt =  @customer_receipt.first if !@customer_receipt.empty?
    if receipt.errors.empty?
      respond_to_action("show_receipts") 
    else
      respond_to_errors(receipt.errors)
    end   
  end
  
  def fetch_invoices_for_credit_invoice  
    doc = Hpricot::XML(request.raw_post)   
    id =  parse_xml(doc/:criteria/'id')   if  parse_xml(doc/:criteria/'id').first    #parent_id to be given here
    @customer_receipt = Customer::CustomerReceiptCrud.fetch_invoices_for_customer(id.to_i,'C')
    respond_to_action("show_receipts")     
  end
  
  def convert_exceltoxml_for_customer_invoices
    uploaded_file = params[:Filedata]
    table_name = params[:table_name]
    @data_rows = IO::FileIO.data_of_excel(uploaded_file)
    @tag_level1 = table_name.pluralize
    @tag_level2 = table_name.singularize
    columns_format = ['invoice_no','invoice_date','customer_code','inv_type','inv_amt','term_code','due_date','ref_no','ref_date','description']
    column_names = []
    @data_rows[0].each {|column_name| column_names << column_name.downcase} if @data_rows[0]
    if columns_format == column_names
      render :template => "sale/customer_invoice/convert_exceltoxml_for_customer_invoices"
    else
      @error_msg = "Uploaded excel is of incorrect format.Please check sample format and update your excel. "
      render :template => "generic_view/wrong_excel_format"
    end
  end
end

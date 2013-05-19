class Sale::SalesInvoiceController < ApplicationController
  require 'hpricot'
  include General
  include ClassMethods
  
  #Invoice Services
  def list_invoices
    doc = Hpricot::XML(request.raw_post)
    doc = doc.to_s.gsub("&amp;","&")
    doc = Hpricot::XML(doc)
    @invoices = Sales::SalesInvoiceCrud.list_invoices(doc)
    render :xml=>'<encoded>'+Base64.encode64(Zlib::Deflate.deflate(@invoices[0].xmlcol))+'</encoded>'
  end

  def show_invoice
    doc = Hpricot::XML(request.raw_post)
    invoice_id  = parse_xml(doc/:params/'id')
    @invoices = Sales::SalesInvoiceCrud.show_invoice(invoice_id)
    respond_to do |wants|
      wants.xml
    end
  end

  def create_invoices
    doc = EncodeDecode.decode(request.raw_post)
    @invoices= Sales::SalesInvoiceCrud.create_invoices(doc,false)
    invoice =  @invoices.first if !@invoices.empty?
    if invoice.errors.empty?
      respond_to_action('show_invoice')
    else
      respond_to_errors(invoice.errors)
    end
  end

  #Invoice Services
  def sales_invoice_inbox
    doc = Hpricot::XML(request.raw_post)
    doc = doc.to_s.gsub("&amp;","&")
    doc = Hpricot::XML(doc)
    @invoices = Sales::SalesInvoiceCrud.sales_invoice_inbox(doc)
    render :xml=>'<encoded>'+Base64.encode64(Zlib::Deflate.deflate(@invoices[0].xmlcol))+'</encoded>'
  end

  def create_invoices_from_inbox
    doc = Hpricot::XML(request.raw_post)
    doc = doc.to_s
    doc = Hpricot::XML(doc)
    shipping_id = parse_xml(doc/:sales_invoices/:sales_invoice/'shipping_id')
    trans_no = parse_xml(doc/:sales_invoices/:sales_invoice/'trans_no')
    #    ship_qty = parse_xml(doc/:sales_invoices/:sales_invoice/'ship_qty')
    order = Sales::SalesOrder.find_by_trans_no(trans_no)
    sales_order_shipping = Sales::SalesOrderShipping.find_by_id(shipping_id.to_i)
    order = Sales::SalesInvoiceCrud.create_invoice_from_inbox(session[:schema],sales_order_shipping,order,sales_order_shipping.clear_qty.to_i)
    if(order.errors[:base].empty? and order.errors[''].empty?)
      render :text => "successfull"
    else
      render :xml => "<errors><error>#{order.errors[:base][0]}</error></errors>"
    end
  end

  #CreditInvoice Services
  def list_credit_invoices
    doc = Hpricot::XML(request.raw_post)
    doc = doc.to_s.gsub("&amp;","&")
    doc = Hpricot::XML(doc)
    @creditinvoices = Sales::SalesCreditInvoiceCrud.list_credit_invoices(doc)
    render :xml=>'<encoded>'+Base64.encode64(Zlib::Deflate.deflate(@creditinvoices[0].xmlcol))+'</encoded>'
  end

  def show_credit_invoice
    doc = Hpricot::XML(request.raw_post)
    creditinvoice_id  = parse_xml(doc/:params/'id')
    @creditinvoices = Sales::SalesCreditInvoiceCrud.show_credit_invoice(creditinvoice_id)
    respond_to do |wants|
      wants.xml
    end
  end

  def create_credit_invoices
    doc = EncodeDecode.decode(request.raw_post)
    @creditinvoices= Sales::SalesCreditInvoiceCrud.create_credit_invoices(doc)
    creditinvoice =  @creditinvoices.first if !@creditinvoices.empty?
    if creditinvoice.errors.empty?
      respond_to_action('show_credit_invoice')
    else
      respond_to_errors(creditinvoice.errors)
    end
  end

  def list_open_invoices
    doc = Hpricot::XML(request.raw_post)
    doc = doc.to_s.gsub("&amp;","&")
    doc = Hpricot::XML(doc)
    @invoices = Sales::SalesInvoiceCrud.list_open_invoices(doc)
    render :xml=>@invoices[0].xmlcol
  end

  def list_open_invoices_hdr
    doc = Hpricot::XML(request.raw_post)
    doc = doc.to_s.gsub("&amp;","&")
    doc = Hpricot::XML(doc)
    @invoices = Sales::SalesInvoiceCrud.list_open_invoices_hdr(doc)
    render :xml=>@invoices[0].xmlcol
  end

  def list_open_invoice_lines
    doc = Hpricot::XML(request.raw_post)
    doc = doc.to_s.gsub("&amp;","&")
    doc = Hpricot::XML(doc)
    @invoices = Sales::SalesInvoiceCrud.list_open_invoice_lines(doc)
    render :xml=>@invoices[0].xmlcol
  end

  def resend_invoice_acknowledgment
    doc = Hpricot::XML(request.raw_post)
    invoice_id  = parse_xml(doc/:params/'id')
    message,text = Sales::SalesInvoiceCrud.resend_invoice_acknowledgment(invoice_id,session[:schema])
    render :text => message
  end
end

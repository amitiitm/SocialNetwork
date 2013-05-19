class Purchase::PurchaseOrderController < ApplicationController
  require 'hpricot'
  include General
  include ClassMethods

  #Order Services
  def list_orders
    doc = Hpricot::XML(request.raw_post)
    doc = doc.to_s.gsub("&amp;","&")
    doc = Hpricot::XML(doc)
    @orders = Purchase::PurchaseOrderCrud.list_orders(doc)
    render :xml=>'<encoded>'+Base64.encode64(Zlib::Deflate.deflate(@orders[0].xmlcol))+'</encoded>'
  end

  def list_open_orders
    doc = Hpricot::XML(request.raw_post)
    doc = doc.to_s.gsub("&amp;","&")
    doc = Hpricot::XML(doc)
    @orders = Purchase::PurchaseOrderCrud.list_open_orders(doc)
    render :xml=>@orders[0].xmlcol
  end

  def list_open_standard_orders
    doc = Hpricot::XML(request.raw_post)
    doc = doc.to_s.gsub("&amp;","&")
    doc = Hpricot::XML(doc)
    @orders = Purchase::PurchaseOrderCrud.list_open_standard_orders(doc)
    render :xml=>@orders[0].xmlcol
  end

  def list_open_memo_orders
    doc = Hpricot::XML(request.raw_post)
    doc = doc.to_s.gsub("&amp;","&")
    doc = Hpricot::XML(doc)
    @orders = Purchase::PurchaseOrderCrud.list_open_memo_orders(doc)
    render :xml=>@orders[0].xmlcol
  end

  def list_open_orders_hdr
    doc = Hpricot::XML(request.raw_post)
    doc = doc.to_s.gsub("&amp;","&")
    doc = Hpricot::XML(doc)
    @orders = Purchase::PurchaseOrderCrud.list_open_orders_hdr(doc)
    render :xml=>@orders[0].xmlcol
  end

  def list_open_order_lines
    doc = Hpricot::XML(request.raw_post)
    doc = doc.to_s.gsub("&amp;","&")
    doc = Hpricot::XML(doc)
    @orders = Purchase::PurchaseOrderCrud.list_open_order_lines(doc)
    render :xml=>@orders[0].xmlcol
  end

  def list_open_memo_orders_hdr
    doc = Hpricot::XML(request.raw_post)
    doc = doc.to_s.gsub("&amp;","&")
    doc = Hpricot::XML(doc)
    @orders = Purchase::PurchaseOrderCrud.list_open_memo_orders_hdr(doc)
    render :xml=>@orders[0].xmlcol
  end

  def list_open_memo_order_lines
    doc = Hpricot::XML(request.raw_post)
    doc = doc.to_s.gsub("&amp;","&")
    doc = Hpricot::XML(doc)
    @orders = Purchase::PurchaseOrderCrud.list_open_memo_order_lines(doc)
    render :xml=>@orders[0].xmlcol
  end

  def list_open_standard_orders_hdr
    doc = Hpricot::XML(request.raw_post)
    doc = doc.to_s.gsub("&amp;","&")
    doc = Hpricot::XML(doc)
    @orders = Purchase::PurchaseOrderCrud.list_open_standard_orders_hdr(doc)
    render :xml=>@orders[0].xmlcol
  end

  def list_open_standard_order_lines
    doc = Hpricot::XML(request.raw_post)
    doc = doc.to_s.gsub("&amp;","&")
    doc = Hpricot::XML(doc)
    @orders = Purchase::PurchaseOrderCrud.list_open_standard_order_lines(doc)
    render :xml=>@orders[0].xmlcol
  end

  def show_order
    doc = Hpricot::XML(request.raw_post)
    order_id  = parse_xml(doc/:params/'id')
    @login_type = parse_xml(doc/:params/'loginType')
    @orders = Purchase::PurchaseOrderCrud.show_order(order_id)
    respond_to do |wants|
      wants.xml
    end
  end

  def create_orders
    doc = Hpricot::XML(request.raw_post)
    doc = doc.to_s.gsub("&amp;","&")
    doc = Hpricot::XML(doc)
    @orders= Purchase::PurchaseOrderCrud.create_orders(doc)
    order =  @orders.first if !@orders.empty?
    if order.errors.empty?
      respond_to_action('show_order')
    else
      respond_to_errors(order.errors)
    end
  end

  def create_po_from_so
    doc = Hpricot::XML(request.raw_post)
    doc = doc.to_s.gsub("&amp;","&")
    doc = Hpricot::XML(doc)
    purchase_order,text = Purchase::PurchaseOrderCrud.create_po_from_so(doc)
    if text == 'error'
      render :xml => "<errors><error>#{purchase_order}</error></errors>"
    else
      render :xml => "<result>Purchase Order Created Successfully</result>"
    end
  end

  #OrderCancel Services
  def list_order_cancels
    doc = Hpricot::XML(request.raw_post)
    doc = doc.to_s.gsub("&amp;","&")
    doc = Hpricot::XML(doc)
    @order_cancels = Purchase::PurchaseOrderCancelCrud.list_order_cancels(doc)
    #    respond_to_action('list_order_cancels')
    render :xml=>'<encoded>'+Base64.encode64(Zlib::Deflate.deflate(@order_cancels[0].xmlcol))+'</encoded>'
  end

  def show_order_cancel
    doc = Hpricot::XML(request.raw_post)
    order_cancel_id  = parse_xml(doc/:params/'id')
    @order_cancels = Purchase::PurchaseOrderCancelCrud.show_order_cancel(order_cancel_id)
    respond_to do |wants|
      wants.xml
    end
  end

  def create_order_cancels
    doc = Hpricot::XML(request.raw_post)
    doc = doc.to_s.gsub("&amp;","&")
    doc = Hpricot::XML(doc)
    @order_cancels= Purchase::PurchaseOrderCancelCrud.create_order_cancels(doc)
    order_cancel =  @order_cancels.first if !@order_cancels.empty?
    if order_cancel.errors.empty?
      respond_to_action('show_order_cancel')
    else
      respond_to_errors(order_cancel.errors)
    end
  end

  def list_open_sales_orders
    doc = Hpricot::XML(request.raw_post)
    doc = doc.to_s.gsub("&amp;","&")
    doc = Hpricot::XML(doc)
    @orders = Sales::SalesOrderCrud.list_open_sales_orders_for_po(doc)
    render :xml=>@orders[0].xmlcol
  end

  def list_open_sales_orders_hdr
    doc = Hpricot::XML(request.raw_post)
    doc = doc.to_s.gsub("&amp;","&")
    doc = Hpricot::XML(doc)
    @orders = Sales::SalesOrderCrud.list_open_sales_orders_hdr(doc)
    render :xml=>@orders[0].xmlcol
  end

  def list_open_sales_order_lines
    doc = Hpricot::XML(request.raw_post)
    doc = doc.to_s.gsub("&amp;","&")
    doc = Hpricot::XML(doc)
    @orders = Sales::SalesOrderCrud.list_open_sales_order_lines(doc)
    render :xml=>@orders[0].xmlcol
  end

  #packingslip fetch services

  def list_open_orders_hdr_for_packing_slip
    doc = Hpricot::XML(request.raw_post)
    doc = doc.to_s.gsub("&amp;","&")
    doc = Hpricot::XML(doc)
    @orders = Purchase::PurchaseOrderCrud.list_open_orders_hdr_for_ps(doc)
    #    respond_to_action('list_orders')
    render :xml=>@orders[0].xmlcol
  end

  def list_open_order_lines_for_packing_slip
    doc = Hpricot::XML(request.raw_post)
    doc = doc.to_s.gsub("&amp;","&")
    doc = Hpricot::XML(doc)
    @orders = Purchase::PurchaseOrderCrud.list_open_order_lines_for_ps(doc)
    #    render_view( @orders,'purchase_orders','L')
    render :xml=>@orders[0].xmlcol
  end

  def list_open_orders_for_packing_slip
    doc = Hpricot::XML(request.raw_post)
    doc = doc.to_s.gsub("&amp;","&")
    doc = Hpricot::XML(doc)
    @orders = Purchase::PurchaseOrderCrud.list_open_orders_for_ps(doc)
    #    respond_to_action('list_orders')
    render :xml=>@orders[0].xmlcol
  end

  def convert_exceltoxml_for_purchase_orders
    uploaded_file = params[:Filedata]
    #    uploaded_file_name = params[:Filename]
    #    extension = uploaded_file.original_filename.split(".").last
    table_name = params[:table_name]
    #    IO::FileIO.save_xslx(uploaded_file) if extension=='xlsx'
    #    #      uploaded_file = "d:/test_excel.xlsx"
    #    #    uploaded_file_name ="d:/test_excel.xlsx"
    #    #        extension = "xlsx"
    #    #    table_name = "table_name"
    #    error_text,workbook = IO::FileIO.openexcelXfile(uploaded_file,uploaded_file_name) if extension=='xlsx'
    #    error_text,workbook = IO::FileIO.openexcelfile(uploaded_file,uploaded_file_name) if extension=='xls'
    #    if error_text
    #      render :text => error_text
    #      return
    #    end
    #    @data_rows = IO::FileIO.data_of_excel(workbook,extension)
    @data_rows = IO::FileIO.data_of_excel(uploaded_file)
    columns_format = ['item_code','item_description','item_qty','item_price']
    column_names = []
    @data_rows[0].each {|column_name| column_names << column_name.downcase} if @data_rows[0]
    @tag_level1 = table_name.pluralize
    @tag_level2 = table_name.singularize
    #    render :xml=> @data_rows, :template => "purchase/purchase_order/convert_exceltoxml_for_purchase_orders"
    if columns_format == column_names
      render  :template => "purchase/purchase_order/convert_exceltoxml_for_purchase_orders"
    else
      @error_msg = "Uploaded excel is of incorrect format.Please check sample format and update your excel. "
      render  :template => "generic_view/wrong_excel_format"
    end
  end
  
  
  def generic_convert_exceltoxml_for_purchase_orders
    uploaded_file = params[:Filedata]
    #    uploaded_file_name = params[:Filename]
    #    extension = uploaded_file.original_filename.split(".").last
    table_name = params[:table_name]
    #    IO::FileIO.save_xslx(uploaded_file) if extension=='xlsx'
    #    error_text,workbook = IO::FileIO.openexcelXfile(uploaded_file,uploaded_file_name) if extension=='xlsx'
    #    error_text,workbook = IO::FileIO.openexcelfile(uploaded_file,uploaded_file_name) if extension=='xls'
    #    if error_text
    #      render :text => error_text
    #      return
    #    end
    #    @data_rows = IO::FileIO.data_of_excel(workbook,extension)
    @data_rows = IO::FileIO.data_of_excel(uploaded_file)
    columns_format = [
      'po_no',
      'po_date',
      'trans_date',
      'ship_date',
      'vendor_code',
      'term_code',
      'due_date'	,
      'ship_via',
      'tax_amt',
      'shipping_amt',	
      'insurance_amt',
      'item_code',
      'vendor_sku_no',
      'customer_sku_no',
      'item_qty',
      'item_price',
      'discount_amt'
    ]
    column_names = []
    @data_rows[0].each {|column_name| column_names << column_name.downcase} if @data_rows[0]
    @tag_level1 = table_name.pluralize
    @tag_level2 = table_name.singularize
    if columns_format == column_names
      render  :template => "purchase/purchase_order/generic_convert_exceltoxml_for_purchase_order"
    else
      @error_msg = "Uploaded excel is of incorrect format.Please check sample format and update your excel. "
      render  :template => "generic_view/wrong_excel_format"
    end
  end
end

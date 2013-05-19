class Purchase::PurchaseMemoController < ApplicationController
  require 'hpricot'
  include General
  include ClassMethods
  
  #Memo Services
  def list_memos
    doc = Hpricot::XML(request.raw_post)   
    doc = doc.to_s.gsub("&amp;","&") 
    doc = Hpricot::XML(doc)
    @memos = Purchase::PurchaseMemoCrud.list_memos(doc)
    render :xml=>'<encoded>'+Base64.encode64(Zlib::Deflate.deflate(@memos[0].xmlcol))+'</encoded>'
  end  

  def list_open_memos
    doc = Hpricot::XML(request.raw_post)   
    doc = doc.to_s.gsub("&amp;","&") 
    doc = Hpricot::XML(doc)
    @memos = Purchase::PurchaseMemoCrud.list_open_memos(doc)
    render :xml=>@memos[0].xmlcol
  end  

  def list_open_memos_hdr
    doc = Hpricot::XML(request.raw_post)   
    doc = doc.to_s.gsub("&amp;","&") 
    doc = Hpricot::XML(doc)
    @memos = Purchase::PurchaseMemoCrud.list_open_memos_hdr(doc)
    render :xml=>@memos[0].xmlcol
  end  

  def list_open_memo_lines
    doc = Hpricot::XML(request.raw_post)   
    doc = doc.to_s.gsub("&amp;","&") 
    doc = Hpricot::XML(doc)
    @memos = Purchase::PurchaseMemoCrud.list_open_memo_lines(doc)
    render :xml=>@memos[0].xmlcol
  end  
  
  def show_memo
    doc = Hpricot::XML(request.raw_post)
    memo_id  = parse_xml(doc/:params/'id')
    @memos = Purchase::PurchaseMemoCrud.show_memo(memo_id)
    respond_to do |wants|
      wants.xml   
    end
  end  

  def create_memos
    doc = Hpricot::XML(request.raw_post)   
    doc = doc.to_s.gsub("&amp;","&") 
    doc = Hpricot::XML(doc)
    request_array = (request.host).split(".")
    company_code = request_array[0]
    company = Setup::Company.find_by_sql ["select schema_name from main.main_companies where code='#{company_code}' "]   if ActiveRecord::Base.retrieve_connection.class.to_s.match('IBM_DBAdapter') 
    company = Setup::Company.find_by_sql ["select schema_name from main.dbo.main_companies where code='#{company_code}' "]   if ActiveRecord::Base.retrieve_connection.class.to_s.match('SQLServerAdapter') 
    schema = company.first.schema_name
    upload_flag  = parse_xml(doc/:purchase_memos/:purchase_memo/'upload_flag')
    if (!upload_flag || upload_flag!='Y')
      @memos = Purchase::PurchaseMemoCrud.create_memos(doc)
      memo =  @memos.first if !@memos.empty?
      if memo.errors.empty?
        respond_to_action('show_memo')
      else
        respond_to_errors(memo.errors)
      end
    else
      @memos,log_filename ,result = Purchase::PurchaseMemoCrud.create_memos_with_log(doc,schema)
      @log_filename = "http://#{request.env['HTTP_HOST']}/upload_file_logs/#{schema}/#{log_filename}"
      if result > 0
        render  :template => "generic_view/list_error_log"
      else
        render  :template => "generic_view/list_success_log"
      end
    end
  end


  #MemoReturn Services
  def list_memo_returns
    doc = Hpricot::XML(request.raw_post)   
    doc = doc.to_s.gsub("&amp;","&") 
    doc = Hpricot::XML(doc)
    @memo_returns = Purchase::PurchaseMemoReturnCrud.list_memo_returns(doc)
    render :xml=>'<encoded>'+Base64.encode64(Zlib::Deflate.deflate(@memo_returns[0].xmlcol))+'</encoded>'
    
  end  
  ######################## NO REFERENCE FOUND IN FLEX SO COMMENTED LATER WE WILL DELETE THEM.
  #  def list_open_memo_returns
  #    doc = Hpricot::XML(request.raw_post)   
  #    doc = doc.to_s.gsub("&amp;","&") 
  #    doc = Hpricot::XML(doc)
  #    @memo_returns = Purchase::PurchaseMemoReturnCrud.list_open_memo_returns(doc)
  #    render :xml=>@memo_returns[0].xmlcol
  #  end  

  def show_memo_return
    doc = Hpricot::XML(request.raw_post)
    memo_return_id  = parse_xml(doc/:params/'id')
    @memo_returns = Purchase::PurchaseMemoReturnCrud.show_memo_return(memo_return_id)
    respond_to do |wants|
      wants.xml   
    end
  end  

  def create_memo_returns
    doc = Hpricot::XML(request.raw_post)   
    doc = doc.to_s.gsub("&amp;","&") 
    doc = Hpricot::XML(doc)
    @memo_returns= Purchase::PurchaseMemoReturnCrud.create_memo_returns(doc)
    memo_return =  @memo_returns.first if !@memo_returns.empty?
    if memo_return.errors.empty?
      respond_to_action('show_memo_return')
    else
      respond_to_errors(memo_return.errors)
    end
  end
  
  def convert_exceltoxml_for_purchase_memos
    uploaded_file = params[:Filedata]
    #    uploaded_file_name = params[:Filename]
    #    extension = uploaded_file.original_filename.split(".").last
    table_name = params[:table_name]
    #    @company_id = params[:company_id]
    #    IO::FileIO.save_xslx(uploaded_file) if extension=='xlsx'
    #    error_text,workbook = IO::FileIO.openexcelXfile(uploaded_file,uploaded_file_name) if extension=='xlsx'
    #    error_text,workbook = IO::FileIO.openexcelfile(uploaded_file,uploaded_file_name) if extension=='xls'
    #    if error_text
    #      render :text => error_text
    #      return
    #    end
    @data_rows = IO::FileIO.data_of_excel(uploaded_file)
    columns_format = [
      'vendor_ref_no' ,
      'vendor_ref_date',
      'trans_date',	
      'ship_date',
      'vendor_code',
      'term_code',
      'due_date',	
      'ship_via',
      'tracking_no',
      'tax_amt'	,
      'shipping_amt',
      'insurance_amt',
      'item_code',
      'customer_sku_no',
      'vendor_sku_no',
      'batch_code'	,
      'packet_code'	,
      'item_qty',
      'item_price',	
      'discount_amt'

    ]
    column_names = []
    @data_rows[0].each {|column_name| column_names << column_name.downcase} if @data_rows[0]
    @tag_level1 = table_name.pluralize
    @tag_level2 = table_name.singularize
    if columns_format == column_names
      render  :template => "purchase/purchase_memo/convert_exceltoxml_for_purchase_memo"
    else
      @error_msg = "Uploaded excel is of incorrect format.Please check sample format and update your excel."
      render  :template => "generic_view/wrong_excel_format"
    end
  end


end

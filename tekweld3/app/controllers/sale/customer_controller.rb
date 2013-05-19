class Sale::CustomerController < ApplicationController
  require 'hpricot'
  include General
  include ClassMethods

  
  def list_customers
    doc = Hpricot::XML(request.raw_post) 
    doc = doc.to_s.gsub("&amp;","&") 
    doc = Hpricot::XML(doc)    
    @customers = Customer::CustomerCrud.list_customers(doc)
    render :xml=>'<encoded>'+Base64.encode64(Zlib::Deflate.deflate(@customers[0].customers))+'</encoded>'
  end
  
  def show_customer
    doc = Hpricot::XML(request.raw_post)
    customer_id  = parse_xml(doc/:params/'id')
    @customers = Customer::CustomerCrud.show_customer(customer_id)
    respond_to do |wants|
      wants.xml   
    end
  end  

  def create_customers
    doc = Hpricot::XML(request.raw_post) 
    doc = doc.to_s.gsub("&amp;","&") 
    doc = Hpricot::XML(doc)  
    @customers= Customer::CustomerCrud.create_customers(doc)
    customer =  @customers.first if !@customers.empty?
    if customer.errors.empty? 
      respond_to_action("show_customer") 
    else
      respond_to_errors(customer.errors)
    end
  end

  def convert_exceltoxml_to_create_customers
    uploaded_file = params[:Filedata]
    uploaded_file_name = params[:Filename]
    extension = uploaded_file.original_filename.split(".").last
    table_name = params[:table_name]
    @data_rows = IO::FileIO.data_of_excel(uploaded_file)
    @tag_level1 = table_name.pluralize
    @tag_level2 = table_name.singularize
    render :template => "sale/customer/convert_exceltoxml_to_create_customers"
  end

  def list_customer_daily_credit_limits
    doc = Hpricot::XML(request.raw_post)
    doc = doc.to_s.gsub("&amp;","&")
    doc = Hpricot::XML(doc)
    @credit_limits = Customer::CustomerDailyCreditLimitCrud.list_customer_daily_credit_limits(doc)
    render :xml=>'<encoded>'+Base64.encode64(Zlib::Deflate.deflate(@credit_limits[0].xmlcol))+'</encoded>'
  end

  def show_customer_daily_credit_limit
    doc = Hpricot::XML(request.raw_post)
    customer_id  = parse_xml(doc/:params/'id')
    @credit_limits = Customer::CustomerDailyCreditLimitCrud.show_customer_daily_credit_limit(customer_id)
    render_view( @credit_limits,'customer_credit_limits','L')
  end

  def create_customer_daily_credit_limits
    doc = Hpricot::XML(request.raw_post)
    doc = doc.to_s.gsub("&amp;","&")
    doc = Hpricot::XML(doc)
    @credit_limits = Customer::CustomerDailyCreditLimitCrud.create_customer_daily_credit_limits(doc)
    customer =  @credit_limits.first if !@credit_limits.empty?
    if customer.errors.empty?
      render_view( @credit_limits,'customer_credit_limits','L')
    else
      respond_to_errors(customer.errors)
    end
  end
  def convert_xls_customer_specific_price
    doc = Hpricot::XML(request.raw_post)
    doc = doc.to_s.gsub("&amp;","&")
    doc = Hpricot::XML(doc)
    customer_id  = parse_xml(doc/:params/'id')
    filename= Customer::CustomerCrud.export_cutomer_pricing_xls(customer_id,session[:schema])
    if filename
      render :xml=> "<results><result>#{filename}</result></results>"
    else
      render :xml=>"<errors><error>Please Try Again</error></errors>"
    end

  end
end

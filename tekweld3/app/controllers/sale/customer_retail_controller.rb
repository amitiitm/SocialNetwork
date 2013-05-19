class Sale::CustomerRetailController < ApplicationController
  require 'hpricot'
  include General
  include ClassMethods
  
  
  def show_customer
    doc = Hpricot::XML(request.raw_post)
    customer_id  = parse_xml(doc/:params/'id')
    @customers = Customer::CustomerCrud.show_customer(customer_id)
    respond_to do |wants|
      wants.xml   
    end
  end  

  def create_customers
    #   Connection.establish_connection_schema('test1067')
    #    doc = Hpricot::XML(request.raw_post)
    #    doc = doc.to_s.gsub("&amp;","&")
    #    doc = Hpricot::XML(doc)
    doc = EncodeDecode.decode(request.raw_post)
    url_with_port = request.host_with_port      
    @customers= Customer::CustomerCrud.create_customers(doc,url_with_port) 
    customer =  @customers.first if !@customers.empty?
    if customer.errors.empty?
      #    render_view( @customers,'customers','C') 
      respond_to_action("show_customer")     
    else
      respond_to_errors(customer.errors)
    end
  end
  
  # Customer list for query 
  def list_retail_customers_inbox
    doc = Hpricot::XML(request.raw_post) 
    doc = doc.to_s.gsub("&amp;","&") 
    doc = Hpricot::XML(doc)    
    @customers = Customer::CustomerCrud.list_retail_customers_inbox(doc)
    render :xml=>@customers[0].xmlcol
  end
  
  def list_retail_customers
    doc = Hpricot::XML(request.raw_post) 
    doc = doc.to_s.gsub("&amp;","&") 
    doc = Hpricot::XML(doc)    
    @customers = Customer::CustomerCrud.list_retail_customers(doc)
    render :xml=>@customers[0].xmlcol
  end
  
  def convert_exceltoxml_to_create_customers
    uploaded_file = params[:Filedata]
    table_name = params[:table_name]
    @data_rows = IO::FileIO.data_of_excel(uploaded_file)
    @tag_level1 = table_name.pluralize
    @tag_level2 = table_name.singularize
    render :template => "sale/customer_retail/convert_exceltoxml_to_create_customers"
  end
end

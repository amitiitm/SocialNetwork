class Sale::CustomerCategoryController < ApplicationController
  require 'hpricot'
  include General
  include ClassMethods
  
  #services for cutomer categories
  def list_customer_categories
    doc = Hpricot::XML(request.raw_post)   
    doc = doc.to_s.gsub("&amp;","&") 
    doc = Hpricot::XML(doc)
    @customer_categories = Customer::CustomerCrud.list_customer_categories(doc)
    render_view( @customer_categories,'customer_categories','L')
  end  

  def show_customer_category
    doc = Hpricot::XML(request.raw_post)
    customer_category_id  = parse_xml(doc/:params/'id')
    @customer_categories = Customer::CustomerCrud.show_customer_category(customer_category_id)
    render_view( @customer_categories,'customer_categories','L')
  end  

  def create_customer_categories
    doc = Hpricot::XML(request.raw_post)   
    doc = doc.to_s.gsub("&amp;","&") 
    doc = Hpricot::XML(doc)
    @customer_categories= Customer::CustomerCrud.create_customer_categories(doc)
    customer_category =  @customer_categories.first if !@customer_categories.empty?
    if customer_category.errors.empty?
      render_view( @customer_categories,'customer_categories','C') 
    else
      respond_to_errors(customer_category.errors)
    end
  end
  
  def convert_exceltoxml_for_customercategories
    uploaded_file = params[:Filedata]
    uploaded_file_name = params[:Filename]
    extension = uploaded_file.original_filename.split(".").last
    table_name = params[:table_name]
    @data_rows = IO::FileIO.data_of_excel(uploaded_file)
    @tag_level1 = table_name.pluralize
    @tag_level2 = table_name.singularize
    render :template => "sale/customer_category/convert_exceltoxml_for_customercategories"
  end 

end

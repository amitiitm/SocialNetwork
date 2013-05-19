class Purchase::VendorCategoryController < ApplicationController
  require 'hpricot'
  include General
  include ClassMethods
  
  def list_vendor_categories
    doc = Hpricot::XML(request.raw_post)  
    doc = doc.to_s.gsub("&amp;","&") 
    doc = Hpricot::XML(doc)    
    @vendor_categories = Vendor::VendorCrud.list_vendor_categories(doc)
    #render_view( @vendor_categories,'vendor_categories','L')
    respond_to_action('list_vendor_categories')
  end  

  def show_vendor_category
    doc = Hpricot::XML(request.raw_post)
    vendor_category_id  = parse_xml(doc/:params/'id')
    @vendor_categories = Vendor::VendorCrud.show_vendor_category(vendor_category_id)
    respond_to_action('list_vendor_categories')
  end  

  def create_vendor_categories
    doc = Hpricot::XML(request.raw_post) 
    doc = doc.to_s.gsub("&amp;","&") 
    doc = Hpricot::XML(doc)  
    @vendor_categories= Vendor::VendorCrud.create_vendor_categories(doc)
    vendor_category =  @vendor_categories.first if !@vendor_categories.empty?
    if vendor_category.errors.empty?
      render_view( @vendor_categories,'vendor_categories','C') 
    else
      respond_to_errors(vendor_category.errors)
    end
  end

  def convert_exceltoxml_for_vendor_categories
    uploaded_file = params[:Filedata]
    uploaded_file_name = params[:Filename]
    extension = uploaded_file.original_filename.split(".").last
    table_name = params[:table_name]
    IO::FileIO.save_xslx(uploaded_file) if extension=='xlsx'
    error_text,workbook = IO::FileIO.openexcelXfile(uploaded_file,uploaded_file_name) if extension=='xlsx'
    error_text,workbook = IO::FileIO.openexcelfile(uploaded_file,uploaded_file_name) if extension=='xls'
    if error_text 
      render :text => error_text
      return
    end
    @data_rows = IO::FileIO.data_of_excel(workbook,extension)
    @tag_level1 = table_name.pluralize
    @tag_level2 = table_name.singularize
    render :xml=> @data_rows, :template => "purchase/vendor_category/convert_exceltoxml_for_vendor_categories"
  end
end

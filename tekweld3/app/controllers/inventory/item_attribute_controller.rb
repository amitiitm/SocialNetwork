class Inventory::ItemAttributeController < ApplicationController
  require 'hpricot'
  include General
  include ClassMethods
  
  def list_catalog_attributes
    doc = Hpricot::XML(request.raw_post)
    doc = doc.to_s.gsub("&amp;","&") 
    doc = Hpricot::XML(doc)    
    @catalog_attributes = Item::CatalogItemCrud.list_catalog_attributes(doc)
    render_view( @catalog_attributes,'catalog_attributes','L') 
  end  

  def show_catalog_attribute
    doc = Hpricot::XML(request.raw_post)
    catalog_attribute_id  = parse_xml(doc/:params/'id')
    @catalog_attributes = Item::CatalogItemCrud.show_catalog_attribute(catalog_attribute_id)
    respond_to_action('show_catalog_attribute')
  end  

  def create_catalog_attributes
    doc = Hpricot::XML(request.raw_post)
    doc = doc.to_s.gsub("&amp;","&") 
    doc = Hpricot::XML(doc)    
    @catalog_attributes= Item::CatalogItemCrud.create_catalog_attributes(doc)
    catalog_attribute =  @catalog_attributes.first if !@catalog_attributes.empty?
    if catalog_attribute.errors.empty?
      respond_to_action('show_catalog_attribute')
    else
      respond_to_errors(catalog_attribute.errors)
    end
  end
  
  def convert_exceltoxml_for_catalog_item_attributes
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
    render :xml=> @data_rows, :template => "inventory/item_attribute/convert_exceltoxml_for_catalog_item_attributes"
  end
end

class Inventory::ItemCategoryController < ApplicationController
  require 'hpricot'
  include General
  include ClassMethods
  
  def list_catalog_item_categories
    doc = Hpricot::XML(request.raw_post)
    doc = doc.to_s.gsub("&amp;","&") 
    doc = Hpricot::XML(doc)    
    @catalog_item_categories = Item::CatalogItemCrud.list_catalog_item_categories(doc)
    #render_view( @catalog_item_categories,'item_categories','L') 
    respond_to_action('list_catalog_item_categories')
  end  

  def show_catalog_item_category
    doc = Hpricot::XML(request.raw_post)
    catalog_item_category_id  = parse_xml(doc/:params/'id')
    @catalog_item_categories = Item::CatalogItemCrud.show_catalog_item_category(catalog_item_category_id)
    #render_view( @catalog_item_category,'item_categories','L') 
    respond_to_action('show_catalog_item_categories')
  end 
  
  def create_catalog_item_categories
    doc = Hpricot::XML(request.raw_post) 
    doc = doc.to_s.gsub("&amp;","&") 
    doc = Hpricot::XML(doc)    
    @catalog_item_categories= Item::CatalogItemCrud.create_catalog_item_categories(doc)
    catalog_item_category =  @catalog_item_categories.first if !@catalog_item_categories.empty?
    if catalog_item_category.errors.empty?
      respond_to_action('show_catalog_item_categories')
      #    render_view( @catalog_item_categories,'item_categories','C') 
    else
      respond_to_errors(catalog_item_category.errors)
    end
  end
  
  def list_catalog_item_category_attributes
    doc = Hpricot::XML(request.raw_post)
    doc = doc.to_s.gsub("&amp;","&") 
    doc = Hpricot::XML(doc)
    catalog_item_category_id  = parse_xml(doc/:criteria/'id')
    @catalog_item_category_attributes = Item::CatalogItemCrud.list_catalog_item_category_attributes(catalog_item_category_id)
    #render_view( @catalog_item_category_attributes,'catalog_item_category_attributes','L') 
    respond_to_action('list_catalog_item_category_attributes')

  end 
  
  def convert_exceltoxml_for_catalog_item_categories
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
    render :xml=> @data_rows, :template => "inventory/item_category/convert_exceltoxml_for_catalog_item_categories"
  end 
end

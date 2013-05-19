class Inventory::ItemController < ApplicationController
  require 'hpricot'
  include General
  include ClassMethods
  
  def list_catalog_items ## used in tekweld
    doc = Hpricot::XML(request.raw_post) 
    doc = doc.to_s.gsub("&amp;","&") 
    doc = Hpricot::XML(doc)    
    @catalog_items = Item::CatalogItemCrud.list_catalog_items(doc) 
    render :xml=>'<encoded>'+Base64.encode64(Zlib::Deflate.deflate(@catalog_items[0].catalog_items))+'</encoded>'
  end  

  def show_catalog_item ## used in tekweld
    doc = Hpricot::XML(request.raw_post)
    catalog_item_id  = parse_xml(doc/:params/'id')
    @catalog_items = Item::CatalogItemCrud.show_catalog_item(catalog_item_id)
    respond_to do |wants|
      wants.xml   
    end
  end  

  def create_catalog_items ## used in tekweld
    doc = Hpricot::XML(request.raw_post) 
    doc = doc.to_s.gsub("&amp;","&") 
    doc = Hpricot::XML(doc)    
    @catalog_items= Item::CatalogItemCrud.create_catalog_items(doc)
    catalog_item =  @catalog_items.first if !@catalog_items.empty?
    if catalog_item.errors.empty?
      #    render_view( @catalog_items,'catalog_items','C') 
      respond_to_action('show_catalog_item')
    else
      respond_to_errors(catalog_item.errors)
    end
  end

  def upload_image
    msgtext = IO::FileIO.upload_image(params[:Filedata],session[:schema])
    render :text =>msgtext
  end  

  def upload_item_templates
    schema_name = session[:schema]
    uploaded_file = params[:Filedata]
    text =  Item::CatalogItemCrud.upload_item_templates(uploaded_file,schema_name)
    if text == 'success'
      render :text=> "Attachment Upload Successfull"
    else
      render :text=> "Attachment Upload UnSuccessfull"
    end
  end

  def upload_catalog_image
    request_array = (request.host).split(".")
    company_code = request_array[0]
    #    company = Setup::Company.find_by_sql ["select schema_name from main.main_companies where code=?",company_code]   if ActiveRecord::Base.retrieve_connection.class.to_s.match('IBM_DBAdapter')
    company = Setup::Company.find_by_sql ["select schema_name from main.dbo.main_companies where code=?",company_code]  # if ActiveRecord::Base.retrieve_connection.class.to_s.match('SQLServerAdapter')
    schema_name = company.first.schema_name
    file_name = IO::FileIO.save_catalog_image(params[:Filedata],schema_name)
    msgtext = "succeefully uploaded "+file_name
    render :text => msgtext
  end      

  def upload_item_data_from_excel
    uploaded_file = params[:Filedata]
    uploaded_file_name = params[:Filename]
    extension = uploaded_file.original_filename.split(".").last
    if extension=='xlsx' || extension=='XLSX'
      IO::FileIO.save_xslx(uploaded_file) 
      error_text,workbook =  IO::FileIO.openexcelXfile(uploaded_file,uploaded_file_name) 
      if error_text 
        render :text => error_text
        return
      end
      text = Catalog::CatalogLib.import_site_data_excelx(workbook)
    end
    if extension=='xls'|| extension=='XLS'
      error_text,workbook =  IO::FileIO.openexcelfile(uploaded_file,uploaded_file_name) 
      if error_text 
        render :text => error_text
        return
      end
      text = Catalog::CatalogLib.import_site_data(workbook.worksheet(0))
    end
    if text =='error'
      render :text=> "Item Upload fails"
    else
      render :text=> "Items successfully uploaded"
    end
  end

  def fetch_default_rush_setup_item
    @catalog_items = Item::CatalogItem.find_by_sql ["
                                  select '' as id,1 as item_qty,0 as item_price,0 as item_amt,'S' as line_type,
                                  catalog_items.sale_description as item_description,catalog_items.image_thumnail,
                                  catalog_items.item_type,catalog_items.unit,catalog_items.cost,catalog_items.name,
                                  catalog_items.store_code as catalog_item_code,catalog_items.id as setup_item_id,
                                  catalog_items.store_code as value,catalog_items.store_code as label,
                                  catalog_items.id as catalog_item_id,catalog_items.scope_flag,catalog_items.workflow
                                  from catalog_items
                                  inner join catalog_item_categories cic on cic.id = catalog_items.catalog_item_category_id
                                  where cic.code = 'RUSHITEM'"]

    #    render :xml=>@catalog_items[0].xmlcol
  end
end

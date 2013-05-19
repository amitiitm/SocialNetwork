class Purchase::VendorController < ApplicationController
  require 'hpricot'
  include General
  include ClassMethods

  def list_vendors
    doc = Hpricot::XML(request.raw_post)
    doc = doc.to_s.gsub("&amp;","&") 
    doc = Hpricot::XML(doc)    
    @vendors = Vendor::VendorCrud.list_vendors(doc)
    render :xml=>'<encoded>'+Base64.encode64(Zlib::Deflate.deflate(@vendors[0].xmlcol))+'</encoded>'
  end  

  def show_vendor
    doc = Hpricot::XML(request.raw_post)
    vendor_id  = parse_xml(doc/:params/'id')
    @vendors = Vendor::VendorCrud.show_vendor(vendor_id)
    render_view( @vendors,'vendors','C') 
  end  

  def create_vendors
    #   Connection.establish_connection_schema('test1067')
    doc = Hpricot::XML(request.raw_post)
    doc = doc.to_s.gsub("&amp;","&") 
    doc = Hpricot::XML(doc)
    @vendors= Vendor::VendorCrud.create_vendors(doc)
    vendor =  @vendors.first if !@vendors.empty?
    if vendor.errors.empty?
      render_view( @vendors,'vendors','C') 
    else
      respond_to_errors(vendor.errors)
    end
  end
  
  def convert_exceltoxml_for_vendors
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
    render :xml=> @data_rows, :template => "purchase/vendor/convert_exceltoxml_for_vendors"
  end

  
end

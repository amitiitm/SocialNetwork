class Setup::ShippingController < ApplicationController
  require 'hpricot'
  include General
  include ClassMethods
  
  #Service for Shipping
  def list_shippings
    doc = Hpricot::XML(request.raw_post)
    doc = doc.to_s.gsub("&amp;","&") 
    doc = Hpricot::XML(doc)
    @shippings = Setup::ShippingCrud.list_shippings(doc)
    render :xml=>'<encoded>'+Base64.encode64(Zlib::Deflate.deflate(@shippings[0].xmlcol))+'</encoded>'
  end  

  def show_shipping
    doc = Hpricot::XML(request.raw_post)
    shipping_id  = parse_xml(doc/:params/'id')
    @shippings = Setup::ShippingCrud.show_shipping(shipping_id)
    render_view( @shippings,'shippings','L')
  end  

  def create_shippings
    doc = Hpricot::XML(request.raw_post)
    doc = doc.to_s.gsub("&amp;","&") 
    doc = Hpricot::XML(doc)    
    @shippings = Setup::ShippingCrud.create_shippings(doc)
    shipping =  @shippings.first if !@shippings.empty?
    if shipping.errors.empty?
      render_view( @shippings,'shippings','C') 
    else
      respond_to_errors(shipping.errors)
    end
  end
  
  def convert_exceltoxml_for_shipping
    uploaded_file = params[:Filedata]
    table_name = params[:table_name]
    @data_rows = IO::FileIO.data_of_excel(uploaded_file)
    @tag_level1 = table_name.pluralize
    @tag_level2 = table_name.singularize
    render :template => "setup/shipping/convert_exceltoxml_for_shipping"
  end
end

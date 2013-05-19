class Purchase::PurchaseController < ApplicationController
  require 'hpricot'
  include General
  include ClassMethods


  #generate PO service
  def generate_po
    doc = Hpricot::XML(request.raw_post) 
    doc = doc.to_s.gsub("&amp;","&") 
    doc = Hpricot::XML(doc)
    @orders =  Workbag::WorkbagProdCrud.create_workbag_and_po(doc)
    order =  @orders.first if !@orders.empty?
    if order.errors.empty?
      #      render_view( @orders,'orders','C') 
      respond_to_action('list_orders')
    else
      respond_to_errors(order.errors)
    end
  end
 
  def convert_excel_to_xml
    uploaded_file = params[:Filedata]
    table_name = params[:table_name]
    @data_rows = IO::FileIO.data_of_excel(uploaded_file)
    @tag_level1 = table_name.pluralize
    @tag_level2 = table_name.singularize
  end    
  
end

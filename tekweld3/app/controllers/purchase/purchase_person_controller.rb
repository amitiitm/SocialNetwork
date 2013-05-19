class Purchase::PurchasePersonController < ApplicationController
  require 'hpricot'
  include General
  include ClassMethods
  
  
  def list_people
    doc = Hpricot::XML(request.raw_post)   
    doc = doc.to_s.gsub("&amp;","&") 
    doc = Hpricot::XML(doc)  
    @peoples = Purchase::PurchasePersonCrud.list_people(doc)
    render :xml=>'<encoded>'+Base64.encode64(Zlib::Deflate.deflate(@peoples[0].xmlcol))+'</encoded>'
  end 
  
  def show_person
    doc = Hpricot::XML(request.raw_post)
    people_id  = parse_xml(doc/:params/'id')
    @peoples = Purchase::PurchasePersonCrud.show_person(people_id)
    render_view( @peoples,'purchase_peoples','L')
  end
  
  def create_people
    doc = Hpricot::XML(request.raw_post)   
    doc = doc.to_s.gsub("&amp;","&") 
    doc = Hpricot::XML(doc)
    @peoples = Purchase::PurchasePersonCrud.create_people(doc)
    people =  @peoples.first if !@peoples.empty?
    if people.errors.empty?
      render_view( @peoples,'purchase_peoples','C') 
    else
      respond_to_errors(people.errors)
    end
  end
  
  def convert_exceltoxml_for_purchasepeople
    uploaded_file = params[:Filedata]
    table_name = params[:table_name]
    @data_rows = IO::FileIO.data_of_excel(uploaded_file)
    @tag_level1 = table_name.pluralize
    @tag_level2 = table_name.singularize
    render :template => "purchase/purchase_person/convert_exceltoxml_for_purchasepeople"
  end
end

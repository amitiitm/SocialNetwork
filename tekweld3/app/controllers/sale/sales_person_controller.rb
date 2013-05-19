class Sale::SalesPersonController < ApplicationController
  require 'hpricot'
  include General
  include ClassMethods
  
  def list_people
    doc = Hpricot::XML(request.raw_post)
    doc = doc.to_s.gsub("&amp;","&")
    doc = Hpricot::XML(doc)
    @peoples = Sales::SalesPersonCrud.list_people(doc)
    render_view( @peoples,'sales_peoples','L')
    #    render :xml=>'<encoded>'+Base64.encode64(Zlib::Deflate.deflate(@peoples[0].xmlcol))+'</encoded>'
  end

  def show_person
    doc = Hpricot::XML(request.raw_post)
    people_id  = parse_xml(doc/'id')
    @people = Sales::SalesPersonCrud.show_person(people_id)
    respond_to do |wants|
      wants.xml
    end
  end

  def create_people
    doc = Hpricot::XML(request.raw_post)
    doc = doc.to_s.gsub("&amp;","&")
    doc = Hpricot::XML(doc)
    @people= Sales::SalesPersonCrud.create_people(doc)
    people =  @people.first if !@people.empty?
    if people.errors.empty?
      respond_to_action('show_person')
    else
      respond_to_errors(people.errors)
    end
  end

  def convert_exceltoxml_for_salespeople
    uploaded_file = params[:Filedata]
    table_name = params[:table_name]
    @data_rows = IO::FileIO.data_of_excel(uploaded_file)
    @tag_level1 = table_name.pluralize
    @tag_level2 = table_name.singularize
    render :template => "sale/sales_person/convert_exceltoxml_for_salespeople"
  end
end

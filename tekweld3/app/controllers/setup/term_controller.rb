class Setup::TermController < ApplicationController
  require 'hpricot'
  include General
  include ClassMethods
  
  #Term services
  def list_terms
    doc = Hpricot::XML(request.raw_post)
    doc = doc.to_s.gsub("&amp;","&") 
    doc = Hpricot::XML(doc)    
    @terms = Setup::TermCrud.list_terms(doc)
    render :xml=>'<encoded>'+Base64.encode64(Zlib::Deflate.deflate(@terms[0].xmlcol))+'</encoded>'
  end  

  def show_term
    doc = Hpricot::XML(request.raw_post)
    shipping_id  = parse_xml(doc/:params/'id')
    @terms = Setup::TermCrud.show_term(shipping_id)
    render_view( @terms,'terms','L')
  end  

  def create_terms
    doc = Hpricot::XML(request.raw_post) 
    doc = doc.to_s.gsub("&amp;","&") 
    doc = Hpricot::XML(doc)    
    @terms = Setup::TermCrud.create_terms(doc)
    term =  @terms.first if !@terms.empty?
    if term.errors.empty?
      render_view( @terms,'terms','C') 
    else
      respond_to_errors(term.errors)
    end
  end
  
  def convert_exceltoxml_for_terms
    uploaded_file = params[:Filedata]
    table_name = params[:table_name]
    @data_rows = IO::FileIO.data_of_excel(uploaded_file)
    @tag_level1 = table_name.pluralize
    @tag_level2 = table_name.singularize
    render :template => "setup/term/convert_exceltoxml_for_terms"
  end
end

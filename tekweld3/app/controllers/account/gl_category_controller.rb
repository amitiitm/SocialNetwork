class Account::GlCategoryController < ApplicationController
  require 'hpricot'
  include General
  include ClassMethods
  
  def list_gl_category
    doc = Hpricot::XML(request.raw_post)
    doc = doc.to_s.gsub("&amp;","&") 
    doc = Hpricot::XML(doc)
    @gl_categories = GeneralLedger::GlAccountCrud.list_gl_category(doc)
    render :xml=>'<encoded>'+Base64.encode64(Zlib::Deflate.deflate(@gl_categories[0].xmlcol))+'</encoded>'
  end

  def show_gl_category
    doc = Hpricot::XML(request.raw_post)
    id  = parse_xml(doc/:params/'id')
    @gl_categories = GeneralLedger::GlAccountCrud.show_gl_category(id)
    render_view(@gl_categories,'gl_categories','L')
  end  
  
  def create_gl_category
    doc = Hpricot::XML(request.raw_post)   
    doc = doc.to_s.gsub("&amp;","&") 
    doc = Hpricot::XML(doc)
    @gl_categories =GeneralLedger::GlAccountCrud.create_gl_categories(doc)
    gl_category = @gl_categories.first if !@gl_categories.empty?
    if  gl_category.errors.empty?
      render_view(@gl_categories,'gl_categories','C')
    else
      respond_to_errors(gl_category.errors)
    end
  end
  
  def convert_exceltoxml_for_glcategory
    uploaded_file = params[:Filedata]
    table_name = params[:table_name]
    @data_rows = IO::FileIO.data_of_excel(uploaded_file)
    @tag_level1 = table_name.pluralize
    @tag_level2 = table_name.singularize
    render :template => "account/gl_category/convert_exceltoxml_for_glcategory"
  end
end

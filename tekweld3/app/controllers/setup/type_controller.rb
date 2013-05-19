class Setup::TypeController < ApplicationController
  require 'hpricot'
  
  def type
  end
  
  def list
    doc = Hpricot::XML(request.raw_post)   
    @listarray = Setup::Type.list(doc)
    respond_to do |format|
      format.xml 
    end
  end

  def list_all_types
    doc = Hpricot::XML(request.raw_post)   
    @listarray = Setup::Type.list_all_types(doc)
    render :template => "setup/type/list"
  end
  
  def list_paths
    request_array = (request.host).split(".")  
    company_code = request_array[0]
    #company = Setup::Company.find_by_sql ["select schema_name from main.main_companies where code=?",company_code]   if ActiveRecord::Base.retrieve_connection.class.to_s.match('IBM_DBAdapter')
    company = Setup::Company.find_by_sql ["select schema_name from main.dbo.main_companies where code=?",company_code]   #if ActiveRecord::Base.retrieve_connection.class.to_s.match('SQLServerAdapter')
    schema_name = company.first.schema_name
    @patharray = Setup::Type.list_all_upload_path(schema_name)
    respond_to_action('list_all_upload_path')
  end

  def show_app_settings  
    @types = Setup::TypeCrud.show_app_settings
    respond_to do |wants|
      wants.xml   
    end  
  end

  def create_app_settings
    doc = Hpricot::XML(request.raw_post)
    doc = doc.to_s.gsub("&amp;","&") 
    doc = Hpricot::XML(doc)
    @types = Setup::TypeCrud.create_app_settings(doc)
    type=  @types.first if !@types.empty?
    if type.errors.empty?
      respond_to_action('show_app_settings') 
    else
      respond_to_errors(type.errors)
    end
  end
  
end

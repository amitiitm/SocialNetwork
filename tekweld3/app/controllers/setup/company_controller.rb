class Setup::CompanyController < ApplicationController
  require 'hpricot'
  include General
  include ClassMethods
  
  #Companies services
  def list_companies
    doc = Hpricot::XML(request.raw_post)  
    doc = doc.to_s.gsub("&amp;","&") 
    doc = Hpricot::XML(doc)    
    @companies = Setup::CompanyCrud.list_companies(doc)
    render :xml=>'<encoded>'+Base64.encode64(Zlib::Deflate.deflate(@companies[0].xmlcol))+'</encoded>'
  end  

  def show_company
    doc = Hpricot::XML(request.raw_post)
    company_id  = parse_xml(doc/:params/'id')
    @companies = Setup::CompanyCrud.show_company(company_id)
    respond_to do |wants|
      wants.xml   
    end
  end  

  def create_companies
    doc = Hpricot::XML(request.raw_post) 
    doc = doc.to_s.gsub("&amp;","&") 
    doc = Hpricot::XML(doc)    
    @companies = Setup::CompanyCrud.create_companies(doc)
    company =  @companies.first if !@companies.empty?
    if company.errors.empty?
      respond_to_action('show_company')
    else
      respond_to_errors(company.errors)
    end
  end
end

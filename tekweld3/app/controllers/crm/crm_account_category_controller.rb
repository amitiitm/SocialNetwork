class Crm::CrmAccountCategoryController < ApplicationController
  require 'hpricot'
  include General
  include ClassMethods
  
  def list_account_categories
    doc = Hpricot::XML(request.raw_post)
    doc = doc.to_s.gsub("&amp;","&") 
    doc = Hpricot::XML(doc)
    @account_categories = Crm::CrmAccountCrud.list_categories(doc)
    #    render_view( @account_categories,'crm_account_categories','L')
    render :xml=>'<encoded>'+Base64.encode64(Zlib::Deflate.deflate(@account_categories[0].xmlcol))+'</encoded>'
  end
 
  def show_account_category
    doc = Hpricot::XML(request.raw_post)   
    category_id = parse_xml(doc/'id') 
    @account_categories = Crm::CrmAccountCrud.show_categories(category_id)
    render_view( @account_categories,'crm_account_categories','L') 
  end
 
  def create_account_categories
    doc = Hpricot::XML(request.raw_post)   
    doc = doc.to_s.gsub("&amp;","&") 
    doc = Hpricot::XML(doc)
    @account_categories = Crm::CrmAccountCrud.create_categories(doc)  
    account_category = @account_categories.first if !@account_categories.empty?
    if account_category.errors.empty?
      render_view(@account_categories,'crm_account_categories','C')
    else
      respond_to_errors(account_category.errors)
    end   
  end
end

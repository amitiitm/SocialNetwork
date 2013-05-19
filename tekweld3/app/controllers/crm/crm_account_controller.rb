class Crm::CrmAccountController < ApplicationController
  require 'hpricot'
  include General
  include ClassMethods
  
  def list_accounts
    doc = Hpricot::XML(request.raw_post)
    doc = doc.to_s.gsub("&amp;","&") 
    doc = Hpricot::XML(doc)     
    @accounts = Crm::CrmAccountCrud.list_accounts(doc)
    render :xml=>'<encoded>'+Base64.encode64(Zlib::Deflate.deflate(@accounts[0].xmlcol))+'</encoded>'
  end
 
  def show_accounts
    doc = Hpricot::XML(request.raw_post)   
    account_id = parse_xml(doc/'id') 
    @account = Crm::CrmAccountCrud.show_accounts(account_id)
    respond_to_action('show_crm_accounts') 
  end
 
  def create_accounts
    doc = Hpricot::XML(request.raw_post)
    doc = doc.to_s.gsub("&amp;","&") 
    doc = Hpricot::XML(doc)    
    accounts = Crm::CrmAccountCrud.create_accounts(doc)  
    @account =  accounts.first if !accounts.empty?
    if @account.errors.empty?
      respond_to_action('show_crm_accounts') 
    else
      respond_to_errors(@account.errors)
    end   
  end
  
  #create crm account on link 
  def create_crm_account_from_lead
    doc = Hpricot::XML(request.raw_post)
    doc = doc.to_s.gsub("&amp;","&") 
    doc = Hpricot::XML(doc)    
    id = parse_xml(doc/:params/'id')
    account_doc = Crm::CrmLeadCrud.generate_xml_for_account(doc) 
    @accounts=Crm::CrmLeadCrud.create_account_from_lead(account_doc,id)
    account =  @accounts.first if !@accounts.empty?
    if account.errors.empty?
      render:text=>'success'
    else
      respond_to_errors(account.errors)
    end
  end
end

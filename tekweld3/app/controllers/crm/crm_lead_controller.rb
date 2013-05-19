class Crm::CrmLeadController < ApplicationController
  require 'hpricot'
  include General
  include ClassMethods
  
  #crm lead services
  def list_crm_leads
    doc = Hpricot::XML(request.raw_post)
    doc = doc.to_s.gsub("&amp;","&") 
    doc = Hpricot::XML(doc)    
    @crm_leads = Crm::CrmLeadCrud.list_crm_leads(doc)
    render :xml=>'<encoded>'+Base64.encode64(Zlib::Deflate.deflate(@crm_leads[0].xmlcol))+'</encoded>'
  end
 
  def show_crm_leads
    doc = Hpricot::XML(request.raw_post)   
    crm_lead_id = parse_xml(doc/'id') 
    @crm_leads = Crm::CrmLeadCrud.show_crm_leads(crm_lead_id)
    respond_to_action('show_crm_leads') 
  end
 
  def create_crm_leads
    doc = Hpricot::XML(request.raw_post)
    doc = doc.to_s.gsub("&amp;","&") 
    doc = Hpricot::XML(doc)    
    @crm_leads = Crm::CrmLeadCrud.create_crm_leads(doc)
    crm_lead =  @crm_leads.first if !@crm_leads.empty?
    if crm_lead.errors.empty?
      respond_to_action('show_crm_leads')
    else
      respond_to_errors(crm_lead.errors)
    end
  end
end

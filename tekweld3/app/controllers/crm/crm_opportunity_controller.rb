class Crm::CrmOpportunityController < ApplicationController
  require 'hpricot'
  include General
  include ClassMethods
  
  def list_opportunities
    doc = Hpricot::XML(request.raw_post)
    doc = doc.to_s.gsub("&amp;","&") 
    doc = Hpricot::XML(doc)    
    @opportunities = Crm::CrmOpportunityCrud.list_opportunities(doc)
    render :xml=>'<encoded>'+Base64.encode64(Zlib::Deflate.deflate(@opportunities[0].xmlcol))+'</encoded>'
  end
 
  def show_opportunities
    doc = Hpricot::XML(request.raw_post)   
    opportunity_id = parse_xml(doc/'id') 
    @opportunities = Crm::CrmOpportunityCrud.show_opportunities(opportunity_id)
    render_view( @opportunities,'crm_opportunities','L') 
  end
 
  def create_opportunities
    doc = Hpricot::XML(request.raw_post)
    doc = doc.to_s.gsub("&amp;","&") 
    doc = Hpricot::XML(doc)    
    @opportunities = Crm::CrmOpportunityCrud.create_opportunities(doc)  
    opportunity =  @opportunities.first if !@opportunities.empty?
    if opportunity.errors.empty?
      render_view( @opportunities,'crm_opportunities','C')
    else
      respond_to_errors(opportunity.errors)
    end   
  end
end

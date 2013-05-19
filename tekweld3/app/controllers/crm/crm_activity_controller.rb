class Crm::CrmActivityController < ApplicationController
  require 'hpricot'
  include General
  include ClassMethods
  
  def list_activities
    doc = Hpricot::XML(request.raw_post)
    doc = doc.to_s.gsub("&amp;","&") 
    doc = Hpricot::XML(doc)    
    @activities = Crm::CrmActivityCrud.list_activities(doc)
    render :xml=>'<encoded>'+Base64.encode64(Zlib::Deflate.deflate(@activities[0].xmlcol))+'</encoded>'
  end
 
  def show_activities
    doc = Hpricot::XML(request.raw_post)   
    activity_id = parse_xml(doc/'id') 
    @activity = Crm::CrmActivityCrud.show_activities(activity_id)
    respond_to_action('show_crm_activities') 
  end
 
  def create_activities
    doc = Hpricot::XML(request.raw_post)
    doc = doc.to_s.gsub("&amp;","&") 
    doc = Hpricot::XML(doc)    
    activities = Crm::CrmActivityCrud.create_activities(doc)  
    @activity =  activities.first if !activities.empty? 
    if @activity.errors.empty?
      respond_to_action('show_crm_activities') 
    else
      respond_to_errors(@activity.errors)
    end   
  end
end

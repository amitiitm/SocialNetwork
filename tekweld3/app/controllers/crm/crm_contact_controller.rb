class Crm::CrmContactController < ApplicationController
  require 'hpricot'
  include General
  include ClassMethods

  def list_contacts
    doc = Hpricot::XML(request.raw_post)
    doc = doc.to_s.gsub("&amp;","&") 
    doc = Hpricot::XML(doc)
    @contacts = Crm::CrmContactCrud.list_contacts(doc)
    render :xml=>'<encoded>'+Base64.encode64(Zlib::Deflate.deflate(@contacts[0].xmlcol))+'</encoded>'
  end
 
  def show_contacts
    doc = Hpricot::XML(request.raw_post)   
    contact_id = parse_xml(doc/'id') 
    @contact = Crm::CrmContactCrud.show_contacts(contact_id)
    respond_to_action('show_crm_contacts') 
  end
 
  def create_contacts
    doc = Hpricot::XML(request.raw_post)
    doc = doc.to_s.gsub("&amp;","&") 
    doc = Hpricot::XML(doc)    
    crm_contacts = Crm::CrmContactCrud.create_contacts(doc) 
    @contact =  crm_contacts.first if !crm_contacts.empty?
    if @contact.errors.empty?
      respond_to_action('show_crm_contacts') 
    else
      respond_to_errors(@contact.errors)
    end   
  end  
end

class Sale::CustomerContactController < ApplicationController
  require 'hpricot'
  include General
  include ClassMethods

  def list_contacts
    doc = Hpricot::XML(request.raw_post)
    doc = doc.to_s.gsub("&amp;","&") 
    doc = Hpricot::XML(doc)
    @contacts = Customer::CustomerContactCrud.list_contacts(doc)
    render :xml=>'<encoded>'+Base64.encode64(Zlib::Deflate.deflate(@contacts[0].xmlcol))+'</encoded>'
  end
 
  def show_contacts
    doc = Hpricot::XML(request.raw_post)   
    contact_id = parse_xml(doc/'id') 
    @contact = Customer::CustomerContactCrud.show_contacts(contact_id)
    render_view(@contact,'customer_contacts','L')
  end
 
  def create_contacts
    doc = Hpricot::XML(request.raw_post)
    doc = doc.to_s.gsub("&amp;","&") 
    doc = Hpricot::XML(doc)    
    @contacts = Customer::CustomerContactCrud.create_contacts(doc) 
    contact =  @contacts.first if !@contacts.empty?
    if contact.errors.empty?
      render_view(@contacts,'customer_contacts','L') 
    else
      respond_to_errors(contact.errors)
    end   
  end 
end

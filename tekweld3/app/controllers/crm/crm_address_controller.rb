class Crm::CrmAddressController < ApplicationController
  require 'hpricot'
  include General
  include ClassMethods
  
  def list_addresses
    doc = Hpricot::XML(request.raw_post)
    doc = doc.to_s.gsub("&amp;","&") 
    doc = Hpricot::XML(doc)    
    @addresses = Crm::CrmAddressCrud.list_addresses(doc)
    render :xml=>'<encoded>'+Base64.encode64(Zlib::Deflate.deflate(@addresses[0].xmlcol))+'</encoded>'
  end
 
  def show_addresses
    doc = Hpricot::XML(request.raw_post)   
    address_id = parse_xml(doc/'id') 
    @addresses = Crm::CrmAddressCrud.show_addresses(address_id)
    render_view( @addresses,'crm_addresses','L') 
  end
 
  def create_addresses
    doc = Hpricot::XML(request.raw_post)
    doc = doc.to_s.gsub("&amp;","&") 
    doc = Hpricot::XML(doc)    
    @addresses = Crm::CrmAddressCrud.create_addresses(doc)  
    address =  @addresses.first if !@addresses.empty?
    if address.errors.empty?
      render_view( @addresses,'crm_addresss','C')
    else
      respond_to_errors(address.errors)
    end   
  end
end

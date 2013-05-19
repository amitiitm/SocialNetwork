class Payment::PaymentProfileController < ApplicationController
  require 'hpricot'
  include General
  include ClassMethods

  def list_payment_profiles
    doc = Hpricot::XML(request.raw_post)
    doc = doc.to_s.gsub("&amp;","&")
    doc = Hpricot::XML(doc)
    @payment_profiles = Payment::PaymentProfileCrud.list_payment_profiles(doc)
    render :xml=>'<encoded>'+Base64.encode64(Zlib::Deflate.deflate(@payment_profiles[0].xmlcol))+'</encoded>'
  end

  def show_payment_profile
    doc = Hpricot::XML(request.raw_post)
    profile_id = parse_xml(doc/'id')
    @payment_profile = Payment::PaymentProfileCrud.show_payment_profile(profile_id)
    render_view(@payment_profile,'customer_payment_profiles','L')
  end

  def create_payment_profiles
    doc = Hpricot::XML(request.raw_post)
    doc = doc.to_s.gsub("&amp;","&")
    doc = Hpricot::XML(doc)
    @payment_profiles,@message = Payment::PaymentProfileCrud.create_payment_profiles(doc)
    if @payment_profiles[0]
      respond_to_action('show_payment_profile')
    else
      render :xml => "<errors><error>#{@message}</error></errors>"
    end
  end
end
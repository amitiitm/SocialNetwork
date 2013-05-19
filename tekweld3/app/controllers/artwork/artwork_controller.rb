class Artwork::ArtworkController < ApplicationController
  require 'hpricot'
  include General
  include ClassMethods
  
  ## Tekweld ArtWork services
  
  def hold_artwork
    doc = Hpricot::XML(request.raw_post)
    doc = doc.to_s.gsub("&amp;","&")
    doc = Hpricot::XML(doc)    
    message,text = Artwork::ArtworkCrud.hold_artwork(doc)
    if text == 'error'
      render :xml=>"<errors><error>#{message}</error></errors>"
    else
      render :text => "successfull"
    end
  end
  
  def list_unfinished_artwork_inbox
    doc = Hpricot::XML(request.raw_post)
    doc = doc.to_s.gsub("&amp;","&")
    doc = Hpricot::XML(doc)
    @orders = Artwork::ArtworkCrud.list_unfinished_artwork_inbox(doc)
    #    render :xml=>@orders[0].xmlcol
    render :xml=>'<encoded>'+Base64.encode64(Zlib::Deflate.deflate(@orders[0].xmlcol))+'</encoded>'
  end
  
  def list_finished_artwork_inbox
    doc = Hpricot::XML(request.raw_post)
    doc = doc.to_s.gsub("&amp;","&")
    doc = Hpricot::XML(doc)
    @orders = Artwork::ArtworkCrud.list_finished_artwork_inbox(doc)
    #    render :xml=>@orders[0].xmlcol
    render :xml=>'<encoded>'+Base64.encode64(Zlib::Deflate.deflate(@orders[0].xmlcol))+'</encoded>'
  end
  
  def upload_artwork_attachments
    schema_name = session[:schema]
    uploaded_file = params[:Filedata]
    text =  Artwork::ArtworkCrud.upload_artwork_attachments(uploaded_file,schema_name)
    if text == 'success'
      render :text=> "Attachment Upload Successfull"
    else
      render :text=> "Attachment Upload UnSuccessfull"
    end
  end

  def show_assigned_artwork
    doc = Hpricot::XML(request.raw_post)
    order_id  = parse_xml(doc/:params/'id')
    @orders = Artwork::ArtworkCrud.show_assigned_artwork(order_id)
    respond_to do |wants|
      wants.xml
    end
  end

  def create_artworks
    doc = Hpricot::XML(request.raw_post)
    doc = doc.to_s.gsub("&amp;","&")
    doc = Hpricot::XML(doc)
    @orders = Artwork::ArtworkCrud.create_artworks(doc,session[:schema])
    artwork =  @orders.first if !@orders.empty?
    if artwork.errors.empty?
      #    render_view( @orders,'orders','C')
      respond_to_action('show_assigned_artwork')
    else
      respond_to_errors(artwork.errors)
    end
  end
  
  def send_artwork_to_customer
    doc = Hpricot::XML(request.raw_post)
    doc = doc.to_s.gsub("&amp;","&")
    doc = Hpricot::XML(doc)
    text = Artwork::ArtworkCrud.send_artwork_to_customer(doc,session[:schema])
    if text == 'success'
      render :text=> "Artwork Sent Successfully"
    else
      render :text=> "Artwork Send Failed"
    end
  end

  ## TEKWELD ASSIGNED ARTWORKS AND ORDERS LIST SERVICES ONLY USER SPECIFIC DATA IS LISTED
  
  def list_assigned_artworks
    doc = Hpricot::XML(request.raw_post)
    doc = doc.to_s.gsub("&amp;","&")
    doc = Hpricot::XML(doc)
    @orders = Artwork::ArtworkCrud.list_assigned_artworks(doc)
    #    render :xml=>@orders[0].xmlcol
    render :xml=>'<encoded>'+Base64.encode64(Zlib::Deflate.deflate(@orders[0].xmlcol))+'</encoded>'
  end

  
  ## List Service for screen to show NOResponse for artwork 
  def list_noresponse_paperproof_records
    doc = Hpricot::XML(request.raw_post)
    doc = doc.to_s.gsub("&amp;","&")
    doc = Hpricot::XML(doc)
    @orders = Artwork::ArtworkCrud.list_noresponse_paperproof_records(doc)
    #    render :xml=>@orders[0].xmlcol
    render :xml=>'<encoded>'+Base64.encode64(Zlib::Deflate.deflate(@orders[0].xmlcol))+'</encoded>'
  end

  
  ## List Service for screen to Accept or Reject customer artwork response
  def list_accept_reject_paperproof_records
    doc = Hpricot::XML(request.raw_post)
    doc = doc.to_s.gsub("&amp;","&")
    doc = Hpricot::XML(doc)
    @orders = Artwork::ArtworkCrud.list_accept_reject_paperproof_records(doc)
    #    render :xml=>@orders[0].xmlcol
    render :xml=>'<encoded>'+Base64.encode64(Zlib::Deflate.deflate(@orders[0].xmlcol))+'</encoded>'
  end
  
  def show_accept_reject_paperproof_records
    doc = Hpricot::XML(request.raw_post)
    order_id  = parse_xml(doc/:params/'id')
    @orders = Artwork::ArtworkCrud.show_accept_reject_paperproof_records(order_id)
    respond_to do |wants|
      wants.xml   
    end
  end 
  
  def create_accept_reject_paperproof_records
    doc = Hpricot::XML(request.raw_post)
    doc = doc.to_s.gsub("&amp;","&")
    doc = Hpricot::XML(doc)
    @orders = Artwork::ArtworkCrud.create_accept_reject_paperproof_records(doc,session[:schema])
    artwork =  @orders.first if !@orders.empty?
    if artwork.errors.empty?
      respond_to_action('show_accept_reject_paperproof_records')
    else
      respond_to_errors(artwork.errors)
    end
  end

  ## services for list,show and send multiple artworks in single email
  def list_orders_tosend_multiple_artworks
    doc = Hpricot::XML(request.raw_post)
    doc = doc.to_s.gsub("&amp;","&")
    doc = Hpricot::XML(doc)
    @orders = Artwork::ArtworkCrud.list_orders_tosend_multiple_artworks(doc)
    #    render :xml=>@orders[0].xmlcol
    render :xml=>'<encoded>'+Base64.encode64(Zlib::Deflate.deflate(@orders[0].xmlcol))+'</encoded>'
  end

  def show_orders_tosend_multiple_artworks
    doc = Hpricot::XML(request.raw_post)
    order_id  = parse_xml(doc/:params/'id')
    @orders = Artwork::ArtworkCrud.show_orders_tosend_multiple_artworks(order_id)
    respond_to do |wants|
      wants.xml
    end
  end

  def send_multiple_artworks_to_customer
    doc = Hpricot::XML(request.raw_post)
    doc = doc.to_s.gsub("&amp;","&")
    doc = Hpricot::XML(doc)
    url_with_port = request.host_with_port
    message,@orders = Artwork::ArtworkCrud.send_multiple_artworks_to_customer(doc,session[:schema],url_with_port)
    if message == 'success'
      respond_to_action('show_orders_tosend_multiple_artworks')
    else
      render :xml => "<errors><error>#{message}</error></errors>"
    end
  end

  def waiting_for_artworks_inbox
    doc = Hpricot::XML(request.raw_post)
    doc = doc.to_s.gsub("&amp;","&")
    doc = Hpricot::XML(doc)
    @artworks = Artwork::ArtworkCrud.waiting_for_artworks_inbox(doc)
    render :xml=>'<encoded>'+Base64.encode64(Zlib::Deflate.deflate(@artworks[0].xmlcol))+'</encoded>'
  end
end

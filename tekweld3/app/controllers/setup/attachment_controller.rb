class Setup::AttachmentController < ApplicationController
  include General
  include ClassMethods
  require 'hpricot'
  
  def list_attachments
    doc = Hpricot::XML(request.raw_post)
    doc = doc.to_s.gsub("&amp;","&") 
    doc = Hpricot::XML(doc)
    @attachments =  Setup::AttachmentCrud.list_attachments(doc)
    respond_to do |format|
      format.xml
    end
  end

  def create_attachments
    doc = Hpricot::XML(request.parameters[:paramXml])
    schema_name = session[:schema]
    uploaded_file = params[:Filedata]
    @attachment =  Setup::AttachmentCrud.create_attachments(doc,uploaded_file,schema_name)
    if @attachment.errors.empty?
      render :text=> "Attachment successfully uploaded"
    else
      respond_to do |format|
        format.xml  { render :xml => @attachment.to_xml() } 
      end
    end
  end
end

class Setup::DocumentController < ApplicationController
  include General
  include ClassMethods 
  require 'hpricot'
  
  #def document_list
  def list_documents
    doc = Hpricot::XML(request.raw_post) 
    doc = doc.to_s.gsub("&amp;","&") 
    doc = Hpricot::XML(doc)  
    @documents = Admin::DocumentCrud.list_documents(doc)
    render_view(@documents,"documents","L")
  end  

  def show_document
    doc = Hpricot::XML(request.raw_post)
    id=parse_xml(doc/:params/:id)  
    @document = Admin::DocumentCrud.show_document(id)
    render_view(@document,"documents","L")
  end

  def create_documents
    doc = Hpricot::XML(request.raw_post) 
    doc = doc.to_s.gsub("&amp;","&") 
    doc = Hpricot::XML(doc)  
    @documents = Admin::DocumentCrud.create_documents(doc)
    documents =  @documents.first if !@documents.empty?
    if documents.errors.empty?
      render_view(@documents,"documents","C")
    else
      respond_to_errors(documents.errors)
    end 
  end
end

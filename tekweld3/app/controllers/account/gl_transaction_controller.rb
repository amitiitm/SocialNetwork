class Account::GlTransactionController < ApplicationController
  require 'hpricot'
  include General
  include ClassMethods
  
  def list_gl_transactions
    doc = Hpricot::XML(request.raw_post)
    doc = doc.to_s.gsub("&amp;","&") 
    doc = Hpricot::XML(doc)
    @journals = GeneralLedger::GlTransactionCrud.list_journals(doc)
    render :xml=>'<encoded>'+Base64.encode64(Zlib::Deflate.deflate(@journals[0].xmlcol))+'</encoded>'
  end

  def show_gl_transactions
    doc = Hpricot::XML(request.raw_post)   
    id  = parse_xml(doc/:params/'id')       if parse_xml(doc/:params/'id').first
    @journals  = GeneralLedger::GlTransactionCrud.show_journals(id)
    respond_to_action('show_gl_transactions')
  end

  def create_gl_transactions
    doc = Hpricot::XML(request.raw_post) 
    doc = doc.to_s.gsub("&amp;","&") 
    doc = Hpricot::XML(doc)  
    @journals = GeneralLedger::GlTransactionCrud.create_journals(doc)
    journal = @journals.first if !@journals.empty?
    if journal.errors.empty?
      respond_to_action('show_gl_transactions')
    else
      respond_to_errors(journal.errors)
    end
  end
end

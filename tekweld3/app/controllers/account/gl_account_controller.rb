class Account::GlAccountController < ApplicationController
  require 'hpricot'
  include General
  include ClassMethods
  
  def list_gl_accounts
    doc = Hpricot::XML(request.raw_post)
    doc = doc.to_s.gsub("&amp;","&") 
    doc = Hpricot::XML(doc)
    @gl_accounts = GeneralLedger::GlAccountCrud.list_gl_accounts(doc)
    render :xml=>'<encoded>'+Base64.encode64(Zlib::Deflate.deflate(@gl_accounts[0].xmlcol))+'</encoded>'
  end

  def show_gl_account
    doc = Hpricot::XML(request.raw_post)
    id  = parse_xml(doc/:params/'id')
    @gl_accounts = GeneralLedger::GlAccountCrud.show_gl_account(id)
    render_view(@gl_accounts,'gl_accounts','L')
  end  
  
  def create_gl_accounts
    doc = Hpricot::XML(request.raw_post)
    doc = doc.to_s.gsub("&amp;","&") 
    doc = Hpricot::XML(doc)
    @gl_accounts =GeneralLedger::GlAccountCrud.create_gl_accounts(doc)
    gl_account = @gl_accounts.first if !@gl_accounts.empty?
    if  gl_account.errors.empty?
      render_view(@gl_accounts,'gl_accounts','C')
    else
      respond_to_errors( gl_account.errors)
    end
  end
  
  def convert_exceltoxml_for_glaccounts
    uploaded_file = params[:Filedata]
    table_name = params[:table_name]
    @data_rows = IO::FileIO.data_of_excel(uploaded_file)
    @tag_level1 = table_name.pluralize
    @tag_level2 = table_name.singularize
    render :template => "account/gl_account/convert_exceltoxml_for_glaccounts"
  end
end

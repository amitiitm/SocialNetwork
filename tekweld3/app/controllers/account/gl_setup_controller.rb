class Account::GlSetupController < ApplicationController
  require 'hpricot'
  include General
  include ClassMethods
  
  def show_gl_setup
    @gl_setups = GeneralLedger::GlSetupCrud.show_gl_setup
    respond_to do |wants|
      wants.xml   
    end
  end  
 
  def create_gl_setups
    doc = Hpricot::XML(request.raw_post)
    doc = doc.to_s.gsub("&amp;","&") 
    doc = Hpricot::XML(doc)
    @gl_setups =GeneralLedger::GlSetupCrud.create_gl_setups(doc)
    gl_setup =  @gl_setups.first if !@gl_setups.empty?
    if gl_setup.errors.empty?
      respond_to_action('show_gl_setup')
    else
      respond_to_errors(gl_setup.errors)
    end
  end
end

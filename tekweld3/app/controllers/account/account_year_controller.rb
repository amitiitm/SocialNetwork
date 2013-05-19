class Account::AccountYearController < ApplicationController
  require 'hpricot'
  include General
  include ClassMethods
  def list_account_years
    doc = Hpricot::XML(request.raw_post)
    doc = doc.to_s.gsub("&amp;","&") 
    doc = Hpricot::XML(doc)
    @accounts = Account::AccountYearCrud.list_account_years(doc)
    render_view( @accounts,'account_years','L')
  end
 
  def show_account_year
    doc = Hpricot::XML(request.raw_post)  
    account_id = parse_xml(doc/'id') 
    @accounts = Account::AccountYearCrud.show_account_year(account_id)
    respond_to_action('show_account_year')
  end
 
  def create_account_years
    doc = Hpricot::XML(request.raw_post)
    doc = doc.to_s.gsub("&amp;","&") 
    doc = Hpricot::XML(doc)
    @accounts = Account::AccountYearCrud.create_account_years(doc)  
    account =  @accounts.first if !@accounts.empty?
    if account.errors.empty? 
      respond_to_action('show_account_year')
    else
      respond_to_errors(account.errors)
    end   
  end
end

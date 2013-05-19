class Account::AccountingController < ApplicationController
  require 'hpricot'
  include General
  include ClassMethods


  #  require 'barby/barcode/code_39'
  #  require 'barby/outputter/prawn_outputter'
  

  ## List Uncleared Accounts of customers in sales_order
  def list_uncleared_accounts_inbox
    doc = Hpricot::XML(request.raw_post)
    doc = doc.to_s.gsub("&amp;","&")
    doc = Hpricot::XML(doc)
    @accounts = Accounting::AccountingCrud.list_uncleared_accounts_inbox(doc)
    render :xml=>@accounts[0].xmlcol
  end
  
  
  def create_accounts_inboxes
    doc = Hpricot::XML(request.raw_post)
    doc = doc.to_s.gsub("&amp;","&")
    doc = Hpricot::XML(doc)
    @orders = Accounting::AccountingCrud.create_accounts_inboxes(doc)
    order =  @orders.first if !@orders.empty?
    if !order[0]
      render :text => 'Successfull'
    else
      render :xml=>"<errors><error>#{order[0]}</error></errors>"
    end
  end
end





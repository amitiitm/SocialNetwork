class Account::DepositController < ApplicationController
  require 'hpricot'
  include General
  include ClassMethods
  
  def list_deposits
    doc = Hpricot::XML(request.raw_post)
    doc = doc.to_s.gsub("&amp;","&") 
    doc = Hpricot::XML(doc)
    @bank_transactions = GeneralLedger::BankTransactionCrud.list_bank_transactions(doc,'DEPS')
    render :xml=>'<encoded>'+Base64.encode64(Zlib::Deflate.deflate(@bank_transactions[0].xmlcol))+'</encoded>'
  end

  def show_deposits
    doc = Hpricot::XML(request.raw_post)   
    id  = parse_xml(doc/:params/'id')
    @bank_transaction = GeneralLedger::BankTransactionCrud.show_bank_transactions(id,'DEPS')
    respond_to_action('show_bank_transactions')
  end

  def create_deposits
    #    doc = Hpricot::XML(request.raw_post)
    #    doc = doc.to_s.gsub("&amp;","&")
    #    doc = Hpricot::XML(doc)
    doc = EncodeDecode.decode(request.raw_post)
    @bank_transaction = GeneralLedger::BankTransactionCrud.create_bank_transactions(doc,'DEPS')
    bank_trans = @bank_transaction.first if !@bank_transaction.empty?
    if bank_trans.errors.empty?
      respond_to_action('show_bank_transactions')
    else
      respond_to_errors(bank_trans.errors)
    end
  end
end

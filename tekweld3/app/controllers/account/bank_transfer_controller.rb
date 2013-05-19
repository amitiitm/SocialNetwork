class Account::BankTransferController < ApplicationController
  require 'hpricot'
  include General
  include ClassMethods
  
  def list_bank_transfers
    doc = Hpricot::XML(request.raw_post)
    doc = doc.to_s.gsub("&amp;","&") 
    doc = Hpricot::XML(doc)
    @bank_transactions = GeneralLedger::BankTransactionCrud.list_bank_transfers(doc,'TRFR')
    render :xml=>'<encoded>'+Base64.encode64(Zlib::Deflate.deflate(@bank_transactions[0].xmlcol))+'</encoded>'
  end

  def show_bank_transfers
    doc = Hpricot::XML(request.raw_post)   
    id  = parse_xml(doc/:params/'id')
    @bank_transaction = GeneralLedger::BankTransactionCrud.show_bank_transactions(id,'TRFR')
    respond_to_action('show_bank_transactions')
  end

  def create_bank_transfers
    #    doc = Hpricot::XML(request.raw_post)
    #    doc = doc.to_s.gsub("&amp;","&")
    #    doc = Hpricot::XML(doc)
    doc = EncodeDecode.decode(request.raw_post)
    @bank_transaction = GeneralLedger::BankTransactionCrud.create_bank_transactions(doc,'TRFR')
    bank_transaction = @bank_transaction.first if !@bank_transaction.empty?
    if bank_transaction.errors.empty?
      respond_to_action('show_bank_transactions')
    else
      respond_to_errors(bank_transaction.errors)
    end
  end
end

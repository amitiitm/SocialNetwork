class Account::BankInfoController < ApplicationController
  require 'hpricot'
  include General
  include ClassMethods

  def bank_payment_info
    doc = Hpricot::XML(request.raw_post)
    doc = doc.to_s.gsub("&amp;","&") 
    doc = Hpricot::XML(doc)
    @bank_info = GeneralLedger::BankInfoCrud.bank_payment_info(doc)    
    render :xml=>'<encoded>'+Base64.encode64(Zlib::Deflate.deflate(@bank_info[0]['xmlcol']))+'</encoded>'
  end
  
  def bank_receipt_info
    doc = Hpricot::XML(request.raw_post)
    doc = doc.to_s.gsub("&amp;","&") 
    doc = Hpricot::XML(doc)   
    @bank_info = GeneralLedger::BankInfoCrud.bank_receipt_info(doc)  
    render :xml=>'<encoded>'+Base64.encode64(Zlib::Deflate.deflate(@bank_info[0]['xmlcol']))+'</encoded>'
  end
  
  def bank_transaction_info
    doc = Hpricot::XML(request.raw_post)
    doc = doc.to_s.gsub("&amp;","&") 
    doc = Hpricot::XML(doc)
    @bank_info = GeneralLedger::BankInfoCrud.bank_transaction_info(doc)       
    render :xml=>'<encoded>'+Base64.encode64(Zlib::Deflate.deflate(@bank_info[0]['xmlcol']))+'</encoded>'
  end
  
  def bank_balance_info
    doc = Hpricot::XML(request.raw_post)
    doc = doc.to_s.gsub("&amp;","&") 
    doc = Hpricot::XML(doc)   
    @bank_info = GeneralLedger::BankInfoCrud.bank_balance_info(doc) 
    render :xml=>'<encoded>'+Base64.encode64(Zlib::Deflate.deflate(@bank_info[0]['xmlcol']))+'</encoded>'
  end
  
  def bank_transfer_info
    doc = Hpricot::XML(request.raw_post)
    doc = doc.to_s.gsub("&amp;","&") 
    doc = Hpricot::XML(doc) 
    @bank_info = GeneralLedger::BankInfoCrud.bank_transfer_info(doc)  
    render :xml=>'<encoded>'+Base64.encode64(Zlib::Deflate.deflate(@bank_info[0]['xmlcol']))+'</encoded>'
  end

 
  
end

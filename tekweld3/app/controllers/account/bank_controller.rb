class Account::BankController < ApplicationController
  require 'hpricot'
  include General
  include ClassMethods
    
  def list_banks
    doc = Hpricot::XML(request.raw_post)
    doc = doc.to_s.gsub("&amp;","&") 
    doc = Hpricot::XML(doc)
    @banks = GeneralLedger::BankCrud.list_banks(doc)
    render :xml=>'<encoded>'+Base64.encode64(Zlib::Deflate.deflate(@banks[0].xmlcol))+'</encoded>'
  end

  def show_bank
    doc = Hpricot::XML(request.raw_post)
    id  = parse_xml(doc/:params/'id')
    @banks = GeneralLedger::BankCrud.show_bank(id)
    respond_to_action('list_banks')
  end  
  
  def create_banks
    #    doc = Hpricot::XML(request.raw_post)
    #    doc = doc.to_s.gsub("&amp;","&")
    #    doc = Hpricot::XML(doc)
    doc = EncodeDecode.decode(request.raw_post)
    @banks =GeneralLedger::BankCrud.create_banks(doc)
    bank = @banks.first if !@banks.empty?
    if bank.errors.empty?
      respond_to_action('list_banks')
    else
      respond_to_errors(bank.errors)
    end
  end
  
  def convert_exceltoxml_for_banks
    uploaded_file = params[:Filedata]
    table_name = params[:table_name]
    @data_rows = IO::FileIO.data_of_excel(uploaded_file)
    @tag_level1 = table_name.pluralize
    @tag_level2 = table_name.singularize
    render :template => "account/bank/convert_exceltoxml_for_banks"
  end
  
  def create_bank_check_bounces
    doc = EncodeDecode.decode(request.raw_post)
    @bank_check_bounce = GeneralLedger::BankBounceCheckCrud.create_bank_check_bounces(doc)
    bank_check_bounce = @bank_check_bounce.first if !@bank_check_bounce.empty?
    if bank_check_bounce.errors.empty?
      respond_to_action('show_bank_check_bounces')
    else
      respond_to_errors(bank_check_bounce.errors)
    end
  end
  
  def list_bank_check_bounces
    doc = Hpricot::XML(request.raw_post)
    doc = doc.to_s.gsub("&amp;","&") 
    doc = Hpricot::XML(doc)
    @bank_check_bounces = GeneralLedger::BankBounceCheckCrud.list_bank_bounce_checks(doc)
    render :xml=>'<encoded>'+Base64.encode64(Zlib::Deflate.deflate(@bank_check_bounces[0].xmlcol))+'</encoded>'
  end
  
  def show_bank_check_bounces
    doc = Hpricot::XML(request.raw_post)
    id  = parse_xml(doc/:params/'id')
    @bank_check_bounce = GeneralLedger::BankBounceCheckCrud.show_bank_bounce_checks(id)
    respond_to_action('show_bank_check_bounces')
  end  

  def fetch_bank_transaction_details
    doc = Hpricot::XML(request.raw_post)
    render :xml => EncodeDecode.encode(GeneralLedger::BankReconciliationCrud.fetch_bank_transaction_details(doc)[0].xmlcol)
  end

  def create_bank_reconciliations
    doc = EncodeDecode.decode(request.raw_post)
    bank_reconciliations = GeneralLedger::BankReconciliationCrud.create_bank_reconciliations(doc)
    if bank_reconciliations.first.errors.empty?
      render :xml => GeneralLedger::BankReconciliationCrud.show_bank_reconciliation(bank_reconciliations)
    else
      respond_to_errors(bank_reconciliations.first.errors)
    end
  end

  def show_bank_reconciliations
    doc = Hpricot::XML(request.raw_post)
    id  = parse_xml(doc/:params/'id')
    render :xml => GeneralLedger::BankReconciliationCrud.show_bank_reconciliation(id)
  end

  def list_bank_reconciliations
    doc = Hpricot::XML(request.raw_post)
    doc = doc.to_s.gsub("&amp;","&")
    doc = Hpricot::XML(doc)
    render :xml => EncodeDecode.encode(GeneralLedger::BankReconciliationCrud.list_bank_reconciliation(doc)[0].xmlcol)
  end
end

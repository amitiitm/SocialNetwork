class GeneralLedger::BankBounceCheckCrud
  include General



  def self.list_bank_bounce_checks(doc)
    criteria = Setup::Criteria.fill_criteria(doc/:criteria)
    bank_bounce_checks = GeneralLedger::BankBounceCheck.find_by_sql ["select CAST( (select(select 
                                                             id,trans_no,
                                                             trans_bk,
                                                             trans_date,
                                                             account_period_code,
                                                             bank_code,
                                                             ref_trans_no,
                                                             ref_trans_date,
                                                             ref_trans_bk , 
                                                             check_no,
                                                             check_date,
                                                             account_flag,
                                                             account_code
                                           
                                                                from bank_bounce_checks where
                                                                      (trans_no between ? and ? AND (0 =? or trans_no in (?) ) )
                                                                AND   (account_period_code between ? and ? AND (0 =? or account_period_code in (?) ) )
                                                                AND   (account_flag between ? and ? AND (0 =? or account_flag in (?) ) )
                                                                AND   (bank_code between ? and ? AND (0 =? or  bank_code in (?) ) )
                                                                AND   (check_no between ? and ? AND (0 =? or check_no in (?) ) )
                                                                AND   (account_code between ? and ? AND (0 =? or account_code in (?) ) )
                                                                AND   (ref_trans_type between ? and ? AND (0 =? or ref_trans_type in (?) ) )
                                                                AND   (ref_trans_no between ? and ? AND (0 =? or ref_trans_no in (?) ) )
                                                                AND   (trans_date between ? and ?  )

  FOR XML PATH('bank_bounce_check'),type,elements xsinil)FOR XML PATH('bank_bounce_checks')) AS xml) as xmlcol ",
      criteria.str1,criteria.str2,criteria.multiselect1.length,criteria.multiselect1,
      criteria.str3,criteria.str4,criteria.multiselect2.length,criteria.multiselect2,
      criteria.str5,criteria.str6,criteria.multiselect3.length,criteria.multiselect3,
      criteria.str7,criteria.str8,criteria.multiselect4.length,criteria.multiselect4,
      criteria.str9,criteria.str10,criteria.multiselect5.length,criteria.multiselect5,
      criteria.str11,criteria.str12,criteria.multiselect6.length,criteria.multiselect6,
      criteria.str13,criteria.str14,criteria.multiselect7.length,criteria.multiselect7,
      criteria.str15,criteria.str16,criteria.multiselect8.length,criteria.multiselect8,
      criteria.dt1,      criteria.dt2

    ]
    bank_bounce_checks
  end

  def self.list_unapplied_uncleared_bank_transactions(bank_id,check_no,trans_type,trans_no,find_flag)
    #    bank_trans_type = trans_type == 'D' ? 'DEPS': 'PAYM'
    if find_flag == 'T'
      bank_transactions = GeneralLedger::BankTransaction.find_by_sql ["select CAST( (select(SELECT
                                                                trans_bk,
                                                                trans_no,
                                                                trans_date,
                                                                check_date,
                                                                account_period_code,
                                                                account_id,
                                                                account_code,
                                                                account_flag,
                                                                bank_id,
                                                                bank_code,
                                                                debit_amt,credit_amt,
                                                                check_no
                                                                from bank_transactions
                                                                where serial_no = '000' and clear_flag = 'N' and trans_type = ? and
                                                                trans_no = ?
  FOR XML PATH('bank_transaction'),type,elements xsinil)FOR XML PATH('bank_transactions')) AS xml) as xmlcol ",trans_type,trans_no]
    else
      bank_transactions = GeneralLedger::BankTransaction.find_by_sql ["select CAST( (select(SELECT
                                                                trans_bk,
                                                                trans_no,
                                                                trans_date,
                                                                check_date,
                                                                account_period_code,
                                                                account_id,
                                                                account_code,
                                                                account_flag,
                                                                bank_id,
                                                                bank_code,
                                                                debit_amt,credit_amt,
                                                                check_no
                                                                from bank_transactions
                                                                where serial_no = '000' and clear_flag = 'N' and trans_type = ?
                                                                AND  bank_id = ? and check_no = ?
  FOR XML PATH('bank_transaction'),type,elements xsinil)FOR XML PATH('bank_transactions')) AS xml) as xmlcol ",trans_type,bank_id,check_no]
    end
    data_xml = Hpricot::XML(bank_transactions[0].xmlcol)
    void_bounce_info = ''
    trans_number = parse_xml(data_xml/:bank_transactions/:bank_transaction/'trans_no')
    trans_bk =  parse_xml(data_xml/:bank_transactions/:bank_transaction/'trans_bk')
    case trans_bk
    when 'RE01'
      customer_receipt = Customer::CustomerReceipt.find_by_trans_no_and_trans_bk(trans_number,trans_bk)
      if (customer_receipt and customer_receipt.applied_amt == 0.00)
        void_bounce_info =  bank_transactions[0].xmlcol
      end
    when 'PA01'
      vendor_payment = Vendor::VendorPayment.find_by_trans_no_and_trans_bk(trans_number,trans_bk)
      if (vendor_payment and vendor_payment.applied_amt == 0.00)
        void_bounce_info =  bank_transactions[0].xmlcol
      end
    end
    void_bounce_info
  end


  def self.show_bank_bounce_checks(bank_bounce_check_id)
    bank_bounce_checks = []
    bank_bounce_check = GeneralLedger::BankBounceCheck.active.find_by_id(bank_bounce_check_id)
    bank_bounce_checks << bank_bounce_check
    gl_lines = GeneralLedger::GlPosting.show_gl_postings(bank_bounce_check.trans_no,bank_bounce_check.company_id,bank_bounce_check.trans_bk) if bank_bounce_check
    bank_bounce_checks << gl_lines
    bank_charges_gl_lines = GeneralLedger::GlDetail.find_all_by_ref_no_and_company_id_and_ref_bk_and_ref_date(bank_bounce_checks[0].trans_no,bank_bounce_checks[0].company_id,bank_bounce_checks[0].trans_bk,bank_bounce_checks[0].trans_date)
    bank_bounce_checks << bank_charges_gl_lines    
    bank_bounce_checks
  end

  def self.create_bank_check_bounces(doc)
    bank_bounce_checks = []
    (doc/:bank_bounce_checks/:bank_bounce_check).each{|bank_doc|
      bank_bounce_check = create_bank_check_bounce(bank_doc)
      bank_bounce_checks <<  bank_bounce_check if bank_bounce_check
    }
    gl_lines = GeneralLedger::GlPosting.show_gl_postings(bank_bounce_checks[0].trans_no,bank_bounce_checks[0].company_id,bank_bounce_checks[0].trans_bk)
    bank_bounce_checks << gl_lines
    bank_charges_gl_lines = GeneralLedger::GlDetail.find_all_by_ref_no_and_company_id_and_ref_bk_and_ref_date(bank_bounce_checks[0].trans_no,bank_bounce_checks[0].company_id,bank_bounce_checks[0].trans_bk,bank_bounce_checks[0].trans_date)
    bank_bounce_checks << bank_charges_gl_lines
    bank_bounce_checks
  end

  def self.create_bank_check_bounce(doc)
    trans_bk =  parse_xml(doc/'ref_trans_bk')
    void_bounce_flag =  parse_xml(doc/'void_bounce_flag')
    #    bank_charge_amt =  parse_xml(doc/'bank_charges_amt') 
    bank_bounce_check = add_or_modify(doc)
    bank_bounce_check.generate_trans_no('FASHBC') if bank_bounce_check.new_record?
    return  if !bank_bounce_check
    return bank_bounce_check if !bank_bounce_check.errors.empty?
#    save_proc = Proc.new{
      bank_bounce_check.save!
      gl = Accounts::BankBounceCheckGlPosting::Posting.new
      account_posting = Accounts::BankBounceCheckAccountsPosting::Posting.new
      bank_transaction_postings = bank_bounce_check.create_bank_transaction_postings
      bank_bounce_check.post_bank_transactions(bank_transaction_postings) if bank_transaction_postings #create bank_transaction PAYM or DEPS depends on the trans_type
      case trans_bk
      when 'RE01'
        gl_postings = gl.create_gl_postings_for_deposit(bank_bounce_check)
        account_posting.post_customerinvoice(bank_bounce_check) #create an invoice against customer and make the payment
      when 'PA01'
        gl_postings = gl.create_gl_postings_for_payment(bank_bounce_check)
        account_posting.post_vendorinvoice(bank_bounce_check) #create an invoice against vendor and make the payment
      end
      if (void_bounce_flag == 'B' ) #for bounce only
        bank_charge_amt_posting(bank_bounce_check)#create bank payment of amount charged.
      end
      GeneralLedger::GlPosting.post_gl_transactions(gl_postings)   if gl_postings
      make_payment_deposit_clear(bank_bounce_check)
#    }
#    bank_bounce_check.save_transaction(&save_proc)
    return bank_bounce_check
  end

  def self.add_or_modify(doc)
    id =  parse_xml(doc/'id') if (doc/'id').first
    bank_bounce_check = GeneralLedger::BankBounceCheck.find_or_create(id)
    return if !bank_bounce_check
    bank_bounce_check.apply_attributes(doc)
    bank_bounce_check.fill_default_header_values
    return bank_bounce_check
  end
  
  def self.bank_charge_amt_posting(bank_bounce_check)
    bank_charge_postings = bank_bounce_check.create_bank_payment_postings
    bank_bounce_check.post_bank_transactions(bank_charge_postings) if bank_charge_postings
    gl_bank = Accounts::BankChargesGlPosting::Posting.new
    gl_postings_for_bank = gl_bank.create_gl_postings_for_bank_charges(bank_charge_postings[0],bank_bounce_check) if bank_charge_postings
    GeneralLedger::GlPosting.post_gl_transactions(gl_postings_for_bank)   if gl_postings_for_bank
  end
  
  def self.make_payment_deposit_clear(bank_bounce_check)
    payment_deposit_transactions = GeneralLedger::BankTransaction.find_all_by_trans_bk_and_trans_no_and_trans_date(bank_bounce_check.ref_trans_bk,bank_bounce_check.ref_trans_no,bank_bounce_check.ref_trans_date)
    payment_deposit_transactions.each{|transaction|
      transaction.update_attributes(:clear_date => bank_bounce_check.trans_date,:clear_flag => 'Y')
    }
  end



end

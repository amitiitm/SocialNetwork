class GeneralLedger::BankTransactionCrud < ActiveRecord::Base
  include General
  include Accounts::GenerateCheckNumber
  cattr_accessor :error_message, :trans_type 

  def self.list_bank_transactions(doc,trans_type)
    criteria = Setup::Criteria.fill_criteria_for_query(doc/:criteria)
    condition = "serial_no = '000' AND 
                        trans_type = '#{trans_type}' AND
                         ( bank_transactions.company_id = #{criteria.company_id}) AND
                        (trans_no between '#{criteria.str1}' and '#{criteria.str2}' AND (0 =#{criteria.multiselect1.length} or trans_no in ('#{criteria.multiselect1}'))) AND
                        nvl(trans_date,'1990-01-01 00:00:00') between '#{criteria.dt1}' and '#{criteria.dt2}' AND
                        (account_period_code between '#{criteria.str3}' and '#{criteria.str4}' AND (0 =#{criteria.multiselect2.length} or account_period_code in ('#{criteria.multiselect2}'))) AND
                        (account_flag between '#{criteria.str5[0,1]}' and '#{criteria.str6[0,1]}' AND (0 =#{criteria.multiselect3.length} or account_flag in ('#{criteria.multiselect3}'))) AND
                        (gl_accounts.code between '#{criteria.str7}' and '#{criteria.str8}' AND (0 = #{criteria.multiselect4.length} or gl_accounts.code in ('#{criteria.multiselect4}'))) AND
                        (check_no between '#{criteria.str9}' and '#{criteria.str10}' AND (0 = #{criteria.multiselect5.length} or check_no in ('#{criteria.multiselect5}')))
    " 
    condition = convert_sql_to_db_specific(condition)                         
    GeneralLedger::BankTransaction.find_by_sql ["select CAST( (select(select bank_transactions.id,bank_transactions.trans_bk,bank_transactions.trans_no,
                                          bank_transactions.trans_date,bank_transactions.account_period_code,bank_transactions.account_flag,
                                          bank_transactions.debit_amt,bank_transactions.credit_amt,bank_transactions.check_no,bank_transactions.check_date,
                                          gl_accounts.name as bank_name from bank_transactions
                                          inner join gl_accounts on gl_accounts.id = bank_transactions.bank_id where
                                          bank_transactions.trans_flag = 'A' AND bank_transactions.trans_bk <> 'VOCK' AND
                                          #{condition}
                                          FOR XML PATH('bank_transaction'),type,elements xsinil)FOR XML PATH('bank_transactions')) AS xml) as xmlcol ",
    ]    
  end
 
  def self.list_bank_transfers(doc,trans_type)
    criteria = Setup::Criteria.fill_criteria_for_query(doc/:criteria)
    condition = "serial_no = '000' AND 
                        trans_type = '#{trans_type}' AND
                        (bank_transactions.company_id=#{criteria.company_id}) AND
                        (trans_no between '#{criteria.str1}' and '#{criteria.str2}' AND (0 =#{criteria.multiselect1.length} or trans_no in ('#{criteria.multiselect1}'))) AND
                        nvl(trans_date,'1990-01-01 00:00:00') between '#{criteria.dt1}' and '#{criteria.dt2}' AND
                        (account_period_code between '#{criteria.str3}' and '#{criteria.str4}' AND (0 =#{criteria.multiselect2.length} or account_period_code in ('#{criteria.multiselect2.length}'))) AND
                        (check_no between '#{criteria.str5}' and '#{criteria.str6}' AND (0 = #{criteria.multiselect3.length} or check_no in ('#{criteria.multiselect3}'))) AND
                        (a.code between '#{criteria.str7}' and '#{criteria.str8}' AND (0 = #{criteria.multiselect4.length} or a.code in ('#{criteria.multiselect4}')))
    "
    condition = convert_sql_to_db_specific(condition)
    #  GeneralLedger::BankTransaction.active.find(:all,
    #       :joins => "inner join gl_accounts a on (bank_transactions.bank_id = a.id)
    #                  inner join gl_accounts b on (account_id = b.id)",
    #       :conditions => [condition ,trans_type,criteria.company_id,criteria.str1,criteria.str2,criteria.multiselect1.length,criteria.multiselect1,
    #                         criteria.dt1,criteria.dt2,
    #                          criteria.str3, criteria.str4, criteria.multiselect2.length,criteria.multiselect2,                                     
    #                         criteria.str5, criteria.str6,criteria.multiselect3.length,criteria.multiselect3,
    #                         criteria.str7, criteria.str8,criteria.multiselect4.length,criteria.multiselect4
    #                         ],
    #                         :select => "bank_transactions.*,a.name as bank_name, b.name as bank2_name" 
    #  )   
    GeneralLedger::BankTransaction.find_by_sql ["select CAST( (select(select bank_transactions.id,bank_transactions.trans_bk,bank_transactions.trans_no,
                                          bank_transactions.trans_date,bank_transactions.account_period_code,bank_transactions.account_flag,
                                          bank_transactions.debit_amt,bank_transactions.credit_amt,bank_transactions.check_no,bank_transactions.check_date,
                                          a.name as bank_name, b.name as bank2_name from bank_transactions
                                          inner join gl_accounts a on (bank_transactions.bank_id = a.id)
                                          inner join gl_accounts b on (account_id = b.id) where
                                          bank_transactions.trans_flag = 'A' AND
                                          #{condition}
                                          FOR XML PATH('bank_transaction'),type,elements xsinil)FOR XML PATH('bank_transactions')) AS xml) as xmlcol ",
      #      trans_type,criteria.company_id,criteria.str1,criteria.str2,criteria.multiselect1.length,criteria.multiselect1,
      #      criteria.dt1,criteria.dt2,
      #      criteria.str3, criteria.str4, criteria.multiselect2.length,criteria.multiselect2,
      #      criteria.str5, criteria.str6,criteria.multiselect3.length,criteria.multiselect3,
      #      criteria.str7, criteria.str8,criteria.multiselect4.length,criteria.multiselect4
    ]
  end
 
  def self.show_bank_transactions(id,trans_type)
    bank_transactions = []
    #  bank_lines =  GeneralLedger::BankTransaction.find_all_by_id(gl_id)
    #  bank_trans = bank_lines.first if !bank_lines.empty?
    bank_trans = GeneralLedger::BankTransaction.find_by_id(id)
    bank_trans ||= GeneralLedger::BankTransaction.new
    if !bank_trans.new_record?
      bank_trans.bank1_name = bank_trans.gl_account.name if bank_trans.gl_account
      if  bank_transfer?(trans_type)
        bank_trans.bank2_name, code = GeneralLedger::GlAccount.fetch_gl_account_code_and_name(bank_trans.account_id)
      end
      bank_transactions  << bank_trans 
      gl_lines = GeneralLedger::GlPosting.show_gl_postings(bank_trans.trans_no,bank_trans.company_id,bank_trans.trans_bk)
      bank_transactions << gl_lines
    end
    bank_transactions
  end

  #  def self.fetch_defaults_for_bank(trans_type,bank_id,trans_date)
  #    check_no,payment_type,check_no_flag = Accounts::GenerateCheckNumber.generate_check_no_for_bank(trans_type,bank_id) if bank_payments?(trans_type) 
  #    deposit_slip_no = Accounts::GenerateCheckNumber.generate_deposit_slip_no(trans_type,bank_id,trans_date) if bank_deposits?(trans_type)
  #    #  payment_type = generate_payment_type(bank_id)
  #    #    bank =  GeneralLedger::GlAccount.find(bank_id)
  #    #    bank_idd = bank_id
  #    #    bank_name = bank.name
  #    #    bank_code = bank.code
  #    #    return check_no,deposit_slip_no,payment_type,check_no_flag,bank_idd,bank_code,bank_name
  #    gl_account = GeneralLedger::GlAccount.find_by_sql ["select * from gl_accounts where trans_flag = 'A' and ( code like '#{'%'+bank_id.to_s+'%'}' or id like '#{'%'+bank_id.to_s+'%'}' )"]
  #    bank = gl_account[0] if gl_account[0]
  #    ########
  #    bank_idd = bank.id if bank
  #    bank_name = bank.name if bank
  #    bank_code = bank.code if bank
  #    return check_no,deposit_slip_no,payment_type,check_no_flag,bank_idd,bank_code,bank_name
  #  end

  def self.fetch_defaults_for_bank(trans_type,bank_id,trans_date)
    check_no,payment_type,check_no_flag = Accounts::GenerateCheckNumber.generate_check_no_for_bank(trans_type,bank_id) if bank_payments?(trans_type) 
    deposit_slip_no = Accounts::GenerateCheckNumber.generate_deposit_slip_no(trans_type,bank_id,trans_date) if bank_deposits?(trans_type)
    #  payment_type = generate_payment_type(bank_id)
    bank =  GeneralLedger::GlAccount.find(bank_id)
    #########
    #    gl_account = GeneralLedger::GlAccount.find_by_sql ["select * from gl_accounts where trans_flag = 'A' and ( code like ? or id like ? )", '%'+bank_id.to_s+'%','%'+bank_id.to_s+'%']
    #    bank = gl_account[0] if gl_account[0]
    ########
    bank_idd = bank.id if bank
    bank_name = bank.name if bank
    bank_code = bank.code if bank
    return check_no,deposit_slip_no,payment_type,check_no_flag,bank_idd,bank_code,bank_name
  end
  
  
  def self.fetch_defaults_for_bank_inbox(trans_type,bank_id,trans_date)
    check_no,payment_type,check_no_flag = Accounts::GenerateCheckNumber.generate_check_no_for_bank(trans_type,bank_id) if bank_payments?(trans_type) 
    deposit_slip_no = Accounts::GenerateCheckNumber.generate_deposit_slip_no(trans_type,bank_id,trans_date) if bank_deposits?(trans_type)
    #  payment_type = generate_payment_type(bank_id)
    #bank =  GeneralLedger::GlAccount.find(bank_id)
    #########
    gl_account = GeneralLedger::GlAccount.find_by_sql("select * from gl_accounts where trans_flag = 'A' and ( code like '%#{bank_id.to_s}%' or id like '%#{bank_id.to_s}%' )")
    bank = gl_account[0] if gl_account[0]
    ########
    bank_idd = bank.id if bank
    bank_name = bank.name if bank
    bank_code = bank.code if bank
    return check_no,deposit_slip_no,payment_type,check_no_flag,bank_idd,bank_code,bank_name
  end

  def self.fetch_max_check_no(bank_id)
    #  condition="bank_id = ? AND
    #                                   TRANSLATE(TRANSLATE(check_no, '0123456789, ', '0000000000 '), ' ', '0123456789') = ' ' AND
    #                                   check_no <> '' 
    #                                  "
    condition="bank_id = #{bank_id} AND
                                        check_no <> '' 
    "
    condition = convert_sql_to_db_specific(condition)                                 
    max_check_no = GeneralLedger::BankTransaction.maximum(:check_no,
      :conditions => [condition])
    check_no = (max_check_no.to_i + 1).to_s
    bank =  GeneralLedger::Bank.fetch_bank(bank_id)
    bank_idd = bank_id
    bank_name = bank.name
    bank_code = bank.code
    return check_no,'','','',bank_idd,bank_code,bank_name
  end

  def self.create_bank_transactions(doc,trans_type)
    bank_transactions = [] 
    self.trans_type = trans_type
    bank_doc = (doc/:bank_transactions/:bank_transaction).first
    bank_transaction = create_bank_transaction(bank_doc)
    if bank_transaction
      bank_transactions <<  bank_transaction
      gl_lines = GeneralLedger::GlPosting.show_gl_postings(bank_transaction.trans_no,bank_transaction.company_id,bank_transaction.trans_bk)
      bank_transactions << gl_lines if !gl_lines.empty?
    end
    bank_transactions
  end

  def self.create_bank_transaction(doc)
    bank_transaction = add_or_modify(doc) 
    return  if !bank_transaction  
    return bank_transaction  if !bank_transaction.errors.empty?
    bank_transaction.generate_trans_no if bank_transaction.new_record? 
    bank_transaction.bank_transaction_lines.applied_lines.each{|line|
      line.copy_header_fields_to_lines( bank_transaction.trans_no, bank_transaction.trans_bk, bank_transaction.trans_date, bank_transaction.company_id) #if line.new_record?
    }  
    bank_transaction.fill_customer_vendor
    bank_transacton_new_line = bank_transaction.generate_contra_entry
    #  gl_postings = []
    vendor_posting = bank_transaction.create_vendor_postings if bank_vendor_transaction?(bank_transaction.account_flag)
    customer_posting = bank_transaction.create_customer_postings if bank_customer_transaction?(bank_transaction.account_flag)
    gl_postings = bank_transaction.create_gl_postings 
  
    save_proc = Proc.new{
      bank_transaction.validate_bank_transactions   
      if bank_transaction.new_record?
        bank_transaction.save! 
        bank_transaction.update_trans_no 
      else
        bank_transaction.save!       
        bank_transaction.bank_transaction_lines.save_line if bank_transaction.bank_transaction_lines
      end  
      bank_transacton_new_line.save!
      #    bank_transaction.delete_customer_vendor_postings(self.trans_type)
      if vendor_posting 
        vendor_posting.save!
        vendor_posting.save_lines
      end  
      if customer_posting
        customer_posting.save!
        customer_posting.save_lines
      end
      GeneralLedger::GlPosting.post_gl_transactions(gl_postings) if gl_postings   
    }
    bank_transaction.save_transaction(&save_proc)
    return bank_transaction
  end
  
  def self.add_or_modify(doc)  
    id =  parse_xml(doc/'id') if (doc/'id').first  
    bank_transaction = GeneralLedger::BankTransaction.find_or_create(id) 
    return if !bank_transaction
    return bank_transaction if bank_transaction.view_only
    bank_transaction.apply_attributes(doc) 
    bank_transaction.fill_from_bank
    if  bank_transfer?(self.trans_type)
      bank_transaction.bank2_name, code = GeneralLedger::GlAccount.fetch_gl_account_code_and_name(bank_transaction.account_id)
    end
    bank_transaction.trans_type = self.trans_type
    bank_transaction.serial_no = '000'
    #  bank_transaction.account_flag = 'B' if self.trans_type = 'TRFR'
    bank_transaction.fill_trans_bk  
    bank_transaction.generate_docu_type
    #  if bank_transaction.new_record? 
    bank_transaction.fill_default_header_values      
    bank_transaction.max_serial_no = bank_transaction.bank_transaction_lines.active.maximum_serial_no if bank_transaction.bank_transaction_lines
    bank_transaction.build_lines(doc/:bank_transaction_lines/:bank_transaction_line) 
    return bank_transaction 
  end
end

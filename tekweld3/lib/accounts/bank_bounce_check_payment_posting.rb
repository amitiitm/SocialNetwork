module Accounts::BankBounceCheckPaymentPosting
  include General
  include ClassMethods

  def create_bank_payment_postings
    bank_postings = []
    debit_posting = fill_debit
    bank_postings << debit_posting
    credit_posting = fill_credit(debit_posting.trans_no)
    bank_postings << credit_posting
    bank_postings
  end 

  def fill_debit
    serial_no = '000'
    bank_posting = create_bank_transaction(serial_no,'')
    debit_amt,credit_amt = fill_bank_posting_for_customer(bank_posting) if self.account_flag == 'C'
    debit_amt,credit_amt = fill_bank_posting_for_vendor(bank_posting)   if self.account_flag == 'V'
  
    bank_posting.serial_no = serial_no
    bank_posting.account_id = ''#self.bank_charge_account_id  
    bank_posting.account_code = ''#self.bank_charge_account_code  
    bank_posting.bank_id = self.bank_id
    bank_posting.bank_code = self.bank_code
    bank_posting.debit_amt = debit_amt
    bank_posting.credit_amt = credit_amt
    bank_posting_line = bank_posting.bank_transaction_lines.build
    fill_bank_posting_line(bank_posting_line,bank_posting)
    bank_posting
  end
  
  def fill_credit(trans_no)
    serial_no = '101'
    bank_posting = create_bank_transaction(serial_no,trans_no)
    debit_amt,credit_amt = fill_bank_posting_for_customer(bank_posting)  if self.account_flag == 'C'
    debit_amt,credit_amt = fill_bank_posting_for_vendor(bank_posting)   if self.account_flag == 'V'
    bank_posting.serial_no = serial_no
    bank_posting.account_flag = 'B'
    bank_posting.account_id =  self.bank_id
    bank_posting.account_code =  self.bank_code
    bank_posting.bank_id = '' #self.bank_charge_account_id  
    bank_posting.bank_code = '' # self.bank_charge_account_code  
    bank_posting.debit_amt = credit_amt
    bank_posting.credit_amt = debit_amt
    bank_posting
  end
  
  def fill_bank_posting_line(bank_posting_line,bank_posting)
    GeneralLedger::BankTransactionLine.delete_all(['trans_bk = ? and trans_no = ? and trans_date = ? and serial_no = 101',bank_posting.trans_bk,bank_posting.trans_no,bank_posting.trans_date])
    bank_posting_line.trans_bk = bank_posting.trans_bk
    bank_posting_line.trans_no = bank_posting.trans_no
    bank_posting_line.trans_date = bank_posting.trans_date
    bank_posting_line.gl_account_id = self.bank_charge_account_id
    bank_posting_line.gl_account_code = self.bank_charge_account_code
    bank_posting_line.debit_amt = self.bank_charges_amt
    bank_posting_line.credit_amt = 0.00
    bank_posting_line.description = "Bank charges. Check # " + self.check_no
    bank_posting_line.serial_no = 101
  end


  def post_bank_transactions(bank_postings)
    bank_postings.each{|posting|
      posting.save!
    }
  end  
  
  def create_bank_transaction(serial_no,trans_no)
    bank_posting = GeneralLedger::BankTransaction.find_or_create_by_ref_no_and_serial_no(self.trans_bk + '-' + self.trans_no,serial_no)
    bank_posting.company_id = self.company_id
    bank_posting.docu_type = 'FAAPPA'
    bank_posting.trans_bk = 'PA01'
    bank_posting.generate_trans_no if (bank_posting.new_record?  and serial_no == '000')
    bank_posting.trans_no = trans_no  if serial_no == '101'
    bank_posting.trans_date = self.trans_date
    bank_posting.payto_name = 'Bank Charges'
    bank_posting.account_period_code = self.account_period_code
    bank_posting.ref_no = self.trans_bk + '-' + self.trans_no
    bank_posting.check_no =  ''
    bank_posting.check_date = self.trans_date 		
    bank_posting.clear_flag = 'N'
    bank_posting.post_flag = 'U'
    bank_posting.action_flag = 'O'
    bank_posting.trans_flag = self.trans_flag
    bank_posting.update_flag = 'V'
    bank_posting.remarks = "Bounce Check # " + self.check_no
    bank_posting.update_trans_no if ( bank_posting.new_record?  and serial_no == '000')
    bank_posting
  end

  def fill_bank_posting_for_customer(bank_posting)
    bank_posting.trans_type = PAYMENTS
    credit_amt = 0
    debit_amt = self.bank_charges_amt
    bank_posting.account_flag = 'G' 
    bank_posting.payment_type =  'CHCK'
    return debit_amt, credit_amt
  end

  def fill_bank_posting_for_vendor(bank_posting)
    bank_posting.trans_type = PAYMENTS
    debit_amt = self.bank_charges_amt
    credit_amt = 0
    bank_posting.account_flag = 'G' 
    bank_posting.payment_type =  'CHCK'
    return debit_amt, credit_amt
  end
end

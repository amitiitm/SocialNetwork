module Accounts::BankPosting
  include General
  include ClassMethods

  def create_bank_postings
    bank_postings = []
    bank_postings << fill_debit
    bank_postings << fill_credit
    bank_postings
  end 

  def fill_debit
    serial_no = '000'
    bank_posting = create_bank_transaction(serial_no)
    debit_amt,credit_amt = fill_bank_posting_for_customer(bank_posting) if customerreceipt?("#{self.class}")
    debit_amt,credit_amt = fill_bank_posting_for_vendor(bank_posting)   if vendorpayment?("#{self.class}")
  
    bank_posting.serial_no = serial_no
    bank_posting.account_id = self.customer_id  if customerreceipt?("#{self.class}")
    bank_posting.account_code = self.customer_code  if customerreceipt?("#{self.class}")
    bank_posting.account_id = self.vendor_id   if vendorpayment?("#{self.class}")
    bank_posting.account_code = self.vendor_code   if vendorpayment?("#{self.class}")
    bank_posting.bank_id = self.bank_id
    bank_posting.bank_code = self.bank_code
    bank_posting.debit_amt = debit_amt
    bank_posting.credit_amt = credit_amt
    bank_posting
  end
  
  def fill_credit
    serial_no = '101'
    bank_posting = create_bank_transaction(serial_no)
    debit_amt,credit_amt = fill_bank_posting_for_customer(bank_posting) if customerreceipt?("#{self.class}")
    debit_amt,credit_amt = fill_bank_posting_for_vendor(bank_posting)   if vendorpayment?("#{self.class}")
    bank_posting.serial_no = serial_no
    bank_posting.account_flag = 'B'
    bank_posting.account_id =  self.bank_id
    bank_posting.account_code =  self.bank_code
    bank_posting.bank_id = self.customer_id  if customerreceipt?("#{self.class}")
    bank_posting.bank_code = self.customer_code  if customerreceipt?("#{self.class}")
    bank_posting.bank_id = self.vendor_id   if vendorpayment?("#{self.class}")
    bank_posting.bank_code = self.vendor_code   if vendorpayment?("#{self.class}")
    bank_posting.debit_amt = credit_amt
    bank_posting.credit_amt = debit_amt
    bank_posting
  end


  def post_bank_transactions(bank_postings)
    #  bank_transaction = GeneralLedger::BankTransaction.find_by_trans_bk_no_date(self.trans_bk,self.trans_no,self.trans_date,self.company_id)
    #  bank_transaction.each{|li| li.destroy} 
    bank_postings.each{|posting|
      posting.save!
    }
  end  
  
  def  create_bank_transaction(serial_no)
    # Change: Praman July-04-2011 Making transaction date editable and post/unpost transaction accordingly.  
    #  bank_posting = GeneralLedger::BankTransaction.find_by_trans_bk_and_trans_no_and_trans_date_and_serial_no(self.trans_bk,self.trans_no,self.trans_date,serial_no)
    bank_posting = GeneralLedger::BankTransaction.find_by_trans_bk_and_trans_no_and_serial_no(self.trans_bk,self.trans_no,serial_no)
    bank_posting = GeneralLedger::BankTransaction.new if !bank_posting
    bank_posting.company_id = self.company_id
    bank_posting.trans_bk = self.trans_bk
    bank_posting.trans_no = self.trans_no
    bank_posting.trans_date = self.trans_date
    bank_posting.payto_name = self.name
    bank_posting.account_period_code = self.account_period_code
    bank_posting.ref_no = ' '
    bank_posting.remarks = self.description
    bank_posting.check_no = self.check_no
    bank_posting.check_date = self.check_date 		
    bank_posting.clear_flag = 'N'
    bank_posting.post_flag = 'U'
    bank_posting.action_flag = 'O'
    bank_posting.trans_flag = self.trans_flag
    bank_posting.update_flag = 'V'
    #  bank_posting.payment_type = self.payment_type
    #  bank_amount = self.check_amt
    bank_posting
  end

  def fill_bank_posting_for_customer(bank_posting)
    bank_posting.trans_type = DEPOSITS
    bank_posting.deposit_no = self.deposit_no
    debit_amt = 0
    credit_amt = self.check_amt
    bank_posting.account_flag = 'C' 
    bank_posting.payment_type = self.receipt_type
    return debit_amt, credit_amt
  end

  def fill_bank_posting_for_vendor(bank_posting)
    bank_posting.trans_type = PAYMENTS
    debit_amt = self.check_amt
    credit_amt = 0
    bank_posting.account_flag = 'V' 
    bank_posting.payment_type = self.payment_type
    return debit_amt, credit_amt
  end
end

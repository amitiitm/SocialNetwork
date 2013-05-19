module Accounts::BankBounceCheckBankPosting
  include General
  include ClassMethods

  def create_bank_transaction_postings
    bank_postings = []
    bank_postings << fill_debit_for_bank
    bank_postings << fill_credit_for_bank
    bank_postings
  end

  def fill_debit_for_bank
    serial_no = '000'
    bank_posting = create_bank_transaction_for_bank(serial_no)
    debit_amt,credit_amt = fill_bank_posting_for_customer_for_bank(bank_posting) if self.account_flag == 'C'
    debit_amt,credit_amt = fill_bank_posting_for_vendor_for_bank(bank_posting)   if self.account_flag == 'V'

    bank_posting.serial_no = serial_no
    bank_posting.account_id = self.account_id
    bank_posting.account_code = self.account_code
    bank_posting.bank_id = self.bank_id
    bank_posting.bank_code = self.bank_code
    bank_posting.debit_amt = debit_amt
    bank_posting.credit_amt = credit_amt
    bank_posting
  end

  def fill_credit_for_bank
    serial_no = '101'
    bank_posting = create_bank_transaction_for_bank(serial_no)
    debit_amt,credit_amt = fill_bank_posting_for_customer_for_bank(bank_posting) if self.account_flag == 'C'
    debit_amt,credit_amt = fill_bank_posting_for_vendor_for_bank(bank_posting)   if self.account_flag == 'V'
    bank_posting.serial_no = serial_no
    bank_posting.account_flag = 'B'
    bank_posting.account_id =  self.bank_id
    bank_posting.account_code =  self.bank_code
    bank_posting.bank_id = self.account_id
    bank_posting.bank_code = self.account_code
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

  def  create_bank_transaction_for_bank(serial_no)
    bank_posting = GeneralLedger::BankTransaction.find_by_trans_bk_and_trans_no_and_serial_no(self.trans_bk,self.trans_no,serial_no)
    bank_posting = GeneralLedger::BankTransaction.new if !bank_posting
    bank_posting.company_id = self.company_id
    bank_posting.trans_bk = self.trans_bk
    bank_posting.trans_no = self.trans_no
    bank_posting.trans_date = self.trans_date
    bank_posting.payto_name = 'check bounce'
    bank_posting.account_period_code = self.account_period_code
    bank_posting.ref_no = ' '
    bank_posting.remarks = "Bounce Check # " + self.check_no
    bank_posting.check_no = self.check_no
    bank_posting.check_date = self.check_date
    bank_posting.clear_flag = 'Y'
    bank_posting.clear_date = self.trans_date
    bank_posting.post_flag = 'U'
    bank_posting.action_flag = 'O'
    bank_posting.trans_flag = self.trans_flag
    bank_posting.update_flag = 'V'
    bank_posting
  end

  def fill_bank_posting_for_customer_for_bank(bank_posting)
    bank_posting.trans_type = PAYMENTS
    credit_amt = 0
    debit_amt = self.debit_amt
    bank_posting.account_flag = 'C'
    bank_posting.payment_type = 'CHCK'
    return debit_amt, credit_amt
  end

  def fill_bank_posting_for_vendor_for_bank(bank_posting)
    bank_posting.trans_type = DEPOSITS
    credit_amt = self.credit_amt
    debit_amt = 0
    bank_posting.account_flag = 'V'
    bank_posting.payment_type = 'CHCK'
    return debit_amt, credit_amt
  end
end

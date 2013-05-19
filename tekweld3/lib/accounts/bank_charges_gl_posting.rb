module Accounts::BankChargesGlPosting

  class Posting
    include General
    include ClassMethods

    def create_gl_postings_for_bank_charges(payment,bank_check_bounce)
      bank_id,bank_charge_account_id = fetch_gl_account(bank_check_bounce)
      gl_postings = []
      gl_postings << post_amt_for_bank(201, bank_id, bank_check_bounce,payment)# if nulltozero(bank_check_bounce.debit_amt) != 0
      gl_postings << post_amt_for_bank_charge(202, bank_charge_account_id, bank_check_bounce,payment) #if nulltozero(bank_check_bounce.debit_amt) != 0
      gl_postings
    end


    def fetch_gl_account(bank_check_bounce)
      bank_id = bank_check_bounce.bank_id
      bank_charge_account_id = bank_check_bounce.bank_charge_account_id
      return bank_id, bank_charge_account_id
    end


    def post_amt_for_bank(dtl_serial_no, bank_id, bank_check_bounce,payment)
      credit_amt = nulltozero(bank_check_bounce.bank_charges_amt)
      debit_amt = 0
      gl_posting = fill_gl_posting(bank_check_bounce,bank_id, dtl_serial_no, debit_amt, credit_amt,payment)
      gl_posting
    end

    def post_amt_for_bank_charge(dtl_serial_no, bank_charge_account_id, bank_check_bounce,payment)
      debit_amt = nulltozero(bank_check_bounce.bank_charges_amt)
      credit_amt = 0
      gl_posting = fill_gl_posting(bank_check_bounce,bank_charge_account_id, dtl_serial_no, debit_amt, credit_amt,payment)
      gl_posting
    end


    def fill_gl_posting(bank_check_bounce,gl_account_id, dtl_serial_no, debit_amt, credit_amt,payment)
      gl_posting = GeneralLedger::GlPosting.new
      fill_gl_posting_header_for_deposit(bank_check_bounce,gl_posting,payment) if bank_check_bounce.account_flag == 'C'
      fill_gl_posting_header_for_payment(bank_check_bounce,gl_posting,payment) if bank_check_bounce.account_flag == 'V'
      gl_posting.dtl_serial_no = dtl_serial_no
      gl_posting.gl_account_id = gl_account_id
      gl_posting.debit_amt = debit_amt
      gl_posting.credit_amt = credit_amt
      gl_posting.ref_no = bank_check_bounce.trans_no
      gl_posting.ref_bk = bank_check_bounce.trans_bk
      gl_posting.ref_date = bank_check_bounce.trans_date
      gl_posting
    end

    def fill_gl_posting_header_for_deposit(bank_check_bounce,gl_posting,payment)
      gl_posting.trans_bk = payment.trans_bk
      gl_posting.trans_no = payment.trans_no
      gl_posting.company_id = bank_check_bounce.company_id
      gl_posting.trans_date = bank_check_bounce.trans_date
      gl_posting.account_period_code = bank_check_bounce.account_period_code
      gl_posting.trans_type = 'I'
      gl_posting.description = ''
      gl_posting.post_flag = 'U'
      gl_posting.update_flag = 'V'
      gl_posting.customer_vendor_flag = 'C'
      gl_posting.customer_vendor_id = bank_check_bounce.account_id
      gl_posting.serial_no = 101
      gl_posting.module_code = 'FAXX'
    end

    def fill_gl_posting_header_for_payment(bank_check_bounce,gl_posting,payment)
      gl_posting.trans_bk = payment.trans_bk
      gl_posting.trans_no = payment.trans_no
      gl_posting.company_id = bank_check_bounce.company_id
      gl_posting.trans_date = bank_check_bounce.trans_date
      gl_posting.customer_vendor_id = bank_check_bounce.account_id
      gl_posting.account_period_code = bank_check_bounce.account_period_code
      gl_posting.trans_type = 'I'
      gl_posting.description = ''
      gl_posting.post_flag = 'U'
      gl_posting.update_flag = 'V'
      gl_posting.customer_vendor_flag = 'V'
      gl_posting.customer_vendor_id = bank_check_bounce.account_id
      gl_posting.serial_no = 101
      gl_posting.module_code =  'FAXX'
    end



    private :fetch_gl_account ,:fill_gl_posting_header_for_payment , :fill_gl_posting_header_for_deposit
  end
end

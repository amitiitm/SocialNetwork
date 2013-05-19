module Accounts::BankBounceCheckGlPosting
  
  class Posting
    include General
    include ClassMethods
    
    def create_gl_postings_for_deposit(object)
      ar_account_id, sales_account_id,bank_charge_account_id = fetch_gl_account_for_deposit(object)
      gl_postings = []
      dtl_serial_no = SALES_INVOICE_GL_SERIAL_NO
      gl_postings << post_amt_for_deposit_debit(dtl_serial_no, ar_account_id, object)# if nulltozero(object.debit_amt) != 0 
      gl_postings << post_amt_for_deposit_credit(1, sales_account_id, object) #if nulltozero(object.debit_amt) != 0 
      if  nulltozero(object.bank_charges_amt) != 0 and bank_charge_account_id
        dtl_serial_no += 1
        # gl_postings << post_bank_charge_amt_for_deposit(dtl_serial_no, bank_charge_account_id, object) 
      end
      gl_postings
    end
    
    def create_gl_postings_for_payment(object)
      ap_account_id, bank_account_id,bank_charge_account_id = fetch_gl_account_for_payment(object)
      gl_postings = []
      dtl_serial_no = PURCHASE_INVOICE_GL_SERIAL_NO
      gl_postings << post_amt_for_payment_credit(dtl_serial_no, ap_account_id, object) #if nulltozero(object.credit_amt) != 0 
      gl_postings << post_amt_for_payment_debit(1, bank_account_id, object)# if nulltozero(object.credit_amt) != 0 
      if  nulltozero(object.bank_charges_amt) != 0 and bank_charge_account_id
        dtl_serial_no += 1
        #    gl_postings << post_bank_charge_amt_for_payment(dtl_serial_no, bank_charge_account_id, object) 
      end
      gl_postings
    end

    def fetch_gl_account_for_deposit(object)
      glsetup = GeneralLedger::GlSetup.find(:first)
      ar_account_id = glsetup.ar_account_id
      sales_account_id = object.bank_id
      bank_charge_account_id = glsetup.default_sales_account_id 
      return ar_account_id,sales_account_id, bank_charge_account_id
    end
    
    def fetch_gl_account_for_payment(object)
      glsetup = GeneralLedger::GlSetup.find(:first)
      #      vendor_id = object.account_id
      #      vendor = Vendor::Vendor.find_by_id(vendor_id)
      bank_account_id = object.bank_id
      ap_account_id = glsetup.ap_account_id
      bank_charge_account_id = glsetup.default_purchase_account_id 
      return ap_account_id, bank_account_id,bank_charge_account_id
    end

    def post_amt_for_deposit_debit(dtl_serial_no, ar_account_id, object)
      debit_amt = nulltozero(object.debit_amt)
      credit_amt = 0
      gl_posting = fill_gl_posting(object,ar_account_id, dtl_serial_no, debit_amt, credit_amt)
      gl_posting
    end
    
    def post_amt_for_deposit_credit(dtl_serial_no, sales_account_id, object)
      credit_amt = nulltozero(object.debit_amt)
      debit_amt = 0
      gl_posting = fill_gl_posting(object,sales_account_id, dtl_serial_no, debit_amt, credit_amt)
      gl_posting
    end
    
    def post_amt_for_payment_credit(dtl_serial_no, ap_account_id, object)
      credit_amt = nulltozero(object.credit_amt)
      debit_amt = 0
      gl_posting = fill_gl_posting(object,ap_account_id, dtl_serial_no, debit_amt, credit_amt)
      gl_posting
    end
    
    def post_amt_for_payment_debit(dtl_serial_no, bank_account_id, object)
      debit_amt = nulltozero(object.credit_amt)
      credit_amt = 0
      gl_posting = fill_gl_posting(object,bank_account_id, dtl_serial_no, debit_amt, credit_amt)
      gl_posting
    end

    def post_bank_charge_amt_for_deposit(dtl_serial_no, bank_charge_account_id, object)
      credit_amt = object.bank_charges_amt
      debit_amt = 0
      gl_posting = fill_gl_posting(object,bank_charge_account_id, dtl_serial_no, debit_amt, credit_amt)	
      gl_posting
    end
    
    def post_bank_charge_amt_for_payment(dtl_serial_no, bank_charge_account_id, object)
      debit_amt = object.bank_charges_amt
      credit_amt = 0
      gl_posting = fill_gl_posting(object,bank_charge_account_id, dtl_serial_no, debit_amt, credit_amt)	
      gl_posting
    end

    def fill_gl_posting(object,gl_account_id, dtl_serial_no, debit_amt, credit_amt)
      gl_posting = GeneralLedger::GlPosting.new
      fill_gl_posting_header_for_deposit(object,gl_posting)      
      gl_posting.dtl_serial_no = dtl_serial_no
      gl_posting.gl_account_id = gl_account_id
      gl_posting.debit_amt = debit_amt
      gl_posting.credit_amt = credit_amt
      gl_posting
    end 

    def fill_gl_posting_header_for_deposit(object,gl_posting)
      gl_posting.trans_bk = object.trans_bk
      gl_posting.trans_no = object.trans_no
      gl_posting.company_id = object.company_id
      gl_posting.trans_date = object.trans_date
      gl_posting.account_period_code = object.account_period_code
      gl_posting.trans_type = 'I'
      gl_posting.description = ''
      gl_posting.post_flag = 'U'
      gl_posting.update_flag = 'V'
      gl_posting.customer_vendor_flag = 'C'
      gl_posting.customer_vendor_id = object.account_id
      gl_posting.serial_no = SALES_INVOICE_GL_SERIAL_NO
      gl_posting.module_code = SALES_INVOICE_MODULE_CODE
    end
    
    def fill_gl_posting_header_for_payment(object,gl_posting)
      gl_posting.trans_bk = object.trans_bk
      gl_posting.trans_no = object.trans_no
      gl_posting.company_id = object.company_id
      gl_posting.trans_date = object.trans_date
      gl_posting.customer_vendor_id = object.account_id
      gl_posting.account_period_code = object.account_period_code
      gl_posting.trans_type = 'I'
      gl_posting.description = ''
      gl_posting.post_flag = 'U'
      gl_posting.update_flag = 'V'
      gl_posting.customer_vendor_flag = 'V'
      gl_posting.customer_vendor_id = object.account_id
      gl_posting.serial_no = PURCHASE_INVOICE_GL_SERIAL_NO
      gl_posting.module_code = PURCHASE_INVOICE_MODULE_CODE
    end

  

    private :fetch_gl_account_for_deposit, :post_amt_for_deposit_debit, :post_bank_charge_amt_for_deposit,:fill_gl_posting,
      :fill_gl_posting_header_for_deposit,:fill_gl_posting_header_for_payment,:fetch_gl_account_for_payment, :post_amt_for_payment_debit, 
      :post_bank_charge_amt_for_payment,:post_amt_for_payment_credit,:post_amt_for_deposit_credit
  end  
end  

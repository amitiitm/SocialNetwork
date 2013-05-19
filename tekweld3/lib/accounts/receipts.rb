module Accounts::Receipts
  include General
  include ClassMethods

  def fill_default_detail_values
    self.detail_lines.each{|line|
      line.apply_flag ||= 'N'
      line.original_amt ||= 0
      line.apply_amt ||= 0
      line.balance_amt ||= 0
      line.disctaken_amt ||= 0
    }
  end

  def generate_trans_no
    self.trans_no = Setup::Sequence.generate_docu_no(self.trans_bk,self.docu_type,self.class,self.company_id)
  end
 
  def update_trans_no
    Setup::Sequence.upd_book_code(self.trans_bk,self.docu_type,self.trans_no,self.company_id)
  end
  def duplicate_bank_trans_no?
    # Change: Praman July-04-2011 Making transaction date editable and post/unpost transaction accordingly.
    #  GeneralLedger::BankTransaction.find_by_trans_bk_no_date(self.trans_bk,self.trans_no,self.trans_date,self.company_id).empty?  ? false : true
    GeneralLedger::BankTransaction.find_all_by_trans_bk_and_trans_no(self.trans_bk,self.trans_no).empty?  ? false : true
  end

 
  def fill_header(trans_type)
    if receipts?(trans_type)
      self.trans_bk = 'RE01'
      self.trans_type = 'P'
      self.docu_type = 'FAARPA'
    end
    if credit_invoice?(trans_type)
      self.trans_bk = 'CM01'
      self.trans_type = 'C'
      self.docu_type = 'FAARCM' if  customerreceipt?("#{self.class}")
      self.docu_type = 'FAAPCM' if  vendorpayment?("#{self.class}")
    end
    if payments?(trans_type)
      self.trans_bk = 'PA01'
      self.trans_type = 'P'
      self.docu_type = 'FAAPPA'
    end
    fill_default_header_values
  end

  def fill_default_header_values
    self.action_flag ||= 'O'
    self.post_flag ||= 'U'
    self.trans_date ||= Time.now
    self.check_date ||= Time.now
    if customerreceipt?("#{self.class}")
      self.soldto_id ||= parent_id
      self.parent_id ||= parent_id
    end
    self.check_amt ||= 0
    self.applied_amt ||= 0
    self.balance_amt ||= 0
    #self.received_amt ||= 0
    self.item_qty ||= 0
    self.trans_flag ||= 'A'
  end

  def parent_id
    #  customer = self.customer
    if (customer = self.customer)
      return customer.billto_id || customer.id
    end
  end

  def validate_receipt_amounts
    #  update_receipt_amount
    #  total_apply_amt = nulltozero(self.sum_of_apply_amt)
    if customerreceipt?("#{self.class}")
      receipts = self.class.find(:all,:conditions =>
          ["check_no = ? and
                                                    trans_no != ? and
                                                    trans_date != ? and
                                                    trans_bk != ? and
                                                    trans_flag = 'A'
          ",self.check_no,self.trans_no,self.trans_date,self.trans_bk ])
      #    raise_error( self.check_no + " check # is duplicate..") if (self.class.find_by_check_no(self.check_no) and !self.check_no.empty? and self.receipt_type == 'CHCK')
      raise_error( self.check_no + " check # is duplicate..") if !receipts.empty?
    end
    if  vendorpayment?("#{self.class}")
      payments =  self.class.find(:all,:conditions =>
          ["check_no = ? and
                                                    payment_type = ? and
                                                    trans_no <> ? and
                                                    trans_date <> ? and
                                                    trans_bk <> ? and
                                                    trans_flag = 'A'
          ",self.check_no,self.payment_type,self.trans_no,self.trans_date,self.trans_bk ])
      raise_error( self.check_no + " check # is duplicate..") if !payments.empty?
      #     raise_error( self.check_no + " check # is duplicate..") if (self.class.find_by_check_no_and_payment_type(self.check_no,self.payment_type) and !self.check_no.empty? )
    end
    if self.new_record?
      raise_error( 'Cannot add .. ' + self.trans_no + " is duplicate in bank transactions..")  if duplicate_bank_trans_no?
    end
    applied_amt =  nulltozero(self.applied_amt)
    received_amt = self.check_amt
    self.detail_lines.applied_lines.each{|recpt_line|
      recpt_line.validate_balance_amt
    }   
    raise_error( "Apply Amt cannot be greater than Received Amt") if applied_amt > received_amt
    total_disctaken_amt =   nulltozero(self.sum_of_disctaken_amt)
    raise_error("apply amt and disc amt have to be zero") if self.trans_flag != 'A' && (applied_amt != 0 || total_disctaken_amt != 0)
  end

  def calculate_balance_for_header
    voucher_no = voucher_no_from_trans_no_bk(self.trans_bk,self.trans_no)
    voucher_date = self.trans_date
    received_amt = self.check_amt
    if  customerreceipt?("#{self.class}")
      previous_applied_amt = (nulltozero(Customer::CustomerReceiptLine.sum(:apply_amt, :conditions=>["voucher_no = ? and voucher_date = ? and trans_flag = 'A'", voucher_no,voucher_date])))*-1
    end
    if vendorpayment?("#{self.class}")
      previous_applied_amt = (nulltozero(Vendor::VendorPaymentLine.sum(:apply_amt, :conditions=>["voucher_no = ? and voucher_date = ? and trans_flag = 'A'", voucher_no,voucher_date])))*-1
    end
    new_applied_amt = nulltozero(self.nulltozero(self.sum_of_apply_amt))
    new_applied_amt += previous_applied_amt
    balance_amt = nulltozero(received_amt) - nulltozero(new_applied_amt)
    self.applied_amt =  new_applied_amt
    self.balance_amt = balance_amt
    self.action_flag = (balance_amt!=0) ? 'O' : 'C'
  end

  def sum_of_apply_amt
    return detail_lines.applied_lines.inject(0){|sum,x| sum += x.apply_amt} if detail_lines
  end

  def sum_of_disctaken_amt
    return detail_lines.inject(0){|sum,x| sum += x.disctaken_amt} if detail_lines
  end

  def check_if_invoice_date_range_closed
    trans_from_date = Setup::Type.fetch_value_from_types('FAGL','trans_from_date')
    trans_to_date = Setup::Type.fetch_value_from_types('FAGL','trans_to_date')
    # trans_from_date = trans_from_date ? trans_from_date.to_time : Time.now
    #trans_to_date = trans_to_date ? trans_to_date.to_time : Time.now
    trans_from_date = trans_from_date ? (trans_from_date.is_a?(ActiveSupport::TimeWithZone) ? trans_from_date.time.strftime('%Y/%m/%d')  : trans_from_date.to_time) : Time.now
    trans_to_date = trans_to_date ? (trans_to_date.is_a?(ActiveSupport::TimeWithZone) ? trans_to_date.time.strftime('%Y/%m/%d')  : trans_to_date.to_time) : Time.now
    self.detail_lines.each{|line|
      line.period_close_flag = ((line.voucher_date < trans_from_date or line.voucher_date > trans_to_date) and nulltozero(line.apply_amt) != 0) ? 'Y':'N'
    }
  end

  def create_gl_postings_for_receipts
    gl_postings = []
    gl_account_id, discount_account_id = customer_gl_account    if customerreceipt?("#{self.class}")
    gl_account_id, discount_account_id = vendor_gl_account      if  vendorpayment?("#{self.class}")
    fill_gl_postings_for_header(gl_account_id).each{|posting| gl_postings << posting}
    fill_gl_postings_for_discount_lines(gl_account_id).each{|posting| gl_postings << posting}
    fill_gl_postings_for_total_discount(gl_account_id,discount_account_id).each{|posting| gl_postings << posting}
    gl_postings
  end

  def fill_gl_postings_for_header(gl_account_id)
    header_postings = []
    gl_posting = create_gl_posting
    gl_account = gl_account_id
    debit_amt = 0
    credit_amt = self.check_amt
    fill_gl_posting_detail(gl_posting,debit_amt,credit_amt,CUSTOMER_RECEIPT_DTL_GL_SERIAL_NO,gl_account)
    header_postings << gl_posting
   
    gl_posting = create_gl_posting
    gl_account = self.bank_id
    serial_no = CUSTOMER_RECEIPT_DTL_GL_SERIAL_NO.to_i + 1
    fill_gl_posting_detail(gl_posting,credit_amt,debit_amt,serial_no,gl_account)
    header_postings << gl_posting

    header_postings
  end

  def fill_gl_postings_for_discount_lines(gl_account_id)
    discount_postings = []
    dtl_debit_serial_no = CUSTOMER_RECEIPT_DTL_DEBIT_SERIAL_NO.to_i
    dtl_credit_serial_no = CUSTOMER_RECEIPT_DTL_CREDIT_SERIAL_NO.to_i
    lines_to_apply = applied_lines_with_discount_and_gl
    lines_to_apply.each{|recpt_line|
      gl_posting = create_gl_posting
      gl_account = gl_account_id
      debit_amt = 0
      credit_amt = recpt_line.disctaken_amt
      fill_gl_posting_detail(gl_posting,debit_amt,credit_amt,dtl_debit_serial_no,gl_account)
      dtl_debit_serial_no += 1
      discount_postings << gl_posting
     
      gl_posting = create_gl_posting
      gl_account = recpt_line.gl_account_id
      fill_gl_posting_detail(gl_posting,credit_amt,debit_amt,dtl_credit_serial_no,gl_account)
      dtl_credit_serial_no += 1
      discount_postings << gl_posting
    }
    discount_postings
  end

  def fill_gl_postings_for_total_discount(gl_account_id,discount_account_id)
    total_discount_postings = []
    dtl_discount_serial_no = CUSTOMER_RECEIPT_DTL_DISCOUNT_SERIAL_NO.to_i
    tot_discount_amt = discount_amt_without_gl
    #    self.detail_lines.to_ary.find_all{ |li| li.apply_flag == 'Y' and nulltozero(li.disctaken_amt != 0) and !li.gl_account_id}.inject(0){|sum,x| sum += x.disctaken_amt if x.apply_flag == 'Y' and !x.gl_account_id}
    if nulltozero(tot_discount_amt) != 0 then
      gl_posting = create_gl_posting
      gl_account = gl_account_id
      fill_gl_posting_detail(gl_posting,0,tot_discount_amt,dtl_discount_serial_no,gl_account)
      dtl_discount_serial_no += 1
      total_discount_postings  << gl_posting
    
      gl_posting = create_gl_posting
      gl_account = discount_account_id
      fill_gl_posting_detail(gl_posting,tot_discount_amt,0,dtl_discount_serial_no,gl_account)
      total_discount_postings  << gl_posting
    end
  
    total_discount_postings
  end
 
  def create_gl_posting
    gl_posting = GeneralLedger::GlPosting.new
    gl_posting.company_id = self.company_id
    gl_posting.trans_bk = self.trans_bk
    gl_posting.trans_no = self.trans_no
    gl_posting.trans_date = self.trans_date
    gl_posting.ref_no = self.check_no
    gl_posting.ref_date = self.check_date
    gl_posting.account_period_code = self.account_period_code
    gl_posting.trans_type = 'I'
    gl_posting.description = self.description
    gl_posting.post_flag = 'U'
    gl_posting.update_flag = 'V'
    gl_posting.customer_vendor_id = self.customer_id  if customerreceipt?("#{self.class}")
    gl_posting.customer_vendor_id = self.vendor_id  if vendorpayment?("#{self.class}")
    gl_posting.customer_vendor_flag = 'C'  if customerreceipt?("#{self.class}")
    gl_posting.customer_vendor_flag = 'V' if vendorpayment?("#{self.class}")
    gl_posting.serial_no =CUSTOMER_RECEIPT_GL_SERIAL_NO
    gl_posting.module_code = CUSTOMER_RECEIPT_MODULE_CODE
    gl_posting
  end

  def fill_gl_posting_detail(gl_posting,debit_amt,credit_amt,dtl_serial_no,gl_account)
    if customerreceipt?("#{self.class}")
      gl_posting.debit_amt = debit_amt
      gl_posting.credit_amt = credit_amt
    end
    if  vendorpayment?("#{self.class}")
      gl_posting.debit_amt = credit_amt
      gl_posting.credit_amt = debit_amt
    end
    gl_posting.dtl_serial_no = dtl_serial_no
    gl_posting.gl_account_id = gl_account
  end

  def discount_amt_without_gl
    return  self.detail_lines.to_ary.find_all{|li| li.trans_flag=='A' and nulltozero(li.disctaken_amt)!= 0 and !li.gl_account_id}.inject(0){|sum,x| sum += x.disctaken_amt }
  end

  def applied_lines_with_discount_and_gl
    return self.detail_lines.to_ary.find_all{|li| li.trans_flag == 'A' and nulltozero(li.disctaken_amt)!= 0 and li.gl_account_id}
  end

end




module Accounts::BankTransactionLib
  include General
  include ClassMethods

  def fill_trans_bk
    self.trans_bk = 'PA01'  if bank_payments?(self.trans_type)
    self.trans_bk = 'RE01'   if bank_deposits?(self.trans_type)  
    self.trans_bk  = 'BT01' if bank_transfer?(self.trans_type)
  end

  def generate_docu_type
    self.docu_type = 'FAAPPA' if self.trans_bk == 'PA01'
    self.docu_type = 'FAARPA' if self.trans_bk == 'RE01'
    self.docu_type = 'FASHTR' if self.trans_bk == 'BT01' 
    #  docu_type
  end
  
  def generate_trans_no 
    #  docu_type = generate_docu_type
    self.trans_no = Setup::Sequence.generate_docu_no(self.trans_bk,self.docu_type,self.class,self.company_id)
  end
 
  def update_trans_no
    #  docu_type = generate_docu_type
    Setup::Sequence.upd_book_code(self.trans_bk,self.docu_type,self.trans_no,self.company_id)  
  end 

  def validate_bank_transactions
    if bank_deposits?(self.trans_type)
      deposits = GeneralLedger::BankTransaction.find(:all,:conditions => 
          ["account_id = ? and
                                                    trans_date = ? and
                                                    trans_type = ? and
                                                    check_no =? and 
                                                    trans_no <> ? and
                                                    trans_bk <> ?    ",self.bank_id,self.trans_date,self.trans_type,self.check_no,self.trans_no,
          self.trans_bk      ])
                                                    
      raise_error("Duplicate check...") if !deposits.empty?
    end
    if bank_payments?(self.trans_type) 
      payments = GeneralLedger::BankTransaction.find(:first,:conditions => ["trans_bk = ? AND
                                                                    check_no = ? AND
                                                                    trans_no <> ?",
          self.trans_bk,self.check_no,self.trans_no])  
                                                  
      #      _by_trans_bk_and_check_no(self.trans_bk,self.check_no)
      raise_error("Duplicate check for this Bank...") if payments
    end
  
    raise_error("Debit and Credit entries should be 0...") if self.trans_flag != 'A' and (self.debit_amt !=0 or self.credit_amt != 0 )	  
    raise_error("Check # Required") if (self.check_no.empty? and self.bank_account_flag != 'C')
    raise_error("From and To Bank cannot be same") if (bank_transfer?(self.trans_type) and self.account_id == self.bank_id)
    if !bank_transaction_lines.applied_lines.empty?
      raise_error("Debits and Credits should be equal ") if ((sum_of_debit_amt + sum_of_credit_amt) != (self.credit_amt + self.debit_amt))
    end
  end

  def fill_from_bank
    gl_account = GeneralLedger::GlAccount.find_by_id(bank_id) 
    bank = gl_account.bank if gl_account
    self.bank_account_flag = bank.account_type if bank
    self.bank1_name = bank.name if bank
  end

  def fill_customer_vendor
    if bank_customer_transaction?(self.account_flag)
      customer = Customer::Customer.find_first_by_condition("id = ?",self.account_id)
      self.salesperson_code = (customer.salesperson_code || 'NA') 
      self.parent_id = customer.billto_id
      self.parent_code = customer.billto_code
      #newly added 4 Jan 2011
      glsetup = GeneralLedger::GlSetup.find(:first)
      self.glaccount_id= glsetup.ar_account_id
      #    customer_category = customer.customer_category
      #    self.glaccount_id = customer_category.gl_accounts_receivable_id if customer_category
    else 
      if bank_vendor_transaction?(self.account_flag)
        vendor = Vendor::Vendor.find_first_by_condition("id = ?",self.account_id)
        self.salesperson_code = (vendor.purchaseperson_code || 'NA')
        #newly added by Minal 4 Jan 2011        
        glsetup = GeneralLedger::GlSetup.find(:first)
        self.glaccount_id= glsetup.ap_account_id
        #      vendor_category = vendor.vendor_category
        #      self.glaccount_id = vendor_category.gl_account_payable_id if vendor_category
      else
        self.glaccount_id = self.account_id
      end
    end
  end

  def generate_contra_entry
    contra_entry_hd = self.new_record? ? GeneralLedger::BankTransaction.new :  find_contra_entry
    #  contra_entry_hd.attributes.each_pair{ |col_name,col_value|
    #    contra_entry_hd[col_name] = self[col_name] if col_name != 'lock_version'
    #  }
    contra_entry_hd.company_id  = self.company_id
    contra_entry_hd.trans_bk  = self.trans_bk
    contra_entry_hd.trans_no  = self.trans_no
    contra_entry_hd.trans_date  = self.trans_date
    contra_entry_hd.check_date = self.check_date
    contra_entry_hd.clear_date = self.clear_date
    contra_entry_hd.account_period_code = self.account_period_code
    contra_entry_hd.post_flag  = self.post_flag 
    contra_entry_hd.clear_flag = self.clear_flag
    contra_entry_hd.action_flag = self.action_flag
    contra_entry_hd.trans_type = self.trans_type
    contra_entry_hd.payment_type = self.payment_type
    contra_entry_hd.deposit_no = self.deposit_no
    contra_entry_hd.check_no  = self.check_no
    contra_entry_hd.remarks  = self.remarks
    contra_entry_hd.ref_no = self.ref_no
    contra_entry_hd.payto_name  = self.payto_name
    contra_entry_hd.comments  = self.comments
    contra_entry_hd.account_id = self.bank_id
    contra_entry_hd.bank_id = self.account_id
    contra_entry_hd.account_code = self.bank_code
    contra_entry_hd.bank_code = self.account_code
    contra_entry_hd.credit_amt = self.debit_amt
    contra_entry_hd.debit_amt = self.credit_amt
    contra_entry_hd.account_flag = 'B'
    contra_entry_hd.serial_no = '101'
    contra_entry_hd
  end

  def find_contra_entry
    # Change: Praman July-04-2011 Making transaction date editable and post/unpost transaction accordingly.  
    #    line = GeneralLedger::BankTransaction.contra_entry.find_by_trans_bk_no_date(self.trans_bk,self.trans_no,self.trans_date,self.company_id)
    line = GeneralLedger::BankTransaction.contra_entry.find_all_by_trans_bk_and_trans_no(self.trans_bk,self.trans_no)
    line.empty? ? nil : line.first 
  end

  def create_vendor_postings
    vendor_postings = create_vendor_postings_for_payments if bank_payments?(self.trans_type)
    vendor_postings = create_vendor_postings_for_deposits if bank_deposits?(self.trans_type) 
    vendor_postings
  end

  def create_vendor_postings_for_payments 
    # Change: Praman July-04-2011 Making transaction date editable and post/unpost transaction accordingly.  
    #    payments = Vendor::VendorPayment.find_by_trans_bk_no_date(self.trans_bk,self.trans_no,self.trans_date,self.company_id)
    payments = Vendor::VendorPayment.find_all_by_trans_bk_and_trans_no(self.trans_bk,self.trans_no)
    payment = payments.first if !payments.empty?
    payment = Vendor::VendorPayment.new if !payment 
    payment.trans_no = self.trans_no
    payment.trans_bk = self.trans_bk
    payment.trans_date = self.trans_date
    payment.company_id = self.company_id 
    payment.account_period_code = self.account_period_code
    payment.post_flag = 'U'
    payment.trans_type = 'P'
    payment.payment_type = self.payment_type
    payment.vendor_id = self.account_id
    payment.vendor_code = self.account_code
    payment.bank_id = self.bank_id
    payment.bank_code = self.bank_code
    payment.term_code = 'NA'
    payment.paid_amt = self.debit_amt
    payment.applied_amt = 0
    payment.balance_amt = self.debit_amt
    payment.check_no = self.check_no
    payment.check_date = self.check_date
    payment.description = self.remarks
    payment.purchaseperson_code = self.salesperson_code
    payment.action_flag = 'O'
    payment.update_flag = 'Y'
    payment
  end

  def create_vendor_postings_for_deposits
    # Change: Praman July-04-2011 Making transaction date editable and post/unpost transaction accordingly.  
    #    vendor_invoices = Vendor::VendorInvoice.find_by_trans_bk_no_date(self.trans_bk,self.trans_no,self.trans_date,self.company_id)
    vendor_invoices = Vendor::VendorInvoice.find_all_by_trans_bk_and_trans_no(self.trans_bk,self.trans_no)
    invoice_hd = vendor_invoices.first if !vendor_invoices.empty?
    invoice_hd = Vendor::VendorInvoice.new if !invoice_hd
    invoice_hd.trans_no = self.trans_no
    invoice_hd.trans_bk = self.trans_bk
    invoice_hd.trans_date = self.trans_date
    invoice_hd.company_id = self.company_id 
    invoice_hd.account_period_code = self.account_period_code
    invoice_hd.post_flag = 'U'
    invoice_hd.trans_type = 'I'
    invoice_hd.vendor_id = self.account_id
    invoice_hd.vendor_code = self.account_code
    invoice_hd.inv_amt = self.credit_amt
    invoice_hd.due_date = self.trans_date
    invoice_hd.term_code = 'NA'
    invoice_hd.discount_per = 0
    invoice_hd.discount_amt = 0
    invoice_hd.discount_date = self.trans_date
    invoice_hd.paid_amt = 0
    invoice_hd.disctaken_amt = 0 
    invoice_hd.balance_amt = self.credit_amt
    invoice_hd.description = self.remarks
    invoice_hd.update_flag = 'V'
    invoice_hd.action_flag = 'O'
    invoice_hd.inv_type = 'I'
    invoice_hd.clear_flag = 'N'
    invoice_hd.clear_amt = 0
    invoice_hd.inv_no = self.trans_bk + self.trans_no
    invoice_hd.inv_date = self.trans_date
  
    if invoice_hd.new_record?
      invoice_dtl = Vendor::VendorInvoiceLine.new 
      invoice_hd.vendor_invoice_lines << invoice_dtl
    else
      invoice_dtl = invoice_hd.vendor_invoice_lines.first if invoice_hd.vendor_invoice_lines
    end
    invoice_dtl.trans_bk = self.trans_bk
    invoice_dtl.trans_no = self.trans_no
    invoice_dtl.trans_date = self.trans_date
    invoice_dtl.serial_no = '101'
    invoice_dtl.gl_account_id = self.bank_id
    invoice_dtl.gl_amt = self.credit_amt
    invoice_dtl.description =  self.remarks
    invoice_dtl.company_id = self.company_id 
    invoice_dtl.update_flag = 'V'
  
    #  invoice_hd.vendor_invoice_lines << invoice_dtl
    invoice_hd
			
  end

  def create_customer_postings
    #  customer = find_first_by_condition("id = ?",self.account_id)
    #  salesperson_code = (customer.salesperson_code || 'NA')
    #  parent_id = customer.billto_id
    customer_postings = create_customer_postings_for_payments if bank_payments?(self.trans_type)
    customer_postings = create_customer_postings_for_deposits if bank_deposits?(self.trans_type) 
    customer_postings
  end

  def create_customer_postings_for_payments
    # Change: Praman July-04-2011 Making transaction date editable and post/unpost transaction accordingly.  
    #    customer_invoices = Customer::CustomerInvoice.find_by_trans_bk_no_date(self.trans_bk,self.trans_no,self.trans_date,self.company_id)
    customer_invoices = Customer::CustomerInvoice.find_all_by_trans_bk_and_trans_no(self.trans_bk,self.trans_no)
    invoice_hd = customer_invoices.first if !customer_invoices.empty?
    invoice_hd = Customer::CustomerInvoice.new if !invoice_hd
    invoice_hd.trans_no = self.trans_no
    invoice_hd.trans_bk = self.trans_bk
    invoice_hd.trans_date = self.trans_date
    invoice_hd.company_id = self.company_id 
    invoice_hd.account_period_code = self.account_period_code
    invoice_hd.post_flag = 'U'
    invoice_hd.trans_type = 'I'
    invoice_hd.customer_id = self.account_id
    invoice_hd.customer_code = self.account_code
    invoice_hd.inv_amt = self.debit_amt
    invoice_hd.due_date = self.trans_date
    invoice_hd.term_code = 'NA'
    invoice_hd.discount_per = 0
    invoice_hd.discount_amt = 0
    invoice_hd.discount_date = self.trans_date
    invoice_hd.paid_amt = 0
    invoice_hd.disctaken_amt = 0 
    invoice_hd.balance_amt = self.debit_amt
    invoice_hd.description = self.remarks
    invoice_hd.update_flag = 'V'
    invoice_hd.action_flag = 'O'
    invoice_hd.inv_type = 'I'
    invoice_hd.clear_flag = 'N'
    invoice_hd.clear_amt = 0
    invoice_hd.inv_no = self.trans_bk + self.trans_no
    invoice_hd.inv_date = self.trans_date
    invoice_hd.salesperson_code = self.salesperson_code
    invoice_hd.parent_id = self.parent_id
    invoice_hd.parent_code = self.parent_code
  
    if invoice_hd.new_record?
      invoice_dtl = Customer::CustomerInvoiceLine.new 
      invoice_hd.customer_invoice_lines << invoice_dtl
    else
      invoice_dtl = invoice_hd.customer_invoice_lines.first if invoice_hd.customer_invoice_lines
    end
    #  invoice_dtl = Customer::CustomerInvoiceLine.new 
    invoice_dtl.trans_bk = self.trans_bk
    invoice_dtl.trans_no = self.trans_no
    invoice_dtl.trans_date = self.trans_date
    invoice_dtl.serial_no = '101'
    invoice_dtl.gl_account_id = self.bank_id
    invoice_dtl.gl_amt = self.debit_amt
    invoice_dtl.description =  self.remarks
    invoice_dtl.company_id = self.company_id 
    invoice_dtl.update_flag = 'V'
    sales_account_id = GeneralLedger::GlSetup.find(:first,
      :select=>'faar_invoice_gl_account_id').faar_invoice_gl_account_id
    #  gl_account = GeneralLedger::GlAccount.find_by_code(sales_account_code) if sales_account_code
    gl_account = GeneralLedger::GlAccount.find_by_id(sales_account_id) if sales_account_id
    if gl_account
      invoice_dtl.gl_account_id = gl_account.id
      invoice_dtl.gl_account_code = gl_account.code
      invoice_dtl.gl_account_name = gl_account.name
    end
  
    #  invoice_hd.customer_invoice_lines << invoice_dtl
    invoice_hd
  end

  def create_customer_postings_for_deposits
    # Change: Praman July-04-2011 Making transaction date editable and post/unpost transaction accordingly.  
    #    customer_receipts = Customer::CustomerReceipt.find_by_trans_bk_no_date(self.trans_bk,self.trans_no,self.trans_date,self.company_id)
    customer_receipts = Customer::CustomerReceipt.find_all_by_trans_bk_and_trans_no(self.trans_bk,self.trans_no)
    receipt = customer_receipts.first if !customer_receipts.empty?
    receipt = Customer::CustomerReceipt.new  if !receipt
    receipt.trans_no = self.trans_no
    receipt.trans_bk = self.trans_bk
    receipt.trans_date = self.trans_date
    receipt.company_id = self.company_id 
    receipt.account_period_code = self.account_period_code
    receipt.post_flag = 'U'
    receipt.trans_type = 'P'
    receipt.receipt_type = self.payment_type
    receipt.customer_id = self.account_id
    receipt.customer_code = self.account_code
    receipt.bank_id = self.bank_id
    receipt.bank_code = self.bank_code
    receipt.term_code = 'NA'
    receipt.received_amt = self.credit_amt
    receipt.applied_amt = 0
    receipt.balance_amt = self.credit_amt
    receipt.check_no = self.check_no
    receipt.check_date = self.check_date
    receipt.description = self.remarks
    receipt.update_flag = 'Y'
    receipt.action_flag = 'O'
    receipt.deposit_no = self.deposit_no
    receipt.salesperson_code = self.salesperson_code
    receipt.parent_id = self.parent_id
    receipt.parent_code = self.parent_code
    receipt

  end

  def delete_customer_vendor_postings(trans_type)
    if bank_payments?(trans_type)
      # Change: Praman July-04-2011 Making transaction date editable and post/unpost transaction accordingly.  
      #      vendor_payments = Vendor::VendorPayment.find_by_trans_bk_no_date(self.trans_bk,self.trans_no,self.trans_date,self.company_id)
      vendor_payments = Vendor::VendorPayment.find_all_by_trans_bk_and_trans_no(self.trans_bk,self.trans_no)
      vendor_payments.each{|li|  li.destroy}
      # Change: Praman July-04-2011 Making transaction date editable and post/unpost transaction accordingly.  
      #      customer_invoices = Customer::CustomerInvoice.find_by_trans_bk_no_date(self.trans_bk,self.trans_no,self.trans_date,self.company_id)
      customer_invoices = Customer::CustomerInvoice.find_all_by_trans_bk_and_trans_no(self.trans_bk,self.trans_no)
      customer_invoices.each{|li|  li.destroy}
    end
    if bank_deposits?(trans_type)
      # Change: Praman July-04-2011 Making transaction date editable and post/unpost transaction accordingly.  
      #      customer_receipts = Customer::CustomerReceipt.find_by_trans_bk_no_date(self.trans_bk,self.trans_no,self.trans_date,self.company_id)
      customer_receipts = Customer::CustomerReceipt.find_all_by_trans_bk_and_trans_no(self.trans_bk,self.trans_no)
      customer_receipts.each{|li|  li.destroy}
      #    vendor_invoices = Vendor::VendorInvoice.find_by_trans_bk_no_date(self.trans_bk,self.trans_no,self.trans_date,self.company_id)
      #    vendor_invoices = Vendor::VendorInvoice.find_all_by_trans_bk_and_trans_no(self.trans_bk,self.trans_no)
      #    vendor_invoices.each{|li|  li.destroy}
    end	
  end

  #def create_gl_postings 
  #  gl_postings = []
  #  fill_gl_postings_for_header.each{|posting| gl_postings << posting}
  #  fill_gl_postings_for_lines.each{|posting| gl_postings << posting} 
  #  
  #  gl_postings
  #end

  def  create_gl_postings 
    gl_postings = []
    if bank_gl_transaction?(self.account_flag)
      gl_postings = fill_gl_debit_posting_for_gl_account
    else
      gl_postings << fill_gl_debit_posting_for_customer_vendor_transfer
    end 
    gl_postings << fill_gl_credit_posting
    gl_postings
  end

  def fill_gl_debit_posting_for_gl_account
    line_postings = []
    serial_no = 202
    self.bank_transaction_lines.applied_lines.each{|line|
      gl_posting = create_new_gl_posting
      gl_posting.debit_amt = line.debit_amt
      gl_posting.credit_amt = line.credit_amt
      gl_posting.gl_account_id = line.gl_account_id
      gl_posting.description ||= line.description
      gl_posting.dtl_serial_no = serial_no
      serial_no = serial_no + 1
      line_postings << gl_posting
    }
    line_postings
  end

  def  fill_gl_debit_posting_for_customer_vendor_transfer
    gl_posting = create_new_gl_posting
    gl_posting.debit_amt = self.debit_amt
    gl_posting.credit_amt = self.credit_amt
    gl_posting.gl_account_id = self.glaccount_id
    gl_posting.dtl_serial_no = '202'
    gl_posting
  end

  def fill_gl_credit_posting
    gl_posting = create_new_gl_posting
    gl_posting.debit_amt = self.credit_amt
    gl_posting.credit_amt = self.debit_amt
    gl_posting.gl_account_id = self.bank_id
    gl_posting.dtl_serial_no = '201'
    gl_posting
  end

  def create_new_gl_posting
    gl_posting = GeneralLedger::GlPosting.new
    gl_posting.company_id = self.company_id
    gl_posting.trans_bk = self.trans_bk
    gl_posting.trans_no = self.trans_no
    gl_posting.trans_date = self.trans_date
    gl_posting.ref_no = self.check_no
    gl_posting.ref_date = self.check_date
    gl_posting.account_period_code = self.account_period_code
    gl_posting.trans_type = self.trans_type
    gl_posting.description = self.remarks
    gl_posting.post_flag = 'U'
    gl_posting.update_flag = 'V'
    gl_posting.customer_vendor_id = self.account_id
    gl_posting.customer_vendor_flag = 'C' if self.account_flag == 'C'
    gl_posting.customer_vendor_flag = 'V' if self.account_flag == 'V'
    gl_posting.serial_no = BANK_GL_SERIAL_NO 
    gl_posting.module_code = CUSTOMER_RECEIPT_MODULE_CODE
    gl_posting
  end

  def sum_of_debit_amt
    return bank_transaction_lines.applied_lines.inject(0){|sum,x| sum += x.debit_amt} if bank_transaction_lines
  end

  def sum_of_credit_amt
    return bank_transaction_lines.applied_lines.inject(0){|sum,x| sum += x.credit_amt} if bank_transaction_lines
  end

end

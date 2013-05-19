module Accounts::Invoice
  include General
  include ClassMethods

  def validate_vendor_invoice
    if !self.inv_no.empty? 
      invoices = Vendor::VendorInvoice.find(:all,:conditions => 
          ["trans_no != ? and
                                                    trans_date != ? and
                                                    trans_bk != ? and  
                                                    inv_no = ? and
                                                    vendor_id =?",self.trans_no,self.trans_date,self.trans_bk,self.inv_no,self.vendor_id ])
      raise_error('Duplicate Invoice # for this vendor') if !invoices.empty?
    end
  end

  def fill_docu_type 
    self.docu_type = 'FAARIN' if customerinvoice?("#{self.class}")
    self.docu_type = 'FAAPIN' if vendorinvoice?("#{self.class}")
  end
 
  def fill_header
    fill_default_header
    self.paid_amt ||= 0
    self.discount_amt ||= 0
    self.disctaken_amt ||= 0
  end
  
  def fill_default_header 
    self.trans_bk = 'IN02' if vendorinvoice?("#{self.class}")
    self.trans_bk = 'IN01' if customerinvoice?("#{self.class}")
    self.trans_type ||= 'I'
    self.action_flag ||= 'O'
    self.post_flag ||= 'U'
    self.trans_date ||= Time.now
    self.sale_date ||= Time.now
    self.inv_date ||= Time.now
    self.balance_amt = self.inv_amt
  end
    
  def generate_trans_no
    self.trans_no = Setup::Sequence.generate_docu_no(self.trans_bk,self.docu_type ,self.class,self.company_id) 
  end

  def update_trans_no
    Setup::Sequence.upd_book_code(self.trans_bk,self.docu_type,self.trans_no,self.company_id)  
  end 

  def apply_address(doc)
    self.name = parse_xml(doc/'name') if (doc/'name').first
    self.city = parse_xml(doc/'city') if (doc/'city').first
    self.state = parse_xml(doc/'state') if (doc/'state').first
    self.zip = parse_xml(doc/'zip') if (doc/'zip').first
    self.phone1  = parse_xml(doc/'phone1') if (doc/'phone1').first
    self.contact1 = parse_xml(doc/'contact1') if (doc/'contact1').first
  end

  
  def create_gl_postings_for_invoice
    #  customer_gl_account_id, discount_account_id = customer_gl_account
    #  gl_postings = []
    gl_postings = fill_postings_for_customer_invoice_lines if customerinvoice?("#{self.class}")
    gl_postings = fill_postings_for_vendor_invoice_lines if vendorinvoice?("#{self.class}")
    gl_postings << fill_postings_for_invoice_header if gl_postings
    gl_postings
  end

  def fill_postings_for_invoice_header
    gl_posting = generate_new_posting
    if customerinvoice?("#{self.class}")
      gl_account_id, discount_account_id = customer_gl_account 
      gl_posting.debit_amt = self.inv_amt
      gl_posting.credit_amt = 0
    end
    if vendorinvoice?("#{self.class}")
      gl_account_id,discount_account_id = vendor_gl_account  
      gl_posting.debit_amt = 0
      gl_posting.credit_amt = self.inv_amt
    end
    gl_posting.dtl_serial_no = INVOICE_DTL_GL_SERIAL_NO
    #  gl_posting.description = ''
    gl_posting.gl_account_id = gl_account_id
    gl_posting
  end

  def fill_postings_for_customer_invoice_lines
    gl_dtl_posting = []
    dtl_serial_no = MAX_SERIAL_NO.to_i
    self.customer_invoice_lines.applied_lines.each{|inv_line|
      #    gl_posting = GeneralLedger::GlPosting.new
      gl_posting = generate_new_posting
      gl_posting.debit_amt = 0
      gl_posting.credit_amt = inv_line.gl_amt
      gl_posting.dtl_serial_no = dtl_serial_no += 1
      gl_posting.description = inv_line.description
      gl_posting.gl_account_id = inv_line.gl_account_id
      gl_dtl_posting << gl_posting
    }
    gl_dtl_posting
  end

  def fill_postings_for_vendor_invoice_lines
    gl_dtl_posting = []
    dtl_serial_no = MAX_SERIAL_NO.to_i
    self.vendor_invoice_lines.applied_lines.each{|inv_line|
      #    gl_posting = GeneralLedger::GlPosting.new
      gl_posting = generate_new_posting
      gl_posting.debit_amt = inv_line.gl_amt
      gl_posting.credit_amt = 0
      gl_posting.dtl_serial_no = dtl_serial_no += 1
      gl_posting.description = inv_line.description
      gl_posting.gl_account_id = inv_line.gl_account_id
      gl_dtl_posting << gl_posting
    }
    gl_dtl_posting
  end
 
  def generate_new_posting
    gl_posting = GeneralLedger::GlPosting.new
    gl_posting.company_id = self.company_id 
    gl_posting.trans_bk = self.trans_bk
    gl_posting.trans_no = self.trans_no
    gl_posting.trans_date = self.trans_date
    gl_posting.ref_bk = self.trans_bk
    gl_posting.ref_no = self.inv_no
    gl_posting.ref_date = self.inv_date
    gl_posting.account_period_code = self.account_period_code
    gl_posting.trans_type = 'I'
    gl_posting.description = self.description
    gl_posting.post_flag = 'U'
    gl_posting.update_flag = 'V'
    gl_posting.customer_vendor_id = self.customer_id  if customerinvoice?("#{self.class}")
    gl_posting.customer_vendor_id = self.vendor_id    if vendorinvoice?("#{self.class}")
    gl_posting.customer_vendor_flag =  'C'  if customerinvoice?("#{self.class}")
    gl_posting.customer_vendor_flag = 'V'    if vendorinvoice?("#{self.class}")
    gl_posting.serial_no = INVOICE_GL_SERIAL_NO
    gl_posting.module_code = self.docu_type[0,4] if self.docu_type
    gl_posting
  end

end


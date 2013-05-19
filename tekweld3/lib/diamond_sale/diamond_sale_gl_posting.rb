module DiamondSale::DiamondSaleGlPosting
  #  include General
  #  include ClassMethods
  #  def create_gl_postings()
  #    gl_account_id = fetch_gl_account_from_customer()
  #    item_debit_acctid, item_credit_acctid, ship_acctid, insurance_acctid, tax_acctid, discount_acctid = fetch_gl_account_for_sales()
  #
  #    gl_postings = []
  #    dtl_serial_no = SALES_INVOICE_GL_SERIAL_NO
  #    if gl_account_id.nil? or item_credit_acctid.nil?
  #      return #throw error pending
  #    end
  #    dtl_serial_no, gl_postings = post_net_amt(dtl_serial_no, gl_postings, gl_account_id)
  #    dtl_serial_no, gl_postings = post_ship_amt(dtl_serial_no, gl_postings, ship_acctid)
  #    dtl_serial_no, gl_postings = post_insurance_amt(dtl_serial_no, gl_postings, insurance_acctid)
  #    dtl_serial_no, gl_postings = post_tax_amt(dtl_serial_no, gl_postings, tax_acctid)
  #    dtl_serial_no, gl_postings = post_other_amt(dtl_serial_no, gl_postings, insurance_acctid)
  #    dtl_serial_no, gl_postings = post_discount_amt(dtl_serial_no, gl_postings, discount_acctid)
  #    dtl_serial_no, gl_postings = post_item_amt(dtl_serial_no, gl_postings, item_credit_acctid, item_debit_acctid)
  #    #GeneralLedger::GlTransaction.post_gl_transactions(gl_postings)
  #    gl_postings
  #  end
  #
  #  def fetch_gl_account_for_sales()
  #    saletype = Setup::Type.find(:first, :conditions=>['type_cd = ? and subtype_cd = ?','saoi','item_debit_acctid'],
  #      :select => 'value')
  #    item_debit_acctcd = saletype.value if not saletype.nil?
  #    item_debit_acctid = GeneralLedger::GlAccount.find_by_code(item_debit_acctcd).id
  #    raise_error( "No GL Defined for Item Debit") if item_debit_acctid.nil?
  #
  #    saletype = Setup::Type.find(:first, :conditions=>['type_cd = ? and subtype_cd = ?','saoi','item_credit_acctid'],
  #      :select => 'value')
  #    item_credit_acctcd = saletype.value if not saletype.nil?
  #    item_credit_acctid = GeneralLedger::GlAccount.find_by_code(item_credit_acctcd).id
  #    raise_error( "No GL Defined for Item Credit") if item_credit_acctid.nil?
  #
  #    saletype = Setup::Type.find(:first, :conditions=>['type_cd = ? and subtype_cd = ?','saoi','ship_acctid'],
  #      :select => 'value')
  #    ship_acctcd = saletype.value if not saletype.nil?
  #    ship_acctid = GeneralLedger::GlAccount.find_by_code(ship_acctcd).id
  #    raise_error( "No GL Defined for Shipping") if ship_acctid.nil?
  #
  #    saletype = Setup::Type.find(:first, :conditions=>['type_cd = ? and subtype_cd = ?','saoi','insurance_acctid'],
  #      :select => 'value')
  #    insurance_acctcd = saletype.value if not saletype.nil?
  #    insurance_acctid = GeneralLedger::GlAccount.find_by_code(insurance_acctcd).id
  #    raise_error( "No GL Defined for Insurance") if insurance_acctid.nil?
  #
  #    saletype = Setup::Type.find(:first, :conditions=>['type_cd = ? and subtype_cd = ?','saoi','tax_acctid'],
  #      :select => 'value')
  #    tax_acctcd = saletype.value if not saletype.nil?
  #    tax_acctid = GeneralLedger::GlAccount.find_by_code(tax_acctcd).id
  #    raise_error( "No GL Defined for Tax") if tax_acctid.nil?
  #
  #    saletype = Setup::Type.find(:first, :conditions=>['type_cd = ? and subtype_cd = ?','saoi','discount_acctid'],
  #      :select => 'value')
  #    discount_acctcd = saletype.value if not saletype.nil?
  #    discount_acctid = GeneralLedger::GlAccount.find_by_code(discount_acctcd).id
  #    raise_error( "No GL Defined for Discount") if discount_acctid.nil?
  #    return item_debit_acctid, item_credit_acctid, ship_acctid, insurance_acctid, tax_acctid, discount_acctid
  #  end
  #
  #  def fetch_gl_account_from_customer()
  #    customer = Customer::Customer.find(self.customer_id)
  #    gl_account_id = customer.customer_category.gl_accounts_receivable_id
  #
  #    if gl_account_id.nil?
  #       raise_error('GL Account not defined for Customer Category')
  #    end
  #    gl_account_id
  #  end
  #
  #  def post_net_amt(dtl_serial_no, gl_postings, gl_account_id)
  #    debit_amt = 0
  #    credit_amt = 0
  #    if self.trans_type == 'I' 
  #      debit_amt = nulltozero(self.net_amt)
  #    else
  #      credit_amt = nulltozero(self.net_amt)
  #    end 
  #    #Enter Debit Entry
  #    gl_postings = fill_gl_posting_for_invoice(gl_account_id, dtl_serial_no, debit_amt, credit_amt, gl_postings)
  #    return dtl_serial_no, gl_postings
  #  end
  #  
  #  def post_ship_amt(dtl_serial_no, gl_postings, ship_acctid)
  #    if self.ship_amt != 0 and not ship_acctid.nil?
  #      dtl_serial_no = dtl_serial_no + 1
  #      debit_amt = 0 
  #      credit_amt = 0
  #      if self.trans_type = 'I' 
  #        credit_amt = self.ship_amt
  #      else
  #        debit_amt = self.ship_amt
  #      end 
  #      gl_postings = fill_gl_posting_for_invoice(ship_acctid, dtl_serial_no, debit_amt, credit_amt, gl_postings)	
  #    end 
  #    return dtl_serial_no, gl_postings
  #  end
  #  
  #  def post_insurance_amt(dtl_serial_no, gl_postings, insurance_acctid)
  #    if self.insurance_amt != 0 and not insurance_acctid.nil?
  #      dtl_serial_no = dtl_serial_no + 1
  #      debit_amt = 0 
  #      credit_amt = 0
  #      if self.trans_type = 'I' 
  #        credit_amt = self.insurance_amt
  #      else
  #        debit_amt = self.insurance_amt
  #      end 
  #      gl_postings = fill_gl_posting_for_invoice(insurance_acctid, dtl_serial_no, debit_amt, credit_amt, gl_postings)	
  #    end 
  #    return dtl_serial_no, gl_postings
  #  end
  #  
  #  def post_tax_amt(dtl_serial_no, gl_postings, tax_acctid)
  #    if self.tax_amt != 0 and not tax_acctid.nil?
  #      dtl_serial_no = dtl_serial_no + 1
  #      debit_amt = 0 
  #      credit_amt = 0
  #      if self.trans_type = 'I' 
  #        credit_amt = self.tax_amt
  #      else
  #        debit_amt = self.tax_amt
  #      end 
  #      gl_postings = fill_gl_posting_for_invoice(tax_acctid, dtl_serial_no, debit_amt, credit_amt, gl_postings)	
  #    end 
  #    return dtl_serial_no, gl_postings
  #  end
  #
  #  def post_other_amt(dtl_serial_no, gl_postings, insurance_acctid)
  #    if self.other_amt != 0 and not insurance_acctid.nil?
  #      dtl_serial_no = dtl_serial_no + 1
  #      debit_amt = 0 
  #      credit_amt = 0
  #      if self.trans_type = 'I' 
  #        credit_amt = self.other_amt
  #      else
  #        debit_amt = self.other_amt
  #      end 
  #      gl_postings = fill_gl_posting_for_invoice(insurance_acctid, dtl_serial_no, debit_amt, credit_amt, gl_postings)	
  #    end 
  #    return dtl_serial_no, gl_postings
  #  end
  #  
  #  def post_discount_amt(dtl_serial_no, gl_postings, discount_acctid)
  #    if self.discount_amt != 0 and not discount_acctid.nil?
  #      dtl_serial_no = dtl_serial_no + 1
  #      debit_amt = 0 
  #      credit_amt = 0
  #      if self.trans_type = 'I' 
  #        debit_amt = self.discount_amt
  #      else
  #        credit_amt = self.discount_amt
  #      end 
  #      gl_postings = fill_gl_posting_for_invoice(discount_acctid, dtl_serial_no, debit_amt, credit_amt, gl_postings)	
  #    end 
  #    return dtl_serial_no, gl_postings
  #  end
  #  
  #  def post_item_amt(dtl_serial_no, gl_postings, item_credit_acctid, item_debit_acctid)
  #    #Enter Credit Entries
  #    diamond_sale_lines.applied_lines.each{|lineitem|
  #      if lineitem.net_amt == 0
  #        next
  #      end
  #      saletype = Setup::Type.find(:first, :conditions=>['type_cd = ? and subtype_cd = ?','item_type','D'],
  #        :select => 'value')
  #      item_acctcd = saletype.value if not saletype.nil?
  #      item_acctid = GeneralLedger::GlAccount.find_by_code(item_acctcd).id if not item_acctcd.nil?
  #      #raise_error( "No GL Defined for Item Debit") if item_acctid.nil?
  #    
  #      debit_amt = 0 
  #      credit_amt = 0
  #      if self.trans_type == 'I' 
  #        credit_amt = lineitem.net_amt
  #        gl_account_id = item_credit_acctid
  #      else
  #        debit_amt = lineitem.net_amt
  #        gl_account_id = item_debit_acctid
  #      end 
  #
  #      gl_account_id = item_acctid if not item_acctid.nil?
  #      
  #      glposting = gl_postings.find{|glitem|
  #        glitem.gl_account_id==gl_account_id
  #      }
  #      if glposting.nil?
  #        dtl_serial_no = dtl_serial_no + 1
  #        gl_postings = fill_gl_posting_for_invoice(gl_account_id, dtl_serial_no, debit_amt, credit_amt, gl_postings)
  #      else
  #        credit_amt = glposting.credit_amt + credit_amt
  #        debit_amt = glposting.debit_amt + debit_amt
  #        serial_no = glposting.serial_no
  #        gl_postings.delete_if{|glitem| glitem.gl_account_id==gl_account_id}
  #        gl_postings = fill_gl_posting_for_invoice(gl_account_id, serial_no, debit_amt, credit_amt, gl_postings)
  #      end
  #    }
  #    return dtl_serial_no, gl_postings
  #  end
  #  
  #  def fill_gl_posting_for_invoice(gl_account_id, dtl_serial_no, debit_amt, credit_amt, gl_postings)
  #    gl_posting = GeneralLedger::GlPosting.new
  #    gl_posting = fill_gl_posting_header_for_invoice(gl_posting)      
  #    gl_posting.dtl_serial_no = dtl_serial_no.to_s
  #    gl_posting.gl_account_id = gl_account_id
  #    gl_posting.debit_amt = debit_amt
  #    gl_posting.credit_amt = credit_amt
  #    gl_postings << gl_posting
  #    gl_postings
  #  end 
  #
  #  def fill_gl_posting_header_for_invoice(gl_posting)
  #    gl_posting.trans_bk = self.trans_bk
  #    gl_posting.trans_no = self.trans_no
  #    gl_posting.trans_date = self.trans_date
  #    gl_posting.customer_vendor_id = self.customer_id
  #    gl_posting.account_period_code = self.account_period_code
  #    gl_posting.trans_type = 'I'
  #    gl_posting.description = ''
  #    gl_posting.post_flag = 'U'
  #    gl_posting.update_flag = 'V'
  #    gl_posting.customer_vendor_id = self.customer_id
  #    gl_posting.serial_no = SALES_INVOICE_GL_SERIAL_NO
  #    gl_posting.module_code = SALES_INVOICE_MODULE_CODE
  #    gl_posting
  #  end

  class Posting
    include General
    include ClassMethods
    
    def create_gl_postings(object)
      ar_account_id, shipping_account_id, discount_account_id, salestax_account_id, default_account_id = fetch_gl_account_for_sales()
      gl_postings = []
      dtl_serial_no = SALES_INVOICE_GL_SERIAL_NO
      gl_postings << post_net_amt(dtl_serial_no, ar_account_id, object) if nulltozero(object.net_amt) != 0 
      if  nulltozero(object.tax_amt) != 0 and salestax_account_id
        dtl_serial_no += 1
        gl_postings << post_salestax_amt(dtl_serial_no, salestax_account_id, object) 
      end
      if  nulltozero(object.discount_amt) != 0 and discount_account_id
        dtl_serial_no += 1
        gl_postings << post_discount_amt(dtl_serial_no, discount_account_id, object)
      end
      if  nulltozero(object.ship_amt) != 0 and shipping_account_id
        dtl_serial_no += 1
        gl_postings << post_shipping_amt(dtl_serial_no, shipping_account_id, object)
      end
      if  nulltozero(object.other_amt) != 0 and default_account_id
        dtl_serial_no += 1
        gl_postings << post_other_amt(dtl_serial_no, default_account_id, object)
      end
      post_item_amt(dtl_serial_no, default_account_id, object).each{|li| gl_postings << li}
      gl_postings
    end

    def fetch_gl_account_for_sales()
      glsetup = GeneralLedger::GlSetup.find(:first)
      ar_account_id = glsetup.ar_account_id
      shipping_account_id = glsetup.shipping_sales_account_id 
      discount_account_id = glsetup.discount_sales_account_id 
      salestax_account_id = glsetup.salestax_sales_account_id 
      default_account_id = glsetup.default_sales_account_id 
      return ar_account_id, shipping_account_id, discount_account_id, salestax_account_id, default_account_id
    end

    def post_net_amt(dtl_serial_no, ar_account_id, object)
      #      credit_amt = nulltozero(object.net_amt)
      #      debit_amt = 0
      debit_amt = nulltozero(object.net_amt)
      credit_amt = 0
      gl_posting = fill_gl_posting_for_invoice(object,ar_account_id, dtl_serial_no, debit_amt, credit_amt)
      gl_posting
    end

    def post_salestax_amt(dtl_serial_no, salestax_account_id, object)
      #      debit_amt = object.tax_amt
      #      credit_amt = 0
      credit_amt = object.tax_amt
      debit_amt = 0
      gl_posting = fill_gl_posting_for_invoice(object,salestax_account_id, dtl_serial_no, debit_amt, credit_amt)	
      gl_posting
    end

    def post_discount_amt(dtl_serial_no, discount_account_id, object )
      #      credit_amt = object.discount_amt
      #      debit_amt = 0
      debit_amt = object.discount_amt
      credit_amt = 0
      gl_posting = fill_gl_posting_for_invoice(object,discount_account_id, dtl_serial_no, debit_amt, credit_amt)	
      gl_posting
    end

    def post_shipping_amt(dtl_serial_no, shipping_account_id, object)
      #      debit_amt = object.ship_amt
      #      credit_amt = 0
      credit_amt = object.ship_amt
      debit_amt = 0
      gl_posting = fill_gl_posting_for_invoice(object,shipping_account_id, dtl_serial_no, debit_amt, credit_amt)	
      gl_posting
    end

    def post_other_amt(dtl_serial_no, default_account_id, object)
      #      debit_amt = object.other_amt
      #      credit_amt = 0
      credit_amt = object.other_amt
      debit_amt = 0
      gl_posting = fill_gl_posting_for_invoice(object,default_account_id, dtl_serial_no, debit_amt, credit_amt)	
      gl_posting
    end
    
    def post_item_amt(dtl_serial_no, default_account_id,object)
      item_gl_postings = []
      object_lines = identify_sales_post_lines(object)
      glsetupitems = GeneralLedger::GlSetupItem.find(:all)
      #      object_lines.each{|lineitem|
      #        #get the sale account from gl_setup_item_details
      #        item_type = 'D'
      #        sales_account_id = glsetupitems.to_ary.find{|line| line.item_type == item_type}.sales_account_id
      #        sales_account_id ||= default_account_id
      #        item_amt = lineitem.line_amt
      #        #        debit_amt = item_amt
      #        #        credit_amt = 0
      #        credit_amt = item_amt
      #        debit_amt = 0
      #        dtl_serial_no =+ 1
      #        item_gl_postings << fill_gl_posting_for_invoice(object,sales_account_id, dtl_serial_no, debit_amt, credit_amt)
      #      }
      #changed by Praman as suggested by Vivek sir
      net_amt = 0.00
      item_type = 'D'
      sales_account_id = glsetupitems.to_ary.find{|line| line.item_type == item_type}.purchase_account_id
      sales_account_id ||= default_account_id
      object_lines.each{|lineitem|
        #get the purchase account from gl_setup_item_details
        net_amt = net_amt + lineitem.net_amt
      }
      debit_amt = 0
      credit_amt = net_amt
      dtl_serial_no =+ 1
      item_gl_postings << fill_gl_posting_for_invoice(object,sales_account_id, dtl_serial_no, debit_amt, credit_amt)

      return item_gl_postings
    end

    def fill_gl_posting_for_invoice(object,gl_account_id, dtl_serial_no, debit_amt, credit_amt)
      gl_posting = GeneralLedger::GlPosting.new
      fill_gl_posting_header_for_invoice(object,gl_posting)      
      gl_posting.dtl_serial_no = dtl_serial_no
      gl_posting.gl_account_id = gl_account_id
      case object.class.name 
      when  'DiamondSale::DiamondSaleInvoice'
        gl_posting.debit_amt = debit_amt
        gl_posting.credit_amt = credit_amt
      when   'DiamondSale::DiamondSaleCredit'
        gl_posting.debit_amt = credit_amt
        gl_posting.credit_amt = debit_amt
      end
      gl_posting
    end 

    def fill_gl_posting_header_for_invoice(object,gl_posting)
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
      gl_posting.customer_vendor_id = object.customer_id
      gl_posting.serial_no = SALES_INVOICE_GL_SERIAL_NO
      gl_posting.module_code = SALES_INVOICE_MODULE_CODE
    end

    def identify_sales_post_lines(object)
      #      current_lines = case object.class.name
      #      when 'DiamondSale::DiamondSaleInvoice'
      #         object.sales_invoice_lines.to_ary.find_all { |line| line.trans_flag == 'A' and nulltozero(line.net_amt) != 0 }  
      #      when 'DiamondSale::DiamondSaleCredit'
      #         object.sales_credit_invoice_lines.to_ary.find_all { |line| line.trans_flag == 'A' and nulltozero(line.net_amt) != 0 }  
      #      else
      #      end
      current_lines =  object.diamond_sale_lines.to_ary.find_all { |line| line.trans_flag == 'A' and nulltozero(line.net_amt) != 0 }  
      current_lines
    end

    private :fetch_gl_account_for_sales, :post_net_amt, :post_salestax_amt,:post_discount_amt, :post_shipping_amt, :post_other_amt, 
      :post_item_amt, :fill_gl_posting_for_invoice, :fill_gl_posting_header_for_invoice, :identify_sales_post_lines
  end  

  
end  

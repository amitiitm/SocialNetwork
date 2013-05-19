


#credit is untouched


module DiamondPurchase::DiamondVendorInvoicePosting
  include General
  include ClassMethods
  
  def unpost_vendorinvoice
    if self.trans_type == 'I' 
      unpost_invoices
   end
   if self.trans_type == 'C'  # it is credit
      unpost_applied_invoices
      unpost_credit_invoice
   end 
  end

  def unpost_invoices
      trans_no1 = self.trans_no.strip + 'a' 
      trans_no2 = self.trans_no.strip + 'b' 
      trans_no3 = self.trans_no.strip + 'c' 
      trans_no4 = self.trans_no.strip + 'd' 
      trans_no5 = self.trans_no.strip + 'e' 
      trans_no6 = self.trans_no.strip + 'f' 

      trans_nos = [self.trans_no, trans_no1, trans_no2, trans_no3,
                  trans_no4, trans_no5, trans_no6]

      Vendor::VendorInvoiceLine.delete_all(['trans_bk = ? and trans_no in (?) and trans_date = ? ',	
            self.trans_bk, self.trans_no, self.trans_date])
      Vendor::VendorInvoice.delete_all(['trans_bk = ? and trans_no in (?) and trans_date = ? ',	
            self.trans_bk, trans_nos, self.trans_date])
  end  

  def unpost_credit_invoice
      Vendor::VendorInvoice.delete_all(['trans_bk = ? and trans_no in (?) and trans_date = ? ',	
            self.trans_bk, self.trans_no, self.trans_date])
      Vendor::VendorPayment.delete_all(['trans_bk = ? and trans_no = ? and trans_date = ? ',	
            self.trans_bk, self.trans_no, self.trans_date])
      Vendor::VendorPaymentLine.delete_all(['trans_bk = ? and trans_no = ? and trans_date = ? ',	
            self.trans_bk, self.trans_no, self.trans_date])
  end  
  
  def unpost_applied_invoices
                               #same as receipt_line here payment lines.
    payment_lines = Vendor::VendorPaymentLine.find(:all,
            :select=>'apply_amt, disctaken_amt, voucher_no, voucher_date',
            :conditions=>['trans_bk = ? and trans_no = ? and trans_date = ?
             and company_id = ?',self.trans_bk,self.trans_no,self.trans_date,self.company_id])

    if payment_lines.nil?
      return
    end
    payment_lines.each{ |lineitem|
      apply_amt = lineitem.apply_amt
      disctaken_amt = lineitem.disctaken_amt
      voucher_no = lineitem.voucher_no
      voucher_dt = lineitem.voucher_dt
      trans_bk = voucher_no[1,4]
      trans_no = voucher_no[5,1] 
                    #vendinv is vendor invoice.
      vendinv = Vendor::VendorInvoice.find(:first,
                :conditions=>['trans_bk = ? and trans_no = ? and company_id = ? and trans_date = ? ;',
                              trans_bk, trans_no, self.company_id, voucher_dt])
      if not vendinv.nil?
        vendinv.action_flag = 'O'
        vendinv.paid_amt = vendinv.paid_amt - apply_amt,
        vendinv.disctaken_amt = vendinv.disctaken_amt - disctaken_amt,
        vendinv.balance_amt = vendinv.inv_amt - (vendinv.paid_amt + vendinv.disctaken_amt ) + ( apply_amt + disctaken_amt) 
        vendinv.save!
      end
    }
  end

  def post_vendorinvoice
    if self.trans_type == 'I' 
      post_invoices
   end
   if self.trans_type == 'C'  # it is credit
      post_credit_invoice
   end 
  end
  

  def post_invoices
      term = Setup::Term.find(:first, :conditions=>['code = ?',self.term_code])
      #if term.nil?
      #  return
      #end
      soldto_id, billto_id = fetch_details_from_vendor()
      if term.nil?
        no_of_entries = 1
        amt_percent = 100
        trans_no1 = self.trans_no
        self.due_date = self.trans_date
        due_days = self.due_date - self.trans_date 
        disc_per = 0
        disc_date = self.trans_date
      else
        no_of_entries = Setup::Term.calculate_no_of_invoices(term)
      end 
      net_amt2 = 0
      purchase_date = self.trans_date
      1.upto(no_of_entries) do |i|
          if not term.nil?
            amt_percent , due_days, trans_no1 = Setup::Term.generate_invoice_no(i, term, no_of_entries, self.trans_no)
            disc_per, disc_date = Setup::Term.calculate_discount_details_from_terms(term, self.trans_date)
          end
          due_date = Setup::Term.calculate_due_date(purchase_date, due_days, self.trans_date)
          net_amt1, net_amt2 = calculate_net_amt(i, no_of_entries, amt_percent, net_amt2)
          inv_type = 'I'
          invoice = fill_vendor_invoice(inv_type, trans_no1, due_date, disc_date, net_amt1, disc_per, soldto_id, billto_id)
          invoice.save!
      end
  end

  def post_credit_invoice
      credit_faar_flag = fetch_credit_faar_flag() 
      tot_applied_amt = post_ref_invoices()
      due_date = self.trans_date
      soldto_id, billto_id = fetch_details_from_vendor()
      #gl_account_id = fetch_gl_account_from_customer()
      payment_type = 'C'
      applied_amt = tot_applied_amt
      balance_amt = self.net_amt - tot_applied_amt
      if credit_faar_flag == 'A'  # as a vendor payment
        payment = fill_vendor_payments(self.trans_type, payment_type, soldto_id, billto_id, applied_amt, due_date, balance_amt)
        payment.save!
      else # credit as negative invoice.
        if tot_applied_amt > 0 
          payment = fill_vendor_payments(self.trans_type, payment_type, soldto_id, billto_id, applied_amt, due_date, balance_amt)
          payment.save!
        else
          # unapplied amount in invoice table.
          inv_amt = (self.net_amt - tot_applied_amt) * (-1)
          inv_type='I'
          disc_per = 0 
          disc_date = self.trans_date
          due_date = self.trans_date
          invoice = fill_vendor_invoice(inv_type, self.trans_no, due_date, disc_date, inv_amt, disc_per, soldto_id, billto_id)
          invoice.save!
       end 
      end
  end
  
  def post_ref_invoices
    tot_applied_amt = 0
    diamond_purchase_lines.each{ |lineitem|      
      net_amt1 = nulltozero(lineitem.net_amt)
      if net_amt1 <= 0 or lineitem.ref_trans_no.nil? 
          next
      end
                             #vendinv is vendor_invoice
      vendinv = Vendor::VendorInvoice.find(:first, 
        :conditions=>['trans_bk = ? and trans_no = ? and trans_date = ? and company_id =?', 
          lineitem.ref_trans_bk, lineitem.ref_trans_no, lineitem.ref_trans_date, lineitem.company_id])
      if vendinv.nil?
        next
      end

      inv_amt = vendinv.inv_amt
      balance_amt = vendinv.balance_amt
      inv_due_date = vendinv.due_date
      if balance_amt <= 0 
        next
      end        
      apply_amt = 0
      if net_amt1 > balance_amt 
         apply_amt = balance_amt
      else
         apply_amt = net_amt1
      end if 

      tot_applied_amt += apply_amt

      vendinv.paid_amt = vendinv.paid_amt + apply_amt
      vendinv.balance_amt = vendinv.balance_amt - apply_amt
      vendinv.save!

      voucher_no = lineitem.ref_trans_bk.strip + lineitem.ref_trans_no.strip
      vendpaymentdtl = Vendor::VendorPaymentLine.new
      vendpaymentdtl.trans_bk = self.trans_bk
      vendpaymentdtl.trans_no = self.trans_no 
      vendpaymentdtl.serial_no = lineitem.serial_no
      vendpaymentdtl.trans_date = self.trans_date
      vendpaymentdtl.apply_flag = 'N'
      vendpaymentdtl.voucher_no = voucher_no
      vendpaymentdtl.inv_no = voucher_no
      vendpaymentdtl.inv_date = lineitem.ref_trans_date
      vendpaymentdtl.original_amt = inv_amt
      vendpaymentdtl.balance_amt = balance_amt
      vendpaymentdtl.apply_amt = apply_amt
      vendpaymentdtl.disctaken_amt = 0
      vendpaymentdtl.update_flag = 'V'
      vendpaymentdtl.voucher_date = lineitem.ref_trans_date
      vendpaymentdtl.due_date = inv_due_date
      vendpaymentdtl.save!
    }
    tot_applied_amt
  end

  def calculate_net_amt(i, no_of_entries, amt_percent, net_amt2)
    net_amt1 = 0
    if i == no_of_entries 
        #------------------------------------------------------
        # for last entry let the amount be 
        # total - previous amounts
        # so that sum of all partial invoices is always same
        # otherwise there may be difference of 1 or 2 cents
        # because of rounding
        #------------------------------------------------------
      net_amt1 = nulltozero(self.net_amt) - nulltozero(net_amt2)
    else 
      net_amt1 = nulltozero(self.net_amt) * (amt_percent / 100)
      net_amt2 += net_amt1
    end 
    return net_amt1, net_amt2
  end

  def fill_vendor_invoice(inv_type, trans_no1, due_date, disc_date, net_amt, disc_per, soldto_id, billto_id)
      vendinv = Vendor::VendorInvoice.new()
      vendinv.trans_bk = self.trans_bk
      vendinv.trans_no = trans_no1
      vendinv.trans_date = self.trans_date
      vendinv.account_period_code  = self.account_period_code
      vendinv.trans_flag = self.trans_flag
      vendinv.post_flag = 'P'  
      vendinv.trans_type = 'I'
      vendinv.inv_no = self.trans_no #ref_trans_no
      vendinv.inv_date = self.trans_date #ref_trans_date
      vendinv.vendor_id = self.vendor_id
      vendinv.inv_amt = net_amt
      vendinv.due_date = due_date
      vendinv.term_code = self.term_code  
      vendinv.discount_per = disc_per
      vendinv.discount_amt = 0
      vendinv.discount_date = disc_date
      vendinv.paid_amt = 0
      vendinv.disctaken_amt = 0
      vendinv.balance_amt = net_amt
      vendinv.description = self.remarks
      vendinv.update_flag = 'V' 
      vendinv.action_flag = 'O'
      vendinv.inv_type = inv_type
      vendinv.purchaseperson_code = '' #self.purchasesperson_code
      vendinv.purchase_date = self.trans_date
      vendinv.soldto_id = soldto_id
      vendinv.parent_id = billto_id 
      vendinv
  end

  def fill_vendor_payments(trans_type, payment_type, soldto_id, billto_id, applied_amt, due_date, balance_amt)
#    (trans_type, payment_type, soldto_id, billto_id, applied_amt, due_date, balance_amt)
      
      vendpayment=Vendor::VendorPayment.new()
      vendpayment.trans_bk = self.trans_bk
      vendpayment.trans_no = self.trans_no
      vendpayment.trans_date = self.trans_date
      vendpayment.account_period_code  = self.account_period_code
      vendpayment.trans_flag = self.trans_flag 
      vendpayment.post_flag = 'P'
      vendpayment.trans_type = trans_type
      vendpayment.payment_type = payment_type
      vendpayment.vendor_id = self.vendor_id
      vendpayment.received_amt = self.net_amt
      vendpayment.applied_amt = applied_amt
      vendpayment.balance_amt = balance_amt
      vendpayment.check_no = self.trans_no #ref_trans_no
      vendpayment.check_date = self.trans_date #ref_trans_date
      vendpayment.update_flag = 'V' 
      vendpayment.action_flag = 'O'
      vendpayment.purchaseperson_code = '' #self.purchasesperson_code
      vendpayment.soldto_id = soldto_id
      vendpayment.term_code = self.term_code
      vendpayment.due_date = due_date
      vendpayment.parent_id = billto_id
      vendpayment.bank_id = 351 # I have to remove this line after correction in customer credit invoice screen.
      vendpayment
  end

  def fetch_details_from_vendor()
      vendor = Vendor::Vendor.find(self.vendor_id)
      soldto_id = vendor.id                   #this name to be change
      billto_id = vendor.billto_id                  #billto_id to change
      if billto_id.nil?
        billto_id = soldto_id
      end

      return soldto_id, billto_id
  end

  def fetch_credit_faar_flag  
    credit_faar_flag = 'A'
    credittype = Setup::Type.find(:first, :conditions=>['type_cd = ? and subtype_cd = ?','faar','credit_faar_flag'],
      :select => 'value')
    credit_faar_flag = credittype.value if not credittype.nil?
    credit_faar_flag
  end
end

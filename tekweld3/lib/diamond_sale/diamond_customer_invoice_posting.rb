module DiamondSale::DiamondCustomerInvoicePosting
  include General
  include ClassMethods
  
  def unpost_customerinvoice
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

      Customer::CustomerInvoiceLine.delete_all(['trans_bk = ? and trans_no in (?) and trans_date = ? ',	
            self.trans_bk, self.trans_no, self.trans_date])
      Customer::CustomerInvoice.delete_all(['trans_bk = ? and trans_no in (?) and trans_date = ? ',	
            self.trans_bk, trans_nos, self.trans_date])
  end  

  def unpost_credit_invoice
      Customer::CustomerInvoice.delete_all(['trans_bk = ? and trans_no in (?) and trans_date = ? ',	
            self.trans_bk, self.trans_no, self.trans_date])
      Customer::CustomerReceipt.delete_all(['trans_bk = ? and trans_no = ? and trans_date = ? ',	
            self.trans_bk, self.trans_no, self.trans_date])
      Customer::CustomerReceiptLine.delete_all(['trans_bk = ? and trans_no = ? and trans_date = ? ',	
            self.trans_bk, self.trans_no, self.trans_date])
  end  
  
  def unpost_applied_invoices
    receipt_lines = Customer::CustomerReceiptLine.find(:all,
            :select=>'apply_amt, disctaken_amt, voucher_no, voucher_date',
            :conditions=>['trans_bk = ? and trans_no = ? and trans_date = ?
             and company_id = ?',self.trans_bk,self.trans_no,self.trans_date,self.company_id])

    if receipt_lines.nil?
      return
    end
    receipt_lines.each{ |lineitem|
      apply_amt = lineitem.apply_amt
      disctaken_amt = lineitem.disctaken_amt
      voucher_no = lineitem.voucher_no
      voucher_dt = lineitem.voucher_dt
      trans_bk = voucher_no[1,4]
      trans_no = voucher_no[5,1] 

      custinv = Customer::CustomerInvoice.find(:first,
                :conditions=>['trans_bk = ? and trans_no = ? and company_id = ? and trans_date = ? ;',
                              trans_bk, trans_no, self.company_id, voucher_dt])
      if not custinv.nil?
        custinv.action_flag = 'O'
        custinv.paid_amt = custinv.paid_amt - apply_amt,
        custinv.disctaken_amt = custinv.disctaken_amt - disctaken_amt,
        custinv.balance_amt = custinv.inv_amt - (custinv.paid_amt + custinv.disctaken_amt ) + ( apply_amt + disctaken_amt) 
        custinv.save!
      end
    }
  end

  def post_customerinvoice
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
      soldto_id, billto_id = fetch_details_from_customer()
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
      sale_date = self.trans_date
      1.upto(no_of_entries) do |i|
          if not term.nil?
            amt_percent , due_days, trans_no1 = Setup::Term.generate_invoice_no(i, term, no_of_entries, self.trans_no)
            disc_per, disc_date = Setup::Term.calculate_discount_details_from_terms(term, self.trans_date)
          end
          due_date = Setup::Term.calculate_due_date(sale_date, due_days, self.trans_date)
          net_amt1, net_amt2 = calculate_net_amt(i, no_of_entries, amt_percent, net_amt2)
          inv_type = 'I'
          invoice = fill_customer_invoice(inv_type, trans_no1, due_date, disc_date, net_amt1, disc_per, soldto_id, billto_id)
          invoice.save!
      end
  end

  def post_credit_invoice
      credit_faar_flag = fetch_credit_faar_flag() 
      tot_applied_amt = post_ref_invoices()
      due_date = self.trans_date
      soldto_id, billto_id = fetch_details_from_customer()
      #gl_account_id = fetch_gl_account_from_customer()
      receipt_type = 'C'
      applied_amt = tot_applied_amt
      balance_amt = self.net_amt - tot_applied_amt
      if credit_faar_flag == 'A'  # as a customer receipt
        receipt = fill_customer_receipts(self.trans_type, receipt_type, soldto_id, billto_id, applied_amt, due_date, balance_amt)
        receipt.save!
      else # credit as negative invoice.
        if tot_applied_amt > 0 
          receipt = fill_customer_receipts(self.trans_type, receipt_type, soldto_id, billto_id, applied_amt, due_date, balance_amt)
          receipt.save!
        else
          # unapplied amount in invoice table.
          inv_amt = (self.net_amt - tot_applied_amt) * (-1)
          inv_type='I'
          disc_per = 0 
          disc_date = self.trans_date
          due_date = self.trans_date
          invoice = fill_customer_invoice(inv_type, self.trans_no, due_date, disc_date, inv_amt, disc_per, soldto_id, billto_id)
          invoice.save!
       end 
      end
  end
  
  def post_ref_invoices
    tot_applied_amt = 0
    diamond_sale_lines.each{ |lineitem|
      net_amt1 = nulltozero(lineitem.net_amt)
      if net_amt1 <= 0 or lineitem.ref_trans_no.nil? 
          next
      end

      custinv = Customer::CustomerInvoice.find(:first, 
        :conditions=>['trans_bk = ? and trans_no = ? and trans_date = ? and company_id =?', 
          lineitem.ref_trans_bk, lineitem.ref_trans_no, lineitem.ref_trans_date, lineitem.company_id])
      if custinv.nil?
        next
      end

      inv_amt = custinv.inv_amt
      balance_amt = custinv.balance_amt
      inv_due_date = custinv.due_date
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

      custinv.paid_amt = custinv.paid_amt + apply_amt
      custinv.balance_amt = custinv.balance_amt - apply_amt
      custinv.save!

      voucher_no = lineitem.ref_trans_bk.strip + lineitem.ref_trans_no.strip
      custreceiptdtl = Customer::CustomerReceiptLine.new
      custreceiptdtl.trans_bk = self.trans_bk
      custreceiptdtl.trans_no = self.trans_no 
      custreceiptdtl.serial_no = lineitem.serial_no
      custreceiptdtl.trans_date = self.trans_date
      custreceiptdtl.apply_flag = 'N'
      custreceiptdtl.voucher_no = voucher_no
      custreceiptdtl.inv_no = voucher_no
      custreceiptdtl.inv_date = lineitem.ref_trans_date
      custreceiptdtl.original_amt = inv_amt
      custreceiptdtl.balance_amt = balance_amt
      custreceiptdtl.apply_amt = apply_amt
      custreceiptdtl.disctaken_amt = 0
      custreceiptdtl.update_flag = 'V'
      custreceiptdtl.voucher_date = lineitem.ref_trans_date
      custreceiptdtl.due_date = inv_due_date
      custreceiptdtl.save!
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

  def fill_customer_invoice(inv_type, trans_no1, due_date, disc_date, net_amt, disc_per, soldto_id, billto_id)
      custinv = Customer::CustomerInvoice.new()
      custinv.trans_bk = self.trans_bk
      custinv.trans_no = trans_no1
      custinv.trans_date = self.trans_date
      custinv.account_period_code  = self.account_period_code
      custinv.trans_flag = self.trans_flag
      custinv.post_flag = 'P'  
      custinv.trans_type = 'I'
      custinv.inv_no = self.trans_no #ref_trans_no
      custinv.inv_date = self.trans_date #ref_trans_date
      custinv.customer_id = self.customer_id
      custinv.inv_amt = net_amt
      custinv.due_date = due_date
      custinv.term_code = self.term_code  
      custinv.discount_per = disc_per
      custinv.discount_amt = 0
      custinv.discount_date = disc_date
      custinv.paid_amt = 0
      custinv.disctaken_amt = 0
      custinv.balance_amt = net_amt
      custinv.description = self.remarks
      custinv.update_flag = 'V' 
      custinv.action_flag = 'O'
      custinv.inv_type = inv_type
      custinv.salesperson_code = '' #self.salesperson_code
      custinv.sale_date = self.trans_date
      custinv.soldto_id = soldto_id
      custinv.parent_id = billto_id 
      custinv
  end

  def fill_customer_receipts(trans_type, receipt_type, soldto_id, billto_id, applied_amt, due_date, balance_amt)
#    (trans_type, receipt_type, soldto_id, billto_id, applied_amt, due_date, balance_amt)
      custcredit = Customer::CustomerReceipt.new()
      custcredit.trans_bk = self.trans_bk
      custcredit.trans_no = self.trans_no
      custcredit.trans_date = self.trans_date
      custcredit.account_period_code  = self.account_period_code
      custcredit.trans_flag = self.trans_flag 
      custcredit.post_flag = 'P'
      custcredit.trans_type = trans_type
      custcredit.receipt_type = receipt_type
      custcredit.customer_id = self.customer_id
      custcredit.received_amt = self.net_amt
      custcredit.applied_amt = applied_amt
      custcredit.balance_amt = balance_amt
      custcredit.check_no = self.trans_no #ref_trans_no
      custcredit.check_date = self.trans_date #ref_trans_date
      custcredit.update_flag = 'V' 
      custcredit.action_flag = 'O'
      custcredit.salesperson_code = '' #self.salesperson_code
      custcredit.soldto_id = soldto_id
      custcredit.term_code = self.term_code
      custcredit.due_date = due_date
      custcredit.parent_id = billto_id
      custcredit.bank_id = 351 # I have to remove this line after correction in customer credit invoice screen.
      custcredit
  end

  def fetch_details_from_customer()
      customer = Customer::Customer.find(self.customer_id)
      soldto_id = customer.id
      billto_id = customer.billto_id
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

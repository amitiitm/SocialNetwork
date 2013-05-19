module Accounts::BankBounceCheckAccountsPosting

  class Posting
    include General
    include ClassMethods

    def post_customerinvoice(object)
      unpost_customer_invoice(object.trans_bk,object.trans_no,object.company_id)
      post_customer_invoice(object)
      post_customercreditinvoice(object)
    end

    def unpost_customer_invoice(trans_bk,trans_no,company_id)
      Customer::CustomerInvoice.delete_all(['trans_bk = ? and trans_no = ? and company_id = ?',	
          trans_bk, trans_no, company_id])
      Customer::CustomerInvoiceLine.delete_all(['trans_bk = ? and trans_no = ? and company_id = ? and serial_no = 101 ',	
          trans_bk, trans_no, company_id])
    end  

    def post_customer_invoice(object)
      invoice = fill_customer_invoice(object)
      invoice.save!
    end
    
    def post_customercreditinvoice(object)
      unpost_credit_invoice(object.trans_bk, object.trans_no, object.company_id)
      post_credit_invoice(object)
    end
    
    def unpost_credit_invoice(trans_bk, trans_no, company_id)
      Customer::CustomerReceiptLine.delete_all(['voucher_no = ? and company_id = ? ',	
          trans_bk+trans_no, company_id])
    end  

    def post_credit_invoice(object)
      receipt = fill_customer_receipts(object)
      receipt.save!
    end
    
    def fill_customer_receipts(object)
      customer_receipt = Customer::CustomerReceipt.find_by_trans_no_and_trans_bk_and_trans_date(object.ref_trans_no,object.ref_trans_bk,object.ref_trans_date)
      customer_receipt_line = customer_receipt.detail_lines.build
      fill_customer_receipt_lines(customer_receipt,customer_receipt_line,object)
      customer_receipt.applied_amt= object.debit_amt
      customer_receipt.balance_amt = 0.00
      customer_receipt.action_flag = 'C'
      customer_receipt
    end
    
    def fill_customer_receipt_lines(customer_receipt,customer_receipt_line,object)
      customer_receipt_line.trans_bk = customer_receipt.trans_bk
      customer_receipt_line.trans_no = customer_receipt.trans_no
      customer_receipt_line.ref_no = object.trans_no
      customer_receipt_line.voucher_no = object.trans_bk + object.trans_no
      customer_receipt_line.company_id = customer_receipt.company_id
      customer_receipt_line.trans_date = customer_receipt.trans_date
      customer_receipt_line.due_date = object.trans_date
      customer_receipt_line.voucher_date = object.trans_date
      customer_receipt_line.trans_flag = customer_receipt.trans_flag 
      customer_receipt_line.voucher_flag =  ''
      customer_receipt_line.original_amt = customer_receipt.received_amt
      customer_receipt_line.apply_amt =  customer_receipt.received_amt
      customer_receipt_line.apply_flag = 'Y'
      customer_receipt_line.balance_amt = customer_receipt.received_amt# 0.00
      customer_receipt_line.serial_no = 101
      customer_receipt_line.update_flag = 'V' 
    end
    
    
    def fill_customer_invoice(object)
      custinv = Customer::CustomerInvoice.new()
      parent_info = Customer::Customer.find(:all,
        :select =>'billto_id , billto_code',
        :conditions =>['id=?',object.account_id])
      custinv.trans_bk = object.trans_bk
      custinv.trans_no = object.trans_no
      custinv.company_id = object.company_id
      custinv.trans_date = object.trans_date
      custinv.account_period_code  = object.account_period_code
      custinv.trans_flag = object.trans_flag
      custinv.post_flag = 'P'  
      custinv.trans_type = 'I'
      custinv.inv_no = object.trans_no #ref_trans_no
      custinv.inv_date = object.trans_date #ref_trans_date
      custinv.customer_id = object.account_id
      custinv.customer_code = object.account_code
      custinv.soldto_id = object.account_id
      custinv.parent_id = parent_info.first.billto_id if parent_info.first   #newly added by Minal 14/12/2010
      custinv.parent_code = parent_info.first.billto_code if parent_info.first 
      custinv.inv_amt = object.debit_amt
      custinv.discount_per = 0.00
      custinv.discount_amt = 0.00
      custinv.paid_amt = object.debit_amt
      custinv.disctaken_amt = 0
      custinv.balance_amt = 0.00
      custinv.description = object.remarks
      custinv.update_flag = 'V' 
      custinv.clear_flag = 'Y' 
      custinv.action_flag = 'O'
      custinv.inv_type = '1'
      custinv.sale_date = object.trans_date
      custinv.due_date = object.trans_date
      custinv.term_code = 'NA'
      custinv.salesperson_code = 'NA'
      custinv_line = custinv.customer_invoice_lines.build
      fill_customer_invoice_lines(custinv_line,custinv,object)
      custinv
    end
    
    def fill_customer_invoice_lines(custinv_line,custinv,object)
      bank = GeneralLedger::Bank.find_by_id(object.bank_id)
      custinv_line.trans_bk = custinv.trans_bk
      custinv_line.trans_no = custinv.trans_no
      custinv_line.company_id = custinv.company_id
      custinv_line.trans_date = custinv.trans_date
      custinv_line.serial_no = 101
      custinv_line.gl_amt = custinv.paid_amt
      custinv_line.gl_account_id = object.bank_id
      custinv_line.gl_account_code = object.bank_code
      custinv_line.gl_account_name = bank.name if bank
      custinv_line.description = 'Bounce check # '+ object.check_no
    end

        
    ##################################################################Vendor posting############################################
    
    def post_vendorinvoice(object)
      unpost_vendor_invoice(object.trans_bk,object.trans_no,object.company_id)
      post_vendor_invoice(object)
      post_vendorcreditinvoice(object)
    end

    def unpost_vendor_invoice(trans_bk,trans_no,company_id)
      Vendor::VendorInvoice.delete_all(['trans_bk = ? and trans_no = ? and company_id = ?',	
          trans_bk, trans_no, company_id])
      Vendor::VendorInvoiceLine.delete_all(['trans_bk = ? and trans_no = ? and company_id = ? and serial_no = 101 ',	
          trans_bk, trans_no, company_id])
    end  

    def post_vendor_invoice(object)
      invoice = fill_vendor_invoice(object)
      invoice.save!
    end

    def fill_vendor_invoice(object)
      vendinv = Vendor::VendorInvoice.new()
      vendinv.trans_bk = object.trans_bk
      vendinv.ref_trans_bk = object.ref_trans_bk
      vendinv.trans_no = object.trans_no
      vendinv.company_id = object.company_id
      vendinv.trans_date = object.trans_date
      vendinv.ref_trans_date = object.ref_trans_date
      vendinv.account_period_code  = object.account_period_code
      vendinv.trans_flag = object.trans_flag
      vendinv.post_flag = 'P'  
      vendinv.trans_type = 'I'
      vendinv.inv_no = object.trans_no #ref_trans_no
      vendinv.ref_trans_no = object.ref_trans_no #ref_trans_no
      vendinv.inv_date = object.trans_date #ref_trans_date
      vendinv.vendor_id = object.account_id
      vendinv.vendor_code = object.account_code
      vendinv.inv_amt = object.credit_amt
      vendinv.discount_per = 0.00
      vendinv.discount_amt = 0.00
      vendinv.item_qty = 0
      vendinv.paid_amt = object.credit_amt
      vendinv.disctaken_amt = 0
      vendinv.balance_amt = 0.00
      vendinv.description = object.remarks
      vendinv.update_flag = 'V' 
      vendinv.action_flag = 'O'
      vendinv.inv_type = 'M'
      vendinv.sale_date = object.trans_date
      vendinv.term_code = 'NA'
      vendinv_line = vendinv.vendor_invoice_lines.build
      fill_vendor_invoice_lines(vendinv_line,vendinv,object)
      vendinv
    end
    
    def fill_vendor_invoice_lines(vendinv_line,vendinv,object)
      bank = GeneralLedger::Bank.find_by_id(object.bank_id)
      vendinv_line.trans_bk = vendinv.trans_bk
      vendinv_line.trans_no = vendinv.trans_no
      vendinv_line.company_id = vendinv.company_id
      vendinv_line.trans_date = vendinv.trans_date
      vendinv_line.serial_no = 101
      vendinv_line.gl_amt = vendinv.paid_amt
      vendinv_line.gl_account_id = object.bank_id
      vendinv_line.gl_account_code = object.bank_code
      vendinv_line.gl_account_name = bank.name if bank
      vendinv_line.description = 'Bounce check # '+ object.check_no
    end
    
    def post_vendorcreditinvoice(object)
      unpost_vendor_credit_invoice(object.trans_bk,object.trans_no,object.company_id)
      post_vendor_credit_invoice(object)
    end

    def unpost_vendor_credit_invoice(trans_bk,trans_no,company_id)
      Vendor::VendorPaymentLine.delete_all(['voucher_no = ? and company_id = ? ',	
          trans_bk+trans_no, company_id])
    end  
    
    def post_vendor_credit_invoice(object)
      payment = fill_vendor_payments(object)
      payment.save!
    end
    
    def fill_vendor_payments(object)
      vendcredit = Vendor::VendorPayment.find_by_trans_no_and_trans_bk_and_trans_date(object.ref_trans_no,object.ref_trans_bk,object.ref_trans_date)
      vendorcredit_line = vendcredit.detail_lines.build
      fill_vendor_payment_lines(vendcredit,vendorcredit_line,object)
      vendcredit.applied_amt= object.credit_amt
      vendcredit.balance_amt = 0.00
      vendcredit.action_flag = 'C'
      vendcredit
    end
 
    def fill_vendor_payment_lines(vendcredit,vendcredit_line,object)
      vendcredit_line.trans_bk = vendcredit.trans_bk
      vendcredit_line.trans_no = vendcredit.trans_no
      vendcredit_line.ref_no = object.trans_no
      vendcredit_line.voucher_no = object.trans_bk + object.trans_no
      vendcredit_line.company_id = vendcredit.company_id
      vendcredit_line.trans_date = vendcredit.trans_date
      vendcredit_line.voucher_date = object.trans_date
      vendcredit_line.due_date = object.trans_date
      vendcredit_line.trans_flag = vendcredit.trans_flag 
      vendcredit_line.original_amt = vendcredit.paid_amt
      vendcredit_line.apply_amt =  vendcredit.paid_amt
      vendcredit_line.apply_flag = 'Y'
      vendcredit_line.balance_amt = vendcredit.paid_amt# 0.00
      vendcredit_line.serial_no = 101
      vendcredit_line.update_flag = 'V' 
    end
    
        
    private :unpost_customer_invoice, :post_customer_invoice,:fill_vendor_invoice, :unpost_vendor_invoice, :post_vendor_invoice,:fill_customer_invoice
        
  end

end

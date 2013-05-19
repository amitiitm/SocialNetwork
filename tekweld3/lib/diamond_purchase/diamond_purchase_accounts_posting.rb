module DiamondPurchase::DiamondPurchaseAccountsPosting
  
class Posting  
    include General
    include ClassMethods

    def post_vendorinvoice(object)
      unpost_invoice(object.trans_bk,object.trans_no,object.company_id)
      post_invoice(object)
    end

    def unpost_invoice(trans_bk,trans_no,company_id)
      Vendor::VendorInvoice.delete_all(['trans_bk = ? and trans_no = ? and company_id = ?',	
            trans_bk, trans_no,company_id])
    end  

    def post_invoice(object)
      invoice = fill_vendor_invoice(object)
      invoice.save!
    end

    def post_vendorcreditinvoice(object)
      unpost_credit_invoice(object.trans_bk,object.trans_no,object.company_id)
      post_credit_invoice(object)
    end

    def unpost_credit_invoice(trans_bk,trans_no,company_id)
      Vendor::VendorPayment.delete_all(['trans_bk = ? and trans_no = ? and company_id = ?',	
            trans_bk, trans_no,company_id])
    end  

    def post_credit_invoice(object)
        tot_applied_amt = 0
        due_date = object.trans_date
        receipt_type = 'C'
        balance_amt = object.net_amt
        receipt = fill_vendor_receipts(object, receipt_type, tot_applied_amt, due_date, balance_amt)
        receipt.save!
    end

    def fill_vendor_invoice(object)
        vendinv = Vendor::VendorInvoice.new()
        vendinv.trans_bk = object.trans_bk
        vendinv.trans_no = object.trans_no
        vendinv.company_id = object.company_id
        vendinv.trans_date = object.trans_date
        vendinv.account_period_code  = object.account_period_code
        vendinv.trans_flag = object.trans_flag
        vendinv.post_flag = 'P'  
        vendinv.trans_type = 'I'
        vendinv.inv_no = object.trans_no #ref_trans_no
        vendinv.inv_date = object.trans_date #ref_trans_date
        vendinv.vendor_id = object.vendor_id
        vendinv.inv_amt = object.net_amt
        vendinv.due_date = object.due_date
        vendinv.term_code = object.term_code  
        vendinv.discount_per = object.discount_per
        vendinv.discount_amt = object.discount_amt
        vendinv.paid_amt = 0
        vendinv.disctaken_amt = 0
        vendinv.balance_amt = object.net_amt
        vendinv.description = object.remarks
        vendinv.update_flag = 'V' 
        vendinv.action_flag = 'O'
        vendinv.inv_type = 'I'
        vendinv.sale_date = object.trans_date
        vendinv
    end

    def fill_vendor_receipts(object, receipt_type, applied_amt, due_date, balance_amt)
        vendcredit = Vendor::VendorPayment.new()
        vendcredit.trans_bk = object.trans_bk
        vendcredit.trans_no = object.trans_no
        vendcredit.company_id = object.company_id
        vendcredit.trans_date = object.trans_date
        vendcredit.account_period_code  = object.account_period_code
        vendcredit.trans_flag = object.trans_flag 
        vendcredit.post_flag = 'P'
        vendcredit.trans_type = object.trans_type
        vendcredit.payment_type = receipt_type
        vendcredit.vendor_id = object.vendor_id
        vendcredit.paid_amt = object.net_amt
        vendcredit.applied_amt = applied_amt
        vendcredit.balance_amt = balance_amt
        vendcredit.check_no = object.trans_no #ref_trans_no
        vendcredit.check_date = object.trans_date #ref_trans_date
        vendcredit.update_flag = 'V' 
        vendcredit.action_flag = 'O'
        vendcredit.purchaseperson_code = object.purchaseperson_code
        vendcredit.soldto_id = object.vendor_id
        vendcredit.term_code = object.term_code
        vendcredit.due_date = due_date
        vendcredit
    end
    
    private :unpost_invoice, :post_invoice, :unpost_credit_invoice, :post_credit_invoice, 
            :fill_vendor_invoice, :fill_vendor_receipts
end

end

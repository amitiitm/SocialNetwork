module DiamondSale::DiamondSaleAccountsPosting
  
class Posting  
    include General
    include ClassMethods

    def post_customerinvoice(object)
      unpost_invoice(object.trans_bk,object.trans_no,object.company_id)
      post_invoice(object)
    end

    def unpost_invoice(trans_bk,trans_no,company_id)
      Customer::CustomerInvoice.delete_all(['trans_bk = ? and trans_no = ? and company_id = ?',	
            trans_bk, trans_no, company_id])
    end  

    def post_invoice(object)
      invoice = fill_customer_invoice(object)
      invoice.save!
    end

    def post_customercreditinvoice(object)
      unpost_credit_invoice(object.trans_bk,object.trans_no,object.company_id)
      post_credit_invoice(object)
    end

    def unpost_credit_invoice(trans_bk,trans_no,company_id)
      Customer::CustomerReceipt.delete_all(['trans_bk = ? and trans_no = ? and company_id = ?',	
            trans_bk, trans_no, company_id])
    end  

    def post_credit_invoice(object)
        tot_applied_amt = 0
        due_date = object.trans_date
        receipt_type = 'C'
        balance_amt = object.net_amt
        receipt = fill_customer_receipts(object, receipt_type, tot_applied_amt, due_date, balance_amt)
        receipt.save!
    end

    def fill_customer_invoice(object)
        custinv = Customer::CustomerInvoice.new()
#        parent_id=Customer::Customer.find(:all,
#                                          :select =>'billto_id',
#                                          :conditions =>['id=?',object.customer_id]).first.billto_id
        parent_id=Customer::Customer.find_all_by_id(object.customer_id).first.billto_id
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
        custinv.customer_id = object.customer_id
        custinv.parent_id = parent_id if parent_id
        custinv.inv_amt = object.net_amt
        custinv.due_date = object.due_date
        custinv.term_code = object.term_code  
        custinv.discount_per = object.discount_per
        custinv.discount_amt = object.discount_amt
        custinv.paid_amt = 0
        custinv.disctaken_amt = 0
        custinv.balance_amt = object.net_amt
        custinv.description = object.remarks
        custinv.update_flag = 'V' 
        custinv.action_flag = 'O'
        custinv.inv_type = 'I'
        custinv.sale_date = object.trans_date
        custinv
    end

    def fill_customer_receipts(object, receipt_type, applied_amt, due_date, balance_amt)
        custcredit = Customer::CustomerReceipt.new()
        parent_id=Customer::Customer.find_all_by_id(object.customer_id).first.billto_id
#        parent_id=Customer::Customer.find(:select =>'billto_id',
#                                          :conditions =>['id=?',object.customer_id]).first.billto_id
        custcredit.trans_bk = object.trans_bk
        custcredit.trans_no = object.trans_no
        custcredit.company_id = object.company_id
        custcredit.trans_date = object.trans_date
        custcredit.account_period_code  = object.account_period_code
        custcredit.trans_flag = object.trans_flag 
        custcredit.post_flag = 'P'
        custcredit.trans_type = object.trans_type
        custcredit.receipt_type = receipt_type
        custcredit.customer_id = object.customer_id
        custcredit.parent_id = parent_id if parent_id
        custcredit.received_amt = object.net_amt
        custcredit.applied_amt = applied_amt
        custcredit.balance_amt = balance_amt
        custcredit.check_no = object.trans_no #ref_trans_no
        custcredit.check_date = object.trans_date #ref_trans_date
        custcredit.update_flag = 'V' 
        custcredit.action_flag = 'O'
#        custcredit.salesperson_code = object.saleperson_code
        custcredit.soldto_id = object.customer_id
        custcredit.term_code = object.term_code
        custcredit.due_date = due_date
        custcredit
    end
    
    private :unpost_invoice, :post_invoice, :unpost_credit_invoice, :post_credit_invoice, 
            :fill_customer_invoice, :fill_customer_receipts
end

end

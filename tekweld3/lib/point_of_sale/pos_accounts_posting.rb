module PointOfSale::PosAccountsPosting
  
  class Posting  
    include General
    include ClassMethods

    def post_customer_receipt(object,customer_receipt_id)
      #      unpost_credit_invoice(customer_receipt_id)
      receipt=post_credit_invoice(object,customer_receipt_id)
      receipt
    end

    def unpost_credit_invoice(customer_receipt_id)
      Customer::CustomerReceipt.delete_all(['id=?',customer_receipt_id ])
    end  

    def post_credit_invoice(object,customer_receipt_id)
      tot_applied_amt = 0
      due_date = object.trans_date
      receipt_type = 'CASH'
      balance_amt = 0
      receipt = fill_customer_receipts(customer_receipt_id,object, receipt_type, tot_applied_amt, due_date, balance_amt)
      receipt.save!
      receipt
    end

   

    def fill_customer_receipts(customer_receipt_id,object, receipt_type, applied_amt, due_date, balance_amt)
      id = customer_receipt_id.to_s if customer_receipt_id
      custcredit = Customer::CustomerReceipt.find_or_create( id || '')
      parent_id=Customer::Customer.find(:all,
        :select =>'billto_id',
        :conditions =>['id=?',object.customer_id]).first.billto_id
      #        custcredit.trans_bk = object.trans_bk
      #        custcredit.trans_no = object.trans_no
      custcredit.docu_type = 'FAARPA'
      custcredit.trans_bk = 'RE01'
      custcredit.company_id = object.company_id
      custcredit.generate_trans_no if custcredit.new_record?
      custcredit.trans_date = object.trans_date
      custcredit.account_period_code  = object.account_period_code
      custcredit.trans_flag = object.trans_flag 
      custcredit.post_flag = 'P'
      #        custcredit.trans_type = object.trans_type
      custcredit.trans_type = 'P'
      custcredit.receipt_type = receipt_type
      custcredit.customer_id = object.customer_id
      custcredit.parent_id = parent_id if parent_id  #newly added by Minal 14/12/2010
      custcredit.received_amt = object.deposit_amt
      custcredit.applied_amt = applied_amt
      custcredit.balance_amt = balance_amt
#      custcredit.check_no = object.trans_no #ref_trans_no
      custcredit.check_date = object.trans_date #ref_trans_date
      custcredit.update_flag = 'Y' 
      custcredit.action_flag = 'O'
      custcredit.salesperson_code = '' #object.saleperson_code
      custcredit.soldto_id = object.customer_id
      #        custcredit.term_code = object.term_code
      custcredit.due_date = due_date
      bank = GeneralLedger::GlAccount.find(:all, 
                                                   :conditions => "acct_flag ='B' and trans_flag='A' ",
                                                   :select => "id, code, name ") 
      custcredit.bank_id = bank.first.id if bank
      custcredit.description = object.trans_bk+'-'+object.trans_no
      custcredit
    end
    
    def post_customer_receipt_pos_invoice(object)
      receipt = post_credit_invoice_pos_invoice(object)
      receipt
    end
          
    def post_credit_invoice_pos_invoice(object)
      tot_applied_amt = 0
      due_date = object.trans_date
      receipt_type = 'CASH'
      balance_amt = 0
      receipt = fill_customer_receipts_pos_invoice(object, receipt_type, tot_applied_amt, due_date, balance_amt)
      receipt.save!
      receipt
    end

   

    def fill_customer_receipts_pos_invoice(object,receipt_type, applied_amt, due_date, balance_amt)
      custreceipt = Customer::CustomerReceipt.new()
      parent_id=Customer::Customer.find(:all,
        :select =>'billto_id',
        :conditions =>['id=?',object.customer_id]).first.billto_id
      #        custcredit.trans_bk = object.trans_bk
      #        custcredit.trans_no = object.trans_no
      received_amt = 0
      object.pos_invoice_payments.each{|payment|
        received_amt = received_amt + payment.payment_amt  if payment.payment_method!='deposit'
      }
      custreceipt.docu_type = 'FAARPA'
      custreceipt.trans_bk = 'RE01'
      custreceipt.company_id = object.company_id
      custreceipt.generate_trans_no if custreceipt.new_record?
      custreceipt.trans_date = object.trans_date
      custreceipt.account_period_code  = object.account_period_code
      custreceipt.trans_flag = object.trans_flag 
      custreceipt.post_flag = 'P'
      #        custcredit.trans_type = object.trans_type
      custreceipt.trans_type = 'P'
      custreceipt.receipt_type = receipt_type
      custreceipt.customer_id = object.customer_id
      custreceipt.parent_id = parent_id if parent_id  #newly added by Minal 23/06/2011
      custreceipt.received_amt = received_amt
      custreceipt.applied_amt = applied_amt
      custreceipt.balance_amt = balance_amt
#      custreceipt.check_no = object.trans_no #ref_trans_no
      custreceipt.check_date = object.trans_date #ref_trans_date
      custreceipt.update_flag = 'Y' 
      custreceipt.action_flag = 'O'
      custreceipt.salesperson_code = '' #object.saleperson_code
      custreceipt.soldto_id = object.customer_id
      #        custcredit.term_code = object.term_code
      custreceipt.due_date = due_date
      bank = GeneralLedger::GlAccount.find(:all, 
                                           :conditions => "acct_flag ='B' and trans_flag='A' ",
                                           :select => "id, code, name ") 
      custreceipt.bank_id = bank.first.id if bank
      custreceipt.description = object.trans_bk+'-'+object.trans_no
      custreceipt
    end
    
    private  :unpost_credit_invoice, :post_credit_invoice, :fill_customer_receipts
  end

end

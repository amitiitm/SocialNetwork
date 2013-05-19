module Sales::SalesAccountsPosting

  class Posting
    include General
    include ClassMethods

    def post_customerinvoice(object)
      unpost_invoice(object.trans_bk,object.trans_no,object.company_id)
      post_invoice(object)
    end

    def unpost_invoice(trans_bk,trans_no,company_id)
      Customer::CustomerInvoice.delete_all(['trans_bk = ? and (trans_no like ?  or trans_no = ?) and company_id = ?',
          trans_bk, trans_no+'-%',trans_no,company_id])
    end

    def post_invoice(object)
      invoices = fill_customer_invoice(object)
      invoices.each{|invoice|
        invoice.save!
      }
    end

    def post_customercreditinvoice(object)
      unpost_credit_invoice(object.trans_bk, object.trans_no, object.company_id)
      post_credit_invoice(object)
    end

   
    def unpost_credit_invoice(trans_bk, trans_no, company_id)
      Customer::CustomerReceipt.delete_all(['trans_bk = ? and (trans_no like ?  or trans_no = ?) and company_id = ?',
          trans_bk, trans_no+'-%',trans_no,company_id])
    end

    def post_credit_invoice(object)
      tot_applied_amt = 0
      receipt_type = 'C'
      balance_amt = object.net_amt
      receipts = fill_customer_receipts(object, receipt_type, tot_applied_amt, balance_amt)
      receipts.each{|receipt|
        receipt.save!
      }
    end

    def fill_customer_invoice(object)
      customer_invoices = []
      term_code = object.term_code
      term = Setup::Term.find_by_code(term_code)
      total_pay_percent = 0 ; payment_counter = 1
      while total_pay_percent !=100 and payment_counter<=12     do
        begin
          custinv = Customer::CustomerInvoice.new()
          percent_field = 'pay'+payment_counter.to_s+'_per'
          days_field = 'pay'+payment_counter.to_s+'_days'
          disc_per = nulltozero(term.disc_per)
          disc_day = nulltozero(term.disc_days)
          parent_id=Customer::Customer.find(:all,
            :select =>'billto_id',
            :conditions =>['id=?',object.customer_id]).first.billto_id
          parent_code =Customer::Customer.find(:all,
            :select =>'billto_code',
            :conditions =>['id=?',object.customer_id]).first.billto_code
          term.pay1_per = term.pay1_per || 100.00
          custinv.trans_bk = object.trans_bk
          custinv.trans_no = term.pay1_per==100 ? object.trans_no : "#{object.trans_no}-#{(64+payment_counter).chr}"
          custinv.company_id = object.company_id
          custinv.trans_date = object.trans_date
          custinv.account_period_code  = object.account_period_code
          custinv.trans_flag = object.trans_flag
          custinv.post_flag = 'P'
          custinv.trans_type = 'I'
          custinv.inv_no = object.trans_no
          custinv.inv_date = object.trans_date
          custinv.customer_id = object.customer_id
          custinv.customer_code = object.customer_code
          custinv.parent_id = parent_id if parent_id
          custinv.parent_code = parent_code if parent_code
          custinv.inv_amt = (object.net_amt * nulltozero(term[percent_field]) )/ 100.00
          custinv.due_date =  relativedate(object.trans_date, term[days_field])
          custinv.term_code = object.term_code
          custinv.discount_per = object.discount_per
          custinv.discount_amt = (object.discount_amt * nulltozero(term[percent_field]) )/ 100.00
          custinv.paid_amt = 0
          custinv.disctaken_amt = 0
          custinv.balance_amt = (object.net_amt * nulltozero(term[percent_field]) )/ 100.00
          #          text = "#{(custinv.due_date).strftime("%b,%d %Y")} --Disc:#{ (custinv.inv_amt * nulltozero(term[disc_per_field]) )/ 100.00}"
          discount_amt  = ((object.net_amt * disc_per )/ 100.00) 
          desc_date = relativedate(object.trans_date,disc_day)
          if(discount_amt > 0)
            text = "#{(desc_date).strftime("%b,%d %Y")} --Disc:#{ discount_amt}"
          else
            text = ''
          end
          custinv.description = text
          custinv.update_flag = 'V'
          custinv.action_flag = 'O'
          custinv.inv_type = '1'
          custinv.sale_date = object.trans_date
          total_pay_percent+= nulltozero(term[percent_field])
          payment_counter+=1
          if total_pay_percent == 100
            prev_inv_amt = 0.00
            prev_bal_amt = 0.00
            customer_invoices.each{|inv|
              prev_inv_amt+=ActiveRecord::Base.connection.select_all("select CAST( #{inv.inv_amt} AS DECIMAL(12,2)) as value1 ")[0]['value1'].to_f
              prev_bal_amt+=ActiveRecord::Base.connection.select_all("select CAST( #{inv.balance_amt} AS DECIMAL(12,2)) as value1 ")[0]['value1'].to_f
            }
            custinv.inv_amt = object.net_amt - prev_inv_amt
            custinv.balance_amt = object.net_amt - prev_bal_amt
          end
          customer_invoices << custinv
        end
      end
      customer_invoices
    end

    
    def fill_customer_receipts(object, receipt_type, applied_amt, balance_amt)
      custcredits = []
      term_code = object.term_code
      term = Setup::Term.find_by_code(term_code)
      total_pay_percent = 0 ; payment_counter = 1
      while total_pay_percent !=100 and payment_counter<=12      do
        begin
          custcredit = Customer::CustomerReceipt.new()
          percent_field = 'pay'+payment_counter.to_s+'_per'
          days_field = 'pay'+payment_counter.to_s+'_days'
          disc_per = nulltozero(term.disc_per)
          disc_day = nulltozero(term.disc_days)
          parent_id=Customer::Customer.find(:all,
            :select =>'billto_id',
            :conditions =>['id=?',object.customer_id]).first.billto_id
          parent_code = Customer::Customer.find(:all,
            :select =>'billto_code',
            :conditions =>['id=?',object.customer_id]).first.billto_code
          term.pay1_per = term.pay1_per || 100.00
          custcredit.trans_bk = object.trans_bk
          custcredit.trans_no = term.pay1_per==100 ? object.trans_no : "#{object.trans_no}-#{(64+payment_counter).chr}"
          custcredit.company_id = object.company_id
          custcredit.trans_date = object.trans_date
          custcredit.account_period_code  = object.account_period_code
          custcredit.trans_flag = object.trans_flag
          custcredit.post_flag = 'P'
          custcredit.trans_type = 'C'
          custcredit.receipt_type = receipt_type
          custcredit.customer_id = object.customer_id
          custcredit.customer_code = object.customer_code
          custcredit.parent_id = parent_id if parent_id  #newly added by Minal 14/12/2010
          custcredit.parent_code = parent_code if parent_code
          custcredit.received_amt = (object.net_amt * term[percent_field] )/ 100.00
          custcredit.applied_amt = (applied_amt * nulltozero(term[percent_field]) )/ 100.00
          custcredit.balance_amt = (balance_amt * nulltozero(term[percent_field]) )/ 100.00
          custcredit.check_no = object.trans_no #ref_trans_no
          custcredit.check_date = object.trans_date #ref_trans_date
          custcredit.update_flag = 'V'
          custcredit.action_flag = 'O'
          custcredit.salesperson_code = '' #object.saleperson_code
          custcredit.soldto_id = object.customer_id
          custcredit.bank_id =  GeneralLedger::GlSetup.find(:first,
            :select=>'faar_bank_id').faar_bank_id
          custcredit.bank_code =  GeneralLedger::GlSetup.find(:first,
            :select=>'faar_bank_code').faar_bank_code
          custcredit.term_code = object.term_code
          custcredit.due_date = relativedate(object.trans_date, term[days_field])
          #          text = "#{(custcredit.due_date).strftime("%b,%d %Y")} --Disc:#{ (custcredit.received_amt * nulltozero(term[disc_per_field]) )/ 100.00}"
          discount_amt  = ((object.net_amt * disc_per )/ 100.00) 
          desc_date = relativedate(object.trans_date,disc_day)
          if(discount_amt > 0)
            text = "#{(desc_date).strftime("%b,%d %Y")} --Disc:#{ discount_amt}"
          else
            text = ''
          end
          custcredit.description = text
          total_pay_percent+= nulltozero(term[percent_field])
          payment_counter+=1
          if total_pay_percent == 100
            prev_inv_amt = 0.00
            prev_bal_amt = 0.00
            custcredits.each{|cr|
              prev_inv_amt+=ActiveRecord::Base.connection.select_all("select CAST( #{cr.received_amt} AS DECIMAL(12,2)) as value1 ")[0]['value1'].to_f
              prev_bal_amt+=ActiveRecord::Base.connection.select_all("select CAST( #{cr.balance_amt} AS DECIMAL(12,2)) as value1 ")[0]['value1'].to_f
            }
            custcredit.received_amt = object.net_amt - prev_inv_amt
            custcredit.balance_amt = balance_amt -  prev_bal_amt
          end
          custcredits << custcredit
        end
      end
      custcredits
    end

    def update_cr_invoice(customer_cr_invoices,trans_no)
      customer_cr_invoices[0].trans_no = trans_no
      customer_cr_invoices
    end

    private :unpost_invoice, :post_invoice, :unpost_credit_invoice, :post_credit_invoice,
      :fill_customer_invoice, :fill_customer_receipts
  end

end

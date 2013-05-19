module Purchase::PurchaseAccountsPosting

  class Posting
    include General
    include ClassMethods

    def post_vendorinvoice(object)
      unpost_invoice(object.trans_bk,object.trans_no,object.company_id)
      post_invoice(object)
    end

    def unpost_invoice(trans_bk,trans_no,company_id)
      Vendor::VendorInvoice.delete_all(['trans_bk = ? and (trans_no like ?  or trans_no = ?) and company_id = ?',
          trans_bk, trans_no+'-%',trans_no,company_id])
    end

   
    def post_invoice(object)
      invoices = fill_vendor_invoice(object)
      invoices.each{|invoice|
        invoice.save!
      }
    end

    def post_vendorcreditinvoice(object)
      unpost_credit_invoice(object.trans_bk,object.trans_no,object.company_id)
      post_credit_invoice(object)
    end

   
    def unpost_credit_invoice(trans_bk,trans_no,company_id)
      Vendor::VendorPayment.delete_all(['trans_bk = ? and (trans_no like ?  or trans_no = ?) and company_id = ?',
          trans_bk, trans_no+'-%',trans_no,company_id])
    end

    def post_credit_invoice(object)
      tot_applied_amt = 0
      payment_type = 'C'
      balance_amt = object.net_amt
      payments = fill_vendor_payments(object, payment_type, tot_applied_amt, balance_amt)
      payments.each{|payment|
        payment.save!
      }
    end

    def fill_vendor_invoice(object)
      vendor_invoices = []
      term_code = object.term_code
      term = Setup::Term.find_by_code(term_code)
      total_pay_percent = 0 ; payment_counter = 1
      while total_pay_percent !=100  and payment_counter<=12      do
        begin
          vendinv = Vendor::VendorInvoice.new()
          percent_field = 'pay'+payment_counter.to_s+'_per'
          days_field = 'pay'+payment_counter.to_s+'_days'
          disc_per = nulltozero(term.disc_per)
          disc_day = nulltozero(term.disc_days)
          term.pay1_per = term.pay1_per || 100.00
          vendinv.trans_bk = object.trans_bk
          vendinv.trans_no = term.pay1_per==100 ? object.trans_no : "#{object.trans_no}-#{(64+payment_counter).chr}"
          vendinv.company_id = object.company_id
          vendinv.trans_date = object.trans_date
          vendinv.account_period_code  = object.account_period_code
          vendinv.trans_flag = object.trans_flag
          vendinv.post_flag = 'P'
          vendinv.trans_type = 'I'
          vendinv.inv_no = object.trans_no #ref_trans_no
          vendinv.inv_date = object.trans_date #ref_trans_date
          vendinv.vendor_id = object.vendor_id
          vendinv.vendor_code = object.vendor_code
          vendinv.inv_amt = (object.net_amt * nulltozero(term[percent_field]) )/ 100.00
          vendinv.due_date = relativedate(object.trans_date, term[days_field])
          vendinv.term_code = object.term_code
          vendinv.discount_per = object.discount_per
          vendinv.discount_amt = (object.discount_amt * nulltozero(term[percent_field]) )/ 100.00
          vendinv.paid_amt = 0
          vendinv.disctaken_amt = 0
          vendinv.balance_amt = (object.net_amt * nulltozero(term[percent_field]) )/ 100.00
          #          text = "#{(vendinv.due_date).strftime("%b,%d %Y")} --Disc:#{ (vendinv.inv_amt * nulltozero(term[disc_per_field]) )/ 100.00}"
          discount_amt  = ((object.net_amt * disc_per )/ 100.00) 
          desc_date = relativedate(object.trans_date,disc_day)
          if(discount_amt > 0)
            text = "#{(desc_date).strftime("%b,%d %Y")} --Disc:#{ discount_amt}"
          else
            text = ''
          end
          vendinv.description = text         
          vendinv.update_flag = 'V'
          vendinv.action_flag = 'O'
          vendinv.inv_type = 'I'
          vendinv.sale_date = object.trans_date
          total_pay_percent+= nulltozero(term[percent_field])
          payment_counter+=1
          if total_pay_percent == 100
            prev_inv_amt = 0.00
            prev_bal_amt = 0.00
            vendor_invoices.each{|inv|
              prev_inv_amt+=ActiveRecord::Base.connection.select_all("select CAST( #{inv.inv_amt} AS DECIMAL(12,2)) as value1 ")[0]['value1'].to_f
              prev_bal_amt+=ActiveRecord::Base.connection.select_all("select CAST( #{inv.balance_amt} AS DECIMAL(12,2)) as value1 ")[0]['value1'].to_f
            }
            vendinv.inv_amt = object.net_amt - prev_inv_amt
            vendinv.balance_amt = object.net_amt - prev_bal_amt
          end
          vendor_invoices << vendinv
        end
      end
      vendor_invoices
    end


   
    def fill_vendor_payments(object, payment_type, applied_amt,  balance_amt)
      vendcredits = []
      term_code = object.term_code
      term = Setup::Term.find_by_code(term_code)
      total_pay_percent = 0 ; payment_counter = 1
      while total_pay_percent !=100  and payment_counter<=12      do
        begin
          vendcredit = Vendor::VendorPayment.new()
          percent_field = 'pay'+payment_counter.to_s+'_per'
          days_field = 'pay'+payment_counter.to_s+'_days'
          disc_per = nulltozero(term.disc_per)
          disc_day = nulltozero(term.disc_days)
          term.pay1_per = term.pay1_per || 100.00
          vendcredit.trans_bk = object.trans_bk
          vendcredit.trans_no = term.pay1_per==100 ? object.trans_no : "#{object.trans_no}-#{(64+payment_counter).chr}"
          vendcredit.company_id = object.company_id
          vendcredit.trans_date = object.trans_date
          vendcredit.account_period_code  = object.account_period_code
          vendcredit.trans_flag = object.trans_flag
          vendcredit.post_flag = 'P'
          vendcredit.trans_type = 'C'
          vendcredit.payment_type = payment_type
          vendcredit.vendor_id = object.vendor_id
          vendcredit.vendor_code = object.vendor_code
          vendcredit.due_date = relativedate(object.trans_date, term[days_field])
          vendcredit.paid_amt = (object.net_amt * term[percent_field] )/ 100.00
          vendcredit.applied_amt = (applied_amt * nulltozero(term[percent_field]) )/ 100.00
          vendcredit.balance_amt = (balance_amt * nulltozero(term[percent_field]) )/ 100.00
          #          text = "#{(vendcredit.due_date).strftime("%b,%d %Y")} --Disc:#{ (vendcredit.paid_amt * nulltozero(term[disc_per_field]) )/ 100.00}"
          discount_amt  = ((object.net_amt * disc_per )/ 100.00) 
          desc_date = relativedate(object.trans_date,disc_day)         
          if(discount_amt > 0)
            text = "#{(desc_date).strftime("%b,%d %Y")} --Disc:#{ discount_amt}"
          else
            text = ''
          end
          vendcredit.description = text
          vendcredit.check_no = object.trans_no #ref_trans_no
          vendcredit.check_date = object.trans_date #ref_trans_date
          vendcredit.update_flag = 'V'
          vendcredit.action_flag = 'O'
          vendcredit.purchaseperson_code = '' #object.purchaseperson_code
          vendcredit.soldto_id = object.vendor_id
          vendcredit.term_code = object.term_code
          total_pay_percent+= nulltozero(term[percent_field])
          payment_counter+=1
          if total_pay_percent == 100
            prev_inv_amt = 0.00
            prev_bal_amt = 0.00
            vendcredits.each{|cr|
              prev_inv_amt+=ActiveRecord::Base.connection.select_all("select CAST( #{cr.paid_amt} AS DECIMAL(12,2)) as value1 ")[0]['value1'].to_f
              prev_bal_amt+=ActiveRecord::Base.connection.select_all("select CAST( #{cr.balance_amt} AS DECIMAL(12,2)) as value1 ")[0]['value1'].to_f
            }
            vendcredit.paid_amt = object.net_amt - prev_inv_amt
            vendcredit.balance_amt = balance_amt -  prev_bal_amt
          end
          vendcredits << vendcredit
        end 
      end
      vendcredits
    end

    private :unpost_invoice, :post_invoice, :unpost_credit_invoice, :post_credit_invoice,
      :fill_vendor_invoice, :fill_vendor_payments
  end

end

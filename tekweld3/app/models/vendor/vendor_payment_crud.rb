class Vendor::VendorPaymentCrud
  include General
  cattr_accessor :error_message, :trans_type 

  def self.list_payments(doc)
    criteria = Setup::Criteria.fill_criteria_for_query(doc/:criteria)
    condition= convert_sql_to_db_specific("(vendor_payments.company_id=#{criteria.company_id} )AND
                        (vendor_payments.trans_no between '#{criteria.str1}' and '#{criteria.str2}' AND (0 =#{criteria.multiselect1.length} or vendor_payments.trans_no in ('#{criteria.multiselect1}') )) AND
                        (vendor_payments.account_period_code between '#{criteria.str3}' and '#{criteria.str4}' AND (0 =#{criteria.multiselect2.length} or vendor_payments.account_period_code in ('#{criteria.multiselect2}') )) AND
                        (vendors.code between '#{criteria.str5}' and '#{criteria.str6}' AND (0 =#{criteria.multiselect4.length} or vendors.code in ('#{criteria.multiselect3}') )) AND
                        (nvl(vendor_payments.check_no,'') between '#{criteria.str7}' and '#{criteria.str8}' AND (0 =#{criteria.multiselect3.length} or nvl(vendor_payments.check_no,'') in ('#{criteria.multiselect4}') )) AND
                        nvl(vendor_payments.trans_date,'1990-01-01 00:00:00') between '#{criteria.dt1}' and '#{criteria.dt2}'  AND
                        nvl(vendor_payments.check_date,'1990-01-01 00:00:00') between '#{criteria.dt3}' and '#{criteria.dt4}' AND
                        (nvl(vendor_payments.paid_amt,0) between #{criteria.dec1} and #{criteria.dec2}) AND
                        nvl(trans_type,'') != 'C'
      ")
    Vendor::VendorPayment.find_by_sql("select CAST((select(select vendor_payments.id,
                                                                   vendor_payments.trans_bk,
                                                                   vendor_payments.trans_no,
                                                                   vendor_payments.trans_date,
                                                                   vendor_payments.payment_type,
                                                                   vendor_payments.paid_amt,
                                                                   vendor_payments.applied_amt,
                                                                   vendor_payments.balance_amt,
                                                                   vendor_payments.account_period_code,
                                                                   vendors.code as vendor_code,
                                                                   gl_accounts.code as bank_code 
                                                          from vendor_payments
                                                          join vendors on vendors.id = vendor_payments.vendor_id
                                                          left outer join gl_accounts on gl_accounts.id = vendor_payments.bank_id
                                                          where (vendor_payments.trans_flag = 'A' ) AND
                                                          #{condition}
                                                          FOR XML PATH('vendor_payment'),type,elements xsinil)
                                                          FOR XML PATH('vendor_payments')) AS xml) as xmlcol ")
  end
 
  
  def self.list_credit_invoices(doc)
    criteria = Setup::Criteria.fill_criteria_for_query(doc/:criteria)
    condition= convert_sql_to_db_specific(" (vendor_payments.company_id=#{criteria.company_id} )AND
                        (vendor_payments.trans_no between '#{criteria.str1}' and '#{criteria.str2}' AND (0 =#{criteria.multiselect1.length} or vendor_payments.trans_no in ('#{criteria.multiselect1}') )) AND
                        (vendor_payments.account_period_code between '#{criteria.str3}' and '#{criteria.str4}' AND (0 =#{criteria.multiselect2.length} or vendor_payments.account_period_code in ('#{criteria.multiselect2}'))) AND
                        (vendors.code between '#{criteria.str5}' and '#{criteria.str6}' AND (0 =#{criteria.multiselect3.length} or vendors.code in ('#{criteria.multiselect3}') )) AND
                        nvl(vendor_payments.trans_date,'1990-01-01 00:00:00') between '#{criteria.dt1}' and '#{criteria.dt2}' AND
                        (nvl(vendor_payments.paid_amt,0) between #{criteria.dec1} and #{criteria.dec2}) AND
                        nvl(trans_type,'') = 'C'
      ")
    Vendor::VendorPayment.find_by_sql("select CAST((select(select vendor_payments.id,
                                                                   vendor_payments.trans_bk,
                                                                   vendor_payments.trans_no,
                                                                   vendor_payments.trans_date,
                                                                   vendor_payments.account_period_code,
                                                                   vendor_payments.payment_type,
                                                                   vendor_payments.applied_amt,
                                                                   vendor_payments.paid_amt,
                                                                   vendor_payments.balance_amt,
                                                                   vendor_payments.item_qty,
                                                                   vendors.code as vendor_code 
                                                              from vendor_payments
                                                              join vendors on vendors.id = vendor_payments.vendor_id
                                                              left outer join gl_accounts on gl_accounts.id = vendor_payments.bank_id
                                                              where (vendor_payments.trans_flag = 'A' ) AND
                                                              #{condition}
                                                              FOR XML PATH('credit_invoice'),type,elements xsinil)
                                                              FOR XML PATH('credit_invoices')) AS xml) as xmlcol ")
  end
  
  def self.show_payments(payment_id,trans_type)
    vendor_payments = []
    payments = Vendor::VendorPayment.find_all_by_id(payment_id) if payment_id
    vendor_payment = payments.empty? ? Vendor::VendorPayment.new : payments.first
    if !vendor_payment.new_record?
      vendor_payment.fill_vendor_address(vendor_payment.vendor)
      if ((credit_invoice?(trans_type) or payments?(trans_type)) and vendor_payment.post_flag == 'U') or apply?(trans_type)
        vendor_invoices = fetch_open_invoices_for_vendor(vendor_payment.vendor_id,vendor_payment.trans_bk,vendor_payment.trans_no,trans_type)
        vendor_invoices.each {|inv| 
          if !vendor_payment.detail_lines.to_ary.find { |li| li.voucher_no == inv.voucher_no  }
            vendor_payment.detail_lines << inv
          end
        }
      end
      vendor_payment.check_if_invoice_date_range_closed if apply?(trans_type)
      vendor_payments << vendor_payment
      gl_lines = GeneralLedger::GlPosting.show_gl_postings(vendor_payment.trans_no,vendor_payment.company_id,vendor_payment.trans_bk)
      vendor_payments << gl_lines 
    end
    return vendor_payments
  end

  def self.fetch_invoices_for_vendor(vendor_id,trans_type)
    vendor_payments = []
    vendor = Vendor::Vendor.find_all_by_id(vendor_id).first
    return if !vendor
    vendor_payment = Vendor::VendorPayment.new
    vendor_payment.fill_header(trans_type)                         
    vendor_payment.fill_header_from_vendor(vendor,trans_type)  
    vendor_payment.fill_vendor_address(vendor)
    terms = Setup::Term.fill_terms(vendor_payment.term_code, vendor_payment.trans_date) 
    vendor_payment.due_date = terms.pay1_date if terms
    if credit_invoice?(trans_type)
      #    gl_account_code = Setup::Type.fetch_value_from_types('FAAP','credit_gl_account_cd') 
      gl_account_id = GeneralLedger::GlSetup.find(:first,
        :select=>'faap_credit_gl_account_id').faap_credit_gl_account_id
      gl_account_code = GeneralLedger::GlAccount.find_by_id(gl_account_id).code if gl_account_id
    end
    if payments?(trans_type) 
      #    gl_account_code = Setup::Type.fetch_value_from_types('FAAP','bank_code') 
      gl_account_id = GeneralLedger::GlSetup.find(:first,
        :select=>'faap_bank_id').faap_bank_id
      gl_account_code = GeneralLedger::GlAccount.find_by_id(gl_account_id).code if gl_account_id
    end
    gl_account = GeneralLedger::GlAccount.find_by_code(gl_account_code) if gl_account_code
    if gl_account
      vendor_payment.bank_id = gl_account.id
      vendor_payment.bank_code = gl_account.code
    end
    vendor_payment.fill_check_details if payments?(trans_type) 
    #  bank =  GeneralLedger::Bank.fetch_bank(vendor_payment.bank_id)
    #  vendor_payment.payment_type = bank.payment_type   if bank
    #  vendor_payment.check_no = Accounts::GenerateCheckNumber.generate_check_no('PAYM', vendor_payment.bank_id, vendor_payment.payment_type)
    vendor_payment_lines = fetch_open_invoices_for_vendor(vendor_id,trans_type)
    vendor_payment_lines.each{|recpt_line|
      vendor_payment.detail_lines << recpt_line
    }
    vendor_payments << vendor_payment if  vendor_payment
    vendor_payments
  end


  def self.fetch_open_invoices_for_vendor(*args)
    #  vendor = Vendor::Vendor.find_all_by_code(vendor_code).first  if vendor_code
    #  vendor_id = vendor.id if vendor
    vendor_id = args[0]
    if args.size == 4
      trans_bk = args[1] 
      trans_no = args[2] 
      trans_type = args[3] 
    else
      trans_type = args[1]
    end
  
    vendor_payment_lines = []
    vendor_invoices = fetch_open_invoices(vendor_id)
    vendor_invoices.each {|inv| 
      vendor_payment_lines << Vendor::VendorPaymentLine.build_invoice_payment_line(inv.attributes)
    }
    if payments?(trans_type)     #For payments we need to get credit invoices too..
      vendor_credit_invoices = fetch_open_credit_invoices(vendor_id)
      vendor_credit_invoices.each{|crdt|
        if trans_bk and trans_no
          if !(crdt.trans_bk + crdt.trans_no == trans_bk + trans_no)
            vendor_payment_lines << Vendor::VendorPaymentLine.build_credit_payment_line(crdt.attributes)
          end
        else
          vendor_payment_lines << Vendor::VendorPaymentLine.build_credit_payment_line(crdt.attributes)
        end    
      } 
    end
    vendor_payment_lines
  end

  def self.fetch_open_invoices(vendor_id)
    condition = convert_sql_to_db_specific( "vendor_id = #{vendor_id}
                      and nvl(action_flag,'') = 'O'
                      and nvl(balance_amt,0) <> 0
      " )
    Vendor::VendorInvoice.active.find(:all,
      :conditions => condition ,
      :order => "due_date"               
    )
  
  end  

  def self.fetch_open_credit_invoices(vendor_id)
    condition = convert_sql_to_db_specific("vendor_id = #{vendor_id}
                      and nvl(action_flag,'') = 'O'
                      and nvl(balance_amt,0)  <> 0
                      and trans_type = 'C'
      ")
    Vendor::VendorPayment.active.find(:all,
      :conditions => condition ,
      :order => "due_date"               
    )
  
  end

  def self.create_payments(doc,trans_type)
    self.trans_type = trans_type
    payments = [] 
    (doc/:vendor_payments/:vendor_payment).each{|payment_doc|
      payment = create_payment(payment_doc)
      if payment
        payments <<  payment
        gl_lines = GeneralLedger::GlPosting.show_gl_postings(payment.trans_no,payment.company_id,payment.trans_bk)
        payments << gl_lines
      end
    }
    payments
  end

  def self.create_payment(doc)
    payment = add_or_modify(doc) 
    return  if !payment
    return payment if !payment.errors.empty?
    payment.calculate_balance_for_header  
    payment.generate_trans_no if payment.new_record?
    payment.detail_lines.each{|paid_line|
      paid_line.copy_header_fields_to_lines(payment.trans_no,payment.trans_bk,payment.trans_date,payment.company_id) #if paid_line.new_record?
    }
    #  payment.update_flag = 'V' if payment.trans_bk == 'PA01' 
    if !apply?(self.trans_type)
      bank_postings = payment.create_bank_postings  if payments?(trans_type)
      gl_postings = payment.create_gl_postings_for_receipts
    end 
    save_proc = Proc.new{
      payment.validate_receipt_amounts
      if payment.new_record?
        payment.save!
        payment.update_trans_no
      else
        #      payment.delete_unapplied_lines
        payment.save! 
        payment.save_lines
        unpost_payments(payment)
        payment.delete_unapplied_lines   
      end
      #    do_postings(payment)
      post_payments(payment)
      if !apply?(self.trans_type)
        payment.post_bank_transactions(bank_postings) if bank_postings
        #    gl_postings = payment.create_gl_postings_for_payments             
        GeneralLedger::GlPosting.post_gl_transactions(gl_postings) if gl_postings
      end
    }
    payment.save_transaction(&save_proc)
    return payment
  end

  def self.add_or_modify(doc)  
    id =  parse_xml(doc/'/id') if (doc/'/id').first  
    payment = Vendor::VendorPayment.find_or_create(id) 
    return if !payment
    if  !apply?(self.trans_type)
      return payment if payment.view_only 
    end
    payment.apply_attributes(doc) 
    payment.fill_header(self.trans_type) if payment.new_record? 
    payment.fill_vendor_address(payment.vendor)
    payment.run_block do
      payment.max_serial_no = payment.detail_lines.applied.maximum_serial_no
      build_lines(doc/:vendor_payment_lines/:vendor_payment_line)   
    end
    return payment 
  end

  def self.unpost_payments(payment)
    deleted_lines = payment.detail_lines.to_ary.find_all { |li| li.trans_flag == 'D'}
    deleted_lines.each{|recpt|
      update_payment_and_invoice_balance_amt(recpt)
      if self.error_message
        payment.add_error(self.error_message)        
        raise
      end
    }
  end

  def self.post_payments(payment)
    new_lines = payment.detail_lines.applied_lines 
    new_lines.each{|recpt|
      update_payment_and_invoice_balance_amt(recpt)
      if self.error_message
        payment.add_error(self.error_message)              
        raise
      end
      #    trans_bk,trans_no = trans_bk_no_from_voucher_no(recpt.voucher_no)
      #    GeneralLedger::BankTransaction.make_bank_transaction_view_only(trans_bk,trans_no,recpt.voucher_date,recpt.company_id) if trans_bk == 'RE01'
      recpt.update_invoice_to_view_only
    }
  end

  def self.update_payment_and_invoice_balance_amt(recpt)
    trans_bk,trans_no = trans_bk_no_from_voucher_no(recpt.voucher_no)   #general.rb
    voucher_applied_amt,voucher_discount_amt = calculate_voucher_amt(recpt.voucher_no,recpt.voucher_date,trans_no,trans_bk,recpt.voucher_date)
    # Change: Praman July-04-2011 Making transaction date editable and post/unpost transaction accordingly.  
    #  invoice = Vendor::VendorInvoice.find_by_trans_bk_no_date(trans_bk,trans_no,recpt.voucher_date,recpt.company_id).first 
    invoice = Vendor::VendorInvoice.find_all_by_trans_bk_and_trans_no(trans_bk,trans_no).first 
    if invoice
      new_balance = nulltozero(nulltozero(invoice.inv_amt) - ( nulltozero(voucher_applied_amt) + nulltozero(voucher_discount_amt)))    
      if new_balance == 0
        action_flag = 'C'
        update_flag = 'V'
        clear_flag = 'N'
      else
        if (nulltozero(invoice.inv_amt) - new_balance).abs < (nulltozero(invoice.inv_amt)).abs then
          action_flag = 'O'
          update_flag = 'V'
          clear_flag = 'N'
        else
          self.error_message ='Error 1', 'Applied amount not correct for the invoice6666 ' 
          return
        end
      end
      invoice.update_for_payments(action_flag,update_flag,voucher_applied_amt,voucher_discount_amt,new_balance,clear_flag)
    end
    
    #For Credit invoice      
    # Change: Praman July-04-2011 Making transaction date editable and post/unpost transaction accordingly.  
    #  payment =  Vendor::VendorPayment.find_by_trans_bk_no_date(trans_bk,trans_no,recpt.voucher_date,recpt.company_id).first
    payment =  Vendor::VendorPayment.find_all_by_trans_bk_and_trans_no(trans_bk,trans_no).first
    if payment
      paid_amt = payment.paid_amt 
      paid_balance = nulltozero(nulltozero(paid_amt) - ( (nulltozero(voucher_applied_amt) + nulltozero(voucher_discount_amt)) * -1 ))
      if paid_balance == 0      
        action_flag = 'C'
        update_flag = 'V'
        applied_amt = (voucher_applied_amt  + voucher_discount_amt ) * -1             
      else   
        action_flag = 'O'
        update_flag = 'V'
        applied_amt = (voucher_applied_amt  + voucher_discount_amt ) * -1     
      end
      payment.update_for_payments(action_flag,update_flag,applied_amt,paid_balance)
    end
  end
 
  def self.calculate_voucher_amt(voucher_no,voucher_date,trans_no,trans_bk,trans_date)  
    #  For Invoice
    cust_recpt_line = Vendor::VendorPaymentLine.find(:all, :select=>'sum(apply_amt) AS apply_amt,sum(disctaken_amt) AS disctaken_amt',
      :conditions=> "voucher_no = '#{voucher_no}' and voucher_date = '#{voucher_date}'"
    ).first || 0
    applied_amt = nulltozero(cust_recpt_line['apply_amt'])
    disc_amt = nulltozero(cust_recpt_line['disctaken_amt'])
    #  For credits
    cust_recpt_line = Vendor::VendorPaymentLine.find(:all, :select=>'sum(apply_amt) AS apply_amt,sum(disctaken_amt) AS disctaken_amt',
      :conditions=> "trans_no = '#{trans_no}' and trans_bk = '#{trans_bk}' and trans_date = '#{trans_date}'").first || 0
    this_apply_amt = nulltozero(cust_recpt_line['apply_amt'])
    this_disc_amt = nulltozero(cust_recpt_line['disctaken_amt'])
  
    applied_amt += ( this_apply_amt * -1)
    disc_amt += (this_disc_amt * -1)
    return applied_amt, disc_amt
  end

  def self.list_payments_for_pay_bills(payments)
    ids = '0'
    payments.each{|payment| ids += ",'#{payment.id}'"}
    Vendor::VendorPayment.find_by_sql(
      "SELECT CAST((
                  SELECT(
                          SELECT  vendor_payments.id,
                                  trans_bk,
                                  trans_no,
                                  trans_date,
                                  vendors.code AS vendor_code,
                                  vendors.name AS vendor_name,
                                  vendor_payments.bank_code,
                                  payment_type,
                                  check_no,
                                  check_date,
                                  ISNULL(paid_amt, 0) AS paid_amt
                          FROM vendor_payments
                          INNER JOIN vendors ON
                              (
                                vendors.id = vendor_id
                              )
                          WHERE vendor_payments.id IN(#{ids})
                          FOR XML PATH('vendor_payment'), ELEMENTS XSINIL, TYPE
			)FOR XML PATH('vendor_payments')
		) AS XML) AS xmlcol")
  end  
end


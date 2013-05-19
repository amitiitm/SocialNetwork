class Customer::CustomerReceiptCrud
  include General
  cattr_accessor :error_message, :trans_type 

  def self.list_receipts(doc)
    criteria = Setup::Criteria.fill_criteria_for_query(doc/:criteria)
    condition = "(customer_receipts.company_id=#{criteria.company_id} )AND
                  (customer_receipts.trans_no between '#{criteria.str1}' and '#{criteria.str2}' AND (0 =#{criteria.multiselect1.length} or customer_receipts.trans_no in ('#{criteria.multiselect1}') )) AND
                  (customer_receipts.account_period_code between '#{criteria.str3}' and '#{criteria.str4}' AND (0 =#{criteria.multiselect2.length} or customer_receipts.account_period_code in ('#{criteria.multiselect2}') )) AND
                  (customers.code between '#{criteria.str5}' and '#{criteria.str6}' AND (0 =#{criteria.multiselect3.length} or customers.code in ('#{criteria.multiselect3}') )) AND
                  customer_receipts.parent_id in (select id from customers
                                                  where (code between '#{criteria.str7}' and '#{criteria.str8}'  and (0 =#{criteria.multiselect4.length} or code in ('#{criteria.multiselect4}') ))) AND
                  (nvl(customer_receipts.check_no,'') between '#{criteria.str9}' and '#{criteria.str10}' AND (0 =#{criteria.multiselect5.length} or nvl(customer_receipts.check_no,'') in ('#{criteria.multiselect5}') )) AND
                  nvl(customer_receipts.trans_date,'1990-01-01 00:00:00') between '#{criteria.dt1}' and '#{criteria.dt2}'  AND
                  nvl(customer_receipts.check_date,'1990-01-01 00:00:00') between '#{criteria.dt3}' and '#{criteria.dt4}' AND
                  (nvl(customer_receipts.received_amt,0) between #{criteria.dec1} and #{criteria.dec2}) AND
                  nvl(trans_type,'') != 'C'
    "
    condition = convert_sql_to_db_specific(condition)
    Customer::CustomerReceipt.find_by_sql("select CAST((select(select customer_receipts.id,
                                                                       customer_receipts.trans_bk,
                                                                       customer_receipts.trans_no,
                                                                       customer_receipts.trans_date,
                                                                       customer_receipts.account_period_code,
                                                                       customer_receipts.receipt_type,
                                                                       customer_receipts.received_amt,
                                                                       customer_receipts.applied_amt,
                                                                       customer_receipts.balance_amt,
                                                                       customers.code as customer_code 
                                                                from customer_receipts
                                                                join customers on customers.id = customer_receipts.customer_id
                                                                where (customer_receipts.trans_flag = 'A' ) AND
                                                                #{condition}
                                                                FOR XML PATH('customer_receipt'),type,elements xsinil)
                                                                FOR XML PATH('customer_receipts')) AS xml) as xmlcol ")
  end
 
  
  def self.list_credit_invoices(doc)
    criteria = Setup::Criteria.fill_criteria_for_query(doc/:criteria)
    condition = "(customer_receipts.company_id=#{criteria.company_id} )AND
                (customer_receipts.trans_no between '#{criteria.str1}' and '#{criteria.str2}' AND (0 =#{criteria.multiselect1.length} or customer_receipts.trans_no in ('#{criteria.multiselect1}') )) AND
                (customer_receipts.account_period_code between '#{criteria.str3}' and '#{criteria.str4}' AND (0 =#{criteria.multiselect2.length} or customer_receipts.account_period_code  in ('#{criteria.multiselect2}'))) AND
                customer_receipts.parent_id in (select id from customers
                where (code between '#{criteria.str5}' and '#{criteria.str6}' AND (0 =#{criteria.multiselect3.length} or code in ('#{criteria.multiselect3}')))) AND
                (customers.code between '#{criteria.str7}' and '#{criteria.str8}' AND (0 =#{criteria.multiselect4.length} or customers.code in ('#{criteria.multiselect4}'))) AND
                nvl(customer_receipts.trans_date,'1990-01-01 00:00:00') between '#{criteria.dt1}' and '#{criteria.dt2}' AND
                (nvl(customer_receipts.received_amt,0) between #{criteria.dec1} and #{criteria.dec2}) AND
                nvl(trans_type,'') = 'C'"
    condition = convert_sql_to_db_specific(condition)                         
    Customer::CustomerReceipt.find_by_sql("select CAST((select(select customer_receipts.id,
                                                                       customer_receipts.trans_bk,
                                                                       customer_receipts.trans_no,
                                                                       customer_receipts.trans_date,
                                                                       customer_receipts.applied_amt,
                                                                       customer_receipts.received_amt as paid_amt,
                                                                       customer_receipts.balance_amt,
                                                                       customer_receipts.account_period_code,
                                                                       customer_receipts.receipt_type,
                                                                       customers.code as customer_code 
                                                              from customer_receipts
                                                              join customers on customers.id = customer_receipts.customer_id
                                                              where (customer_receipts.trans_flag = 'A' ) AND
                                                              #{condition}
                                                              FOR XML PATH('credit_invoice'),type,elements xsinil)
                                                              FOR XML PATH('credit_invoices')) AS xml) as xmlcol ")
  end
  
  def self.show_receipts(receipt_id,trans_type)
    customer_receipts = []
    receipts = Customer::CustomerReceipt.find_by_id(receipt_id) if receipt_id
    customer_receipt = receipts || Customer::CustomerReceipt.new 
    if !customer_receipt.new_record?
      customer_receipt.customer_address(customer_receipt.customer)
      if ((credit_invoice?(trans_type) or receipts?(trans_type)) and customer_receipt.post_flag == 'U') or apply?(trans_type)
        customer_invoices = fetch_open_invoices_for_customer(customer_receipt.parent_id,customer_receipt.trans_bk,customer_receipt.trans_no,customer_receipt.company_id,trans_type)
        customer_invoices.each {|inv| 
          if !customer_receipt.detail_lines.to_ary.find { |li| li.voucher_no == inv.voucher_no  }
            customer_receipt.detail_lines << inv
          end
        }
      end
      customer_receipt.check_if_invoice_date_range_closed if apply?(trans_type)
      customer_receipts << customer_receipt
      gl_lines = GeneralLedger::GlPosting.show_gl_postings(customer_receipt.trans_no,customer_receipt.company_id,customer_receipt.trans_bk)
      customer_receipts << gl_lines 
    end
    return customer_receipts
  end

  def self.fetch_invoices_for_customer(customer_id,trans_type)
    customer_receipts = []
    customer = Customer::Customer.find_by_id(customer_id)
    return if !customer
    customer_receipt = Customer::CustomerReceipt.new
    customer_receipt.fill_header(trans_type)                         
    customer_receipt.fill_header_from_customer(customer,trans_type)  
    customer_receipt.customer_address(customer)
    terms = Setup::Term.fill_terms(customer_receipt.term_code, customer_receipt.trans_date) 
    customer_receipt.due_date = terms.pay1_date if terms
    if credit_invoice?(trans_type)
      #    gl_account_code = Setup::Type.fetch_ini_values_for_accounts('customer_credit_invoice_gl_account')
      #   prev   fetch_value_from_types('FAAR','credit_gl_account_cd') 
      gl_account_id = GeneralLedger::GlSetup.find(:first,
        :select=>'faar_credit_gl_account_id').faar_credit_gl_account_id
      gl_account_code = GeneralLedger::GlAccount.find_by_id(gl_account_id).code if gl_account_id 
    end
    if receipts?(trans_type) 
      #    gl_account_code = Setup::Type.fetch_ini_values_for_accounts('customer_receipt_bank_code')
      #    prev  Setup::Type.fetch_value_from_types('FAAR','bank_code') 
      gl_account_id = GeneralLedger::GlSetup.find(:first,
        :select=>'faar_bank_id').faar_bank_id
      gl_account_code = GeneralLedger::GlAccount.find_by_id(gl_account_id).code if gl_account_id                                        
    end
    gl_account = GeneralLedger::GlAccount.find_by_code(gl_account_code) if gl_account_code
    if gl_account
      customer_receipt.bank_id = gl_account.id
      customer_receipt.bank_code = gl_account.code
      bank = gl_account.bank 
    end
  
    customer_receipt.fill_bank_details(bank)
    customer_receipt_lines = fetch_open_invoices_for_customer(customer.billto_id,trans_type)
    customer_receipt_lines.each{|recpt_line|
      customer_receipt.detail_lines << recpt_line
    }
    customer_receipts << customer_receipt if  customer_receipt
    customer_receipts
  end


  def self.fetch_open_invoices_for_customer(*args)
    #  customer = Customer::Customer.find_all_by_code(customer_code).first  if customer_code
    #  customer_id = customer.id if customer
    customer_id = args[0]
    if args.size == 4
      trans_bk = args[1] 
      trans_no = args[2] 
      trans_type = args[3] 
    else
      trans_type = args[1]
    end
  
    customer_receipt_lines = []
    customer_invoices = fetch_open_invoices(customer_id)
    customer_invoices.each {|inv| 
      customer_receipt_lines << Customer::CustomerReceiptLine.build_invoice_receipt_line(inv.attributes)
    }
    if receipts?(trans_type)     #For Receipts we need to get credit invoices too...
      customer_credit_invoices = fetch_open_credit_invoices(customer_id)
      customer_credit_invoices.each{|crdt|
        if trans_bk and trans_no
          if !(crdt.trans_bk + crdt.trans_no == trans_bk + trans_no)
            customer_receipt_lines << Customer::CustomerReceiptLine.build_credit_receipt_line(crdt.attributes)
          end
        else
          customer_receipt_lines << Customer::CustomerReceiptLine.build_credit_receipt_line(crdt.attributes)
        end    
      } 
    end
    customer_receipt_lines 
  end

  def self.fetch_open_invoices(customer_id)
    condition = "parent_id = ? 
                      and nvl(action_flag,'') = 'O'
                      and nvl(balance_amt,0) <> 0
    "
    condition = convert_sql_to_db_specific(condition)                      
    Customer::CustomerInvoice.active.find(:all,
      :conditions => [condition ,customer_id],
      :order => "due_date"               
    )
  
  end  

  def self.fetch_open_credit_invoices(customer_id)
    condition = "parent_id = ? 
                      and nvl(action_flag,'') = 'O'
                      and nvl(balance_amt,0)  <> 0
    " 
    condition = convert_sql_to_db_specific(condition)
    Customer::CustomerReceipt.active.find(:all,
      :conditions => [condition ,customer_id],
      :order => "due_date"               
    )
  
  end

  def self.create_receipts(doc,trans_type)
    self.trans_type = trans_type
    receipts = [] 
    receipt_doc= (doc/:customer_receipts/:customer_receipt).first
    receipt = create_receipt(receipt_doc)
    if receipt 
      receipts <<  receipt 
      gl_lines = GeneralLedger::GlPosting.show_gl_postings(receipt.trans_no,receipt.company_id,receipt.trans_bk)
      receipts << gl_lines 
    end
    receipts
  end

  def self.create_receipt(doc)
    receipt = add_or_modify(doc) 
    return  if !receipt
    return receipt if !receipt.errors.empty?
    receipt.calculate_balance_for_header  
    receipt.generate_trans_no if receipt.new_record?
    receipt.detail_lines.each{|recept_line|
      recept_line.copy_header_fields_to_lines(receipt.trans_no,receipt.trans_bk,receipt.trans_date,receipt.company_id) #if recept_line.new_record?
    }
    receipt.update_flag = 'V' if receipt.trans_bk == 'PA01' 
    if !apply?(self.trans_type)
      bank_postings = []
      gl_postings = []
      bank_postings = receipt.create_bank_postings if receipts?(trans_type)
      gl_postings = receipt.create_gl_postings_for_receipts  
    end 
    save_proc = Proc.new{
      receipt.validate_receipt_amounts    
      if receipt.new_record?
        receipt.save! 
        receipt.update_trans_no
      else
        receipt.save! 
        receipt.save_lines
        unpost_receipts(receipt)
        receipt.delete_unapplied_lines   
      end
      post_receipts(receipt)
      if !apply?(self.trans_type)
        receipt.post_bank_transactions(bank_postings) if !bank_postings.empty?            
        GeneralLedger::GlPosting.post_gl_transactions(gl_postings) if !gl_postings.empty?
      end
    }
    receipt.save_transaction(&save_proc)
    return receipt
  end

  def self.add_or_modify(doc)  
    id =  parse_xml(doc/'/id') if (doc/'/id').first  
    receipt = Customer::CustomerReceipt.find_or_create(id) 
    return if !receipt
    return receipt if receipt.view_only
    receipt.apply_attributes(doc) 
    #  if receipt.new_record? 
    receipt.fill_header(self.trans_type) if receipt.new_record?     
    receipt.run_block do
      receipt.max_serial_no = receipt.detail_lines.applied.maximum_serial_no
      build_lines(doc/:customer_receipt_lines/:customer_receipt_line)   
    end
    return receipt 
  end

  def self.unpost_receipts(receipt)
    deleted_lines = receipt.detail_lines.to_ary.find_all { |li| li.trans_flag == 'D'}
    deleted_lines.each{|recpt|
      update_receipt_and_invoice_balance_amt(recpt)
      receipt.raise_error(self.error_message)     if self.error_message        
    }
  end

  def self.post_receipts(receipt)
    new_lines = receipt.detail_lines.applied_lines 
    new_lines.each{|recpt|
      update_receipt_and_invoice_balance_amt(recpt)  
      receipt.raise_error(self.error_message)       if self.error_message      
      #    trans_bk,trans_no = trans_bk_no_from_voucher_no(recpt.voucher_no)
      #    GeneralLedger::BankTransaction.make_bank_transaction_view_only(trans_bk,trans_no,recpt.voucher_date,recpt.company_id)
      recpt.update_invoice_to_view_only
    }
  end

  def self.update_receipt_and_invoice_balance_amt(recpt)
    trans_bk,trans_no = trans_bk_no_from_voucher_no(recpt.voucher_no)   
    voucher_applied_amt,voucher_discount_amt = calculate_voucher_amt(recpt.voucher_no,recpt.voucher_date,trans_no,trans_bk,recpt.voucher_date)
    # Change: Praman July-04-2011 Making transaction date editable and post/unpost transaction accordingly.  
    #  invoice = Customer::CustomerInvoice.find_by_trans_bk_no_date(trans_bk,trans_no,recpt.voucher_date,recpt.company_id).first 
    invoice = Customer::CustomerInvoice.find_all_by_trans_bk_and_trans_no(trans_bk,trans_no).first
    if invoice
      new_balance = nulltozero(nulltozero(invoice.inv_amt) - ( nulltozero(voucher_applied_amt) + nulltozero(voucher_discount_amt)))    
      if new_balance == 0
        action_flag = 'C'
        update_flag = 'V'
      else
        if (nulltozero(invoice.inv_amt) - new_balance).abs < (nulltozero(invoice.inv_amt)).abs then
          action_flag = 'O'
          update_flag = 'V'
        else
          self.error_message ='Error 1', 'Applied amount not correct for the invoice6666 ' 
          return
        end
      end
      invoice.update_for_receipts(action_flag,update_flag,voucher_applied_amt,voucher_discount_amt,new_balance)
    end
    
    #For Credit invoice      
    # Change: Praman July-04-2011 Making transaction date editable and post/unpost transaction accordingly.  
    #  payment =  Customer::CustomerReceipt.find_by_trans_bk_no_date(trans_bk,trans_no,recpt.voucher_date,recpt.company_id).first
    payment =  Customer::CustomerReceipt.find_all_by_trans_bk_and_trans_no(trans_bk,trans_no).first
    if payment
      paid_amt = payment.received_amt 
      paid_balance = nulltozero(nulltozero(paid_amt) - ( (nulltozero(voucher_applied_amt) + nulltozero(voucher_discount_amt)) * -1 ))
      if paid_balance == 0      
        action_flag = 'C'
        update_flag = 'V'
        applied_amt = (voucher_applied_amt  + voucher_discount_amt ) * -1             
      else
        if (nulltozero(paid_amt).abs - paid_balance) < (nulltozero(paid_amt)).abs then
          action_flag = 'O'
          update_flag = 'V'
          applied_amt = (voucher_applied_amt  + voucher_discount_amt ) * -1
        else
          self.error_message ='Error 1', 'Applied amount not correct for the invoice6666 ' 
          return
        end
      end
      payment.update_for_receipts(action_flag,update_flag,applied_amt,paid_balance)
    end
  end

 
  def self.calculate_voucher_amt(voucher_no,voucher_date,trans_no,trans_bk,trans_date)  
    #  For Invoice
    cust_recpt_line = Customer::CustomerReceiptLine.find(:all, :select=>'sum(apply_amt) AS apply_amt,sum(disctaken_amt) AS disctaken_amt',
      :conditions=> "voucher_no = '#{voucher_no}' and voucher_date = '#{voucher_date}'").first || 0
    applied_amt = nulltozero(cust_recpt_line['apply_amt'])
    disc_amt = nulltozero(cust_recpt_line['disctaken_amt'])
    #  For credits
    cust_recpt_line = Customer::CustomerReceiptLine.find(:all, :select=>'sum(apply_amt) AS apply_amt,sum(disctaken_amt) AS disctaken_amt',
      :conditions=>"trans_no = '#{trans_no}' and trans_bk = '#{trans_bk}' and trans_date = '#{trans_date}'").first || 0
    this_apply_amt = nulltozero(cust_recpt_line['apply_amt'])
    this_disc_amt = nulltozero(cust_recpt_line['disctaken_amt'])
  
    applied_amt += ( this_apply_amt * -1)
    disc_amt += (this_disc_amt * -1)
    return applied_amt, disc_amt
  end  

end
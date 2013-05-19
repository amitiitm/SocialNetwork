class Customer::CustomerInvoiceCrud
  include General
 
  def self.list_invoices(doc)
    criteria = Setup::Criteria.fill_criteria_for_query(doc/:criteria)
    condition = " ( customer_invoices.company_id = #{criteria.company_id}) AND
                      customer_invoices.parent_id in (select id from customers
                                                        where (code between '#{criteria.str1}' and '#{criteria.str2}' And (0 =#{criteria.multiselect1.length} or code in ('#{criteria.multiselect1}')))) AND
                        (customers.code between '#{criteria.str3}' and '#{criteria.str4}' AND  (0 =#{criteria.multiselect2.length} or customers.code in ('#{criteria.multiselect2}'))) AND
                        (customer_invoices.trans_no between '#{criteria.str5}' and '#{criteria.str6}' AND (0 =#{criteria.multiselect3.length} or customer_invoices.trans_no in ('#{criteria.multiselect3}'))) AND
                        nvl(customer_invoices.trans_date,'1990-01-01 00:00:00') between '#{criteria.dt1}' and '#{criteria.dt2}' AND
                        (customer_invoices.inv_no between '#{criteria.str7}' and '#{criteria.str8}' AND (0 =#{criteria.multiselect4.length} or customer_invoices.inv_no in ('#{criteria.multiselect4}')))
    "
    condition = convert_sql_to_db_specific(condition)
    Customer::CustomerInvoice.find_by_sql ["select CAST( (select(select customer_invoices.id,
                                                                        customer_invoices.trans_bk,
                                                                        customer_invoices.trans_no,
                                                                        customer_invoices.trans_date,
                                                                        customer_invoices.inv_amt,
                                                                        customer_invoices.inv_type,
                                                                        customer_invoices.inv_no,
                                                                        customer_invoices.account_period_code,
                                                                        customer_invoices.paid_amt,
                                                                        customer_invoices.disctaken_amt,
                                                                        customer_invoices.balance_amt,
                                                                        customers.code as customer_code 
                                                                  from customer_invoices
                                                                  join customers on customers.id = customer_invoices.customer_id
                                                                  where (customer_invoices.trans_flag = 'A' and customer_invoices.trans_bk <> 'VOCK') AND
                                                                  #{condition}
                                                                  FOR XML PATH('customer_invoice'),type,elements xsinil
                                                                  )FOR XML PATH('customer_invoices')) AS xml) as xmlcol ",
      #      criteria.company_id,criteria.str1,criteria.str2,criteria.multiselect1.length,criteria.multiselect1,
      #      criteria.str3, criteria.str4, criteria.multiselect2.length,criteria.multiselect2,
      #      criteria.str5, criteria.str6,criteria.multiselect3.length,criteria.multiselect3,
      #      criteria.dt1,criteria.dt2,
      #      criteria.str7, criteria.str8,criteria.multiselect4.length,criteria.multiselect4
    ]   
  end
  
  def self.show_invoices(invoice_id)
    customer_invoice = []
    invoices = Customer::CustomerInvoice.find_all_by_id(invoice_id) if invoice_id
    invoice = invoices.empty? ? Customer::CustomerInvoice.new : invoices.first
    customer_invoice << invoice
    if !invoice.new_record?
      invoice.customer_address(invoice.customer)
      invoice.customer_invoice_lines.applied_lines.each{|inv_line|
        inv_line.fill_gl_code_name 
      }  
      payment_lines = payments(invoice.trans_no,invoice.trans_bk)
      splitted_trans_no = invoice.trans_no.split("-").first || invoice.trans_no
      gl_lines = GeneralLedger::GlPosting.show_gl_postings(splitted_trans_no,invoice.company_id,invoice.trans_bk)                
      customer_invoice << gl_lines 
      customer_invoice << payment_lines 
    end
    customer_invoice
  end
 
 
  def self.payments(trans_no,trans_bk)
    Customer::CustomerReceiptLine.find_all_by_voucher_no(voucher_no_from_trans_no_bk(trans_bk,trans_no)) 
  end

  def self.fetch_invoice_header_details(customer_id) 
    customer_invoices = []
    customer = Customer::Customer.find_all_by_id(customer_id).first
    return if !customer
    customer_invoice = Customer::CustomerInvoice.new
    customer_invoice.fill_header  
    customer_invoice.fill_header_from_customer(customer,'I')  
    customer_invoice.customer_address(customer)
    terms = Setup::Term.fill_terms(customer_invoice.term_code, customer_invoice.sale_date) 
    if terms
      #    customer_invoice.due_date = terms.pay1_date  # these columns are deleted
      #    customer_invoice.discount_date = terms.pay2_date
      #      customer_invoice.discount_per = nulltozero(terms.disc_per)
    end  
    customer_invoice.customer_invoice_lines << new_invoice_line
    customer_invoices << customer_invoice
    customer_invoices
  end
 
 
  def self.new_invoice_line
    customer_invoice_line = Customer::CustomerInvoiceLine.new
    customer_invoice_line.serial_no = MAX_SERIAL_NO
    #  sales_account_code =  Setup::Type.fetch_ini_values_for_accounts('customer_invoiceline_gl_account')
    #  prev  Setup::Type.fetch_value_from_types('faar','invoice_gl_acct')
    #  prev sales_account_code = sales_account.first.value if !sales_account.empty?
    sales_account_id = GeneralLedger::GlSetup.find(:first,
      :select=>'faar_invoice_gl_account_id').faar_invoice_gl_account_id
    #  gl_account = GeneralLedger::GlAccount.find_by_code(sales_account_code) if sales_account_code
    gl_account = GeneralLedger::GlAccount.find_by_id(sales_account_id) if sales_account_id
    if gl_account
      customer_invoice_line.gl_account_id = gl_account.id
      customer_invoice_line.gl_account_code = gl_account.code
      customer_invoice_line.gl_account_name = gl_account.name
    end
  
    customer_invoice_line
  end
 
  def self.create_invoices(doc)
    invoices = [] 
    multiple_invoice_flag = parse_xml(doc/:customer_invoices/:multiple_invoices) if (doc/:customer_invoices/:multiple_invoices)
    if multiple_invoice_flag and multiple_invoice_flag =='Y'
      (doc/:customer_invoices/:customer_invoice).each{|invoice_doc|
        invoice = create_invoice(invoice_doc)
        invoices <<  invoice if invoice
      }
    else
      invoice_doc = (doc/:customer_invoices/:customer_invoice).first
      invoice = create_invoice(invoice_doc)
      if invoice
        invoices <<  invoice 
        return invoices if !invoice.errors.empty?
        gl_lines = GeneralLedger::GlPosting.show_gl_postings(invoice.trans_no,invoice.company_id,invoice.trans_bk)
        #    gl_lines = GeneralLedger::GlDetail.gl_transactions(invoice.trans_no,invoice.trans_bk)
        invoices <<  gl_lines if gl_lines
      end
    end
    invoices
  end

  def self.create_invoice(doc)
    invoice = add_or_modify(doc) 
    return  if !invoice
    return invoice if !invoice.errors.empty?
    invoice.generate_trans_no if invoice.new_record?
    invoice.trans_no = parse_xml(doc/"invoice_number") if parse_xml(doc/"invoice_number")
    invoice.customer_invoice_lines.applied_lines.each{|invoice_line|
      invoice_line.copy_header_fields_to_lines(invoice.trans_no,invoice.trans_bk,invoice.trans_date,invoice.company_id) #if invoice_line.new_record?
    }
    gl_postings = []
    gl_postings = invoice.create_gl_postings_for_invoice
    save_proc = Proc.new{
      if invoice.new_record?
        invoice.save!  
        invoice.update_trans_no
      else
        invoice.save! 
        invoice.save_lines
      end
      #    gl_postings = invoice.create_gl_postings_for_invoice
      GeneralLedger::GlPosting.post_gl_transactions(gl_postings) if !gl_postings.empty?
    }
    invoice.save_transaction(&save_proc)
    return invoice
  end

  def self.add_or_modify(doc)
    id =  parse_xml(doc/'/id') if (doc/'/id').first  
    invoice = Customer::CustomerInvoice.find_or_create(id) 
    return if !invoice
    return invoice  if invoice.view_only
    invoice.apply_attributes(doc) 
    invoice.apply_address(doc)
    if invoice.new_record?
      invoice.fill_default_header
    end
    invoice.fill_docu_type
    invoice.run_block do
      line_doc = doc/:customer_invoice_lines/:customer_invoice_line 
      build_lines(line_doc)
    end
    return invoice 
  end

end

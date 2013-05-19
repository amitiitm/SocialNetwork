class Sales::SalesCreditInvoiceCrud
  include General

  #Sales CreditInvoice services  
  def self.list_credit_invoices(doc)
    criteria = Setup::Criteria.fill_criteria_for_query(doc/:criteria) 
    Sales::SalesCreditInvoice.find_by_sql ["select CAST( (select(select sales_credit_invoices.id,sales_credit_invoices.trans_bk,sales_credit_invoices.trans_no,
                                    sales_credit_invoices.trans_date,sales_credit_invoices.shipping_code,sales_credit_invoices.account_period_code,
                                    sales_credit_invoices.tracking_no,sales_credit_invoices.ship_date,sales_credit_invoices.item_amt,
                                    sales_credit_invoices.net_amt,customers.code as customer_code from sales_credit_invoices
                                    inner join customers on customers.id = sales_credit_invoices.customer_id where
                                    (sales_credit_invoices.trans_flag = 'A') AND
                                    (sales_credit_invoices.company_id = #{criteria.company_id}) AND
                                    (customers.code between '#{criteria.str1}' and '#{criteria.str2}' AND (0 =#{criteria.multiselect1.length} or customers.code in ('#{criteria.multiselect1}'))) AND
                                    (trans_no between '#{criteria.str3}' and '#{criteria.str4}' AND (0 =#{criteria.multiselect2.length} or trans_no in ('#{criteria.multiselect2}'))) AND
                                    (trans_date between '#{criteria.dt1}' and '#{criteria.dt2}' ) AND
                                    (account_period_code between '#{criteria.str5[0,8]}' and '#{criteria.str6[0,8]}' AND (0 =#{criteria.multiselect3.length} or account_period_code in ('#{criteria.multiselect3}')))
                                    order by trans_date, trans_no
                                    FOR XML PATH('sales_credit_invoice'),type,elements xsinil)FOR XML PATH('sales_credit_invoices')) AS xml) as xmlcol "
    ]
  end

  def self.show_credit_invoice(creditinvoice_id)
    Sales::SalesCreditInvoice.find_all_by_id(creditinvoice_id)
  end
  
  def self.create_credit_invoices(doc)
    creditinvoices = [] 
    (doc/:sales_credit_invoices/:sales_credit_invoice).each{|creditinvoice_doc|
      creditinvoice = create_credit_invoice(creditinvoice_doc)
      creditinvoices <<  creditinvoice if creditinvoice
    }
    creditinvoices
  end

  def self.create_credit_invoice(doc)
    creditinvoice = add_or_modify_credit_invoice(doc) 
    return  if !creditinvoice
    creditinvoice.generate_trans_no('SAOICR') if creditinvoice.new_record?
    creditinvoice.apply_header_fields_to_lines  
    creditinvoice.apply_line_fields_to_header  
    ref_hdrs, ref_lines = creditinvoice.run_sales_posting()
    inventory = Inventory::InventorySales::Posting.new
    inventory_postings = inventory.create_inventory_postings(creditinvoice)
    gl_sale = Sales::SalesGlPosting::Posting.new
    gl_postings = gl_sale.create_gl_postings(creditinvoice)
    save_proc = Proc.new{
      if creditinvoice.new_record?
        creditinvoice.save!  
      else
        creditinvoice.save! 
        creditinvoice.sales_credit_invoice_lines.save_line
      end
      #save reference transactions
      ref_lines.each{|ref_line|
        ref_line.save!
      } if ref_lines
      ref_hdrs.each{|ref_hdr|
        ref_hdr.update_attributes(:update_flag=>'V')
      } if ref_hdrs
      Inventory::InventoryPosting.post_inventory_transactions(inventory_postings) if inventory_postings
      account_posting = Sales::SalesAccountsPosting::Posting.new
      account_posting.post_customercreditinvoice(creditinvoice)
      GeneralLedger::GlPosting.post_gl_transactions(gl_postings)   if gl_postings
    }
    #  creditinvoice.save_transaction(&save_proc)
    if(creditinvoice.errors.empty?)
      creditinvoice.save_transaction(&save_proc)
    end
    return creditinvoice
  end

  def self.add_or_modify_credit_invoice(doc)  
    id =  parse_xml(doc/'id') if (doc/'id').first  
    creditinvoice = Sales::SalesCreditInvoice.find_or_create(id) 
    return if !creditinvoice
    if !creditinvoice.new_record? and creditinvoice.update_flag == 'V'
      creditinvoice.errors.add('This Credit Invoice is View Only. Cannot be updated.') 
      return creditinvoice
    end
    creditinvoice.apply_attributes(doc) 
    creditinvoice.fill_default_header_values() if creditinvoice.new_record?
    creditinvoice.ref_type = creditinvoice.trans_type
    creditinvoice.max_serial_no = creditinvoice.sales_credit_invoice_lines.maximum_serial_no
    creditinvoice.build_lines(doc/:sales_credit_invoice_lines/:sales_credit_invoice_line)   
    return creditinvoice 
  end

  private_class_method :create_credit_invoice, :add_or_modify_credit_invoice

end

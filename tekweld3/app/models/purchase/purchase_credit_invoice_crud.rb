class Purchase::PurchaseCreditInvoiceCrud
  include General

  #Purchase CreditInvoice services  
  def self.list_credit_invoices(doc)
    criteria = Setup::Criteria.fill_criteria_for_query(doc/:criteria)
    Purchase::PurchaseCreditInvoice.find_by_sql ["select CAST( (select(select purchase_credit_invoices.id,purchase_credit_invoices.trans_bk,purchase_credit_invoices.trans_no,
                                    purchase_credit_invoices.trans_date,purchase_credit_invoices.shipping_code,purchase_credit_invoices.account_period_code,
                                    purchase_credit_invoices.tracking_no,purchase_credit_invoices.ship_date,purchase_credit_invoices.item_amt,
                                    purchase_credit_invoices.net_amt,vendors.code as vendor_code from purchase_credit_invoices
                                    inner join vendors on vendors.id = purchase_credit_invoices.vendor_id where
                                    (purchase_credit_invoices.trans_flag = 'A') AND
                                    (purchase_credit_invoices.company_id = #{criteria.company_id}) AND
                                    (vendors.code between '#{criteria.str1}' and  '#{criteria.str2}' AND (0 =#{criteria.multiselect1.length} or vendors.code in ('#{criteria.multiselect1}'))) AND
                                    (trans_no between  '#{criteria.str3}' and '#{criteria.str4}' AND (0 = #{criteria.multiselect2.length} or trans_no in ('#{criteria.multiselect2}'))) AND
                                    (trans_date between  '#{criteria.dt1}' and '#{criteria.dt2}' ) AND
                                    (account_period_code between '#{criteria.str5[0,8]}' and '#{criteria.str6[0,8]}'  AND (0 = #{criteria.multiselect3.length} or account_period_code in ('#{criteria.multiselect3}')))
                                    order by trans_date, trans_no
                                    FOR XML PATH('purchase_credit_invoice'),type,elements xsinil)FOR XML PATH('purchase_credit_invoices')) AS xml) as xmlcol "    ] 
  end

  def self.show_credit_invoice(creditinvoice_id)
    Purchase::PurchaseCreditInvoice.find_all_by_id(creditinvoice_id)
  end
  
  def self.create_credit_invoices(doc)
    creditinvoices = [] 
    (doc/:purchase_credit_invoices/:purchase_credit_invoice).each{|creditinvoice_doc|
      creditinvoice = create_credit_invoice(creditinvoice_doc)
      creditinvoices <<  creditinvoice if creditinvoice
    }
    creditinvoices
  end

  def self.create_credit_invoice(doc)
    creditinvoice = add_or_modify_credit_invoice(doc) 
    return  if !creditinvoice
    creditinvoice.generate_trans_no('PAOICR') if creditinvoice.new_record?
    creditinvoice.apply_header_fields_to_lines  
    creditinvoice.apply_line_fields_to_header  
    ref_hdrs, ref_lines = creditinvoice.run_purchase_posting()
    inventory = Inventory::InventoryPurchase::Posting.new
    inventory_postings = inventory.create_inventory_postings(creditinvoice)
    gl_purchase = Purchase::PurchaseGlPosting::Posting.new
    gl_postings = gl_purchase.create_gl_postings(creditinvoice)
    save_proc = Proc.new{
      if creditinvoice.new_record?
        creditinvoice.save!  
      else
        creditinvoice.save!
        creditinvoice.purchase_credit_invoice_lines.save_line
      end
      #save reference transactions
      ref_lines.each{|ref_line|
        ref_line.save!
      } if ref_lines
      ref_hdrs.each{|ref_hdr|
        ref_hdr.update_attributes(:update_flag=>'V')
      } if ref_hdrs
      #post inventory
      Inventory::InventoryPosting.post_inventory_transactions(inventory_postings) if inventory_postings
      account_posting = Purchase::PurchaseAccountsPosting::Posting.new
      account_posting.post_vendorcreditinvoice(creditinvoice)
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
    creditinvoice = Purchase::PurchaseCreditInvoice.find_or_create(id) 
    return if !creditinvoice
    if !creditinvoice.new_record? and creditinvoice.update_flag == 'V'
      creditinvoice.errors.add('This Credit Invoice is View Only. Cannot be updated.') 
      return creditinvoice
    end
    creditinvoice.apply_attributes(doc) 
    creditinvoice.fill_default_header_values() if creditinvoice.new_record?
    creditinvoice.ref_type = creditinvoice.trans_type
    creditinvoice.max_serial_no = creditinvoice.purchase_credit_invoice_lines.maximum_serial_no
    creditinvoice.build_lines(doc/:purchase_credit_invoice_lines/:purchase_credit_invoice_line)   
    return creditinvoice 
  end

  private_class_method :create_credit_invoice, :add_or_modify_credit_invoice

end

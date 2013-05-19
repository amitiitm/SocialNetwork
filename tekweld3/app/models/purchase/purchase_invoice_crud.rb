class Purchase::PurchaseInvoiceCrud
  include General

  #Purchase Invoice services
  def self.list_invoices(doc)
    criteria = Setup::Criteria.fill_criteria_for_query(doc/:criteria)
    Purchase::PurchaseInvoice.find_by_sql ["select CAST( (select(select purchase_invoices.id,purchase_invoices.trans_bk,purchase_invoices.trans_no,purchase_invoices.trans_date,
                                    purchase_invoices.trans_type,purchase_invoices.shipping_code,purchase_invoices.account_period_code,
                                    purchase_invoices.tracking_no,purchase_invoices.ship_date,purchase_invoices.item_amt,purchase_invoices.net_amt,vendors.code as vendor_code from purchase_invoices
                                    inner join vendors on vendors.id = purchase_invoices.vendor_id where
                                    (purchase_invoices.trans_flag = 'A') AND                               
                                    (purchase_invoices.company_id = #{criteria.company_id}) AND
                                    (vendors.code between '#{criteria.str1}' and '#{criteria.str2}' AND (0 = #{criteria.multiselect1.length} or vendors.code in ('#{criteria.multiselect1}'))) AND
                                    (trans_no between '#{criteria.str3}' and '#{criteria.str4}' AND (0 = #{criteria.multiselect2.length} or trans_no in ('#{criteria.multiselect2}'))) AND
                                    (trans_date between '#{criteria.dt1}' and '#{ criteria.dt2}' ) AND
                                    (account_period_code between '#{criteria.str5[0,8]}' and '#{criteria.str6[0,8]}' AND (0 = #{criteria.multiselect3.length} or account_period_code in ('#{criteria.multiselect3}')))
                                    order by trans_date, trans_no
                                    FOR XML PATH('purchase_invoice'),type,elements xsinil)FOR XML PATH('purchase_invoices')) AS xml) as xmlcol ",
    ]
  end

  def self.list_open_invoices(doc)
    criteria = Setup::Criteria.fill_criteria_for_query(doc/:criteria)
    Purchase::PurchaseInvoice.find_by_sql ["select CAST( (select(select b.*, (b.item_qty - b.clear_qty) as open_qty ,
                                    catalog_items.taxable as taxable,catalog_items.image_thumnail as image_thumnail, catalog_items.packet_require_yn as packet_require_yn,
                                    purchase_invoices.discount_per as hdr_discount_per,
                                    purchase_invoices.discount_amt as hdr_discount_amt,
                                    purchase_invoices.tax_per as hdr_tax_per,
                                    purchase_invoices.tax_amt as hdr_tax_amt,
                                    vendors.code as vendor_code from purchase_invoices
                                    inner join vendors on vendors.id = purchase_invoices.vendor_id
                                    join purchase_invoice_lines b on b.purchase_invoice_id = purchase_invoices.id
                                    join catalog_items on catalog_items.id = b.catalog_item_id
                                    where (purchase_invoices.trans_flag = 'A') AND
                                    b.purchase_invoice_id = purchase_invoices.id and
                                    b.item_qty > b.clear_qty and
                                    b.trans_flag = 'A' and
                                    ( purchase_invoices.company_id = #{criteria.company_id}) and
                                    purchase_invoices.vendor_id between #{criteria.int1} and #{criteria.int2}
                                    order by purchase_invoices.trans_date, purchase_invoices.trans_no, b.serial_no
                                    FOR XML PATH('purchase_invoice'),type,elements xsinil)FOR XML PATH('purchase_invoices')) AS xml) as xmlcol
      " ]
  end

  def self.list_open_invoices_hdr(doc)
    criteria = Setup::Criteria.fill_criteria_for_query(doc/:criteria)
    Purchase::PurchaseInvoice.find_by_sql ["select CAST( (select(select distinct purchase_invoices.id, purchase_invoices.trans_no, purchase_invoices.trans_date, purchase_invoices.ext_ref_no as vendor_invoice_no,
                                    vendors.code as vendor_code from purchase_invoices
                                    inner join vendors on vendors.id = purchase_invoices.vendor_id
                                    join purchase_invoice_lines b on b.purchase_invoice_id = purchase_invoices.id
                                    join catalog_items on catalog_items.id = b.catalog_item_id
                                    where (purchase_invoices.trans_flag = 'A') AND
                                    b.purchase_invoice_id = purchase_invoices.id and
                                    b.item_qty > b.clear_qty and
                                    b.trans_flag = 'A' and
                                    ( purchase_invoices.company_id = #{criteria.company_id}) and
                                    purchase_invoices.vendor_id between #{criteria.int1} and #{criteria.int2}
                                    order by purchase_invoices.trans_no
                                    FOR XML PATH('purchase_invoice'),type,elements xsinil)FOR XML PATH('purchase_invoices')) AS xml) as xmlcol
      "]
  end

  def self.list_open_invoice_lines(doc)
    criteria = Setup::Criteria.fill_criteria_for_query(doc/:criteria)
    Purchase::PurchaseInvoice.find_by_sql ["select CAST( (select(select b.*, (b.item_qty - b.clear_qty) as open_qty ,
                                    catalog_items.taxable as taxable,catalog_items.image_thumnail as image_thumnail, catalog_items.packet_require_yn as packet_require_yn,
                                    purchase_invoices.discount_per as hdr_discount_per,
                                    purchase_invoices.discount_amt as hdr_discount_amt,
                                    purchase_invoices.tax_per as hdr_tax_per,
                                    purchase_invoices.tax_amt as hdr_tax_amt,
                                    vendors.code as vendor_code from purchase_invoices
                                    inner join vendors on vendors.id = purchase_invoices.vendor_id
                                    join purchase_invoice_lines b on b.purchase_invoice_id = purchase_invoices.id
                                    join catalog_items on catalog_items.id = b.catalog_item_id
                                    where (purchase_invoices.trans_flag = 'A') AND
                                    b.purchase_invoice_id = purchase_invoices.id and
                                    b.item_qty > b.clear_qty and
                                    b.trans_flag = 'A' and
                                    ( purchase_invoices.company_id = #{criteria.company_id}) and
                                    purchase_invoices.id between #{criteria.int1} and #{criteria.int2}
                                    order by purchase_invoices.trans_date, purchase_invoices.trans_no, b.serial_no
                                    FOR XML PATH('purchase_invoice'),type,elements xsinil)FOR XML PATH('purchase_invoices')) AS xml) as xmlcol
      "]
  end

  def self.list_purchase_invoice_bom(bom_id)
    select_query = "select transaction_boms.* from transaction_boms where id = #{bom_id} order by trans_date desc"
    query = convert_sql_to_db_specific(select_query)
    TransactionBom::TransactionBom.find_by_sql [query]
  end


  def self.show_invoice(invoice_id)
    Purchase::PurchaseInvoice.find_all_by_id(invoice_id)
  end

  def self.create_invoices(doc)
    invoices = []
    (doc/:purchase_invoices/:purchase_invoice).each{|invoice_doc|
      invoice = create_invoice(invoice_doc)
      invoices <<  invoice if invoice
    }
    invoices
  end

  def self.create_invoice(doc)
    invoice = add_or_modify_invoice(doc)
    return  if !invoice
    invoice.generate_trans_no('PAOIIN') if invoice.new_record?
    invoice.apply_header_fields_to_lines
    invoice.apply_line_fields_to_header
    ref_hdrs, ref_lines = invoice.run_purchase_posting()
    gl_purchase = Purchase::PurchaseGlPosting::Posting.new
    gl_postings = gl_purchase.create_gl_postings(invoice)
    save_proc = Proc.new{
      if invoice.new_record?
        invoice.save!
      else
        invoice.save!
        invoice.purchase_invoice_lines.save_line
      end
      #save reference transactions
      ref_lines.each{|ref_line|
        ref_line.save!
      } if ref_lines
      ref_hdrs.each{|ref_hdr|
        ref_hdr.update_attributes(:update_flag=>'V')
      } if ref_hdrs
      inventory = Inventory::InventoryPurchase::Posting.new
      inventory_postings = inventory.create_inventory_postings(invoice)
      Inventory::InventoryPosting.post_inventory_transactions(inventory_postings) if inventory_postings
      account_posting = Purchase::PurchaseAccountsPosting::Posting.new
      account_posting.post_vendorinvoice(invoice)
      GeneralLedger::GlPosting.post_gl_transactions(gl_postings)   if gl_postings
    }
    #  invoice.save_transaction(&save_proc)
    if(invoice.errors.empty?)
      invoice.save_transaction(&save_proc)
    end

    return invoice
  end

  def self.add_or_modify_invoice(doc)
    id =  parse_xml(doc/'id') if (doc/'id').first
    invoice = Purchase::PurchaseInvoice.find_or_create(id)
    return if !invoice
    if !invoice.new_record? and invoice.update_flag == 'V'
      invoice.errors.add('This Invoice is View Only. Cannot update.')
      return invoice
    end
    invoice.apply_attributes(doc)
    invoice.fill_default_header_values() if invoice.new_record?
    invoice.ref_type = invoice.trans_type
    invoice.max_serial_no = invoice.purchase_invoice_lines.maximum_serial_no
    invoice.build_lines(doc/:purchase_invoice_lines/:purchase_invoice_line)
    return invoice
  end

  private_class_method :create_invoice, :add_or_modify_invoice

end

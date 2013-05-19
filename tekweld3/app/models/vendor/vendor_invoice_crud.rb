class Vendor::VendorInvoiceCrud < ActiveRecord::Base
  include General
 
  def self.list_invoices(doc)
    criteria = Setup::Criteria.fill_criteria_for_query(doc/:criteria)
    condition = convert_sql_to_db_specific(" (vendor_invoices.company_id=#{criteria.company_id} )AND
                        (vendors.code between '#{criteria.str1}' and '#{criteria.str2}' AND  (0 = #{criteria.multiselect1.length} or vendors.code in ('#{criteria.multiselect1}'))) AND
                        (vendor_invoices.trans_no between '#{criteria.str3}' and '#{criteria.str4}' AND (0 = #{criteria.multiselect2.length} or vendor_invoices.trans_no in ('#{criteria.multiselect2}'))) AND
                        nvl(vendor_invoices.trans_date,'1990-01-01 00:00:00') between '#{criteria.dt1}' and '#{criteria.dt2}' AND
                        (vendor_invoices.inv_no between '#{criteria.str5}' and '#{criteria.str6}' AND (0 = #{criteria.multiselect3.length} or vendor_invoices.inv_no in ('#{criteria.multiselect3}')))
      ")
    Vendor::VendorInvoice.find_by_sql("select CAST((select(select vendor_invoices.id,
                                                                   vendor_invoices.trans_bk,
                                                                   vendor_invoices.trans_no,
                                                                   vendor_invoices.trans_date,
                                                                   vendor_invoices.account_period_code,
                                                                   vendor_invoices.inv_amt,
                                                                   vendor_invoices.paid_amt,
                                                                   vendor_invoices.disctaken_amt,
                                                                   vendor_invoices.balance_amt,
                                                                   vendor_invoices.inv_type,
                                                                   vendor_invoices.inv_no,
                                                                   vendors.code as vendor_code 
                                                            from vendor_invoices
                                                            join vendors on vendors.id = vendor_invoices.vendor_id
                                                            where (vendor_invoices.trans_flag = 'A' and vendor_invoices.trans_bk <> 'VOCK') AND
                                                            #{condition}
                                                            FOR XML PATH('vendor_invoice'),type,elements xsinil)
                                                            FOR XML PATH('vendor_invoices')) AS xml) as xmlcol ")
  end
  
  def self.show_invoices(invoice_id)
    vendor_invoice = []
    invoice = Vendor::VendorInvoice.find_by_id(invoice_id) if invoice_id
    invoice =  Vendor::VendorInvoice.new if !invoice
    vendor_invoice << invoice
    if !invoice.new_record?
      invoice.fill_vendor_address(invoice.vendor)
      payment_lines = payments(invoice.trans_no,invoice.trans_bk,invoice.company_id)
      splitted_trans_no = invoice.trans_no.split("-").first || invoice.trans_no
      gl_lines = GeneralLedger::GlPosting.show_gl_postings(splitted_trans_no,invoice.company_id,invoice.trans_bk)                
      vendor_invoice << gl_lines 
      vendor_invoice << payment_lines 
    end
    vendor_invoice
  end
 
  def self.payments(trans_no,trans_bk,company_id)
    Vendor::VendorPaymentLine.find_all_by_voucher_no_and_company_id(voucher_no_from_trans_no_bk(trans_bk,trans_no),company_id) 
  end
  
  def self.fetch_lines_for_invoice(vendor_id) 
    vendor_invoices = []
    vendor = Vendor::Vendor.find_by_id(vendor_id)
    return if !vendor
    vendor_invoice = Vendor::VendorInvoice.new
    vendor_invoice.fill_header  
    vendor_invoice.fill_header_from_vendor(vendor,'I')  
    vendor_invoice.fill_vendor_address(vendor)
    terms = Setup::Term.fill_terms(vendor_invoice.term_code, vendor_invoice.sale_date) 
    if terms
      #    vendor_invoice.due_date = terms.pay1_date  #as these three columns are deleted
      #    vendor_invoice.discount_date = terms.pay2_date
      #    vendor_invoice.discount_per = nulltozero(terms.disc_per)
    end  
 
    vendor_invoice.vendor_invoice_lines << new_invoice_line(vendor.gl_account_id)
    vendor_invoices << vendor_invoice
    vendor_invoices
  end
 
 
  def self.new_invoice_line(gl_account_id)
    vendor_invoice_line = Vendor::VendorInvoiceLine.new
    vendor_invoice_line.serial_no = MAX_SERIAL_NO
    vendor_invoice_line.gl_account_id = gl_account_id
    gl_account =  GeneralLedger::GlAccount.find(gl_account_id)
    if gl_account
      vendor_invoice_line.gl_account_name = gl_account.name
      vendor_invoice_line.gl_account_code = gl_account.code
    end
    vendor_invoice_line
  end
 
  def self.create_invoices(doc)
    invoices = [] 
    multiple_invoice_flag = parse_xml(doc/:vendor_invoices/:multiple_invoices) if (doc/:vendor_invoices/:multiple_invoices)
    if multiple_invoice_flag and multiple_invoice_flag =='Y'
      (doc/:vendor_invoices/:vendor_invoice).each{|invoice_doc|
        invoice = create_invoice(invoice_doc)
        invoices <<  invoice if invoice
      }
    else
      invoice_doc = (doc/:vendor_invoices/:vendor_invoice).first
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
    #  invoice.apply_header_fields_to_lines
    invoice.vendor_invoice_lines.applied_lines.each{|invoice_line|
      invoice_line.copy_header_fields_to_lines(invoice.trans_no,invoice.trans_bk,invoice.trans_date,invoice.company_id) #if invoice_line.new_record?
    }  
    gl_postings = invoice.create_gl_postings_for_invoice
    save_proc = Proc.new{
      invoice.validate_vendor_invoice
      if invoice.new_record?
        invoice.save!  
        invoice.update_trans_no
      else
        invoice.save! 
        invoice.vendor_invoice_lines.save_line 
      end
      #    gl_postings = invoice.create_gl_postings_for_invoice
      GeneralLedger::GlPosting.post_gl_transactions(gl_postings) if gl_postings
    }
    invoice.save_transaction(&save_proc)
    return invoice
  end

  def self.add_or_modify(doc)
    id =  parse_xml(doc/'/id') if (doc/'/id').first  
    invoice = Vendor::VendorInvoice.find_or_create(id) 
    return if !invoice
    return invoice if invoice.view_only
    invoice.apply_attributes(doc) 
    invoice.fill_vendor_address(invoice.vendor)
    #  invoice.apply_address(doc)
    if invoice.new_record?
      invoice.fill_default_header
    end
    invoice.fill_docu_type
    invoice.run_block do
      build_lines(doc/:vendor_invoice_lines/:vendor_invoice_line)
    end
    return invoice 
  end

  def self.fetch_open_invoices(doc)
    criteria = Setup::Criteria.fill_criteria(doc/:criteria)
    Vendor::VendorInvoice.find_by_sql([
        " SELECT CAST((
                SELECT(
                      SELECT(
                              SELECT  TOP 1 code AS account_period_code
                              FROM account_periods
                              WHERE   DATEDIFF(DAY,GETDATE(),to_date) >=0  and DATEDIFF(DAY,GETDATE(),from_date) <=0
                              AND     gl = 'O'
                              AND     trans_flag='A'
                              FOR XML PATH(''),TYPE
                            ),
                            CONVERT(DATE,GETDATE()) AS check_date,
                            (
                              SELECT CAST((
                                        SELECT	vendor_open_invoices.*,
                                                vendors.vendor_category_code AS vendor_category_code,
                                                vendors.code AS vendor_code,
                                                vendors.name AS vendor_name,
                                                vendors.memo_term_code AS term_code,
                                                'PA01' AS trans_bk,
                                                (SELECT '' FOR XML PATH('trans_no'),TYPE) ,
                                                0 AS apply_amt,
                                                0 AS disctaken_amt,
                                                '' AS gl_account_code,
                                                '' AS gl_account_name,
                                                CONVERT(DATE, GETDATE()) AS trans_date,
                                                CONVERT(DATE,GETDATE() + ISNULL(pay1_days, 0)) AS payment_due_date,
                                                'N' AS apply_flag
                                        FROM(
                                              SELECT	'' AS id,
                                                        vendor_invoices.inv_no AS ref_no,
                                                        vendor_invoices.discount_date,
                                                        ISNULL(vendor_invoices.balance_amt,0) AS balance_amt,
                                                        vendor_invoices.due_date,
                                                        vendor_invoices.vendor_id,
                                                        vendor_invoices.trans_bk + vendor_invoices.trans_no AS voucher_no,
                                                        vendor_invoices.trans_date AS voucher_date,
                                                        vendor_invoices.inv_amt AS original_amt,
                                                        ISNULL(vendor_invoices.balance_amt,0 ) AS remaining_amt,
                                                        vendor_invoices.description AS description
                                              FROM vendor_invoices
                                              WHERE   vendor_invoices.trans_flag = 'A'
                                              AND     ISNULL(action_flag, '') ='O'
                                              AND     ISNULL(balance_amt, 0) <> 0

                                              UNION ALL

                                              SELECT  '' AS id,
                                                      '' AS ref_no,
                                                      '' AS discount_date,
                                                      ISNULL(vendor_payments.balance_amt,0) * -1 AS balance_amt,
                                                      vendor_payments.due_date,
                                                      vendor_payments.vendor_id,
                                                      vendor_payments.trans_bk + vendor_payments.trans_no AS voucher_no,
                                                      vendor_payments.trans_date AS voucher_date,
                                                      ISNULL(vendor_payments.paid_amt, 0) * -1 AS original_amt,
                                                      ISNULL(vendor_payments.balance_amt,0 ) * -1 AS remaining_amt,
                                                      vendor_payments.description AS description
                                              FROM vendor_payments
                                              WHERE   vendor_payments.trans_flag = 'A'
                                              AND     ISNULL(action_flag,'') = 'O'
                                              AND     ISNULL(balance_amt,0)  <> 0
                                              AND     trans_type = 'C'
                                            )vendor_open_invoices
                                            INNER JOIN vendors ON
                                                    (
                                                        vendors.id = vendor_id
                                                    )
                                            LEFT OUTER JOIN terms ON
                                                    (
                                                        terms.code = vendors.invoice_term_code
                                                    )
                                            WHERE   vendors.code BETWEEN ? AND ? AND (0 = ? OR vendors.code IN(?))
                                            ORDER BY vendors.code
                                            FOR XML PATH('vendor_payment_line'),TYPE, ELEMENTS XSINIL
                                          ) AS XML)
                                        FOR XML PATH('vendor_payment_lines'), TYPE
                            )FOR XML PATH('vendor_payment'), ELEMENTS XSINIL, TYPE
                      )FOR XML PATH('vendor_payments')
                  ) AS XML) xmlcol",
        criteria.str1, criteria.str2, criteria.multiselect1.length, criteria.multiselect1])
  end
end

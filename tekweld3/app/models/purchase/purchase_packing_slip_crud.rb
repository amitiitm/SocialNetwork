class Purchase::PurchasePackingSlipCrud
  include General

  #fetch service for invoices

  def self.list_open_ps(doc)
    criteria = Setup::Criteria.fill_criteria_for_query(doc/:criteria)
    Purchase::PurchasePackingSlip.find_by_sql ["select CAST( (select(select b.*, (b.item_qty - b.clear_qty) as open_qty,
                                    catalog_items.taxable as taxable,catalog_items.image_thumnail as image_thumnail, b.item_description as catalog_item_description, catalog_items.packet_require_yn as packet_require_yn,
                                    purchase_packing_slips.discount_per as hdr_discount_per,
                                    purchase_packing_slips.discount_amt as hdr_discount_amt,
                                    purchase_packing_slips.tax_per as hdr_tax_per,
                                    purchase_packing_slips.tax_amt as hdr_tax_amt,
                                    vendors.code as vendor_code from purchase_packing_slips
                                    inner join vendors on vendors.id = purchase_packing_slips.vendor_id
                                    join purchase_packing_slip_lines b on b.purchase_packing_slip_id = purchase_packing_slips.id
                                    join catalog_items on catalog_items.id = b.catalog_item_id
                                    where (purchase_packing_slips.trans_flag = 'A') AND
                                    b.purchase_packing_slip_id = purchase_packing_slips.id and
                                    b.item_qty > b.clear_qty and
                                    b.trans_flag = 'A' and
                                    purchase_packing_slips.trans_type = 'I' and
                                    purchase_packing_slips.store_id= #{criteria.company_id} and
                                    purchase_packing_slips.vendor_id between #{criteria.int1} and #{criteria.int2}
                                    order by purchase_packing_slips.trans_date, purchase_packing_slips.trans_no, b.serial_no
                                    FOR XML PATH('purchase_packing_slip'),type,elements xsinil)FOR XML PATH('purchase_packing_slips')) AS xml) as xmlcol
      "]
  end

  def self.list_open_ps_hdr(doc)
    criteria = Setup::Criteria.fill_criteria_for_query(doc/:criteria)
    Purchase::PurchasePackingSlip.find_by_sql ["select CAST( (select(select distinct purchase_packing_slips.id, purchase_packing_slips.trans_no, purchase_packing_slips.trans_date, purchase_packing_slips.ext_ref_no as vendor_po_no ,
                                    vendors.code as vendor_code from purchase_packing_slips
                                    inner join vendors on vendors.id = purchase_packing_slips.vendor_id
                                    join purchase_packing_slip_lines b on b.purchase_packing_slip_id = purchase_packing_slips.id
                                    join catalog_items on catalog_items.id = b.catalog_item_id
                                    where (purchase_packing_slips.trans_flag = 'A') AND
                                    b.purchase_packing_slip_id = purchase_packing_slips.id and
                                    b.item_qty > b.clear_qty and
                                    b.trans_flag = 'A' and
                                    purchase_packing_slips.trans_type = 'I' and
                                    purchase_packing_slips.store_id= #{criteria.company_id} and
                                    purchase_packing_slips.vendor_id between #{criteria.int1} and #{criteria.int2}
                                    order by  purchase_packing_slips.trans_no
                                    FOR XML PATH('purchase_packing_slip'),type,elements xsinil)FOR XML PATH('purchase_packing_slips')) AS xml) as xmlcol
      "]
  end

  def self.list_open_ps_lines(doc)
    criteria = Setup::Criteria.fill_criteria_for_query(doc/:criteria)
    Purchase::PurchasePackingSlip.find_by_sql ["select CAST( (select(select b.*, (b.item_qty - b.clear_qty) as open_qty,
                                    catalog_items.taxable as taxable,catalog_items.image_thumnail as image_thumnail, b.item_description as catalog_item_description, catalog_items.packet_require_yn as packet_require_yn,
                                    purchase_packing_slips.discount_per as hdr_discount_per,
                                    purchase_packing_slips.discount_amt as hdr_discount_amt,
                                    purchase_packing_slips.tax_per as hdr_tax_per,
                                    purchase_packing_slips.tax_amt as hdr_tax_amt,
                                    vendors.code as vendor_code from purchase_packing_slips
                                    inner join vendors on vendors.id = purchase_packing_slips.vendor_id
                                    join purchase_packing_slip_lines b on b.purchase_packing_slip_id = purchase_packing_slips.id
                                    join catalog_items on catalog_items.id = b.catalog_item_id
                                    where (purchase_packing_slips.trans_flag = 'A') AND
                                    b.purchase_packing_slip_id = purchase_packing_slips.id and
                                    b.item_qty > b.clear_qty and
                                    b.trans_flag = 'A' and
                                    purchase_packing_slips.trans_type = 'I' and
                                    purchase_packing_slips.store_id= #{criteria.company_id} and
                                    purchase_packing_slips.id between #{criteria.int1} and #{criteria.int2}
                                    order by purchase_packing_slips.trans_date, purchase_packing_slips.trans_no, b.serial_no
                                    FOR XML PATH('purchase_packing_slip'),type,elements xsinil)FOR XML PATH('purchase_packing_slips')) AS xml) as xmlcol
      "]
  end

  def self.list_purchase_packing_slip_bom(bom_id)
    select_query = "select transaction_boms.* from transaction_boms where id = #{bom_id} order by trans_date desc"
    query = convert_sql_to_db_specific(select_query)
    TransactionBom::TransactionBom.find_by_sql [query]
  end

  #fetch service for memo from packing slips

  def self.list_open_ps_for_memo(doc)
    criteria = Setup::Criteria.fill_criteria_for_query(doc/:criteria)
    Purchase::PurchasePackingSlip.find_by_sql ["select CAST( (select(select
                                    b.id,
                                    b.trans_bk,
		                    b.trans_no,
		                    b.trans_date,
		                    b.serial_no,
		                    b.catalog_item_id,
                                    b.transaction_bom_id,
	                            b.catalog_item_code,
		                    b.item_description,
		                    b.company_id,
	                            b.item_price,
		                    b.discount_per,
		                    b.discount_amt,
		                    b.net_amt,
		                    b.item_type,
		                    b.catalog_item_packet_code,
		                    b.catalog_item_packet_id,
                                    b.customer_sku_no,
                                    b.vendor_sku_no,
                                    b.item_qty,
                                    (b.item_qty - b.clear_qty) as open_qty,
                                    catalog_items.taxable as taxable,catalog_items.image_thumnail as image_thumnail, b.item_description as catalog_item_description, catalog_items.packet_require_yn as packet_require_yn,
                                    purchase_packing_slips.discount_per as hdr_discount_per,
                                    purchase_packing_slips.discount_amt as hdr_discount_amt,
                                    purchase_packing_slips.tax_per as hdr_tax_per,
                                    purchase_packing_slips.tax_amt as hdr_tax_amt,
                                    vendors.code as vendor_code from purchase_packing_slips
                                    inner join vendors on vendors.id = purchase_packing_slips.vendor_id
                                    join purchase_packing_slip_lines b on b.purchase_packing_slip_id = purchase_packing_slips.id
                                    join catalog_items on catalog_items.id = b.catalog_item_id
                                    where (purchase_packing_slips.trans_flag = 'A') AND
                                    b.purchase_packing_slip_id = purchase_packing_slips.id and
                                    b.item_qty > b.clear_qty and
                                    b.trans_flag = 'A' and
                                    purchase_packing_slips.trans_type = 'M' and
                                    purchase_packing_slips.store_id= #{criteria.company_id} and
                                    purchase_packing_slips.vendor_id between #{criteria.int1} and #{criteria.int2}
                                    order by purchase_packing_slips.trans_date, purchase_packing_slips.trans_no, b.serial_no
                                    FOR XML PATH('purchase_packing_slip'),type,elements xsinil)FOR XML PATH('purchase_packing_slips')) AS xml) as xmlcol
      "]
  end

  def self.list_open_ps_hdr_for_memo(doc)
    criteria = Setup::Criteria.fill_criteria_for_query(doc/:criteria)
    Purchase::PurchasePackingSlip.find_by_sql ["select CAST( (select(select distinct purchase_packing_slips.id, purchase_packing_slips.trans_no, purchase_packing_slips.trans_date, purchase_packing_slips.ext_ref_no as vendor_po_no ,
                                    vendors.code as vendor_code from purchase_packing_slips
                                    inner join vendors on vendors.id = purchase_packing_slips.vendor_id
                                    join purchase_packing_slip_lines b on b.purchase_packing_slip_id = purchase_packing_slips.id
                                    join catalog_items on catalog_items.id = b.catalog_item_id
                                    where (purchase_packing_slips.trans_flag = 'A') AND
                                    b.purchase_packing_slip_id = purchase_packing_slips.id and
                                    b.item_qty > b.clear_qty and
                                    b.trans_flag = 'A' and
                                    purchase_packing_slips.trans_type = 'M' and
                                    purchase_packing_slips.store_id=#{criteria.company_id} and
                                    purchase_packing_slips.vendor_id between #{criteria.int1} and #{criteria.int2}
                                    order by  purchase_packing_slips.trans_no
                                    FOR XML PATH('purchase_packing_slip'),type,elements xsinil)FOR XML PATH('purchase_packing_slips')) AS xml) as xmlcol
      "]
  end

  def self.list_open_ps_lines_for_memo(doc)
    criteria = Setup::Criteria.fill_criteria_for_query(doc/:criteria)
    Purchase::PurchasePackingSlip.find_by_sql ["select CAST( (select(select  b.trans_bk,
                                   b.id,
		                    b.trans_no,
		                    b.trans_date,
		                    b.serial_no,
		                    b.catalog_item_id,
	                            b.catalog_item_code,
		                    b.item_description,
		                    b.company_id,
	                            b.item_price,
		                    b.discount_per,
		                    b.discount_amt,
		                    b.net_amt,
		                    b.item_type,
		                    b.catalog_item_packet_code,
		                    b.catalog_item_packet_id,
                                    b.customer_sku_no,
                                    b.vendor_sku_no,
                                    b.item_qty,
                                    (b.item_qty - b.clear_qty) as open_qty,
                                    catalog_items.taxable as taxable,catalog_items.image_thumnail as image_thumnail, b.item_description as catalog_item_description, catalog_items.packet_require_yn as packet_require_yn,
                                    purchase_packing_slips.discount_per as hdr_discount_per,
                                    purchase_packing_slips.discount_amt as hdr_discount_amt,
                                    purchase_packing_slips.tax_per as hdr_tax_per,
                                    purchase_packing_slips.tax_amt as hdr_tax_amt,
                                    vendors.code as vendor_code from purchase_packing_slips
                                    inner join vendors on vendors.id = purchase_packing_slips.vendor_id
                                    join purchase_packing_slip_lines b on b.purchase_packing_slip_id = purchase_packing_slips.id
                                    join catalog_items on catalog_items.id = b.catalog_item_id
                                    where (purchase_packing_slips.trans_flag = 'A') AND
                                    b.purchase_packing_slip_id = purchase_packing_slips.id and
                                    b.item_qty > b.clear_qty and
                                    b.trans_flag = 'A' and
                                    purchase_packing_slips.trans_type = 'M' and
                                    purchase_packing_slips.store_id= #{criteria.company_id} and
                                    purchase_packing_slips.id between #{criteria.int1} and #{criteria.int2}
                                    order by purchase_packing_slips.trans_date, purchase_packing_slips.trans_no, b.serial_no
                                    FOR XML PATH('purchase_packing_slip'),type,elements xsinil)FOR XML PATH('purchase_packing_slips')) AS xml) as xmlcol
      "]
  end

  #Pcking slip services
  def self.list_packing_slips(doc)
    criteria = Setup::Criteria.fill_criteria_for_query(doc/:criteria)
    Purchase::PurchasePackingSlip.find_by_sql ["select CAST( (select(select purchase_packing_slips.id,purchase_packing_slips.trans_bk,purchase_packing_slips.trans_no,purchase_packing_slips.trans_date,purchase_packing_slips.trans_type,purchase_packing_slips.account_period_code,purchase_packing_slips.shipping_code,
                                    purchase_packing_slips.term_code,purchase_packing_slips.ship_date,purchase_packing_slips.cancel_date,purchase_packing_slips.tax_amt,purchase_packing_slips.discount_amt,purchase_packing_slips.item_amt,
                                    purchase_packing_slips.net_amt,purchase_packing_slips.ref_trans_no,purchase_packing_slips.ref_type,purchase_packing_slips.ref_trans_bk,purchase_packing_slips.ref_trans_date,
                                    purchase_packing_slips.remarks,purchase_packing_slips.tracking_no,purchase_packing_slips.bill_name,vendors.code as vendor_code from purchase_packing_slips
                                    inner join vendors on vendors.id = purchase_packing_slips.vendor_id where
                                    (purchase_packing_slips.trans_flag = 'A') AND
                                    (purchase_packing_slips.company_id = #{ criteria.company_id}) AND
                                    (vendors.code between '#{criteria.str1}' and '#{criteria.str2}' AND (0 = #{criteria.multiselect1.length} or vendors.code in ('#{criteria.multiselect1}'))) AND
                                    (trans_no between '#{criteria.str3}' and '#{criteria.str4}' AND (0 = #{criteria.multiselect2.length} or trans_no in ('#{criteria.multiselect2}'))) AND
                                    (trans_date between '#{criteria.dt1}' and '#{criteria.dt2}' ) AND
                                    (account_period_code between '#{criteria.str5[0,8]}' and '#{criteria.str6[0,8]}' AND (0 =#{criteria.multiselect3.length} or account_period_code in ('#{criteria.multiselect3}')))
                                    order by trans_date, trans_no
                                    FOR XML PATH('purchase_packing_slip'),type,elements xsinil)FOR XML PATH('purchase_packing_slips')) AS xml) as xmlcol "
         ]
  end



  def self.show_packing_slips(packing_slip_id)
    Purchase::PurchasePackingSlip.find_all_by_id(packing_slip_id)
  end

  def self.create_packing_slips(doc)
    packing_slips = []
    (doc/:purchase_packing_slips/:purchase_packing_slip).each{|packing_slip_doc|
      packing_slip = create_packing_slip(packing_slip_doc)
      packing_slips <<  packing_slip if packing_slip
    }
    packing_slips
  end

  def self.create_packing_slip(doc)
    packing_slip = add_or_modify_packing_slip(doc)
    packing_slip.generate_trans_no('PAOIPS') if packing_slip.new_record?
    packing_slip.apply_header_fields_to_lines
    packing_slip.apply_line_fields_to_header
    ref_hdrs, ref_lines = packing_slip.run_purchase_posting()
    return  if !packing_slip
    save_proc = Proc.new{
      if packing_slip.new_record?
        packing_slip.save!
        packing_slip.purchase_packing_slip_lines.each{|line|
          line.transaction_boms.each{|bom|
            line.transaction_bom_id = bom.id
            line.save!
          }
        }
      else
        packing_slip.save!
        packing_slip.purchase_packing_slip_lines.save_line
        packing_slip.purchase_packing_slip_lines.each{|line|
          line.transaction_boms.save_line
          line.transaction_boms.each{ |bom|
            if( bom.type_id == line.id and bom.types =='PackingSlip')
              line.transaction_bom_id = bom.id
              line.save!
              bom.transaction_bom_diamonds.save_line
              bom.transaction_bom_stones.save_line
              bom.transaction_bom_others.save_line
              bom.transaction_bom_castings.save_line
              bom.transaction_bom_findings.save_line
            end
          }
        }
      end
      ref_lines.each{|ref_line|
        ref_line.save!
      }if ref_lines
      ref_hdrs.each{|ref_hdr|
        ref_hdr.update_attributes(:update_flag=>'V')
      } if ref_hdrs
    }
    packing_slip.save_transaction(&save_proc)
    return packing_slip
  end

  def self.add_or_modify_packing_slip(doc)
    id =  parse_xml(doc/'id') if (doc/'id').first
    packing_slip = Purchase::PurchasePackingSlip.find_or_create(id)
    return if !packing_slip
    if !packing_slip.new_record? and packing_slip.update_flag == 'V'
      packing_slip.errors.add('This Order is View Only. Cannot update.')
      return packing_slip
    end
    packing_slip.apply_attributes(doc)
    packing_slip.fill_default_header_values() if packing_slip.new_record?
    packing_slip.ref_type = packing_slip.trans_type
    packing_slip.max_serial_no = packing_slip.purchase_packing_slip_lines.maximum_serial_no
    packing_slip.build_lines(doc/:purchase_packing_slip_lines/:purchase_packing_slip_line)
    return packing_slip
  end

  private_class_method :create_packing_slip, :add_or_modify_packing_slip

end

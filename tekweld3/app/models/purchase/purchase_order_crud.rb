class Purchase::PurchaseOrderCrud
  include General

  #Purchase Order services  
  
  def self.list_orders(doc)
    criteria = Setup::Criteria.fill_criteria_for_query(doc/:criteria)    
    Purchase::PurchaseOrder.find_by_sql ["select CAST( (select(select purchase_orders.id,purchase_orders.trans_bk,purchase_orders.trans_no,purchase_orders.trans_date,purchase_orders.trans_type,purchase_orders.account_period_code,purchase_orders.shipping_code,
                                    purchase_orders.term_code,purchase_orders.ship_date,purchase_orders.cancel_date,purchase_orders.tax_amt,purchase_orders.discount_amt,purchase_orders.item_amt,
                                    purchase_orders.net_amt,purchase_orders.ref_trans_no,purchase_orders.ref_type,purchase_orders.ref_trans_bk,purchase_orders.ref_trans_date,
                                    purchase_orders.remarks,purchase_orders.tracking_no,purchase_orders.bill_name,vendors.code as vendor_code from purchase_orders
                                    inner join vendors on vendors.id = purchase_orders.vendor_id where
                                    (purchase_orders.trans_flag = 'A') AND
                                    (purchase_orders.company_id = #{criteria.company_id}) AND
                                    (vendors.code between '#{criteria.str1}' and '#{criteria.str2}' AND (0 = #{criteria.multiselect1.length} or vendors.code in ('#{criteria.multiselect1}'))) AND
                                    (trans_no between '#{criteria.str3}' and '#{criteria.str4}' AND (0 = #{criteria.multiselect2.length} or trans_no in ('#{criteria.multiselect2}'))) AND
                                    (trans_date between '#{criteria.dt1}' and '#{criteria.dt2}' ) AND
                                    (account_period_code between '#{criteria.str5[0,8]}' and '#{criteria.str6[0,8]}' AND (0 = #{criteria.multiselect3.length} or account_period_code in ('#{criteria.multiselect3}')))
                                    order by trans_date, trans_no
                                    FOR XML PATH('purchase_order'),type,elements xsinil)FOR XML PATH('purchase_orders')) AS xml) as xmlcol "  ]
  end

  def self.list_open_standard_orders(doc)
    criteria = Setup::Criteria.fill_criteria_for_query(doc/:criteria)
    Purchase::PurchaseOrder.find_by_sql ["select CAST( (select(select b.*, (b.item_qty - b.clear_qty) as open_qty,
                                    catalog_items.taxable as taxable,catalog_items.image_thumnail as image_thumnail, catalog_items.packet_require_yn as packet_require_yn,
                                    purchase_orders.discount_per as hdr_discount_per, 
                                    purchase_orders.discount_amt as hdr_discount_amt, 
                                    purchase_orders.tax_per as hdr_tax_per, 
                                    purchase_orders.tax_amt as hdr_tax_amt,
                                    vendors.code as vendor_code from purchase_orders
                                    inner join vendors on vendors.id = purchase_orders.vendor_id
                                    join purchase_order_lines b on b.purchase_order_id = purchase_orders.id 
                                    join catalog_items on catalog_items.id = b.catalog_item_id
                                    where (purchase_orders.trans_flag = 'A') AND
                                    b.purchase_order_id = purchase_orders.id and
                                    b.item_qty > b.clear_qty and
                                    b.trans_flag = 'A' and
                                    purchase_orders.trans_type in ('S','W','O') and
                                    purchase_orders.store_id= #{criteria.company_id} and
                                    purchase_orders.vendor_id between #{criteria.int1} and #{criteria.int2}
                                    order by purchase_orders.trans_date, purchase_orders.trans_no, b.serial_no
                                    FOR XML PATH('purchase_order'),type,elements xsinil)FOR XML PATH('purchase_orders')) AS xml) as xmlcol 
      "]
  end


  def self.list_open_memo_orders(doc)
    criteria = Setup::Criteria.fill_criteria_for_query(doc/:criteria)
    Purchase::PurchaseOrder.find_by_sql ["select CAST( (select(select b.*, (b.item_qty - b.clear_qty) as open_qty,
                                    catalog_items.taxable as taxable,catalog_items.image_thumnail as image_thumnail, catalog_items.packet_require_yn as packet_require_yn,
                                    purchase_orders.discount_per as hdr_discount_per, 
                                    purchase_orders.discount_amt as hdr_discount_amt, 
                                    purchase_orders.tax_per as hdr_tax_per, 
                                    purchase_orders.tax_amt as hdr_tax_amt,
                                    vendors.code as vendor_code from purchase_orders
                                    inner join vendors on vendors.id = purchase_orders.vendor_id
                                    join purchase_order_lines b on b.purchase_order_id = purchase_orders.id 
                                    join catalog_items on catalog_items.id = b.catalog_item_id
                                    where (purchase_orders.trans_flag = 'A') AND
                                    b.purchase_order_id = purchase_orders.id and
                                    b.item_qty > b.clear_qty and
                                    b.trans_flag = 'A' and
                                    purchase_orders.trans_type in('O', 'M') and
                                    purchase_orders.store_id= #{criteria.company_id} and
                                    purchase_orders.vendor_id between #{criteria.int1} and #{criteria.int2}
                                    order by purchase_orders.trans_date, purchase_orders.trans_no, b.serial_no
                                    FOR XML PATH('purchase_order'),type,elements xsinil)FOR XML PATH('purchase_orders')) AS xml) as xmlcol 
      "]
  end

  def self.list_open_memo_orders_hdr(doc)
    criteria = Setup::Criteria.fill_criteria_for_query(doc/:criteria)
    Purchase::PurchaseOrder.find_by_sql ["select CAST( (select(select distinct purchase_orders.id, purchase_orders.trans_no, purchase_orders.trans_date, purchase_orders.ext_ref_no as vendor_po_no ,
                                    vendors.code as vendor_code from purchase_orders
                                    inner join vendors on vendors.id = purchase_orders.vendor_id
                                    join purchase_order_lines b on b.purchase_order_id = purchase_orders.id 
                                    join catalog_items on catalog_items.id = b.catalog_item_id
                                    where (purchase_orders.trans_flag = 'A') AND
                                    b.purchase_order_id = purchase_orders.id and
                                    b.item_qty > b.clear_qty and
                                    b.trans_flag = 'A' and
                                    purchase_orders.trans_type in('O', 'M') and
                                    purchase_orders.store_id= #{criteria.company_id} and
                                    purchase_orders.vendor_id between #{criteria.int1} and #{criteria.int2}
                                    order by  purchase_orders.trans_no
                                    FOR XML PATH('purchase_order'),type,elements xsinil)FOR XML PATH('purchase_orders')) AS xml) as xmlcol 
      "]
  end

  def self.list_open_memo_order_lines(doc)
    criteria = Setup::Criteria.fill_criteria_for_query(doc/:criteria)
    Purchase::PurchaseOrder.find_by_sql ["select CAST( (select(select b.*, (b.item_qty - b.clear_qty) as open_qty,
                                    catalog_items.taxable as taxable,catalog_items.image_thumnail as image_thumnail, catalog_items.packet_require_yn as packet_require_yn,
                                    purchase_orders.discount_per as hdr_discount_per, 
                                    purchase_orders.discount_amt as hdr_discount_amt, 
                                    purchase_orders.tax_per as hdr_tax_per, 
                                    purchase_orders.tax_amt as hdr_tax_amt,
                                    vendors.code as vendor_code from purchase_orders
                                    inner join vendors on vendors.id = purchase_orders.vendor_id
                                    join purchase_order_lines b on b.purchase_order_id = purchase_orders.id 
                                    join catalog_items on catalog_items.id = b.catalog_item_id
                                    where (purchase_orders.trans_flag = 'A') AND
                                    b.purchase_order_id = purchase_orders.id and
                                    b.item_qty > b.clear_qty and
                                    b.trans_flag = 'A' and
                                    purchase_orders.trans_type = 'M' and
                                    purchase_orders.store_id= #{criteria.company_id} and
                                    purchase_orders.id between #{criteria.int1} and #{criteria.int2}
                                    order by purchase_orders.trans_date, purchase_orders.trans_no, b.serial_no
                                    FOR XML PATH('purchase_order'),type,elements xsinil)FOR XML PATH('purchase_orders')) AS xml) as xmlcol 
      "]
  end


  def self.list_open_standard_orders_hdr(doc)
    criteria = Setup::Criteria.fill_criteria_for_query(doc/:criteria)
    Purchase::PurchaseOrder.find_by_sql ["select CAST( (select(select distinct purchase_orders.id, purchase_orders.trans_no, purchase_orders.trans_date, purchase_orders.ext_ref_no as vendor_po_no,
                                    vendors.code as vendor_code from purchase_orders
                                    inner join vendors on vendors.id = purchase_orders.vendor_id
                                    join purchase_order_lines b on b.purchase_order_id = purchase_orders.id 
                                    join catalog_items on catalog_items.id = b.catalog_item_id
                                    where (purchase_orders.trans_flag = 'A') AND
                                    b.purchase_order_id = purchase_orders.id and
                                    b.item_qty > b.clear_qty and
                                    b.trans_flag = 'A' and
                                    purchase_orders.trans_type in('S','W','O') and
                                    purchase_orders.store_id = #{criteria.company_id} and
                                    purchase_orders.vendor_id between #{criteria.int1} and #{criteria.int2}
                                    order by  purchase_orders.trans_no
                                    FOR XML PATH('purchase_order'),type,elements xsinil)FOR XML PATH('purchase_orders')) AS xml) as xmlcol 
      "]
  end


  def self.list_open_standard_order_lines(doc)
    criteria = Setup::Criteria.fill_criteria_for_query(doc/:criteria)
    Purchase::PurchaseOrder.find_by_sql ["select CAST( (select(select b.*, (b.item_qty - b.clear_qty) as open_qty,
                                    catalog_items.taxable as taxable,catalog_items.image_thumnail as image_thumnail, catalog_items.packet_require_yn as packet_require_yn,
                                    purchase_orders.discount_per as hdr_discount_per, 
                                    purchase_orders.discount_amt as hdr_discount_amt, 
                                    purchase_orders.tax_per as hdr_tax_per, 
                                    purchase_orders.tax_amt as hdr_tax_amt,
                                    vendors.code as vendor_code from purchase_orders
                                    inner join vendors on vendors.id = purchase_orders.vendor_id
                                    join purchase_order_lines b on b.purchase_order_id = purchase_orders.id 
                                    join catalog_items on catalog_items.id = b.catalog_item_id
                                    where (purchase_orders.trans_flag = 'A') AND
                                    b.purchase_order_id = purchase_orders.id and
                                    b.item_qty > b.clear_qty and
                                    b.trans_flag = 'A' and
                                    purchase_orders.trans_type in('S','W','O') and
                                    purchase_orders.store_id= #{criteria.company_id} and
                                    purchase_orders.id between #{criteria.int1} and #{criteria.int2}
                                    order by purchase_orders.trans_date, purchase_orders.trans_no, b.serial_no
                                    FOR XML PATH('purchase_order'),type,elements xsinil)FOR XML PATH('purchase_orders')) AS xml) as xmlcol 
      "]
  end


  def self.list_open_orders(doc)
    criteria = Setup::Criteria.fill_criteria_for_query(doc/:criteria)
    Purchase::PurchaseOrder.find_by_sql ["select CAST( (select(select b.*, (b.item_qty - b.clear_qty) as open_qty,
                                    catalog_items.taxable as taxable,catalog_items.image_thumnail as image_thumnail, catalog_items.packet_require_yn as packet_require_yn,
                                    vendors.code as vendor_code from purchase_orders
                                    inner join vendors on vendors.id = purchase_orders.vendor_id
                                    join purchase_order_lines b on b.purchase_order_id = purchase_orders.id 
                                    join catalog_items on catalog_items.id = b.catalog_item_id
                                    where (purchase_orders.trans_flag = 'A') AND
                                    b.purchase_order_id = purchase_orders.id and
                                    b.item_qty > b.clear_qty and
                                    b.trans_flag = 'A' and
                                    purchase_orders.store_id= #{criteria.company_id} and
                                    purchase_orders.vendor_id between #{criteria.int1} and #{criteria.int2}
                                    order by purchase_orders.trans_date, purchase_orders.trans_no, b.serial_no
                                    FOR XML PATH('purchase_order'),type,elements xsinil)FOR XML PATH('purchase_orders')) AS xml) as xmlcol 
      "]
  end

  def self.list_open_orders_hdr(doc)
    criteria = Setup::Criteria.fill_criteria_for_query(doc/:criteria)
    Purchase::PurchaseOrder.find_by_sql ["select CAST( (select(select distinct purchase_orders.id, purchase_orders.trans_no, purchase_orders.trans_date, purchase_orders.ext_ref_no as vendor_po_no, 
                                    vendors.code as vendor_code from purchase_orders
                                    inner join vendors on vendors.id = purchase_orders.vendor_id
                                    join purchase_order_lines b on b.purchase_order_id = purchase_orders.id 
                                    join catalog_items on catalog_items.id = b.catalog_item_id
                                    where (purchase_orders.trans_flag = 'A') AND
                                    b.purchase_order_id = purchase_orders.id and
                                    b.item_qty > b.clear_qty and
                                    b.trans_flag = 'A' and
                                    purchase_orders.store_id=#{criteria.company_id} and
                                    purchase_orders.vendor_id between #{criteria.int1} and #{criteria.int2}
                                    order by purchase_orders.trans_no
                                    FOR XML PATH('purchase_order'),type,elements xsinil)FOR XML PATH('purchase_orders')) AS xml) as xmlcol 
      "]
  end

  def self.list_open_order_lines(doc)
    criteria = Setup::Criteria.fill_criteria_for_query(doc/:criteria)
    Purchase::PurchaseOrder.find_by_sql ["select CAST( (select(select b.*, (b.item_qty - b.clear_qty) as open_qty,
                                    catalog_items.taxable as taxable, catalog_items.image_thumnail as image_thumnail,  catalog_items.packet_require_yn as packet_require_yn, 
                                    vendors.code as vendor_code from purchase_orders
                                    inner join vendors on vendors.id = purchase_orders.vendor_id
                                    join purchase_order_lines b on b.purchase_order_id = purchase_orders.id 
                                    join catalog_items on catalog_items.id = b.catalog_item_id
                                    where (purchase_orders.trans_flag = 'A') AND
                                    b.purchase_order_id = purchase_orders.id and
                                    b.item_qty > b.clear_qty and
                                    b.trans_flag = 'A' and
                                    purchase_orders.store_id= #{criteria.company_id} and
                                    purchase_orders.id between #{criteria.int1} and #{criteria.int2}
                                    order by purchase_orders.trans_date, purchase_orders.trans_no, b.serial_no
                                    FOR XML PATH('purchase_order'),type,elements xsinil)FOR XML PATH('purchase_orders')) AS xml) as xmlcol 
      "]
  end
  
  #fetch service for packingslip
  
  def self.list_open_orders_for_ps(doc)
    criteria = Setup::Criteria.fill_criteria_for_query(doc/:criteria)
    Purchase::PurchaseOrder.find_by_sql ["select CAST( (select(select b.*, (b.item_qty - b.clear_qty) as open_qty, 
                                    catalog_items.taxable as taxable,catalog_items.image_thumnail as image_thumnail, b.item_description as catalog_item_description, catalog_items.packet_require_yn as packet_require_yn,
                                    purchase_orders.discount_per as hdr_discount_per, 
                                    purchase_orders.discount_amt as hdr_discount_amt, 
                                    purchase_orders.tax_per as hdr_tax_per, 
                                    purchase_orders.tax_amt as hdr_tax_amt,
                                    vendors.code as vendor_code from purchase_orders
                                    inner join vendors on vendors.id = purchase_orders.vendor_id
                                    join purchase_order_lines b on b.purchase_order_id = purchase_orders.id 
                                    join catalog_items on catalog_items.id = b.catalog_item_id
                                    where (purchase_orders.trans_flag = 'A') AND
                                    b.purchase_order_id = purchase_orders.id and
                                    b.item_qty > b.clear_qty and
                                    b.trans_flag = 'A' and
                                    purchase_orders.trans_type in('S','O') and
                                    purchase_orders.store_id= #{criteria.company_id} and
                                    purchase_orders.vendor_id between #{criteria.int1} and #{criteria.int2}
                                    order by purchase_orders.trans_date, purchase_orders.trans_no, b.serial_no
                                    FOR XML PATH('purchase_order'),type,elements xsinil)FOR XML PATH('purchase_orders')) AS xml) as xmlcol 
      "]
  end

  def self.list_open_orders_hdr_for_ps(doc)
    criteria = Setup::Criteria.fill_criteria_for_query(doc/:criteria)
    Purchase::PurchaseOrder.find_by_sql ["select CAST( (select(select distinct purchase_orders.id, purchase_orders.trans_no, purchase_orders.trans_date, purchase_orders.ext_ref_no as vendor_po_no ,
                                    vendors.code as vendor_code from purchase_orders
                                    inner join vendors on vendors.id = purchase_orders.vendor_id
                                    join purchase_order_lines b on b.purchase_order_id = purchase_orders.id 
                                    join catalog_items on catalog_items.id = b.catalog_item_id
                                    where (purchase_orders.trans_flag = 'A') AND
                                    b.purchase_order_id = purchase_orders.id and
                                    b.item_qty > b.clear_qty and
                                    b.trans_flag = 'A' and
                                    purchase_orders.trans_type in('S','O') and
                                    purchase_orders.store_id= #{criteria.company_id} and
                                    purchase_orders.vendor_id between #{criteria.int1} and #{criteria.int2}
                                    order by  purchase_orders.trans_no
                                    FOR XML PATH('purchase_order'),type,elements xsinil)FOR XML PATH('purchase_orders')) AS xml) as xmlcol 
      "]
  end

  def self.list_open_order_lines_for_ps(doc)
    criteria = Setup::Criteria.fill_criteria_for_query(doc/:criteria)
    Purchase::PurchaseOrder.find_by_sql ["select CAST( (select(select b.*, (b.item_qty - b.clear_qty) as open_qty, 
                                    catalog_items.taxable as taxable,catalog_items.image_thumnail as image_thumnail, b.item_description as catalog_item_description, catalog_items.packet_require_yn as packet_require_yn,
                                    purchase_orders.discount_per as hdr_discount_per, 
                                    purchase_orders.discount_amt as hdr_discount_amt, 
                                    purchase_orders.tax_per as hdr_tax_per, 
                                    purchase_orders.tax_amt as hdr_tax_amt,
                                    vendors.code as vendor_code from purchase_orders
                                    inner join vendors on vendors.id = purchase_orders.vendor_id
                                    join purchase_order_lines b on b.purchase_order_id = purchase_orders.id 
                                    join catalog_items on catalog_items.id = b.catalog_item_id
                                    where (purchase_orders.trans_flag = 'A') AND
                                    b.purchase_order_id = purchase_orders.id and
                                    b.item_qty > b.clear_qty and
                                    b.trans_flag = 'A' and
                                    purchase_orders.trans_type in('S','O') and
                                    purchase_orders.store_id=#{criteria.company_id} and
                                    purchase_orders.id between #{criteria.int1} and #{criteria.int2}
                                    order by purchase_orders.trans_date, purchase_orders.trans_no, b.serial_no
                                    FOR XML PATH('purchase_order'),type,elements xsinil)FOR XML PATH('purchase_orders')) AS xml) as xmlcol 
      "]
  end
  
  def self.list_bom_for_ps(bom_id)
    select_query = "select transaction_boms.* from transaction_boms where id = #{bom_id} order by trans_date desc"
    query = convert_sql_to_db_specific(select_query)
    TransactionBom::TransactionBom.find_by_sql [query]
  end
  
  def self.list_purchase_order_bom(bom_id)
    select_query = "select transaction_boms.* from transaction_boms where id = #{bom_id} order by trans_date desc"
    query = convert_sql_to_db_specific(select_query)
    TransactionBom::TransactionBom.find_by_sql [query]
  end

  
  def self.show_order(order_id)
    Purchase::PurchaseOrder.find_all_by_id(order_id)
  end
  
  def self.create_po_from_so(doc)
    begin
      order_id = parse_xml(doc/:params/'order_id')
      vendor_id = parse_xml(doc/:params/'vendor_id')
      created_by = parse_xml(doc/:params/'created_by')
      order = Sales::SalesOrder.find_by_id(order_id)
      company = Setup::Company.find_by_id(order.company_id)
      order_line = Sales::SalesOrderLine.active.find_by_sales_order_id_and_item_type(order_id,'I')
      return 'Please enter Item inside order before creating Purchase Order','error' if !order_line
      vendor = Vendor::Vendor.find_by_id(vendor_id)
      term = Setup::Term.fill_terms(vendor.invoice_term_code,Time.now.to_date)
      xml_string = "<purchase_orders>"
      xml_string = xml_string+"<purchase_order>"
      xml_string = xml_string +"<vendor_id>#{vendor.id}</vendor_id>"
      xml_string = xml_string +"<term_code>#{vendor.invoice_term_code}</term_code>"
      xml_string = xml_string +"<due_date>#{term.pay1_date}</due_date>"
      xml_string = xml_string +"<ship_date>#{Time.now.to_date}</ship_date>"
      xml_string = xml_string +"<trans_type>O</trans_type>"
      xml_string = xml_string +"<ref_trans_no>#{order.trans_no}</ref_trans_no>"
      xml_string = xml_string +"<ref_trans_bk>#{order.trans_bk}</ref_trans_bk>"
      xml_string = xml_string +"<shipping_code/>"
      xml_string = xml_string +"<cancel_date>#{Time.now.to_date}</cancel_date>"
      xml_string = xml_string +"<trans_no />"
      xml_string = xml_string +"<trans_date>#{Time.now.to_date}</trans_date>"
      xml_string = xml_string +"<account_period_code>#{Setup::AccountPeriod.period_from_date(Time.now).code}</account_period_code>"
      xml_string = xml_string +"<trans_flag>A</trans_flag>"
      xml_string = xml_string +"<store_id>#{order.company_id}</store_id>"
      xml_string = xml_string +"<bill_name>#{vendor.name}</bill_name>"
      xml_string = xml_string +"<bill_address1>#{vendor.address1}</bill_address1>"
      xml_string = xml_string +"<bill_address2>#{vendor.address2}</bill_address2>"
      xml_string = xml_string +"<bill_city>#{vendor.city}</bill_city>"
      xml_string = xml_string +"<bill_state>#{vendor.state}</bill_state>"
      xml_string = xml_string +"<bill_zip>#{vendor.zip}</bill_zip>"
      xml_string = xml_string +"<bill_fax>#{vendor.fax}</bill_fax>"
      xml_string = xml_string +"<bill_phone>#{vendor.phone}</bill_phone>"
      xml_string = xml_string +"<bill_country>#{vendor.country}</bill_country>"
      xml_string = xml_string +"<ship_name>#{company.name}</ship_name>"
      xml_string = xml_string +"<ship_address1>#{company.address1}</ship_address1>"
      xml_string = xml_string +"<ship_address2>#{company.address2}</ship_address2>"
      xml_string = xml_string +"<ship_city>#{company.city}</ship_city>"
      xml_string = xml_string +"<ship_state>#{company.state}</ship_state>"
      xml_string = xml_string +"<ship_zip>#{company.zip}</ship_zip>"
      xml_string = xml_string +"<ship_country>#{company.country}</ship_country>"
      xml_string = xml_string +"<ship_phone>#{company.phone}</ship_phone>"
      xml_string = xml_string +"<ship_fax>#{company.fax}</ship_fax>"
      xml_string = xml_string +"<remarks>#{order.remarks}</remarks>"
      xml_string = xml_string +"<item_amt>#{order_line.item_amt}</item_amt>"
      xml_string = xml_string +"<discount_per>0.00</discount_per>"
      xml_string = xml_string +"<discount_amt>0.00</discount_amt>"
      xml_string = xml_string +"<tax_per>0.00</tax_per>"
      xml_string = xml_string +"<tax_amt>0.00</tax_amt>"
      xml_string = xml_string +"<ship_amt>0.00</ship_amt>"
      xml_string = xml_string +"<other_amt>0.00</other_amt>"
      xml_string = xml_string +"<net_amt>#{order_line.item_amt}</net_amt>"
      xml_string = xml_string +"<insurance_amt>0.00</insurance_amt>"
      xml_string = xml_string +"<post_flag>P</post_flag>"
      xml_string = xml_string +"<vendor_code>#{vendor.code}</vendor_code>"
      xml_string = xml_string +"<store_code>#{company.company_cd}</store_code>"
      xml_string = xml_string +"<updated_by>#{created_by}</updated_by>"
      xml_string = xml_string +"<updated_by_code/>"
      xml_string = xml_string +"<created_by>#{created_by}</created_by>"
      xml_string = xml_string +"<company_id>#{order.company_id}</company_id>"
      xml_string = xml_string +"<id/>"

      xml_string = xml_string+"<purchase_order_lines>"
      xml_string = xml_string+"<purchase_order_line>"
      xml_string = xml_string +"<catalog_item_id>#{order_line.catalog_item_id}</catalog_item_id>"
      xml_string = xml_string +"<vendor_sku_no />"
      xml_string = xml_string +"<item_description>#{order_line.item_description}</item_description>"
      xml_string = xml_string +"<item_qty>#{order_line.item_qty}</item_qty>"
      xml_string = xml_string +"<item_price>#{order_line.item_price}</item_price>"
      xml_string = xml_string +"<item_amt>#{order_line.item_amt}</item_amt>"
      xml_string = xml_string +"<discount_per>0.00</discount_per>"
      xml_string = xml_string +"<discount_amt>0.00</discount_amt>"
      xml_string = xml_string +"<net_amt>#{order_line.item_amt}</net_amt>"
      xml_string = xml_string +"<trans_flag>A</trans_flag>"
      xml_string = xml_string +"<taxable>Y</taxable>"
      xml_string = xml_string +"<trans_bk />"
      xml_string = xml_string +"<trans_no />"
      xml_string = xml_string +"<trans_date />"
      xml_string = xml_string +"<ref_trans_bk>#{order.trans_bk}</ref_trans_bk>"
      xml_string = xml_string +"<ref_trans_no>#{order.trans_no}</ref_trans_no>"
      xml_string = xml_string +"<ref_type>O</ref_type>"
      xml_string = xml_string +"<ref_trans_date>#{order.trans_date}</ref_trans_date>"
      xml_string = xml_string +"<ref_serial_no>#{order_line.serial_no}</ref_serial_no>"
      xml_string = xml_string +"<ref_qty>0.00</ref_qty>"
      xml_string = xml_string +"<clear_qty>0.00</clear_qty>"
      xml_string = xml_string +"<serial_no>101</serial_no>"
      xml_string = xml_string +"<image_thumnail></image_thumnail>"
      xml_string = xml_string +"<catalog_item_code>#{order_line.catalog_item_code}</catalog_item_code>"
      xml_string = xml_string +"<item_type>I</item_type>"
      xml_string = xml_string +"<customer_sku_no />"
      xml_string = xml_string +"<company_id>#{order.company_id}</company_id>"
      xml_string = xml_string +"<updated_by>#{created_by}</updated_by>"
      xml_string = xml_string +"<created_by>#{created_by}</created_by>"
      xml_string = xml_string +"<updated_by_code/>"
      xml_string = xml_string +"<id />"
      xml_string = xml_string+"</purchase_order_line>"
      xml_string = xml_string+"</purchase_order_lines>"

      xml_string = xml_string+"</purchase_order>"
      xml_string = xml_string+"</purchase_orders>"
      xml = %{#{xml_string}}
      doc = Hpricot::XML(xml)
      purchase_orders =  create_orders(doc)
      purchase_order =  purchase_orders.first if !purchase_orders.empty?
      if purchase_order.errors.empty?
        activity = order.create_sales_order_transaction_activity("PURCHASE ORDER# #{purchase_order.trans_no} IS CREATED AGAINST SO# #{order.trans_no}")
        activity.save!
        return purchase_orders,'success'
      else
        return 'Some error occurred','error'
      end
    rescue Exception => ex
      return "Exception Occurred",'error'
    end
  end

  def self.create_orders(doc)
    orders = [] 
    (doc/:purchase_orders/:purchase_order).each{|order_doc|
      order = create_order(order_doc)
      orders <<  order if order
    }
    orders
  end

  def self.create_order(doc)
    order = add_or_modify_order(doc) 
    order.generate_trans_no('PAOIOD') if order.new_record?
    #    order.trans_no = parse_xml(doc/"po_no") if parse_xml(doc/"po_no")
    order.apply_header_fields_to_lines  
    order.apply_line_fields_to_header  
    return  if !order
    save_proc = Proc.new{
      if order.new_record?
        order.save!  
      else
        order.save! 
        order.purchase_order_lines.save_line
      end
    }
    if(order.errors.empty?)
      order.save_transaction(&save_proc)
    end
    return order
  end

  def self.add_or_modify_order(doc)  
    id =  parse_xml(doc/'id') if (doc/'id').first  
    order = Purchase::PurchaseOrder.find_or_create(id) 
    return if !order
    if !order.new_record? and order.update_flag == 'V'
      order.errors.add('This Order is View Only. Cannot update.') 
      return order
    end
    order.apply_attributes(doc) 
    order.fill_default_header_values() if order.new_record? 
    order.ref_type = order.trans_type
    order.max_serial_no = order.purchase_order_lines.maximum_serial_no
    order.build_lines(doc/:purchase_order_lines/:purchase_order_line)   
    return order 
  end

  private_class_method :create_order, :add_or_modify_order

end

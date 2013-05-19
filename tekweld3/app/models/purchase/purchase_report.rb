class Purchase::PurchaseReport
  include General
  
  def self.order_register(doc)
    criteria = Setup::Criteria.fill_criteria_for_sp(doc/:criteria)
    sql_query = ActiveRecord::Base.connection();
    sql_query.execute "SET IMPLICIT_TRANSACTIONS OFF";
    sql_query.begin_db_transaction
    list = ActiveRecord::Base.connection.select_all("exec sp_retail_puoi_order_register
           '#{criteria.user_id}',
           '#{criteria.dt1.to_datetime.strftime('%m-%d-%Y %H:%M:%S')}',       '#{criteria.dt2.to_datetime.strftime('%m-%d-%Y %H:%M:%S')}',
           '#{criteria.dt3.to_datetime.strftime('%m-%d-%Y %H:%M:%S')}',       '#{criteria.dt4.to_datetime.strftime('%m-%d-%Y %H:%M:%S')}',
           '#{criteria.dt5.to_datetime.strftime('%m-%d-%Y %H:%M:%S')}',       '#{criteria.dt6.to_datetime.strftime('%m-%d-%Y %H:%M:%S')}',
           '#{criteria.dt7.to_datetime.strftime('%m-%d-%Y %H:%M:%S')}',       '#{criteria.dt8.to_datetime.strftime('%m-%d-%Y %H:%M:%S')}',
           '#{criteria.str1}',      '#{criteria.str2}',        '#{criteria.multiselect1}' ,
           '#{criteria.str3}',      '#{criteria.str4}',        '#{criteria.multiselect2}' ,
           '#{criteria.str5}',      '#{criteria.str6}',        '#{criteria.multiselect3}' ,
           '#{criteria.str7}',      '#{criteria.str8}',        '#{criteria.multiselect4}' ,
           '#{criteria.str9}',      '#{criteria.str10}',       '#{criteria.multiselect5}' ,
           '#{criteria.str11}',     '#{criteria.str12}',       '#{criteria.multiselect6}' ,
           '#{criteria.str13}',     '#{criteria.str14}',       '#{criteria.multiselect7}'          ")
    sql_query.commit_db_transaction 
    list
  end 
  
  def self.invoice_register(doc)
    criteria = Setup::Criteria.fill_criteria_for_sp(doc/:criteria)
    sql_query = ActiveRecord::Base.connection();
    sql_query.execute "SET IMPLICIT_TRANSACTIONS OFF";
    sql_query.begin_db_transaction
    list = ActiveRecord::Base.connection.select_all("exec sp_retail_puoi_invoice_register
           '#{criteria.user_id}',
           '#{criteria.dt1.to_datetime.strftime('%m-%d-%Y %H:%M:%S')}',       '#{criteria.dt2.to_datetime.strftime('%m-%d-%Y %H:%M:%S')}',
           '#{criteria.dt3.to_datetime.strftime('%m-%d-%Y %H:%M:%S')}',       '#{criteria.dt4.to_datetime.strftime('%m-%d-%Y %H:%M:%S')}',
           '#{criteria.dt5.to_datetime.strftime('%m-%d-%Y %H:%M:%S')}',       '#{criteria.dt6.to_datetime.strftime('%m-%d-%Y %H:%M:%S')}',
           '#{criteria.dt7.to_datetime.strftime('%m-%d-%Y %H:%M:%S')}',       '#{criteria.dt8.to_datetime.strftime('%m-%d-%Y %H:%M:%S')}',
           '#{criteria.str1}',      '#{criteria.str2}',        '#{criteria.multiselect1}' ,
           '#{criteria.str3}',      '#{criteria.str4}',        '#{criteria.multiselect2}' ,
           '#{criteria.str5}',      '#{criteria.str6}',        '#{criteria.multiselect3}' ,
           '#{criteria.str7}',      '#{criteria.str8}',        '#{criteria.multiselect4}' ,
           '#{criteria.str9}',      '#{criteria.str10}',       '#{criteria.multiselect5}' ,
           '#{criteria.str11}',     '#{criteria.str12}',       '#{criteria.multiselect6}' ,
           '#{criteria.str13}',     '#{criteria.str14}',       '#{criteria.multiselect7}' ,
           '#{criteria.str15}',     '#{criteria.str16}',       '#{criteria.multiselect8}' ,
           '#{criteria.str17}',     '#{criteria.str18}',       '#{criteria.multiselect9}'        ")
    sql_query.commit_db_transaction 
    list
  end 

 
  def self.credit_invoice_register(doc)
    criteria = Setup::Criteria.fill_criteria_for_sp(doc/:criteria)
    sql_query = ActiveRecord::Base.connection();
    sql_query.execute "SET IMPLICIT_TRANSACTIONS OFF";
    sql_query.begin_db_transaction
    list = ActiveRecord::Base.connection.select_all("exec sp_retail_puoi_credit_invoice_register
           '#{criteria.user_id}',
           '#{criteria.dt1.to_datetime.strftime('%m-%d-%Y %H:%M:%S')}',       '#{criteria.dt2.to_datetime.strftime('%m-%d-%Y %H:%M:%S')}',
           '#{criteria.dt3.to_datetime.strftime('%m-%d-%Y %H:%M:%S')}',       '#{criteria.dt4.to_datetime.strftime('%m-%d-%Y %H:%M:%S')}',
           '#{criteria.dt5.to_datetime.strftime('%m-%d-%Y %H:%M:%S')}',       '#{criteria.dt6.to_datetime.strftime('%m-%d-%Y %H:%M:%S')}',
           '#{criteria.str1}',      '#{criteria.str2}',        '#{criteria.multiselect1}' ,
           '#{criteria.str3}',      '#{criteria.str4}',        '#{criteria.multiselect2}' ,
           '#{criteria.str5}',      '#{criteria.str6}',        '#{criteria.multiselect3}' ,
           '#{criteria.str7}',      '#{criteria.str8}',        '#{criteria.multiselect4}' ,
           '#{criteria.str9}',      '#{criteria.str10}',       '#{criteria.multiselect5}' ,
           '#{criteria.str11}',     '#{criteria.str12}',       '#{criteria.multiselect6}'        ")
    sql_query.commit_db_transaction 
    list
  end 

  def self.memo_register(doc)
    criteria = Setup::Criteria.fill_criteria_for_sp(doc/:criteria)
    sql_query = ActiveRecord::Base.connection();
    sql_query.execute "SET IMPLICIT_TRANSACTIONS OFF";
    sql_query.begin_db_transaction
    list = ActiveRecord::Base.connection.select_all("exec sp_retail_puoi_memo_register
           '#{criteria.user_id}',
           '#{criteria.dt1.to_datetime.strftime('%m-%d-%Y %H:%M:%S')}',       '#{criteria.dt2.to_datetime.strftime('%m-%d-%Y %H:%M:%S')}',
           '#{criteria.dt3.to_datetime.strftime('%m-%d-%Y %H:%M:%S')}',       '#{criteria.dt4.to_datetime.strftime('%m-%d-%Y %H:%M:%S')}',
           '#{criteria.dt5.to_datetime.strftime('%m-%d-%Y %H:%M:%S')}',       '#{criteria.dt6.to_datetime.strftime('%m-%d-%Y %H:%M:%S')}',
           '#{criteria.dt7.to_datetime.strftime('%m-%d-%Y %H:%M:%S')}',       '#{criteria.dt8.to_datetime.strftime('%m-%d-%Y %H:%M:%S')}',
           '#{criteria.str1}',      '#{criteria.str2}',        '#{criteria.multiselect1}' ,
           '#{criteria.str3}',      '#{criteria.str4}',        '#{criteria.multiselect2}' ,
           '#{criteria.str5}',      '#{criteria.str6}',        '#{criteria.multiselect3}' ,
           '#{criteria.str7}',      '#{criteria.str8}',        '#{criteria.multiselect4}' ,
           '#{criteria.str9}',      '#{criteria.str10}',       '#{criteria.multiselect5}' ,
           '#{criteria.str11}',     '#{criteria.str12}',       '#{criteria.multiselect6}' ,
           '#{criteria.str13}',     '#{criteria.str14}',       '#{criteria.multiselect7}' ,
           '#{criteria.str15}',     '#{criteria.str16}',       '#{criteria.multiselect8}'      ")
    sql_query.commit_db_transaction 
    list
  end 

  def self.memo_return_register(doc)
    criteria = Setup::Criteria.fill_criteria_for_sp(doc/:criteria)
    sql_query = ActiveRecord::Base.connection();
    sql_query.execute "SET IMPLICIT_TRANSACTIONS OFF";
    sql_query.begin_db_transaction
    list = ActiveRecord::Base.connection.select_all("exec sp_retail_puoi_memo_return_register
           '#{criteria.user_id}',
           '#{criteria.dt1.to_datetime.strftime('%m-%d-%Y %H:%M:%S')}',       '#{criteria.dt2.to_datetime.strftime('%m-%d-%Y %H:%M:%S')}',
           '#{criteria.dt3.to_datetime.strftime('%m-%d-%Y %H:%M:%S')}',       '#{criteria.dt4.to_datetime.strftime('%m-%d-%Y %H:%M:%S')}',
           '#{criteria.str1}',      '#{criteria.str2}',        '#{criteria.multiselect1}' ,
           '#{criteria.str3}',      '#{criteria.str4}',        '#{criteria.multiselect2}' ,
           '#{criteria.str5}',      '#{criteria.str6}',        '#{criteria.multiselect3}' ,
           '#{criteria.str7}',      '#{criteria.str8}',        '#{criteria.multiselect4}' ,
           '#{criteria.str9}',      '#{criteria.str10}',       '#{criteria.multiselect5}' ,
           '#{criteria.str11}',     '#{criteria.str12}',       '#{criteria.multiselect6}'           ")
    sql_query.commit_db_transaction 
    list
  end 
  
  def self.cancel_order_register(doc)
    criteria = Setup::Criteria.fill_criteria_for_sp(doc/:criteria)
    sql_query = ActiveRecord::Base.connection();
    sql_query.execute "SET IMPLICIT_TRANSACTIONS OFF";
    sql_query.begin_db_transaction
    list = ActiveRecord::Base.connection.select_all("exec sp_retail_puoi_order_cancellation_register
           '#{criteria.user_id}',
           '#{criteria.dt1.to_datetime.strftime('%m-%d-%Y %H:%M:%S')}',       '#{criteria.dt2.to_datetime.strftime('%m-%d-%Y %H:%M:%S')}',
           '#{criteria.str1}',      '#{criteria.str2}',        '#{criteria.multiselect1}' ,
           '#{criteria.str3}',      '#{criteria.str4}',        '#{criteria.multiselect2}' ,
           '#{criteria.str5}',      '#{criteria.str6}',        '#{criteria.multiselect3}' ,
           '#{criteria.str7}',      '#{criteria.str8}',        '#{criteria.multiselect4}' ,
           '#{criteria.str9}',      '#{criteria.str10}',       '#{criteria.multiselect5}' ,
           '#{criteria.str11}',     '#{criteria.str12}',       '#{criteria.multiselect6}' ")
    sql_query.commit_db_transaction 
    list
  end

  def self.open_order_report(doc)
    criteria = Setup::Criteria.fill_criteria_for_sp(doc/:criteria)
    sql_query = ActiveRecord::Base.connection();
    sql_query.execute "SET IMPLICIT_TRANSACTIONS OFF";
    sql_query.begin_db_transaction
    list = ActiveRecord::Base.connection.select_all("exec sp_retail_puoi_open_order_report
           '#{criteria.user_id}',
           '#{criteria.dt1.to_datetime.strftime('%m-%d-%Y %H:%M:%S')}',       '#{criteria.dt2.to_datetime.strftime('%m-%d-%Y %H:%M:%S')}',
           '#{criteria.dt3.to_datetime.strftime('%m-%d-%Y %H:%M:%S')}',       '#{criteria.dt4.to_datetime.strftime('%m-%d-%Y %H:%M:%S')}',
           '#{criteria.dt5.to_datetime.strftime('%m-%d-%Y %H:%M:%S')}',       '#{criteria.dt6.to_datetime.strftime('%m-%d-%Y %H:%M:%S')}',
           '#{criteria.dt7.to_datetime.strftime('%m-%d-%Y %H:%M:%S')}',       '#{criteria.dt8.to_datetime.strftime('%m-%d-%Y %H:%M:%S')}',
           '#{criteria.str1}',      '#{criteria.str2}',        '#{criteria.multiselect1}' ,
           '#{criteria.str3}',      '#{criteria.str4}',        '#{criteria.multiselect2}' ,
           '#{criteria.str5}',      '#{criteria.str6}',        '#{criteria.multiselect3}' ,
           '#{criteria.str7}',      '#{criteria.str8}',        '#{criteria.multiselect4}' ,
           '#{criteria.str9}',      '#{criteria.str10}',       '#{criteria.multiselect5}' ,
           '#{criteria.str11}',     '#{criteria.str12}',       '#{criteria.multiselect6}' ,
           '#{criteria.str13}',     '#{criteria.str14}',       '#{criteria.multiselect7}' ,
           '#{criteria.str15}',     '#{criteria.str16}',       '#{criteria.multiselect8}'  ,
           '#{criteria.str17}',     '#{criteria.str18}',       '#{criteria.multiselect9}',
           '#{criteria.str19}',     '#{criteria.str20}',       '#{criteria.multiselect10}',
           '#{criteria.str21}',     '#{criteria.str22}',       '#{criteria.multiselect11}'  ")
    sql_query.commit_db_transaction 
    list
  end

  def self.open_memo_report(doc)
    criteria = Setup::Criteria.fill_criteria_for_sp(doc/:criteria)
    sql_query = ActiveRecord::Base.connection();
    sql_query.execute "SET IMPLICIT_TRANSACTIONS OFF";
    sql_query.begin_db_transaction
    list = ActiveRecord::Base.connection.select_all("exec sp_retail_puoi_open_memo_report
           '#{criteria.user_id}',
           '#{criteria.dt1.to_datetime.strftime('%m-%d-%Y %H:%M:%S')}',       '#{criteria.dt2.to_datetime.strftime('%m-%d-%Y %H:%M:%S')}',
           '#{criteria.dt3.to_datetime.strftime('%m-%d-%Y %H:%M:%S')}',       '#{criteria.dt4.to_datetime.strftime('%m-%d-%Y %H:%M:%S')}',
           '#{criteria.dt5.to_datetime.strftime('%m-%d-%Y %H:%M:%S')}',       '#{criteria.dt6.to_datetime.strftime('%m-%d-%Y %H:%M:%S')}',
           '#{criteria.dt7.to_datetime.strftime('%m-%d-%Y %H:%M:%S')}',       '#{criteria.dt8.to_datetime.strftime('%m-%d-%Y %H:%M:%S')}',
           '#{criteria.dt9.to_datetime.strftime('%m-%d-%Y %H:%M:%S')}',       '#{criteria.dt10.to_datetime.strftime('%m-%d-%Y %H:%M:%S')}',
           '#{criteria.str1}',      '#{criteria.str2}',        '#{criteria.multiselect1}' ,
           '#{criteria.str3}',      '#{criteria.str4}',        '#{criteria.multiselect2}' ,
           '#{criteria.str5}',      '#{criteria.str6}',        '#{criteria.multiselect3}' ,
           '#{criteria.str7}',      '#{criteria.str8}',        '#{criteria.multiselect4}' ,
           '#{criteria.str9}',      '#{criteria.str10}',       '#{criteria.multiselect5}' ,
           '#{criteria.str11}',     '#{criteria.str12}',       '#{criteria.multiselect6}' ,
           '#{criteria.str13}',     '#{criteria.str14}',       '#{criteria.multiselect7}' ,
           '#{criteria.str15}',     '#{criteria.str16}',       '#{criteria.multiselect8}' ,
           '#{criteria.str17}',     '#{criteria.str18}',       '#{criteria.multiselect9}' ,
           '#{criteria.str19}',     '#{criteria.str20}',       '#{criteria.multiselect10}',
           '#{criteria.str21}',     '#{criteria.str22}',       '#{criteria.multiselect11}',
           '#{criteria.str23}',     '#{criteria.str24}',       '#{criteria.multiselect12}',
           '#{criteria.str25}',     '#{criteria.str26}',       '#{criteria.multiselect13}' ")
    sql_query.commit_db_transaction 
    list
  end

  def self.open_invoice_report(doc)
    criteria = Setup::Criteria.fill_criteria(doc/:criteria) 
    condition= convert_sql_to_db_specific("b.purchase_invoice_id = purchase_invoices.id and b.item_qty > b.clear_qty and
                        (purchase_invoices.company_id in(select company_id from user_companies where user_id=?)) AND 
                        (vendors.code between ? and ? AND (0 =? or vendors.code in (?))) AND
                        (purchase_invoices.trans_no between ? and ? AND (0 =? or purchase_invoices.trans_no in (?))) AND
                        (purchase_invoices.trans_date between ? and ? ) AND
                        (purchase_invoices.account_period_code between ? and ? AND (0 =? or purchase_invoices.account_period_code in (?))) AND
                        (purchase_invoices.ext_ref_no between ? and ? AND (0 =? )or (purchase_invoices.ext_ref_no in (?))) AND
                        (purchase_invoices.trans_type between ? and ? AND (0 =? )or (purchase_invoices.trans_type in (?))) AND   
                        (purchasepeople.code between ? and ? AND(0 =? )or (purchasepeople.code in (?)))")
    Purchase::PurchaseInvoice.active.find(:all,
      :select=>' (b.item_qty - b.clear_qty) as open_qty ,vendors.code as vendor_code,vendors.name as vendor_name,purchase_invoices.trans_date,term_code,purchase_invoices.trans_no,
                    due_date,ship_date,purchase_invoices.shipping_code,tracking_no,purchase_invoices.account_period_code,b.catalog_item_code,
                    b.item_description,b.item_qty,b.item_price, b.item_amt,b.net_amt,b.discount_amt,b.discount_per,
                    purchase_invoices.ext_ref_no as PO_no,purchasepeople.code as purchaseperson_code',
      :joins=>'   inner join purchase_invoice_lines b on b.purchase_invoice_id = purchase_invoices.id 
                     inner join vendors on vendors.id = purchase_invoices.vendor_id 
                     left join purchasepeople on purchasepeople.id = purchase_invoices.purchaseperson_id',
      :conditions => [condition,
        criteria.user_id,
        criteria.str1,      criteria.str2,      criteria.multiselect1.length, criteria.multiselect1,
        criteria.str3,      criteria.str4,      criteria.multiselect2.length, criteria.multiselect2, 
        criteria.dt1,       criteria.dt2,
        criteria.str5[0,8], criteria.str6[0,8] ,criteria.multiselect3.length, criteria.multiselect3,
        criteria.str7,      criteria.str8,      criteria.multiselect4.length, criteria.multiselect4,
        criteria.str9[0,1], criteria.str10[0,1],criteria.multiselect5.length, criteria.multiselect5,
        criteria.str11,     criteria.str12,     criteria.multiselect6.length, criteria.multiselect6],
      :order => "purchase_invoices.trans_date, purchase_invoices.trans_no, b.serial_no"
    )
  end


  def self.purchase_indent_report(doc)
    criteria = Setup::Criteria.fill_criteria(doc/:criteria) 
    condition= convert_sql_to_db_specific("b.purchase_indent_id = purchase_indents.id and
                         (purchase_indents.company_id in(select company_id from user_companies where user_id=?)) AND 
                         (purchase_indents.account_period_code between ? and ? AND (0 =? or purchase_indents.account_period_code in (?))) AND
                         (purchase_indents.trans_date between ? and ? ) AND
                         (purchase_indents.trans_no between ? and ? AND (0 =? or purchase_indents.trans_no in (?))) AND
                         (purchase_indents.trans_bk between ? and ? AND (0 =? or purchase_indents.trans_bk in (?))) AND
                         (purchase_indents.ship_date between ? and ? ) AND
                         (nvl(purchase_indents.due_date,'1990-01-01 00:00:00') between ? and ? ) AND
                         (nvl(purchase_indents.ext_ref_no,'') between ? and ? AND (0 =? or purchase_indents.ext_ref_no in (?))) AND
                         (nvl(purchase_indents.ext_ref_date,'1990-01-01 00:00:00') between ? and ? ) ")
    #    Purchase::PurchaseIndent.active.find(:all,
    #       :select=>' purchase_indents.indent_date,purchase_indents.trans_no,
    #                  due_date,ship_date,purchase_indents.account_period_code,purchase_indents.ext_ref_no as vendor_PO_no,purchase_indents.ext_ref_date as PO_date,b.catalog_item_code,
    #                  b.item_description,b.item_qty,b.ref_trans_no,b.ref_trans_bk,b.ref_serial_no,b.ref_trans_date,
    #                  (b.item_qty - b.clear_qty) as balance_qty ,b.serial_no,purchase_indents.purchaseperson_code,b.trans_flag as line_trans_flag,
    #                  companies.company_cd as company_code,companies.name as company_name,b.clear_qty,
    #                  catalog_item_categories.code as catalog_item_category',
    #        :joins=>' inner join purchase_indent_lines b on b.purchase_indent_id = purchase_indents.id 
    #                  inner join catalog_items on catalog_items.id = b.catalog_item_id
    #                  inner join catalog_item_categories on catalog_item_categories.id  = catalog_items.catalog_item_category_id
    #                  inner join companies on companies.id = purchase_indents.company_id      ',
    #        :conditions => [condition,
    #                        criteria.user_id,
    #                        criteria.str1[0,8], criteria.str2[0,8], criteria.multiselect1.length, criteria.multiselect1,
    #                        criteria.dt1,       criteria.dt2,
    #                        criteria.str3,      criteria.str4,      criteria.multiselect2.length, criteria.multiselect2, 
    #                        criteria.str5,      criteria.str6,      criteria.multiselect3.length, criteria.multiselect3,
    #                        criteria.dt3,       criteria.dt4,
    #                        criteria.dt5,       criteria.dt6,
    #                        criteria.str7,      criteria.str8,      criteria.multiselect4.length, criteria.multiselect4,
    #                        criteria.dt7,       criteria.dt8 ],
    #                      :order => "purchase_indents.trans_date, purchase_indents.trans_no, b.serial_no"
    #    )
    Purchase::PurchaseIndent.find_by_sql(["select cast((select(SELECT purchase_indents.indent_date,purchase_indents.trans_no,
                                        due_date,ship_date,purchase_indents.account_period_code,purchase_indents.ext_ref_no as vendor_po_no,purchase_indents.ext_ref_date as po_date,b.catalog_item_code,
                                        b.item_description,b.item_qty,b.ref_trans_no,b.ref_trans_bk,b.ref_serial_no,b.ref_trans_date,
                                        (b.item_qty - b.clear_qty) as balance_qty ,b.serial_no,purchase_indents.purchaseperson_code,b.trans_flag as line_trans_flag,
                                        companies.company_cd as company_code,companies.name as company_name,b.clear_qty,
                                        catalog_item_categories.code as catalog_item_category FROM purchase_indents inner join purchase_indent_lines b on b.purchase_indent_id = purchase_indents.id 
                                        inner join catalog_items on catalog_items.id = b.catalog_item_id
                                        inner join catalog_item_categories on catalog_item_categories.id = catalog_items.catalog_item_category_id
                                        inner join companies on companies.id = purchase_indents.company_id WHERE (purchase_indents.[trans_flag] = 'A') AND b.trans_flag='A' AND #{condition}
                                        ORDER BY purchase_indents.trans_date, purchase_indents.trans_no, b.serial_no
                                        for xml path('purchase_order_cancel'),type,elements xsinil)for xml path('purchase_order_cancels'))as xml)as xmlcol",
        criteria.user_id,
        criteria.str1[0,8], criteria.str2[0,8], criteria.multiselect1.length, criteria.multiselect1,
        criteria.dt1,       criteria.dt2,
        criteria.str3,      criteria.str4,      criteria.multiselect2.length, criteria.multiselect2, 
        criteria.str5,      criteria.str6,      criteria.multiselect3.length, criteria.multiselect3,
        criteria.dt3,       criteria.dt4,
        criteria.dt5,       criteria.dt6,
        criteria.str7,      criteria.str8,      criteria.multiselect4.length, criteria.multiselect4,
        criteria.dt7,       criteria.dt8 ])[0].xmlcol
  end

  def self.open_purchase_indent_report(doc)
    criteria = Setup::Criteria.fill_criteria(doc/:criteria) 
    condition= convert_sql_to_db_specific("b.purchase_indent_id = purchase_indents.id and b.item_qty > b.clear_qty and
                         (purchase_indents.company_id in(select company_id from user_companies where user_id=?)) AND 
                         (purchase_indents.account_period_code between ? and ? AND (0 =? or purchase_indents.account_period_code in (?))) AND
                         (purchase_indents.trans_date between ? and ? ) AND
                         (purchase_indents.trans_no between ? and ? AND (0 =? or purchase_indents.trans_no in (?))) AND
                         (purchase_indents.trans_bk between ? and ? AND (0 =? or purchase_indents.trans_bk in (?))) AND
                         (purchase_indents.ship_date between ? and ? ) AND
                         (nvl(purchase_indents.due_date,'1990-01-01 00:00:00') between ? and ? ) AND
                         (nvl(purchase_indents.ext_ref_no,'') between ? and ? AND (0 =?  or purchase_indents.ext_ref_no in (?))) AND
                         (nvl(purchase_indents.ext_ref_date,'1990-01-01 00:00:00') between ? and ? )  AND 
                         (nvl(b.catalog_item_code,'') between ? and ? AND (0 =?  or b.catalog_item_code in (?))) AND
                         (catalog_item_categories.code between ? and ? AND (0 =? or catalog_item_categories.code in (?))) ")
                        
    #    Purchase::PurchaseIndent.active.find(:all,
    #       :select=>' purchase_indents.indent_date,purchase_indents.trans_no,
    #                  due_date,ship_date,purchase_indents.account_period_code,purchase_indents.ext_ref_no as vendor_PO_no,purchase_indents.ext_ref_date as PO_date,b.catalog_item_code,
    #                  b.item_description,b.item_qty,b.ref_trans_no,b.ref_trans_bk,b.ref_serial_no,b.ref_trans_date,
    #                  (b.item_qty - b.clear_qty) as balance_qty ,b.serial_no,purchase_indents.purchaseperson_code,b.trans_flag as line_trans_flag,
    #                  companies.company_cd as company_code,companies.name as company_name,b.clear_qty,
    #                  catalog_item_categories.code as catalog_item_category',
    #        :joins=>' inner join purchase_indent_lines b on b.purchase_indent_id = purchase_indents.id 
    #                  inner join catalog_items on catalog_items.id = b.catalog_item_id
    #                  inner join catalog_item_categories on catalog_item_categories.id  = catalog_items.catalog_item_category_id
    #                  inner join companies on companies.id = purchase_indents.company_id      ',
    #        :conditions => [condition,
    #                        criteria.user_id,
    #                        criteria.str1[0,8], criteria.str2[0,8], criteria.multiselect1.length, criteria.multiselect1,
    #                        criteria.dt1,       criteria.dt2,      
    #                        criteria.str3,      criteria.str4,      criteria.multiselect2.length, criteria.multiselect2,                        
    #                        criteria.str5,      criteria.str6,      criteria.multiselect3.length, criteria.multiselect3,
    #                        criteria.dt3,       criteria.dt4,
    #                        criteria.dt5,       criteria.dt6,
    #                        criteria.str7,      criteria.str8,      criteria.multiselect4.length, criteria.multiselect4,                        
    #                        criteria.dt7,       criteria.dt8,                        
    #                        criteria.str9,     criteria.str10,     criteria.multiselect5.length, criteria.multiselect5,
    #                        criteria.str11,     criteria.str12,    criteria.multiselect6.length, criteria.multiselect6 ],
    #                      :order => "purchase_indents.trans_date, purchase_indents.trans_no, b.serial_no"
    #    )
    Purchase::PurchaseIndent.find_by_sql(["select cast((select(SELECT purchase_indents.indent_date,purchase_indents.trans_no,
                                        due_date,ship_date,purchase_indents.account_period_code,purchase_indents.ext_ref_no as vendor_po_no,purchase_indents.ext_ref_date as po_date,b.catalog_item_code,
                                        b.item_description,b.item_qty,b.ref_trans_no,b.ref_trans_bk,b.ref_serial_no,b.ref_trans_date,
                                        (b.item_qty - b.clear_qty) as balance_qty ,b.serial_no,purchase_indents.purchaseperson_code,b.trans_flag as line_trans_flag,
                                        companies.company_cd as company_code,companies.name as company_name,b.clear_qty,
                                        catalog_item_categories.code as catalog_item_category FROM purchase_indents inner join purchase_indent_lines b on b.purchase_indent_id = purchase_indents.id 
                                        inner join catalog_items on catalog_items.id = b.catalog_item_id
                                        inner join catalog_item_categories on catalog_item_categories.id = catalog_items.catalog_item_category_id
                                        inner join companies on companies.id = purchase_indents.company_id WHERE (purchase_indents.[trans_flag] = 'A') AND b.trans_flag='A' AND #{condition}
                                        ORDER BY purchase_indents.trans_date, purchase_indents.trans_no, b.serial_no
                                        for xml path('purchase_order_cancel'),type,elements xsinil)for xml path('purchase_order_cancels'))as xml)as xmlcol",
        criteria.user_id,
        criteria.str1[0,8], criteria.str2[0,8], criteria.multiselect1.length, criteria.multiselect1,
        criteria.dt1,       criteria.dt2,      
        criteria.str3,      criteria.str4,      criteria.multiselect2.length, criteria.multiselect2,                        
        criteria.str5,      criteria.str6,      criteria.multiselect3.length, criteria.multiselect3,
        criteria.dt3,       criteria.dt4,
        criteria.dt5,       criteria.dt6,
        criteria.str7,      criteria.str8,      criteria.multiselect4.length, criteria.multiselect4,                        
        criteria.dt7,       criteria.dt8,                        
        criteria.str9,     criteria.str10,     criteria.multiselect5.length, criteria.multiselect5,
        criteria.str11,     criteria.str12,    criteria.multiselect6.length, criteria.multiselect6 ])[0].xmlcol
  end

  def self.purchase_order_format(purchase_order_id)  
    Purchase::PurchaseOrder.find(:all,
      :joins=>"inner join terms on terms.code = purchase_orders.term_code
                         inner join companies on companies.id = purchase_orders.company_id
                         inner join users on users.id=purchase_orders.updated_by
                         left outer join purchasepeople on purchasepeople.code=purchase_orders.purchaseperson_code
      ",
      :select=>"purchase_orders.*,users.first_name+' '+users.last_name as prepared_by
                          ,terms.name as term_name,purchasepeople.name as purchaseperson_name,companies.company_logo_file as company_logo_file",
      :conditions =>["purchase_orders.id = ?",purchase_order_id])     
  end

  def self.purchase_invoice_format(purchase_invoice_id)  
    Purchase::PurchaseInvoice.find(:all,
      :joins=>"inner join terms on terms.code = purchase_invoices.term_code
                         inner join companies on companies.id = purchase_invoices.company_id
                         inner join users on users.id=purchase_invoices.updated_by
                         left outer join purchasepeople on purchasepeople.code=purchase_invoices.purchaseperson_code
                         left outer join types ty on (
		             ty.type_cd = 'TRANS_TYPE'
		             and ty.subtype_cd = 'PI'
                             and ty.value = purchase_invoices.trans_type )",
      :select=>"purchase_invoices.*,terms.name as term_name,ty.description as invoice_type
                         ,users.first_name+' '+users.last_name as prepared_by,purchasepeople.name as purchaseperson_name,companies.company_logo_file as company_logo_file",
      :conditions =>["purchase_invoices.id = ?",purchase_invoice_id])     
  end
 
  def self.purchase_memo_format(purchase_memo_id)  
    Purchase::PurchaseMemo.find(:all,
      :joins=>"inner join terms on terms.code = purchase_memos.term_code
                         inner join companies on companies.id = purchase_memos.company_id
                         inner join users on users.id=purchase_memos.updated_by
                         left outer join purchasepeople on purchasepeople.code=purchase_memos.purchaseperson_code
      ",
      :select=>"purchase_memos.*,terms.name as term_name,purchasepeople.name as purchaseperson_name
                          ,users.first_name+' '+users.last_name as prepared_by,companies.company_logo_file as company_logo_file",
      :conditions =>["purchase_memos.id = ?",purchase_memo_id])     
  end
 
  def self.purchase_credit_invoice_format(purchase_credit_invoice_id)  
    Purchase::PurchaseCreditInvoice.find(:all,
      :joins=>"inner join terms on terms.code = purchase_credit_invoices.term_code
                         inner join companies on companies.id = purchase_credit_invoices.company_id
                         inner join users on users.id=purchase_credit_invoices.updated_by
                         left outer join purchasepeople on purchasepeople.code=purchase_credit_invoices.purchaseperson_code
      ",
      :select=>"purchase_credit_invoices.*,terms.name as term_name,purchasepeople.name as purchaseperson_name
                          ,users.first_name+' '+users.last_name as prepared_by,companies.company_logo_file as company_logo_file",
      :conditions =>["purchase_credit_invoices.id = ?",purchase_credit_invoice_id])     
  end
 
  def self.purchase_memo_return_format(purchase_memo_return_id)  
    Purchase::PurchaseMemoReturn.find(:all,
      :joins=>"inner join users on users.id=purchase_memo_returns.updated_by
                         inner join companies on companies.id = purchase_memo_returns.company_id
                         left outer join purchasepeople on purchasepeople.code=purchase_memo_returns.purchaseperson_code
      ",
      :select=>"purchase_memo_returns.*,users.first_name+' '+users.last_name as prepared_by
                          ,purchasepeople.name as purchaseperson_name,companies.company_logo_file as company_logo_file
      ",
      :conditions =>["purchase_memo_returns.id = ?",purchase_memo_return_id])     
  end


  #Invoice register(one line)
  def self.purchase_invoice_register_one_line(doc)
    criteria = Setup::Criteria.fill_criteria_for_sp(doc/:criteria)
    sql_query = ActiveRecord::Base.connection();
    sql_query.execute "SET IMPLICIT_TRANSACTIONS OFF";
    sql_query.begin_db_transaction
    list = ActiveRecord::Base.connection.select_all("exec sp_retail_puoi_invoice_register_oneline
           '#{criteria.user_id}',
           '#{criteria.dt1.to_datetime.strftime('%m-%d-%Y %H:%M:%S')}',       '#{criteria.dt2.to_datetime.strftime('%m-%d-%Y %H:%M:%S')}',
           '#{criteria.dt3.to_datetime.strftime('%m-%d-%Y %H:%M:%S')}',       '#{criteria.dt4.to_datetime.strftime('%m-%d-%Y %H:%M:%S')}',
           '#{criteria.dt5.to_datetime.strftime('%m-%d-%Y %H:%M:%S')}',       '#{criteria.dt6.to_datetime.strftime('%m-%d-%Y %H:%M:%S')}',
           '#{criteria.dt7.to_datetime.strftime('%m-%d-%Y %H:%M:%S')}',       '#{criteria.dt8.to_datetime.strftime('%m-%d-%Y %H:%M:%S')}',
           '#{criteria.str1}',      '#{criteria.str2}',        '#{criteria.multiselect1}' ,
           '#{criteria.str3}',      '#{criteria.str4}',        '#{criteria.multiselect2}' ,
           '#{criteria.str5}',      '#{criteria.str6}',        '#{criteria.multiselect3}' ,
           '#{criteria.str7}',      '#{criteria.str8}',        '#{criteria.multiselect4}' ,
           '#{criteria.str9}',      '#{criteria.str10}',       '#{criteria.multiselect5}' ,
           '#{criteria.str11}',     '#{criteria.str12}',       '#{criteria.multiselect6}' ,
           '#{criteria.str13}',     '#{criteria.str14}',       '#{criteria.multiselect7}' ,
           '#{criteria.str15}',     '#{criteria.str16}',       '#{criteria.multiselect8}' ,
           '#{criteria.str17}',     '#{criteria.str18}',       '#{criteria.multiselect9}'        ")
    sql_query.commit_db_transaction 
    list
  end 
end
 


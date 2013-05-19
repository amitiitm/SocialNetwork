class Inventory::InventoryTransactionReport
  include General
  
  def self.issue_report(doc)
    criteria = Setup::Criteria.fill_criteria_for_sp(doc/:criteria)
    sql_query = ActiveRecord::Base.connection();
    sql_query.execute "SET IMPLICIT_TRANSACTIONS OFF";
    sql_query.begin_db_transaction
    list = ActiveRecord::Base.connection.select_all("exec sp_retail_invn_issue_report
           '#{criteria.user_id}',
           '#{criteria.dt1.to_datetime.strftime('%m-%d-%Y %H:%M:%S')}',       '#{criteria.dt2.to_datetime.strftime('%m-%d-%Y %H:%M:%S')}',
           '#{criteria.dt3.to_datetime.strftime('%m-%d-%Y %H:%M:%S')}',       '#{criteria.dt4.to_datetime.strftime('%m-%d-%Y %H:%M:%S')}',
           '#{criteria.str1}',      '#{criteria.str2}',        '#{criteria.multiselect1}' ,
           '#{criteria.str3}',      '#{criteria.str4}',        '#{criteria.multiselect2}' ,
           '#{criteria.str5}',      '#{criteria.str6}',        '#{criteria.multiselect3}' ,
           '#{criteria.str7}',      '#{criteria.str8}',        '#{criteria.multiselect4}' ,
           '#{criteria.str9}',      '#{criteria.str10}',       '#{criteria.multiselect5}' ,
           '#{criteria.str11}',     '#{criteria.str12}',       '#{criteria.multiselect6}' ,
           '#{criteria.str13}',     '#{criteria.str14}',       '#{criteria.multiselect7}' ,
           '#{criteria.str15}',     '#{criteria.str16}',       '#{criteria.multiselect8}' ,
           '#{criteria.str17}',     '#{criteria.str18}',       '#{criteria.multiselect9}'")
    sql_query.commit_db_transaction 
    list
  end 
    
  def self.receieve_report(doc)
    criteria = Setup::Criteria.fill_criteria_for_sp(doc/:criteria)
    sql_query = ActiveRecord::Base.connection();
    sql_query.execute "SET IMPLICIT_TRANSACTIONS OFF";
    sql_query.begin_db_transaction
    list = ActiveRecord::Base.connection.select_all("exec sp_retail_invn_receive_report
           '#{criteria.user_id}',
           '#{criteria.dt1.to_datetime.strftime('%m-%d-%Y %H:%M:%S')}',       '#{criteria.dt2.to_datetime.strftime('%m-%d-%Y %H:%M:%S')}',
           '#{criteria.dt3.to_datetime.strftime('%m-%d-%Y %H:%M:%S')}',       '#{criteria.dt4.to_datetime.strftime('%m-%d-%Y %H:%M:%S')}',
           '#{criteria.str1}',      '#{criteria.str2}',        '#{criteria.multiselect1}' ,
           '#{criteria.str3}',      '#{criteria.str4}',        '#{criteria.multiselect2}' ,
           '#{criteria.str5}',      '#{criteria.str6}',        '#{criteria.multiselect3}' ,
           '#{criteria.str7}',      '#{criteria.str8}',        '#{criteria.multiselect4}' ,
           '#{criteria.str9}',      '#{criteria.str10}',       '#{criteria.multiselect5}' ,
           '#{criteria.str11}',     '#{criteria.str12}',       '#{criteria.multiselect6}' ,
           '#{criteria.str13}',     '#{criteria.str14}',       '#{criteria.multiselect7}' ,
           '#{criteria.str15}',     '#{criteria.str16}',       '#{criteria.multiselect8}' ,
           '#{criteria.str17}',     '#{criteria.str18}',       '#{criteria.multiselect9}' ")
    sql_query.commit_db_transaction 
    list
  end

  def self.stock_report(doc)
    criteria = Setup::Criteria.fill_criteria_for_sp(doc/:criteria)
    sql_query = ActiveRecord::Base.connection();
    sql_query.execute "SET IMPLICIT_TRANSACTIONS OFF";
    sql_query.begin_db_transaction
    list = ActiveRecord::Base.connection.select_all("exec sp_retail_invn_stock_report
           '#{criteria.user_id}',
           '#{criteria.str1}',      '#{criteria.str2}',        '#{criteria.multiselect1}' ,
           '#{criteria.str3}',      '#{criteria.str4}',        '#{criteria.multiselect2}' ,
           '#{criteria.str5}',      '#{criteria.str6}',        '#{criteria.multiselect3}' ,
           '#{criteria.str7}',      '#{criteria.str8}',        '#{criteria.multiselect4}' ,
           '#{criteria.str10}'")
    sql_query.commit_db_transaction 
    list
  end
  
  def self.activity_report(doc)
    criteria = Setup::Criteria.fill_criteria_for_sp(doc/:criteria)
    sql_query = ActiveRecord::Base.connection();
    sql_query.execute "SET IMPLICIT_TRANSACTIONS OFF";
    sql_query.begin_db_transaction
    list = ActiveRecord::Base.connection.select_all("exec sp_retail_invn_activity_report
           '#{criteria.user_id}',
           '#{criteria.dt1.to_datetime.strftime('%m-%d-%Y %H:%M:%S')}',       '#{criteria.dt2.to_datetime.strftime('%m-%d-%Y %H:%M:%S')}',
           '#{criteria.dt3.to_datetime.strftime('%m-%d-%Y %H:%M:%S')}',       '#{criteria.dt4.to_datetime.strftime('%m-%d-%Y %H:%M:%S')}',
           '#{criteria.str1}',      '#{criteria.str2}',        '#{criteria.multiselect1}' ,
           '#{criteria.str3}',      '#{criteria.str4}',        '#{criteria.multiselect2}' ,
           '#{criteria.str5}',      '#{criteria.str6}',        '#{criteria.multiselect3}' ,
           '#{criteria.str7}',      '#{criteria.str8}',        '#{criteria.multiselect4}' ,
           '#{criteria.str9}',      '#{criteria.str10}',       '#{criteria.multiselect5}' ,
           '#{criteria.str11}',     '#{criteria.str12}',       '#{criteria.multiselect6}' ,
           '#{criteria.str13}',     '#{criteria.str14}',       '#{criteria.multiselect7}' ,
           '#{criteria.str15}',     '#{criteria.str16}',       '#{criteria.multiselect8}'     ")
    sql_query.commit_db_transaction 
    list
  end
  
  #  def self.store_transfer_report(doc)
  #    criteria = Setup::Criteria.fill_criteria(doc/:criteria) 
  #    condition = " (inventory_details.company_id in(select company_id from user_companies where user_id=?)) AND 
  #                        (inventory_details.account_period_code between ? and ? AND (0 =? or inventory_details.account_period_code in (?))) AND 
  #                        (inventory_details.trans_bk between ? and ?  AND (0 =? or inventory_details.trans_bk in (?))) AND
  #                        (b.store_code between ? and ? AND (0 =? or b.store_code in (?))) AND
  #                        (c.code between ? and ? AND (0 =? or c.code in (?))) AND
  #                        (f.company_cd between ? and ? AND (0 =? or f.company_cd in (?))) AND
  #                        (inventory_details.trans_no between ? and ?  AND (0 =? or inventory_details.trans_no in (?))) AND
  #                        (inventory_details.ext_ref_no between ? and ?  AND (0 =? or inventory_details.ext_ref_no in (?))) AND
  #                        (nvl(d.code,'') between ? and ? AND (0=? or d.code in(?))) AND
  #                        (nvl(inventory_details.trans_date,'1990-01-01 00:00:00') between ? and ? ) AND
  #                        (nvl(inventory_details.ext_ref_date,'1990-01-01 00:00:00') between ? and ? ) "
  #    condition = convert_sql_to_db_specific(condition)
  #    #    Inventory::InventoryDetail.active.find(:all,
  #    #      :joins => " inner join catalog_items b on b.id = inventory_details.catalog_item_id
  #    #                  inner join catalog_item_categories c on c.id = b.catalog_item_category_id
  #    #                  left outer join catalog_item_packets d on d.id = inventory_details.catalog_item_packet_id
  #    #                  inner join companies e on e.id = inventory_details.trans_type_id AND (inventory_details.trans_type='S')
  #    #                  inner join companies f on f.id =  inventory_details.company_id    ",
  #    #      :conditions => [condition,
  #    #        criteria.user_id,
  #    #        criteria.str1[0,8], criteria.str2[0,8],     criteria.multiselect1.length, criteria.multiselect1,
  #    #        criteria.str3[0,4], criteria.str4[0,4],     criteria.multiselect2.length, criteria.multiselect2,
  #    #        criteria.str5,      criteria.str6,          criteria.multiselect3.length, criteria.multiselect3,
  #    #        criteria.str7,      criteria.str8 ,         criteria.multiselect4.length, criteria.multiselect4,
  #    #        criteria.str9,      criteria.str10 ,        criteria.multiselect5.length, criteria.multiselect5,
  #    #        criteria.str11,     criteria.str12 ,        criteria.multiselect6.length, criteria.multiselect6,
  #    #        criteria.str13,     criteria.str14 ,        criteria.multiselect7.length, criteria.multiselect7,
  #    #        criteria.str15,     criteria.str16 ,        criteria.multiselect8.length, criteria.multiselect8, 
  #    #        criteria.dt1,       criteria.dt2,
  #    #        criteria.dt3,       criteria.dt4      ],
  #    #      :select => 'b.store_code as item_code,c.code as item_category,b.item_type,b.name as item_name,inventory_details.trans_no,inventory_details.trans_bk,inventory_details.trans_date,
  #    #                  inventory_details.serial_no,inventory_details.stock_rec_qty,inventory_details.stock_rec_amt,inventory_details.stock_rec_price,
  #    #                  inventory_details.account_period_code,d.code as catalog_item_packet_code,
  #    #                  inventory_details.stock_iss_qty,inventory_details.stock_iss_amt,inventory_details.stock_iss_price,f.company_cd as company_code,
  #    #                  f.name as company_name,inventory_details.ext_ref_no,inventory_details.ext_ref_date,
  #    #                 e.name as transfer_to_name,e.company_cd as transfer_to_code'
  #    #    )
  #    Inventory::InventoryDetail.find_by_sql ["select CAST( (select(select b.store_code as item_code,c.code as item_category,b.item_type,b.name as item_name,inventory_details.trans_no,inventory_details.trans_bk,inventory_details.trans_date,
  #                  inventory_details.serial_no,inventory_details.stock_rec_qty,inventory_details.stock_rec_amt,inventory_details.stock_rec_price,
  #                  inventory_details.account_period_code,d.code as catalog_item_packet_code,
  #                  inventory_details.stock_iss_qty,inventory_details.stock_iss_amt,inventory_details.stock_iss_price,f.company_cd as company_code,
  #                  f.name as company_name,inventory_details.ext_ref_no,inventory_details.ext_ref_date,
  #                  e.name as transfer_to_name,e.company_cd as transfer_to_code
  #                  from inventory_details
  #                  inner join catalog_items b on b.id = inventory_details.catalog_item_id
  #                  inner join catalog_item_categories c on c.id = b.catalog_item_category_id
  #                  left outer join catalog_item_packets d on d.id = inventory_details.catalog_item_packet_id
  #                  inner join companies e on e.id = inventory_details.trans_type_id AND (inventory_details.trans_type='S')
  #                  inner join companies f on f.id =  inventory_details.company_id 
  #                  where inventory_details.trans_flag = 'A' and #{condition}    
  #                  FOR XML PATH('store_transfer_report'),type,elements xsinil)FOR XML PATH('store_transfer_reports')) AS xml) as xmlcol",
  #      criteria.user_id,
  #      criteria.str1[0,8], criteria.str2[0,8],     criteria.multiselect1.length, criteria.multiselect1,
  #      criteria.str3[0,4], criteria.str4[0,4],     criteria.multiselect2.length, criteria.multiselect2,
  #      criteria.str5,      criteria.str6,          criteria.multiselect3.length, criteria.multiselect3,
  #      criteria.str7,      criteria.str8 ,         criteria.multiselect4.length, criteria.multiselect4,
  #      criteria.str9,      criteria.str10 ,        criteria.multiselect5.length, criteria.multiselect5,
  #      criteria.str11,     criteria.str12 ,        criteria.multiselect6.length, criteria.multiselect6,
  #      criteria.str13,     criteria.str14 ,        criteria.multiselect7.length, criteria.multiselect7,
  #      criteria.str15,     criteria.str16 ,        criteria.multiselect8.length, criteria.multiselect8, 
  #      criteria.dt1,       criteria.dt2,
  #      criteria.dt3,       criteria.dt4      ]
  #
  #  end

  def self.store_transfer_report(doc)
    criteria = Setup::Criteria.fill_criteria_for_sp(doc/:criteria)
    sql_query = ActiveRecord::Base.connection();
    sql_query.execute "SET IMPLICIT_TRANSACTIONS OFF";
    sql_query.begin_db_transaction
    list = ActiveRecord::Base.connection.select_all("exec sp_retail_invn_store_transfer_report
           '#{criteria.user_id}',
           '#{criteria.str1[0,8]}',      '#{criteria.str2[0,8]}',        '#{criteria.multiselect1}' ,
           '#{criteria.str3[0,4]}',      '#{criteria.str4[0,4]}',        '#{criteria.multiselect2}' ,
           '#{criteria.str5}',      '#{criteria.str6}',        '#{criteria.multiselect3}' ,
           '#{criteria.str7}',      '#{criteria.str8}',        '#{criteria.multiselect4}' ,
           '#{criteria.str9}',      '#{criteria.str10}',       '#{criteria.multiselect5}' ,
           '#{criteria.str11}',     '#{criteria.str12}',       '#{criteria.multiselect6}' ,
           '#{criteria.str13}',     '#{criteria.str14}',       '#{criteria.multiselect7}' ,
           '#{criteria.str15}',     '#{criteria.str16}',       '#{criteria.multiselect8}'  ,
           '#{criteria.str17}',     '#{criteria.str18}',       '#{criteria.multiselect9}'  ,
           '#{criteria.dt1.to_datetime.strftime('%m-%d-%Y %H:%M:%S')}',       '#{criteria.dt2.to_datetime.strftime('%m-%d-%Y %H:%M:%S')}',
           '#{criteria.dt3.to_datetime.strftime('%m-%d-%Y %H:%M:%S')}',       '#{criteria.dt4.to_datetime.strftime('%m-%d-%Y %H:%M:%S')}'      ")
    sql_query.commit_db_transaction 
    list
  end
  
  #  def self.backdated_stock_report(doc)
  #    criteria = Setup::Criteria.fill_criteria(doc/:criteria)  
  #    sql = "
  #              select CAST( (select(Select  A.item_category,A.item_code,A.item_type,
  #                      (Sum(A.stock)) as stock,
  #                      (Sum(A.purmemo_stock)) as purmemo_stock,    
  #                      (Sum(A.salmemo_stock)) as salmemo_stock,
  #                      (Sum(A.stock * nvl(catalog_items.cost,0))) as stock_amt,
  #                      (Sum( A.purmemo_stock  * nvl(catalog_items.cost,0))) as purmemo_stockamt,
  #                      (Sum( A.salmemo_stock  * nvl(catalog_items.cost,0))) as salmemo_stockamt,
  #                      (Sum((A.stock + A.purmemo_stock - A.salmemo_stock) * nvl(catalog_items.cost,0))) as balanceamt,
  #                      (Sum( A.stock + A.purmemo_stock - A.salmemo_stock)) as balance
  #               From 	
  #                     (select nvl(catalog_item_categories.code, '') as item_category,nvl(catalog_items.store_code,'') as item_code,
  #                             catalog_items.item_type,
  #                             inventory_details.catalog_item_id,catalog_item_categories.id as item_category_id,
  #                            (Sum(nvl(stock_rec_qty,0)) - Sum(nvl(stock_iss_qty,0))) as stock,                            
  #                            (Case When inventory_details.trans_bk not In ('SM01','SI01', 'SE01', 'LM01', 'LR01') 
  #		               Then (Sum(nvl(memo_rec_qty,0)) - Sum(nvl(memo_iss_qty,0)))
  #			       Else 0 
  #			      End) as purmemo_stock,
  #                            (Case When inventory_details.trans_bk in ( 'SM01','SI01', 'SE01', 'LM01', 'LR01')  
  #				Then (Sum(nvl(memo_iss_qty,0)) - Sum(nvl(memo_rec_qty,0))) 
  #			        Else 0 
  #			      End) as salmemo_stock,
  #                            (Sum(nvl(stock_rec_amt,0))-  Sum(nvl(stock_iss_amt,0)) ) as stockamt, 
  #                            (Case  When inventory_details.trans_bk Not In ( 'SM01','SI01', 'SE01', 'LM01', 'LR01')  
  #                                Then (Sum(nvl(memo_rec_amt,0))-  Sum(nvl(memo_iss_amt,0)))
  #                                Else 0 
  #                              End) as purmemo_stockamt,
  #	                    (Case When inventory_details.trans_bk In ( 'SM01','SI01', 'SE01', 'LM01', 'LR01')  
  #				Then (Sum(nvl(memo_iss_amt,0)) - Sum(nvl(memo_rec_amt,0)))
  #				Else 0 
  #                              End) as salmemo_stockamt
  #                        from inventory_details
  #                        inner join catalog_items on 
  #                                   catalog_items.id = inventory_details.catalog_item_id
  #                        inner join catalog_item_categories on
  #                                   catalog_item_categories.id = catalog_items.catalog_item_category_id
  #                        inner join companies on 
  #                                   companies.id = inventory_details.company_id
  #                        left outer join catalog_item_packets on
  #                                    catalog_item_packets.id = inventory_details.catalog_item_packet_id
  #                        where  (inventory_details.trans_flag = 'A') AND
  #                               (inventory_details.company_id in(select company_id from user_companies where user_id = ?)) AND
  #                               (inventory_details.account_period_code between ? and ? ) AND
  #                               (catalog_item_categories.code between ? and ? and  (0 =? or catalog_item_categories.code in (?))) AND
  #                               (catalog_items.store_code between ? and ? and  (0 =? or catalog_items.store_code in (?))) AND
  #                               (nvl(catalog_item_packets.code,' ') between ? and ? and  (0 =? or nvl(catalog_item_packets.code,' ') in (?))) AND 
  #                               (inventory_details.trans_date between ? and ? ) 
  #                        group by catalog_items.item_type,catalog_item_categories.code,catalog_items.store_code,
  #                                 inventory_details.trans_bk,
  #                                 inventory_details.catalog_item_id, catalog_item_categories.id ) A 
  #              inner Join catalog_item_categories on 
  #                    catalog_item_categories.id = A.item_category_id 
  #              inner Join catalog_items on 
  #                    catalog_items.id = A.catalog_item_id and 
  #                    catalog_items.catalog_item_category_id = A.item_category_id and
  #                    catalog_items.item_type = A.item_type            
  #              Group By  A.item_category,
  #                        A.item_code,    
  #                        A.item_type 
  #              HAVING ((Sum(A.stock)) != 0) or
  #                      ((Sum(A.purmemo_stock)) != 0) or
  #                       ((Sum(A.salmemo_stock)) != 0)
  # FOR XML PATH('backdated_stock_report'),type,elements xsinil)FOR XML PATH('backdated_stock_reports')) AS xml) as xmlcol
  #    "
  #    sql = convert_sql_to_db_specific(sql)
  #    Inventory::InventoryTransactionLine.find_by_sql([sql,
  #        criteria.user_id,
  #        criteria.str1[0,8], criteria.str2[0,8], 
  #        criteria.str3,      criteria.str4,      criteria.multiselect1.length, criteria.multiselect1,
  #        criteria.str5,      criteria.str6,      criteria.multiselect2.length, criteria.multiselect2,
  #        criteria.str7,      criteria.str8,      criteria.multiselect3.length, criteria.multiselect3,
  #        criteria.dt1,       criteria.dt2
  #      ])
  #  end

  def self.backdated_stock_report(doc)
    criteria = Setup::Criteria.fill_criteria_for_sp(doc/:criteria)
    sql_query = ActiveRecord::Base.connection();
    sql_query.execute "SET IMPLICIT_TRANSACTIONS OFF";
    sql_query.begin_db_transaction
    list = ActiveRecord::Base.connection.select_all("exec sp_retail_invn_backdated_stock_report
           '#{criteria.user_id}',
           '#{criteria.str1[0,8]}',      '#{criteria.str2[0,8]}', 
           '#{criteria.str3}',           '#{criteria.str4}',        '#{criteria.multiselect1}' ,
           '#{criteria.str5}',           '#{criteria.str6}',        '#{criteria.multiselect2}' ,
           '#{criteria.str7}',           '#{criteria.str8}',        '#{criteria.multiselect3}' ,
           '#{criteria.str9}',           '#{criteria.str10}',       '#{criteria.multiselect4}' ,
           '#{criteria.dt1.to_datetime.strftime('%m-%d-%Y %H:%M:%S')}',       '#{criteria.dt2.to_datetime.strftime('%m-%d-%Y %H:%M:%S')}'  ")
    sql_query.commit_db_transaction 
    list
  end
  
  def self.all_store_stock_report(doc)
    criteria = Setup::Criteria.fill_criteria(doc/:criteria)
    condition = " (inventory_summaries.trans_flag= 'A') AND
                        (inventory_summaries.company_id in ( select id from companies f where f.company_type in
                                                             (select company_type from companies g
                                                              inner join user_companies on g.id = user_companies.company_id 
                                                              where user_id = ?) ) ) AND 
                        (nvl(d.code,'') between ? and ? AND (0 =? or d.code in (?))) AND
                        (b.store_code between ? and ? AND (0 =? or b.store_code in (?))) AND
                        (c.code between ? and ? AND (0 =? or c.code in (?))) "
    condition = convert_sql_to_db_specific(condition)
    #    Inventory::InventorySummary.find(:all,
    #      :joins => " inner join catalog_items b on b.id = inventory_summaries.catalog_item_id
    #                  inner join catalog_item_categories c on c.id = b.catalog_item_category_id
    #                  inner join companies e on e.id = inventory_summaries.company_id
    #                  left outer join catalog_item_packets d on d.id = inventory_summaries.catalog_item_packet_id ",
    #      :conditions => [condition,
    #        criteria.user_id,
    #        criteria.str1, criteria.str2,   criteria.multiselect1.length, criteria.multiselect1,
    #        criteria.str3, criteria.str4 ,  criteria.multiselect2.length, criteria.multiselect2,
    #        criteria.str5, criteria.str6 ,  criteria.multiselect3.length, criteria.multiselect3
    #      ],
    #      :select => "e.name as company_name,
    #                  e.company_cd as company_code,
    #                  b.store_code as item_code,
    #                  b.name as item_name,
    #                 (Case When e.company_type in ('S')  
    #                       Then ('Store')
    #                      Else ('Head Office') 
    #                              End) as store_type,
    #                  (sum(inventory_summaries.stock_rec_qty) - sum(inventory_summaries.stock_iss_qty)) as on_stock_qty,
    #                  (sum(inventory_summaries.stock_rec_amt) - sum(inventory_summaries.stock_iss_amt)) as on_stock_amt,
    #                  (sum(inventory_summaries.memo_rec_qty) - sum(inventory_summaries.memo_iss_qty)) as on_memo_qty,
    #                  (sum(inventory_summaries.memo_rec_amt) - sum(inventory_summaries.memo_iss_amt)) as on_memo_amt,
    #                   ( sum(inventory_summaries.stock_rec_qty) + sum(inventory_summaries.memo_rec_qty) ) - ( sum(inventory_summaries.stock_iss_qty) + sum(inventory_summaries.memo_iss_qty) ) as on_hand_qty, 
    #                  ( sum(inventory_summaries.stock_rec_amt) + sum(inventory_summaries.memo_rec_amt) ) - ( sum(inventory_summaries.stock_iss_amt) + sum(inventory_summaries.memo_iss_amt) ) as on_hand_amt",
    #      :group =>"e.name, b.store_code,b.name,e.company_cd,e.company_type
    #        HAVING ((sum(inventory_summaries.stock_rec_qty) - sum(inventory_summaries.stock_iss_qty)) != 0) or
    #               ((sum(inventory_summaries.memo_rec_qty) - sum(inventory_summaries.memo_iss_qty)) != 0) or
    #               ((sum(inventory_summaries.stock_rec_qty)- sum(inventory_summaries.stock_iss_qty))- (sum(inventory_summaries.memo_rec_qty)-sum(inventory_summaries.memo_iss_qty)) != 0)"
    #     
    #    )
    Inventory::InventorySummary.find_by_sql ["select CAST( (select(select e.name as company_name,
                  e.company_cd as company_code,
                  b.store_code as item_code,
                  b.name as item_name,
                 (Case When e.company_type in ('S')  
                       Then ('Store')
                      Else ('Head Office') 
                              End) as store_type,
                  (sum(inventory_summaries.stock_rec_qty) - sum(inventory_summaries.stock_iss_qty)) as on_stock_qty,
                  case when (sum(inventory_summaries.stock_rec_qty) - sum(inventory_summaries.stock_iss_qty)) = 0
                  then 0.00
                  else (sum(inventory_summaries.stock_rec_amt) - sum(inventory_summaries.stock_iss_amt)) 
                  end as on_stock_amt,
                  (sum(inventory_summaries.memo_rec_qty) - sum(inventory_summaries.memo_iss_qty)) as on_memo_qty,
                  case when (sum(inventory_summaries.memo_rec_qty) - sum(inventory_summaries.memo_iss_qty)) = 0
                  then 0.00
                  else (sum(inventory_summaries.memo_rec_amt) - sum(inventory_summaries.memo_iss_amt)) 
                  end  as on_memo_amt,
                  ( sum(inventory_summaries.stock_rec_qty) + sum(inventory_summaries.memo_rec_qty) ) - ( sum(inventory_summaries.stock_iss_qty) + sum(inventory_summaries.memo_iss_qty) ) as on_hand_qty, 
                  case when ( sum(inventory_summaries.stock_rec_qty) + sum(inventory_summaries.memo_rec_qty) ) - ( sum(inventory_summaries.stock_iss_qty) + sum(inventory_summaries.memo_iss_qty) ) = 0
                  then 0.00
                  else ( sum(inventory_summaries.stock_rec_amt) + sum(inventory_summaries.memo_rec_amt) ) - ( sum(inventory_summaries.stock_iss_amt) + sum(inventory_summaries.memo_iss_amt) )
                  end   as on_hand_amt
                  from inventory_summaries
                  inner join catalog_items b on b.id = inventory_summaries.catalog_item_id
                  inner join catalog_item_categories c on c.id = b.catalog_item_category_id
                  inner join companies e on e.id = inventory_summaries.company_id
                  left outer join catalog_item_packets d on d.id = inventory_summaries.catalog_item_packet_id  
                  where #{condition} 
                  group by  e.name, b.store_code,b.name,e.company_cd,e.company_type
                  HAVING ((sum(inventory_summaries.stock_rec_qty) - sum(inventory_summaries.stock_iss_qty)) != 0) or
                  ((sum(inventory_summaries.memo_rec_qty) - sum(inventory_summaries.memo_iss_qty)) != 0) or
                  ((sum(inventory_summaries.stock_rec_qty)- sum(inventory_summaries.stock_iss_qty))- (sum(inventory_summaries.memo_rec_qty)-sum(inventory_summaries.memo_iss_qty)) != 0)  
                  FOR XML PATH('inventory_transaction'),type,elements xsinil)FOR XML PATH('inventory_transactions')) AS xml) as xmlcol",
      criteria.user_id,
      criteria.str1, criteria.str2,   criteria.multiselect1.length, criteria.multiselect1,
      criteria.str3, criteria.str4 ,  criteria.multiselect2.length, criteria.multiselect2,
      criteria.str5, criteria.str6 ,  criteria.multiselect3.length, criteria.multiselect3      ]
  end
  def self.stock_aging_detail_report(doc)
    criteria = Setup::Criteria.fill_criteria_for_sp(doc/:criteria)
    sql_query = ActiveRecord::Base.connection();
    sql_query.execute "SET IMPLICIT_TRANSACTIONS OFF";
    sql_query.begin_db_transaction
    list = ActiveRecord::Base.connection.select_all("exec sp_retail_invn_stock_aging_report
           '#{criteria.user_id}',
           '#{criteria.str1}',           '#{criteria.str2}',        '#{criteria.multiselect1}' ,
           '#{criteria.str3}',           '#{criteria.str4}',        '#{criteria.multiselect2}' ,
           '#{criteria.str5}',           '#{criteria.str6}',        '#{criteria.multiselect3}' ,
           '#{criteria.str7}',           '#{criteria.str8}',        '#{criteria.multiselect4}' ,
           'D'")
    sql_query.commit_db_transaction 
    list
  end
 
  def self.stock_aging_summary_report(doc)
    criteria = Setup::Criteria.fill_criteria_for_sp(doc/:criteria)
    sql_query = ActiveRecord::Base.connection();
    sql_query.execute "SET IMPLICIT_TRANSACTIONS OFF";
    sql_query.begin_db_transaction
    list = ActiveRecord::Base.connection.select_all("exec sp_retail_invn_stock_aging_report
           '#{criteria.user_id}',
           '#{criteria.str1}',           '#{criteria.str2}',        '#{criteria.multiselect1}' ,
           '#{criteria.str3}',           '#{criteria.str4}',        '#{criteria.multiselect2}' ,
           '#{criteria.str5}',           '#{criteria.str6}',        '#{criteria.multiselect3}' ,
           '#{criteria.str7}',           '#{criteria.str8}',        '#{criteria.multiselect4}' ,
           'S'")
    sql_query.commit_db_transaction 
    list
  end
  #  def self.stock_aging_detail_report(doc)
  #    criteria = Setup::Criteria.fill_criteria(doc/:criteria)
  #    #   Inventory::InventorySummary.find(:all)
  #    mstr_temp_table = []
  #    li_group1 = 30
  #    li_group2 = 60
  #    li_group3 = 90
  #    #   condition = "(inventory_summaries.company_id in(select company_id from user_companies where user_id = ?)) AND
  #    #                              (catalog_item_categories.code between ? and ? and  (0 =? or catalog_item_categories.code in (?))) AND
  #    #                              (catalog_items.store_code between ? and ? and  (0 =? or catalog_items.store_code in (?))) AND
  #    #                              (nvl(catalog_item_packets.code,' ') between ? and ? and  (0 =? or nvl(catalog_item_packets.code,' ') in (?))) "
  #    #   condition = convert_sql_to_db_specific(condition)    
  #    #   @current_stocks = Inventory::InventorySummary.find(:all,
  #    #              :joins =>"inner join catalog_items on 
  #    #                                   catalog_items.id = inventory_summaries.catalog_item_id
  #    #                        inner join catalog_item_categories on 
  #    #                                   catalog_item_categories.id = catalog_items.catalog_item_category_id
  #    #                        left outer join catalog_item_packets on
  #    #                                        catalog_item_packets.catalog_item_id = inventory_summaries.catalog_item_id
  #    #                        inner join companies on 
  #    #                                   companies.id = inventory_summaries.company_id ",
  #    #              :conditions =>[condition,
  #    #                              criteria.user_id,
  #    #                              criteria.str1, criteria.str2,   criteria.multiselect1.length, criteria.multiselect1,
  #    #                              criteria.str3, criteria.str4 ,  criteria.multiselect2.length, criteria.multiselect2,
  #    #                              criteria.str5, criteria.str6 ,  criteria.multiselect3.length, criteria.multiselect3],
  #    #              :select =>"catalog_items.store_code as item_code,
  #    #                         catalog_items.name as item_name,
  #    #                         catalog_item_categories.code as category_code,
  #    #                         ( sum(inventory_summaries.stock_rec_qty) -  sum(inventory_summaries.stock_iss_qty)) as current_stock,
  #    #                         companies.company_cd as company_code,companies.name as company_name ",
  #    #              :group =>"catalog_items.store_code,catalog_items.name,catalog_item_categories.code,companies.company_cd,companies.name   " )
  #    condition = " (inventory_summaries.trans_flag= 'A') AND
  #                        (inventory_summaries.company_id in (select company_id from user_companies where user_id=?)) AND 
  #                        (nvl(d.code,'') between ? and ? AND (0 =? or d.code in (?))) AND
  #                        (b.store_code between ? and ? AND (0 =? or b.store_code in (?))) AND
  #                        (c.code between ? and ? AND (0 =? or c.code in (?))) "
  #    condition = convert_sql_to_db_specific(condition)
  #    @current_stocks=Inventory::InventorySummary.find(:all,
  #      :joins => " inner join catalog_items b on b.id = inventory_summaries.catalog_item_id
  #                  inner join catalog_item_categories c on c.id = b.catalog_item_category_id
  #                  inner join companies e on e.id = inventory_summaries.company_id
  #                  left outer join catalog_item_packets d on d.id = inventory_summaries.catalog_item_packet_id ",
  #      :conditions => [condition,
  #        criteria.user_id,
  #        criteria.str5, criteria.str6,   criteria.multiselect3.length, criteria.multiselect3,
  #        criteria.str3, criteria.str4 ,  criteria.multiselect2.length, criteria.multiselect2,
  #        criteria.str1, criteria.str2 ,  criteria.multiselect1.length, criteria.multiselect1
  #      ],
  #      :select => 'e.name as company_name,
  #                  e.company_cd as company_code,
  #                  b.store_code as item_code,
  #                  b.name as item_name,c.code as category_code,
  #                  (sum(inventory_summaries.stock_rec_qty) - sum(inventory_summaries.stock_iss_qty)) as current_stock,
  #                  (sum(inventory_summaries.stock_rec_amt) - sum(inventory_summaries.stock_iss_amt)) as on_stock_amt,
  #                  (sum(inventory_summaries.memo_rec_qty) - sum(inventory_summaries.memo_iss_qty)) as on_memo_qty,
  #                  (sum(inventory_summaries.memo_rec_amt) - sum(inventory_summaries.memo_iss_amt)) as on_memo_amt,
  #                   ( sum(inventory_summaries.stock_rec_qty) + sum(inventory_summaries.memo_rec_qty) ) - ( sum(inventory_summaries.stock_iss_qty) + sum(inventory_summaries.memo_iss_qty) ) as on_hand_qty, 
  #                  ( sum(inventory_summaries.stock_rec_amt) + sum(inventory_summaries.memo_rec_amt) ) - ( sum(inventory_summaries.stock_iss_amt) + sum(inventory_summaries.memo_iss_amt) ) as on_hand_amt',
  #      :group =>"e.name, b.store_code,b.name,e.company_cd ,c.code
  #        HAVING ((sum(inventory_summaries.stock_rec_qty) - sum(inventory_summaries.stock_iss_qty)) != 0) or
  #               ((sum(inventory_summaries.memo_rec_qty) - sum(inventory_summaries.memo_iss_qty)) != 0) or
  #               ((sum(inventory_summaries.stock_rec_qty)- sum(inventory_summaries.stock_iss_qty))- (sum(inventory_summaries.memo_rec_qty)-sum(inventory_summaries.memo_iss_qty)) != 0)"
  #     
  #    )
  #    @current_stocks.each { |current_stock|                   
  #      if(current_stock)
  #        ldec_current_stock = current_stock.current_stock.to_i
  #        ldec_rem_stock = ldec_current_stock
  #        condition = "(inventory_details.receipt_issue_flag = 'R') AND
  #                                  (nvl(inventory_details.stock_rec_qty,0) > 0) AND
  #                                  (catalog_items.store_code = ?) AND
  #                                  (catalog_item_categories.code = ?) AND
  #                                  (companies.company_cd = ?)"
  #        condition = convert_sql_to_db_specific(condition)
  #        @invn_aging = Inventory::InventoryDetail.active.find(:all,
  #          :joins =>"inner join catalog_items on
  #                                       catalog_items.id = inventory_details.catalog_item_id
  #                            inner join catalog_item_categories on 
  #                                     catalog_item_categories.id = catalog_items.catalog_item_category_id
  #                            inner join companies on 
  #                                   companies.id = inventory_details.company_id ",
  #          :conditions =>[condition,
  #            current_stock.item_code,current_stock.category_code,current_stock.company_code],
  #          :select =>"trans_bk,trans_no,trans_date,
  #                             inventory_details.stock_rec_qty  ",
  #          :order => "catalog_item_categories.code asc ,catalog_items.store_code asc,trans_date desc" )
  #        serial_no = 0
  #        @invn_aging.each { |invn_aging|         
  #          if(invn_aging.stock_rec_qty.to_i <= 0)
  #            next
  #          end
  #          group1_stock = 0
  #          group2_stock = 0
  #          group3_stock = 0
  #          group4_stock = 0
  #          serial_no = serial_no + 1
  #          ldec_balance_stock = invn_aging.stock_rec_qty.to_i
  #          li_due_days = Time.new.to_date - invn_aging.trans_date.to_date
  #          ldec_rem_stock = ldec_rem_stock - ldec_balance_stock
  #          
  #          if(ldec_rem_stock <0)
  #            ldec_balance_stock = ldec_balance_stock + ldec_rem_stock
  #          end
  #          if(li_due_days >=0 and li_due_days<=li_group1)
  #            group1_stock = ldec_balance_stock
  #          elsif(li_due_days >= (li_group1+1) and li_due_days <= li_group2)
  #            group2_stock = ldec_balance_stock
  #          elsif(li_due_days >= (li_group2+1) and li_due_days <= li_group3)
  #            group3_stock = ldec_balance_stock
  #          else
  #            group4_stock = ldec_balance_stock
  #          end
  #          x = Inventory::InventoryAgingTable.new
  #          x.fill_temp_table(current_stock.category_code,current_stock.item_code,current_stock.item_name,serial_no,invn_aging.trans_bk,
  #            invn_aging.trans_no,invn_aging.trans_date,li_due_days,group1_stock,group2_stock,
  #            group3_stock,group4_stock,ldec_current_stock,current_stock.company_code,current_stock.company_name)
  #          mstr_temp_table << x
  #          if(ldec_rem_stock <= 0 )
  #            break
  #          end
  #        }
  #      end
  #    }
  #    mstr_temp_table
  #  end
  #
  #  def self.stock_aging_summary_report(doc)
  #    mstr_temp_table = stock_aging_detail_report(doc)
  #    summary_sort(mstr_temp_table)
  #  end
  #
  #  def self.summary_sort(mstr_temp_table)
  #    final_table = []
  #    mstr_temp_table.each{ |x|
  #      if(final_table.empty?)
  #        final_table << mstr_temp_table.first
  #      else
  #        final_table.each{|y|
  #          if(y.item_code == x.item_code and y.company_code == x.company_code)
  #            y.group1_stock = y.group1_stock + x.group1_stock
  #            y.group2_stock = y.group2_stock + x.group2_stock
  #            y.group3_stock = y.group3_stock + x.group3_stock
  #            y.group4_stock = y.group4_stock + x.group4_stock
  #            #            y.balance_amt = y.balance_amt + x.balance_amt
  #            #            y.credit_amt = y.credit_amt + x.credit_amt
  #            #            y.current_amt = y.current_amt + x.current_amt
  #            break
  #          elsif((final_table.index(y) + 1) == final_table.length and final_table.last.item_code != x.item_code and  final_table.last.company_code != x.company_code)
  #            final_table << x
  #            break
  #          elsif((final_table.index(y) + 1) == final_table.length and final_table.last.item_code == x.item_code and  final_table.last.company_code != x.company_code)
  #            final_table << x
  #            break
  #          elsif((final_table.index(y) + 1) == final_table.length and final_table.last.item_code != x.item_code and  final_table.last.company_code == x.company_code)
  #            final_table << x
  #            break
  #          end
  #        }
  #      end
  #    }
  #    final_table
  #  end
 
  #  def self.stock_packetwise_report(doc)
  #    criteria = Setup::Criteria.fill_criteria(doc/:criteria) 
  #    condition = " (inventory_summaries.trans_flag= 'A') AND
  #                        (inventory_summaries.company_id in (select company_id from user_companies where user_id=?)) AND 
  #                        (nvl(d.code,'') between ? and ? AND (0 =? or d.code in (?))) AND
  #                        (b.store_code between ? and ? AND (0 =? or b.store_code in (?))) AND
  #                        (c.code between ? and ? AND (0 =? or c.code in (?))) "
  #    condition = convert_sql_to_db_specific(condition)
  #    Inventory::InventorySummary.find(:all,
  #      :joins => " inner join catalog_items b on b.id = inventory_summaries.catalog_item_id
  #                  inner join catalog_item_categories c on c.id = b.catalog_item_category_id
  #                  inner join companies e on e.id = inventory_summaries.company_id
  #                  left outer join catalog_item_packets d on d.id = inventory_summaries.catalog_item_packet_id ",
  #      :conditions => [condition,
  #        criteria.user_id,
  #        criteria.str1, criteria.str2,   criteria.multiselect1.length, criteria.multiselect1,
  #        criteria.str3, criteria.str4 ,  criteria.multiselect2.length, criteria.multiselect2,
  #        criteria.str5, criteria.str6 ,  criteria.multiselect3.length, criteria.multiselect3
  #      ],
  #      :select => 'e.name as company_name,
  #                  e.company_cd as company_code,
  #                  b.store_code as item_code,
  #                  b.name as item_name,
  #                  d.code as catalog_item_packet_code,c.code as catalog_item_category_code,
  #                  (sum(inventory_summaries.stock_rec_qty) - sum(inventory_summaries.stock_iss_qty)) as on_stock_qty,
  #                  (sum(inventory_summaries.stock_rec_amt) - sum(inventory_summaries.stock_iss_amt)) as on_stock_amt,
  #                  (sum(inventory_summaries.memo_rec_qty) - sum(inventory_summaries.memo_iss_qty)) as on_memo_qty,
  #                  (sum(inventory_summaries.memo_rec_amt) - sum(inventory_summaries.memo_iss_amt)) as on_memo_amt,
  #                   ( sum(inventory_summaries.stock_rec_qty) + sum(inventory_summaries.memo_rec_qty) ) - ( sum(inventory_summaries.stock_iss_qty) + sum(inventory_summaries.memo_iss_qty) ) as on_hand_qty, 
  #                  ( sum(inventory_summaries.stock_rec_amt) + sum(inventory_summaries.memo_rec_amt) ) - ( sum(inventory_summaries.stock_iss_amt) + sum(inventory_summaries.memo_iss_amt) ) as on_hand_amt',
  #      :group =>"e.name, b.store_code,b.name,e.company_cd,d.code,c.code
  #        HAVING ((sum(inventory_summaries.stock_rec_qty) - sum(inventory_summaries.stock_iss_qty)) != 0) or
  #               ((sum(inventory_summaries.memo_rec_qty) - sum(inventory_summaries.memo_iss_qty)) != 0) or
  #               ((sum(inventory_summaries.stock_rec_qty)- sum(inventory_summaries.stock_iss_qty))- (sum(inventory_summaries.memo_rec_qty)-sum(inventory_summaries.memo_iss_qty)) != 0)"
  #     
  #    )
  #  end

  
  def self.stock_packetwise_report(doc)
    criteria = Setup::Criteria.fill_criteria(doc/:criteria) 
    condition = " (inventory_summaries.trans_flag= 'A') AND
                        (inventory_summaries.company_id in (select company_id from user_companies where user_id=?)) AND 
                        (nvl(d.code,'') between ? and ? AND (0 =? or d.code in (?))) AND
                        (b.store_code between ? and ? AND (0 =? or b.store_code in (?))) AND
                        (c.code between ? and ? AND (0 =? or c.code in (?))) "
    condition = convert_sql_to_db_specific(condition)
    select_statement_transaction_price='e.name as company_name,
                  e.company_cd as company_code,
                  b.store_code as item_code,
                  b.name as item_name,
                  d.code as catalog_item_packet_code,c.code as catalog_item_category_code,
                  (sum(inventory_summaries.stock_rec_qty) - sum(inventory_summaries.stock_iss_qty)) as on_stock_qty,
                  case when (sum(inventory_summaries.stock_rec_qty) - sum(inventory_summaries.stock_iss_qty)) = 0
                  then 0.00
                  else (sum(inventory_summaries.stock_rec_amt) - sum(inventory_summaries.stock_iss_amt)) 
                  end as on_stock_amt,
                  (sum(inventory_summaries.memo_rec_qty) - sum(inventory_summaries.memo_iss_qty)) as on_memo_qty,
                  case when (sum(inventory_summaries.memo_rec_qty) - sum(inventory_summaries.memo_iss_qty)) = 0
                  then 0.00
                  else (sum(inventory_summaries.memo_rec_amt) - sum(inventory_summaries.memo_iss_amt)) 
                  end  as on_memo_amt,
                  ( sum(inventory_summaries.stock_rec_qty) + sum(inventory_summaries.memo_rec_qty) ) - ( sum(inventory_summaries.stock_iss_qty) + sum(inventory_summaries.memo_iss_qty) ) as on_hand_qty, 
                  case when ( sum(inventory_summaries.stock_rec_qty) + sum(inventory_summaries.memo_rec_qty) ) - ( sum(inventory_summaries.stock_iss_qty) + sum(inventory_summaries.memo_iss_qty) ) = 0
                  then 0.00
                  else ( sum(inventory_summaries.stock_rec_amt) + sum(inventory_summaries.memo_rec_amt) ) - ( sum(inventory_summaries.stock_iss_amt) + sum(inventory_summaries.memo_iss_amt) )
                  end   as on_hand_amt  ,ex.metal_type as metal_type'
    select_statement_tag_price='e.name as company_name,
                  e.company_cd as company_code,
                  b.store_code as item_code,ex.tag_price,d.code as catalog_item_packet_code,
                  b.name as item_name,c.code as catalog_item_category_code,
                  (sum(inventory_summaries.stock_rec_qty) - sum(inventory_summaries.stock_iss_qty)) as on_stock_qty,
                  case when (sum(inventory_summaries.stock_rec_qty) - sum(inventory_summaries.stock_iss_qty)) = 0
                  then 0.00
                  else ((sum(inventory_summaries.stock_rec_qty) - sum(inventory_summaries.stock_iss_qty)) * ex.tag_price) 
                  end as on_stock_amt,
                  (sum(inventory_summaries.memo_rec_qty) - sum(inventory_summaries.memo_iss_qty)) as on_memo_qty,
                  case when (sum(inventory_summaries.memo_rec_qty) - sum(inventory_summaries.memo_iss_qty)) = 0
                  then 0.00
                  else ((sum(inventory_summaries.memo_rec_qty) - sum(inventory_summaries.memo_iss_qty)) * ex.tag_price) 
                  end  as on_memo_amt,
                  ( sum(inventory_summaries.stock_rec_qty) + sum(inventory_summaries.memo_rec_qty) ) - ( sum(inventory_summaries.stock_iss_qty) + sum(inventory_summaries.memo_iss_qty) ) as on_hand_qty, 
                  case when ( sum(inventory_summaries.stock_rec_qty) + sum(inventory_summaries.memo_rec_qty) ) - ( sum(inventory_summaries.stock_iss_qty) + sum(inventory_summaries.memo_iss_qty) ) = 0
                  then 0.00
                  else (( sum(inventory_summaries.stock_rec_qty) + sum(inventory_summaries.memo_rec_qty) ) - ( sum(inventory_summaries.stock_iss_qty) + sum(inventory_summaries.memo_iss_qty)) )* ex.tag_price
                  end   as on_hand_amt ,ex.metal_type as metal_type
    '
    select_statement_purchase_price='e.name as company_name,
                  e.company_cd as company_code,
                  b.store_code as item_code,ex.tag_price,d.code as catalog_item_packet_code,
                  b.name as item_name,c.code as catalog_item_category_code,
                  (sum(inventory_summaries.stock_rec_qty) - sum(inventory_summaries.stock_iss_qty)) as on_stock_qty,
                  case when (sum(inventory_summaries.stock_rec_qty) - sum(inventory_summaries.stock_iss_qty)) = 0
                  then 0.00
                  else ((sum(inventory_summaries.stock_rec_qty) - sum(inventory_summaries.stock_iss_qty)) * d.price) 
                  end as on_stock_amt,
                  (sum(inventory_summaries.memo_rec_qty) - sum(inventory_summaries.memo_iss_qty)) as on_memo_qty,
                  case when (sum(inventory_summaries.memo_rec_qty) - sum(inventory_summaries.memo_iss_qty)) = 0
                  then 0.00
                  else ((sum(inventory_summaries.memo_rec_qty) - sum(inventory_summaries.memo_iss_qty)) * d.price) 
                  end  as on_memo_amt,
                  ( sum(inventory_summaries.stock_rec_qty) + sum(inventory_summaries.memo_rec_qty) ) - ( sum(inventory_summaries.stock_iss_qty) + sum(inventory_summaries.memo_iss_qty) ) as on_hand_qty, 
                  case when ( sum(inventory_summaries.stock_rec_qty) + sum(inventory_summaries.memo_rec_qty) ) - ( sum(inventory_summaries.stock_iss_qty) + sum(inventory_summaries.memo_iss_qty) ) = 0
                  then 0.00
                  else (( sum(inventory_summaries.stock_rec_qty) + sum(inventory_summaries.memo_rec_qty) ) - ( sum(inventory_summaries.stock_iss_qty) + sum(inventory_summaries.memo_iss_qty)) )* d.price
                  end   as on_hand_amt , ex.metal_type as metal_type'
    select_statement = case criteria.str8
    when 'P' then select_statement_purchase_price
    when 'S' then select_statement_tag_price
    when 'T' then select_statement_transaction_price
    else select_statement_transaction_price
    end
    #    Inventory::InventorySummary.find(:all,
    #      :joins => " inner join catalog_items b on b.id = inventory_summaries.catalog_item_id
    #                  inner join catalog_item_categories c on c.id = b.catalog_item_category_id
    #                  inner join companies e on e.id = inventory_summaries.company_id
    #                  left outer join catalog_item_packets d on d.id = inventory_summaries.catalog_item_packet_id 
    #                  left outer join catalog_item_packet_extensions ex on ex.catalog_item_packet_id = d.id",
    #      :conditions => [condition,
    #        criteria.user_id,
    #        criteria.str1, criteria.str2,   criteria.multiselect1.length, criteria.multiselect1,
    #        criteria.str3, criteria.str4 ,  criteria.multiselect2.length, criteria.multiselect2,
    #        criteria.str5, criteria.str6 ,  criteria.multiselect3.length, criteria.multiselect3
    #      ],
    #      :select => select_statement,
    #      :group =>"e.name, b.store_code,b.name,e.company_cd,d.code,c.code,ex.tag_price,d.price
    #        HAVING ((sum(inventory_summaries.stock_rec_qty) - sum(inventory_summaries.stock_iss_qty)) != 0) or
    #               ((sum(inventory_summaries.memo_rec_qty) - sum(inventory_summaries.memo_iss_qty)) != 0) or
    #               ((sum(inventory_summaries.stock_rec_qty)- sum(inventory_summaries.stock_iss_qty))- (sum(inventory_summaries.memo_rec_qty)-sum(inventory_summaries.memo_iss_qty)) != 0)"
    #     
    #    )
    Inventory::InventorySummary.find_by_sql ["select CAST( (select(select #{select_statement}
                  from inventory_summaries  
                  inner join catalog_items b on b.id = inventory_summaries.catalog_item_id
                  inner join catalog_item_categories c on c.id = b.catalog_item_category_id
                  inner join companies e on e.id = inventory_summaries.company_id
                  left outer join catalog_item_packets d on d.id = inventory_summaries.catalog_item_packet_id 
                  left outer join catalog_item_packet_extensions ex on ex.catalog_item_packet_id = d.id  
                  where #{condition}    
                  group by e.name, b.store_code,b.name,e.company_cd,d.code,c.code,ex.tag_price,d.price,ex.metal_type
                  HAVING ((sum(inventory_summaries.stock_rec_qty) - sum(inventory_summaries.stock_iss_qty)) != 0) or
                  ((sum(inventory_summaries.memo_rec_qty) - sum(inventory_summaries.memo_iss_qty)) != 0) or
                  ((sum(inventory_summaries.stock_rec_qty)- sum(inventory_summaries.stock_iss_qty))- (sum(inventory_summaries.memo_rec_qty)-sum(inventory_summaries.memo_iss_qty)) != 0)
                  FOR XML PATH('inventory_transaction'),type,elements xsinil)FOR XML PATH('inventory_transactions')) AS xml) as xmlcol",
      criteria.user_id,
      criteria.str1, criteria.str2,   criteria.multiselect1.length, criteria.multiselect1,
      criteria.str3, criteria.str4 ,  criteria.multiselect2.length, criteria.multiselect2,
      criteria.str5, criteria.str6 ,  criteria.multiselect3.length, criteria.multiselect3
    ]    
  end
  
  def self.missing_image_report(doc,schema_name)
    criteria = Setup::Criteria.fill_criteria(doc/:criteria) 
    path = Setup::Type.find(:first, :conditions=>['type_cd = ? and subtype_cd = ?','UPLOAD_FOLDER','IMAGE'])
    directory = path.value + schema_name if path
    missed_item_images=[]
    @items = Item::CatalogItem.find(:all,
      :select=>"catalog_items.store_code as catalog_item_code,catalog_items.image_thumnail,catalog_items.image_small,
                                              catalog_items.image_normal,catalog_items.image_enlarge,catalog_item_categories.code as item_category,catalog_items.name as item_name",
      :joins=>'inner join catalog_item_categories on catalog_item_categories.id=catalog_items.catalog_item_category_id',
      :conditions=>["(catalog_items.store_code between ? and ? AND (0 =? or catalog_items.store_code in (?))) AND 
                                                 (catalog_item_categories.code between ? and ? AND (0 =? or catalog_item_categories.code in (?)))",
                                                 
        criteria.str1,      criteria.str2,      criteria.multiselect1.length, criteria.multiselect1,
        criteria.str3,      criteria.str4,      criteria.multiselect2.length, criteria.multiselect2]  )
    @items.each{|item|
      if (item.image_thumnail.nil? || item.image_thumnail=='')
        item.image_thumnail ='     ---NOT ASSIGNED---'
        missed_item_images << item
      else
        if !File.exist?("#{Dir.getwd}/#{directory}/#{item.image_thumnail}") 
          item.image_thumnail = item.image_thumnail
          missed_item_images << item   #done by praman
        else
          item.image_thumnail=''
        end
        #        missed_item_images << item   #done by minal 
      end
      
      #Image Small
      if (item.image_small.nil? || item.image_small =='')
        item.image_small = '     ---NOT ASSIGNED---'
        unless missed_item_images.include?(item) 
          missed_item_images << item
        end
      else
        if !File.exist?("#{Dir.getwd}/#{directory}/#{item.image_small}") 
          item.image_small = item.image_small
          unless missed_item_images.include?(item) 
            missed_item_images << item  
          end
        else
          item.image_small=''
        end
      end
      
      # Image Normal
      if (item.image_normal.nil? || item.image_normal== '')
        item.image_normal ='     ---NOT ASSIGNED---'
        unless missed_item_images.include?(item) 
          missed_item_images << item
        end
      else
        if !File.exist?("#{Dir.getwd}/#{directory}/#{item.image_normal}") 
          item.image_normal = item.image_normal
          unless missed_item_images.include?(item) 
            missed_item_images << item  
          end
        else
          item.image_normal = ''
        end
      end
      
      #image Enlarge
      if (item.image_enlarge.nil? || item.image_enlarge=='')
        item.image_enlarge = '     ---NOT ASSIGNED---'
        unless missed_item_images.include?(item) 
          missed_item_images << item
        end
      else
        if !File.exist?("#{Dir.getwd}/#{directory}/#{item.image_enlarge}") 
          item.image_enlarge = item.image_enlarge
          unless missed_item_images.include?(item) 
            missed_item_images << item  
          end
        else
          item.image_enlarge =''
        end
      end
    }
    missed_item_images
  end
  
  #No reference found of related controller in flex
  #  def self.variance_report(doc)
  #    criteria = Setup::Criteria.fill_criteria(doc/:criteria)
  #    query = "(select CAST( (select(select tbl_variance_report.* from(  select y.catalog_item_id,
  #                    y.catalog_item_packet_id,
  #                    c.code as catalog_item_category_code,
  #                    b.store_code as catalog_item_code,
  #                    d.code as catalog_item_packet_code,
  #                    b.name as catalog_item_name,
  #                    y.system_qty as system_qty,
  #                    y.physical_qty as physical_qty,
  #                    (y.system_qty - y.physical_qty) as variance_qty,
  #                    y.table_name,e.company_cd
  #              from
  #                    (select *
  #                    from(
  #			(
  #                        select	company_id,
  #                                catalog_item_id,
  #				catalog_item_packet_id,
  #				SUM(stock_rec_qty + memo_rec_qty - stock_iss_qty - memo_iss_qty) as system_qty,
  #				'Inventory Summaries' as table_name,
  #				0 as physical_qty
  #			from	inventory_summaries
  #			where	trans_flag ='A'
  #			group by company_id, catalog_item_id, catalog_item_packet_id
  #
  #		except
  #
  #                        select	company_id,
  #				catalog_item_id,
  #				catalog_item_packet_id,
  #				SUM(item_qty) as physical_qty,
  #				'Inventory Summaries' as table_name,
  #				0 as system_qty
  #		from	physical_inventory_lines
  #		where	trans_flag ='A' AND (trans_no between ? and ? AND (0 =? or trans_no in (?)))
  #		group by company_id, catalog_item_id, catalog_item_packet_id
  #
  #            )
  #
  #        UNION
  #               (
  #                        select  company_id,
  #                                catalog_item_id,
  #                                catalog_item_packet_id,
  #                                0 as system_qty,
  #                                'Physical Inventory' as table_name,
  #                                SUM(item_qty) as physical_qty
  #		from	physical_inventory_lines
  #		where	trans_flag ='A' AND (trans_no between ? and ? AND (0 =? or trans_no in (?)))
  #		group by company_id, catalog_item_id, catalog_item_packet_id
  #
  #	except
  #
  #			select	company_id,
  #				catalog_item_id,
  #				catalog_item_packet_id,
  #				0 as physical_qty,
  #				'Physical Inventory' as table_name,
  #				sum(stock_rec_qty + memo_rec_qty - stock_iss_qty - memo_iss_qty) as system_qty
  #
  #		from	inventory_summaries
  #		where	trans_flag ='A'
  #		group by company_id, catalog_item_id, catalog_item_packet_id
  #					)
  #                ) X) y
  #
  #        inner join catalog_items b on b.id = y.catalog_item_id
  #        inner join companies e on e.id = y.company_id
  #        inner join catalog_item_categories c on c.id = b.catalog_item_category_id
  #        inner join catalog_item_packets d on d.id = y.catalog_item_packet_id
  #where
  #                        (y.company_id in (select company_id from user_companies where user_id=?)) AND
  #                        (Isnull(d.code,'') between ? and ? AND (0 =? or d.code in (?))) AND
  #                        (b.store_code between ? and ? AND (0 =? or b.store_code in (?))) AND
  #                        (c.code between ? and ? AND (0 =? or c.code in (?)))
  #                        AND (y.system_qty - y.physical_qty) <> 0
  #
  #    ) as tbl_variance_report order by tbl_variance_report.catalog_item_code, tbl_variance_report.catalog_item_packet_code
  #FOR XML PATH('inventory_transaction'),type,elements xsinil ) FOR XML PATH('inventory_transactions'))  AS xml) as xmlcol
  #     )#"
  #    query = convert_sql_to_db_specific(query)
  #    Inventory::InventorySummary.find_by_sql [query,
  #      criteria.str1, criteria.str2,   criteria.multiselect1.length, criteria.multiselect1,
  #      criteria.str1, criteria.str2,   criteria.multiselect1.length, criteria.multiselect1,
  #      criteria.user_id,
  #      criteria.str3, criteria.str4 ,  criteria.multiselect2.length, criteria.multiselect2,
  #      criteria.str5, criteria.str6 ,  criteria.multiselect3.length, criteria.multiselect3,
  #      criteria.str7, criteria.str8 ,  criteria.multiselect4.length, criteria.multiselect4
  #    ]
  #  end

  #backdated_stock variance report  
  def self.backdated_stock_variance_report(doc)
    criteria = Setup::Criteria.fill_criteria_for_sp(doc/:criteria)
    sql_query = ActiveRecord::Base.connection();
    sql_query.execute "SET IMPLICIT_TRANSACTIONS OFF";
    sql_query.begin_db_transaction
    list = ActiveRecord::Base.connection.select_all("exec sp_retail_invn_physical_stock_variance_report
           '#{criteria.user_id}',
           '#{criteria.dt2.to_datetime.strftime('%m-%d-%Y %H:%M:%S')}',  
           '#{criteria.str1}',      '#{criteria.str2}',        '#{criteria.multiselect1}' ,
           '#{criteria.str3}',      '#{criteria.str4}',        '#{criteria.multiselect2}' ,
           '#{criteria.str5}',      '#{criteria.str6}',        '#{criteria.multiselect3}' ,
           '#{criteria.str7}',      '#{criteria.str8}',        '#{criteria.multiselect4}'      ")
    sql_query.commit_db_transaction 
    list
  end
end

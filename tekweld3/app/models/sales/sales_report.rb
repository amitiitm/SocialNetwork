class Sales::SalesReport
  include General
  
 
  ## Tekweld Sales Order Stages Service
  def self.list_sales_order_stages(doc)
    criteria = Setup::Criteria.fill_criteria_for_query(doc/:criteria)
    condition = "( so.company_id = #{criteria.company_id}) AND
                     (so.customer_code between '#{criteria.str1}' and '#{criteria.str2}' AND (0 =#{criteria.multiselect1.length} or so.customer_code in ('#{criteria.multiselect1}'))) AND
                     (so.trans_no between '#{criteria.str3}' and '#{criteria.str4}' AND (0 =#{criteria.multiselect2.length} or so.trans_no in ('#{criteria.multiselect2}'))) AND
                     (so.trans_date between '#{criteria.dt1}' and '#{criteria.dt2}' ) AND
                     (so.account_period_code between '#{criteria.str5[0,8]}' and '#{criteria.str6[0,8]}' AND (0 =#{criteria.multiselect3.length} or so.account_period_code in ('#{criteria.multiselect3}'))) AND
                     (so.logo_name between '#{criteria.str7}' and '#{criteria.str8}' AND (0 =#{criteria.multiselect4.length} or so.logo_name in ('#{criteria.multiselect4}'))) AND
                     (so.ext_ref_no between '#{criteria.str9}' and '#{criteria.str10}' AND (0 =#{criteria.multiselect5.length} or so.ext_ref_no in ('#{criteria.multiselect5}'))) AND
                    (isnull(so.accounting_status,'') between '#{criteria.str11}' and '#{criteria.str12}' AND (0 =#{criteria.multiselect6.length} or isnull(so.accounting_status,'') in ('#{criteria.multiselect6}'))) AND
                    (isnull(so.artwork_status,'') between '#{criteria.str13}' and '#{criteria.str14}' AND (0 =#{criteria.multiselect7.length} or isnull(so.artwork_status,'') in ('#{criteria.multiselect7}'))) AND
                    (isnull(so.paper_proof_status,'') between '#{criteria.str15}' and '#{criteria.str16}' AND (0 =#{criteria.multiselect8.length} or isnull(so.paper_proof_status,'') in ('#{criteria.multiselect8}'))) AND
                    (isnull(so.acknowledgment_status,'') between '#{criteria.str17}' and '#{criteria.str18}' AND (0 =#{criteria.multiselect9.length} or isnull(so.acknowledgment_status,'') in ('#{criteria.multiselect9}'))) AND
                    (isnull(so.shipping_status,'') between '#{criteria.str19}' and '#{criteria.str20}' AND (0 =#{criteria.multiselect10.length} or isnull(so.shipping_status,'') in ('#{criteria.multiselect10}'))) AND
                    (isnull(so.order_status,'') between '#{criteria.str21}' and '#{criteria.str22}' AND (0 =#{criteria.multiselect11.length} or isnull(so.order_status,'') in ('#{criteria.multiselect11}'))) AND
                    so.trans_flag = 'A'"
    Sales::SalesOrder.find_by_sql ["select CAST((
                                  select(select 
                                  cust.name as customer_name,so.customer_code,types.description as order_type,
                                  so.rushorder_flag,so.order_flagged,so.id,so.trans_flag,so.trans_bk,so.trans_no,so.trans_date,so.account_period_code,
                                  so.term_code,so.shipping_code,so.cancel_date,so.due_date,so.ship_date,so.trans_type,so.ref_type,so.post_flag,
                                  so.item_qty,so.clear_qty,so.tracking_no,so.ext_ref_no,so.salesperson_code,so.account_dept_email,so.artwork_dept_email,
                                  so.corr_dept_email,so.purchase_dept_email,so.shipping_dept_email,so.promotional_code,so.artwork_version,so.inhand_date,so.paper_proof_flag,
                                  so.paper_proof_status,so.accounting_status,so.customer_contact,so.customer_phone,so.shipvia_accountnumber,so.shipping_status,
                                  so.workflow_location,so.order_status,so.payment_status,so.artwork_status,so.acknowledgment_status,so.inventory_status,so.artworkassignedtouser_id,so.orderassignedtouser_id,
                                  so.logo_name,so.ship_method,so.ship_method_description,so.paperproofsenttocust_date,so.firstpaperproofreminder_date,so.secondpaperproofreminder_date,so.externalsalesperson_code,                                 

                                  (case so.orderpickstatus_flag when 'N' then '' when 'Y' then 'Y' end) as orderpickstatus_flag,
                                  (case so.ordercompletestatus_flag when 'N' then '' when 'Y' then 'Y' end) as ordercompletestatus_flag,
                                  (case so.orderqcstatus_flag when 'N' then '' when 'Y' then 'Y' end) as orderqcstatus_flag,
                                  (case so.ordercancelstatus_flag when 'N' then '' when 'Y' then 'Y' end) as ordercancelstatus_flag,
                                  (case so.artworkattached_flag when 'N' then '' when 'Y' then 'Y' end) as artworkattached_flag,
                                  
                                  (case so.orderentrycomplete_flag when 'N' then '' when 'Y' then 'Y' end) as orderentrycomplete_flag,
                                  (case so.custpoattached_flag when 'N' then '' when 'Y' then 'Y' end) as custpoattached_flag,
                                  (case so.orderacksent_flag when 'N' then '' when 'Y' then 'Y' end) as orderacksent_flag,
                                  (case so.custapproveack_flag when 'N' then '' when 'Y' then 'Y' end) as custapproveack_flag,
                                  (case so.accountreviewed_flag when 'N' then '' when 'Y' then 'Y' end) as accountreviewed_flag,
                                  (case so.shipdatereviewed_flag when 'N' then '' when 'Y' then 'Y' end) as shipdatereviewed_flag,
                                  (case so.shipped_flag when 'N' then '' when 'Y' then 'Y' end) as shipped_flag,
                                  (case so.invoiced_flag when 'N' then '' when 'Y' then 'Y' end) as invoiced_flag,
                                  (case so.wip_flag when 'N' then '' when 'Y' then 'Y' end) as wip_flag,
                                  (case so.artworkreceived_flag when 'N' then '' when 'Y' then 'Y' end) as artworkreceived_flag,
                                  (case so.artworkassigned_flag when 'N' then '' when 'Y' then 'Y' end) as artworkassigned_flag,
                                  (case so.artworkcompleted_flag when 'N' then '' when 'Y' then 'Y' end) as artworkcompleted_flag,
                                  (case so.artworkreviewed_flag when 'N' then '' when 'Y' then 'Y' end) as artworkreviewed_flag,
                                  (case so.artworksenttocust_flag when 'N' then '' when 'Y' then 'Y' end) as artworksenttocust_flag,
                                  (case so.artworkapprovedbycust_flag when 'R' then 'Rejected by Customer' when 'A' then 'Accepted by Customer' end) as artworkapprovedbycust_flag,
                                  (case so.firstpaperproofreminder when 'N' then '' when 'Y' then 'Y' end) as firstpaperproofreminder,
                                  (case so.secondpaperproofreminder when 'N' then '' when 'Y' then 'Y' end) as secondpaperproofreminder

                                  from sales_orders so
                                  inner join customers cust on cust.id = so.customer_id
                                  left outer join types on (
                                        types.type_cd = 'trans_type'
                                        and types.subtype_cd = 'so'
                                        and so.trans_type = types.value 
                                       )
                                  where #{condition}
                                  order by so.trans_no
                                   FOR XML PATH('sales_order'), TYPE,ELEMENTS XSINIL
                                  )FOR XML PATH('sales_orders')) AS varchar(MAX)) as xmlcol"
      
    ]
  end
  
  ## Tekweld Sales Standard Order  Service
  def self.standard_order_register(doc)
    criteria = Setup::Criteria.fill_criteria_for_query(doc/:criteria)
    condition = "( so.company_id = #{criteria.company_id}) AND
                     (so.customer_code between '#{criteria.str1}' and '#{criteria.str2}' AND (0 =#{criteria.multiselect1.length} or so.customer_code in ('#{criteria.multiselect1}'))) AND
                     (so.trans_no between '#{criteria.str3}' and '#{criteria.str4}' AND (0 =#{criteria.multiselect2.length} or so.trans_no in ('#{criteria.multiselect2}'))) AND
                     (so.trans_date between '#{criteria.dt1}' and '#{criteria.dt2}' ) AND
                     (so.account_period_code between '#{criteria.str5[0,8]}' and '#{criteria.str6[0,8]}' AND (0 =#{criteria.multiselect3.length} or so.account_period_code in ('#{criteria.multiselect3}'))) AND
                     (so.logo_name between '#{criteria.str7}' and '#{criteria.str8}' AND (0 =#{criteria.multiselect4.length} or so.logo_name in ('#{criteria.multiselect4}'))) AND
                     (so.ext_ref_no between '#{criteria.str9}' and '#{criteria.str10}' AND (0 =#{criteria.multiselect5.length} or so.ext_ref_no in ('#{criteria.multiselect5}'))) AND
                     (logo_name between '#{criteria.str11}' and '#{criteria.str12}' AND (0 =#{criteria.multiselect6.length} or logo_name in ('#{criteria.multiselect6}'))) AND
                    (isnull(so.artwork_status,'') between '#{criteria.str13}' and '#{criteria.str14}' AND (0 =#{criteria.multiselect7.length} or isnull(so.artwork_status,'') in ('#{criteria.multiselect7}'))) AND
                    (isnull(so.paper_proof_status,'') between '#{criteria.str15}' and '#{criteria.str16}' AND (0 =#{criteria.multiselect8.length} or isnull(so.paper_proof_status,'') in ('#{criteria.multiselect8}'))) AND
                    (isnull(so.acknowledgment_status,'') between '#{criteria.str17}' and '#{criteria.str18}' AND (0 =#{criteria.multiselect9.length} or isnull(so.acknowledgment_status,'') in ('#{criteria.multiselect9}'))) AND
                    (isnull(so.shipping_status,'') between '#{criteria.str19}' and '#{criteria.str20}' AND (0 =#{criteria.multiselect10.length} or isnull(so.shipping_status,'') in ('#{criteria.multiselect10}'))) AND
                    (isnull(so.order_status,'') between '#{criteria.str21}' and '#{criteria.str22}' AND (0 =#{criteria.multiselect11.length} or isnull(so.order_status,'') in ('#{criteria.multiselect11}'))) AND
                    (isnull(so.accounting_status,'') between '#{criteria.str23}' and '#{criteria.str24}' AND (0 =#{criteria.multiselect12.length} or isnull(so.accounting_status,'') in ('#{criteria.multiselect12}'))) AND
                     so.trans_flag = 'A' and sol.trans_flag = 'A' and sol.item_type = 'I'"
    Sales::SalesOrder.find_by_sql ["select CAST((
                                  select(select distinct so.*,sol.item_qty as line_item_qty,sol.item_description,
                                  sol.catalog_item_code,sol.item_price as line_item_price,
                                  cust.name as customer_name,types.description as order_type
                                  from sales_orders so
                                  inner join customers cust on cust.id = so.customer_id
                                  left outer join sales_order_lines sol on sol.sales_order_id = so.id
                                  left outer join types on (
                                        types.type_cd = 'trans_type'
                                        and types.subtype_cd = 'so'
                                        and so.trans_type = types.value 
                                       )
                                  where #{condition}
                                  order by so.trans_no
                                   FOR XML PATH('sales_order'), TYPE,ELEMENTS XSINIL
                                  )FOR XML PATH('sales_orders')) AS varchar(MAX)) as xmlcol"
    ]
  end
  
  ## Tekweld User Activity
  #  def self.list_user_activity(doc)
  #    criteria = Setup::Criteria.fill_criteria(doc/:criteria)
  #    condition = "( so.company_id = ?) AND
  #                     (cust.code between ? and ? AND (0 =? or cust.code in (?))) AND
  #                     (so.trans_no between ? and ? AND (0 =? or so.trans_no in (?))) AND
  #                     (so.trans_date between ? and ? ) AND
  #                     (so.account_period_code between ? and ? AND (0 =? or so.account_period_code in (?))) AND
  #                     (so.trans_type between ? and ? AND (0 =? or so.trans_type in (?))) AND
  #                     (ext_ref_no between ? and ? AND (0 =? or ext_ref_no in (?))) AND
  #                     (logo_name between ? and ? AND (0 =? or logo_name in (?))) AND
  #                     so.trans_flag = 'A'#"
  #    Sales::SalesOrder.find_by_sql ["select distinct so.id,so.trans_no
  #                                  from sales_orders so
  #                                  inner join customers cust on cust.id = so.customer_id
  #                                  left outer join types on (
  #                                        types.type_cd = 'trans_type'
  #                                        and types.subtype_cd = 'so'
  #                                        and so.trans_type = types.value
  #                                       )
  #                                  where #{condition}#",
  #      criteria.company_id,
  #      criteria.str1,criteria.str2,criteria.multiselect1.length,criteria.multiselect1,
  #      criteria.str3,criteria.str4,criteria.multiselect2.length,criteria.multiselect2,
  #      criteria.dt1,criteria.dt2,
  #      criteria.str5[0,8],criteria.str6[0,8],criteria.multiselect3.length,criteria.multiselect3,
  #      criteria.str7,criteria.str8,criteria.multiselect4.length,criteria.multiselect4,
  #      criteria.str9,criteria.str10,criteria.multiselect5.length,criteria.multiselect5,
  #      criteria.str11,criteria.str12,criteria.multiselect6.length,criteria.multiselect6
  #    ]
  #  end

  def self.list_user_activity(doc)
    criteria = Setup::Criteria.fill_criteria(doc/:criteria)
    condition = "( so.company_id = ?) AND
                     (cust.code between ? and ? AND (0 =? or cust.code in (?))) AND
                     (so.trans_no between ? and ? AND (0 =? or so.trans_no in (?))) AND
                     (so.trans_date between ? and ? ) AND
                     (so.account_period_code between ? and ? AND (0 =? or so.account_period_code in (?))) AND
                     (ext_ref_no between ? and ? AND (0 =? or ext_ref_no in (?))) AND
                     (logo_name between ? and ? AND (0 =? or logo_name in (?))) AND
                     so.trans_flag = 'A'"
    sales_orders = Sales::SalesOrder.find_by_sql ["select distinct so.id,so.trans_no,so.qc_off_flag
                                  from sales_orders so
                                  inner join customers cust on cust.id = so.customer_id
                                  left outer join types on (
                                        types.type_cd = 'trans_type'
                                        and types.subtype_cd = 'so'
                                        and so.trans_type = types.value
                                       )
                                  where #{condition}",
      criteria.company_id,
      criteria.str1,criteria.str2,criteria.multiselect1.length,criteria.multiselect1,
      criteria.str3,criteria.str4,criteria.multiselect2.length,criteria.multiselect2,
      criteria.dt1,criteria.dt2,
      criteria.str5[0,8],criteria.str6[0,8],criteria.multiselect3.length,criteria.multiselect3,
      criteria.str9,criteria.str10,criteria.multiselect5.length,criteria.multiselect5,
      criteria.str7,criteria.str8,criteria.multiselect4.length,criteria.multiselect4
    ]
    order_array = []
    sales_orders.each{|sales_order|
      order_hash = Hash.new
      order_hash[:trans_no] = sales_order.trans_no
      order_created_date_time = Time.now
      order_assigned_date_time = Time.now
      order_completed_date_time = Time.now
      quality_checked_date_time = Time.now
      artwork_in_progress_date_time = Time.now
      internal_proofing_time = Time.now
      artwork_received_time = Time.now
      sales_order_transaction_activities = Sales::SalesOrder.find_by_sql ["SELECT sales_orders.id,sales_orders.trans_no,sales_order_transaction_activities.activity_date ,sales_order_transaction_activities.sales_order_stage_code,users.first_name,users.last_name from sales_orders INNER JOIN sales_order_transaction_activities ON sales_order_transaction_activities.sales_order_id = sales_orders.id INNER JOIN users on sales_order_transaction_activities.created_by = users.id where (sales_orders.trans_flag = 'A' and sales_orders.trans_no = '#{sales_order.trans_no}') order by sales_orders.id"]
      for sales_order_transaction_activity in sales_order_transaction_activities
        if sales_order_transaction_activity.sales_order_stage_code == NEW_ORDER
          order_hash[:order_created_user_name] = sales_order_transaction_activity.first_name
          datetime = find_datetime_difference(Time.now,sales_order_transaction_activity.activity_date)
          order_hash[:order_created_time] = datetime[:diff]
          order_created_date_time = sales_order_transaction_activity.activity_date
        end
        if sales_order_transaction_activity.sales_order_stage_code == ORDER_PICKED
          order_hash[:order_assigned_user_name] = sales_order_transaction_activity.first_name
          datetime = find_datetime_difference(sales_order_transaction_activity.activity_date,order_created_date_time)
          order_assigned_date_time = sales_order_transaction_activity.activity_date
          order_hash[:order_assigned_time_diff] = datetime[:diff]
        end
        if sales_order_transaction_activity.sales_order_stage_code == ENTRY_COMPLETED
          order_hash[:order_entry_user_name] = sales_order_transaction_activity.first_name
          datetime = find_datetime_difference(sales_order_transaction_activity.activity_date,order_assigned_date_time)
          order_completed_date_time = sales_order_transaction_activity.activity_date
          order_hash[:order_entry_time_diff] = datetime[:diff]
          if sales_order.qc_off_flag == 'Y'
            quality_checked_date_time = sales_order_transaction_activity.activity_date
          end
        end
        if sales_order_transaction_activity.sales_order_stage_code == QC_COMPLETE
          order_hash[:order_qc_user_name] = sales_order_transaction_activity.first_name
          datetime = find_datetime_difference(sales_order_transaction_activity.activity_date,order_completed_date_time)
          quality_checked_date_time = sales_order_transaction_activity.activity_date
          order_hash[:order_qc_time_diff] = datetime[:diff]
        end
        if sales_order_transaction_activity.sales_order_stage_code =~ /ACCOUNT REVIEWED INTERNALLY/
          order_hash[:order_account_user_name] = sales_order_transaction_activity.first_name
          datetime = find_datetime_difference(sales_order_transaction_activity.activity_date,quality_checked_date_time)
          order_hash[:order_account_time_diff] = datetime[:diff]
        end
        if sales_order_transaction_activity.sales_order_stage_code =~ /Customer Art IS RECEIVED/
          artwork_received_time = sales_order_transaction_activity.activity_date
        end
        if sales_order_transaction_activity.sales_order_stage_code == PROOF_IN_PROGRESS
          order_hash[:artwork_assigned_user_name] = sales_order_transaction_activity.first_name
          datetime = find_datetime_difference(sales_order_transaction_activity.activity_date,artwork_received_time)
          artwork_in_progress_date_time = sales_order_transaction_activity.activity_date
          order_hash[:artwork_assigned_time_diff] = datetime[:diff]
        end
        if sales_order_transaction_activity.sales_order_stage_code == READY_FOR_INTERNAL_PROOFING
          order_hash[:artwork_completed_user_name] = sales_order_transaction_activity.first_name
          datetime = find_datetime_difference(sales_order_transaction_activity.activity_date,artwork_in_progress_date_time)
          internal_proofing_time = sales_order_transaction_activity.activity_date
          order_hash[:artwork_completed_time_diff] = datetime[:diff]
        end
        if sales_order_transaction_activity.sales_order_stage_code == ARTWORK_QC
          order_hash[:artwork_reviewed_user_name] = sales_order_transaction_activity.first_name
          datetime = find_datetime_difference(sales_order_transaction_activity.activity_date,internal_proofing_time)
          order_hash[:artwork_reviewed_time_diff] = datetime[:diff]
        end
      end
      order_array.push(order_hash)
    }
    return order_array
  end

  def self.list_activity_detail_report(doc)
    criteria = Setup::Criteria.fill_criteria(doc/:criteria)
    sql_query = ActiveRecord::Base.connection();
    sql_query.execute "SET IMPLICIT_TRANSACTIONS OFF";
    sql_query.begin_db_transaction
    list = ActiveRecord::Base.connection.select_all("exec  sp_activity_detail_report
      '#{NEW_ORDER}',
      '#{criteria.company_id}',
      '#{criteria.str1}','#{criteria.str2}',#{criteria.multiselect1.length},'#{criteria.multiselect1}',
      '#{criteria.str3}','#{criteria.str4}',#{criteria.multiselect2.length},'#{criteria.multiselect2}',
      '#{criteria.dt1.strftime('%m-%d-%Y %H:%M:%S')}','#{criteria.dt2.strftime('%m-%d-%Y %H:%M:%S')}',
      '#{criteria.str5[0,8]}','#{criteria.str6[0,8]}',#{criteria.multiselect3.length},'#{criteria.multiselect3}',
      '#{criteria.str7}','#{criteria.str8}',#{criteria.multiselect4.length},'#{criteria.multiselect4}',
      '#{criteria.str9}','#{criteria.str10}',#{criteria.multiselect5.length},'#{criteria.multiselect5}'")
    sql_query.commit_db_transaction
    list
  end

  def self.open_order_report(doc)
    criteria = Setup::Criteria.fill_criteria(doc/:criteria)
    condition = convert_sql_to_db_specific("b.sales_order_id = sales_orders.id and b.item_qty > b.clear_qty and
                         (sales_orders.company_id in(select company_id from user_companies where user_id=?)) AND
                         (sales_orders.account_period_code between ? and ? AND (0 =? or sales_orders.account_period_code in (?))) AND
                         (customers.code between ? and ? AND (0 =? or customers.code in (?))) AND
                         (sales_orders.trans_type between ? and ? AND (0 =? )or (sales_orders.trans_type in (?))) AND
                         (nvl(sales_orders.ext_ref_no,'') between ? and ? AND (0 =? )or (sales_orders.ext_ref_no in (?))) AND
                         (nvl(sales_orders.ext_ref_date,'1990-01-01 00:00:00') between ? and ? ) AND
                         (sales_orders.trans_no between ? and ? AND (0 =? or sales_orders.trans_no in (?))) AND
                         (sales_orders.trans_date between ? and ? ) AND
                         (nvl(sales_orders.ship_date,'1990-01-01 00:00:00') between ? and ? ) AND
                         (nvl(sales_orders.cancel_date,'1990-01-01 00:00:00') between ? and ? ) AND
                         (b.catalog_item_code between ? and ? AND (0 =? )or (b.catalog_item_code in (?))) AND
                         (nvl(sales_orders.salesperson_code,'') between ? and ? AND(0 =? )or (sales_orders.salesperson_code in (?))) AND
                         (catalog_item_categories.code between ? and ? AND (0 =? or catalog_item_categories.code in (?))) AND
                         (customer_categories.code between ? and ? AND (0 =? or customer_categories.code in (?)))  AND
                         (sales_orders.trans_bk between ? and ? AND (0 =? or sales_orders.trans_bk in (?)))  AND
                         (nvl(b.catalog_item_packet_code,'') between ? and ? AND (0 =?  or b.catalog_item_packet_code in (?))) AND
                         (nvl(sales_orders.due_date,'1990-01-01 00:00:00') between ? and ? )       ")
    Sales::SalesOrder.active.find(:all,
      :select=>'customers.code as customer_code,customers.name as customer_name,sales_orders.trans_date,sales_orders.trans_no,sales_orders.workflow_location,
                  due_date,ship_date,cancel_date,sales_orders.account_period_code,sales_orders.ext_ref_no as PO_no,sales_orders.ext_ref_date as po_date,sales_orders.salesperson_code,b.catalog_item_code,
                  b.item_description,b.item_qty,b.item_price, b.item_amt,b.net_amt,b.serial_no,b.discount_amt,b.discount_per,
                  (b.item_qty - b.clear_qty) as balance_qty,types.description as trans_type,b.clear_qty,
                  companies.company_cd as company_code,companies.name as company_name,b.trans_flag as line_trans_flag',
      :joins=>" inner join sales_order_lines b on b.sales_order_id = sales_orders.id
                   inner join catalog_items on catalog_items.id = b.catalog_item_id
                   inner join catalog_item_categories on catalog_item_categories.id  =  catalog_items.catalog_item_category_id
                   inner join customers on customers.id = sales_orders.customer_id
                   inner join customer_categories on customer_categories.id = customers.customer_category_id
                   inner join companies on companies.id = sales_orders.company_id
                   left outer join types on (
		             types.type_cd = 'trans_type'
		             and types.subtype_cd = 'PO'
		             and sales_orders.trans_type = types.value
	)
      ",
      :conditions => [condition,
        criteria.user_id,
        criteria.str1[0,8], criteria.str2[0,8], criteria.multiselect1.length, criteria.multiselect1,
        criteria.str3,      criteria.str4,      criteria.multiselect2.length, criteria.multiselect2,
        criteria.str5[0,1], criteria.str6[0,1] ,criteria.multiselect3.length, criteria.multiselect3,
        criteria.str7,      criteria.str8,      criteria.multiselect4.length, criteria.multiselect4,
        criteria.dt1,       criteria.dt2,
        criteria.str9,      criteria.str10,     criteria.multiselect5.length, criteria.multiselect5,
        criteria.dt3,       criteria.dt4,
        criteria.dt5,       criteria.dt6,
        criteria.dt7,       criteria.dt8,
        criteria.str11,     criteria.str12,     criteria.multiselect6.length, criteria.multiselect6,
        criteria.str13,     criteria.str14,     criteria.multiselect7.length, criteria.multiselect7,
        criteria.str15,     criteria.str16,     criteria.multiselect8.length, criteria.multiselect8,
        criteria.str17,     criteria.str18,     criteria.multiselect9.length, criteria.multiselect9,
        criteria.str19,     criteria.str20,     criteria.multiselect10.length, criteria.multiselect10,
        criteria.str21,     criteria.str22,     criteria.multiselect11.length, criteria.multiselect11,
        criteria.dt9,       criteria.dt10
      ],
      :order => "sales_orders.trans_date, sales_orders.trans_no, b.serial_no"
    )
  end

  def self.payment_hold_report(doc)
    criteria = Setup::Criteria.fill_criteria_for_query(doc/:criteria)
    condition = "(so.company_id = #{criteria.company_id}) AND
                 (so.customer_code between '#{criteria.str1}' and '#{criteria.str2}' AND (0 =#{criteria.multiselect1.length} or so.customer_code in ('#{criteria.multiselect1}'))) AND
                 (so.trans_no between '#{criteria.str3}' and '#{criteria.str4}' AND (0 =#{criteria.multiselect2.length} or so.trans_no in ('#{criteria.multiselect2}'))) AND
                 (so.trans_date between '#{criteria.dt1}' and '#{criteria.dt2}' ) AND
                 (so.orderqcstatus_flag='Y' and so.payment_authorize_flag='N') AND
                  so.trans_flag = 'A'"
    Sales::SalesOrder.find_by_sql ["select CAST((
                                  select(select so.id,so.trans_no,so.item_qty,so.net_amt,so.ship_date,so.order_status,so.workflow_location,
                                  so.payment_status,so.trans_date,so.customer_code,
                                  cust.name as customer_name, cust.phone1,cust.phone2, cust.email
                                  from sales_orders so
                                  inner join customers cust on so.customer_id = cust.id
                                  where #{condition}
                                  order by so.trans_no
                                   FOR XML PATH('payment_hold_report'), TYPE,ELEMENTS XSINIL
                                  )FOR XML PATH('payment_hold_reports')) AS varchar(MAX)) as xmlcol"
    ]
  end

  def self.list_incomplete_orders(doc)
    criteria = Setup::Criteria.fill_criteria_for_query(doc/:criteria)
    condition = "( so.company_id = #{criteria.company_id}) AND
                     (so.customer_code between '#{criteria.str1}' and '#{criteria.str2}' AND (0 =#{criteria.multiselect1.length} or so.customer_code in ('#{criteria.multiselect1}'))) AND
                     (so.trans_no between '#{criteria.str3}' and '#{criteria.str4}' AND (0 =#{criteria.multiselect2.length} or so.trans_no in ('#{criteria.multiselect2}'))) AND
                     (so.trans_date between '#{criteria.dt1}' and '#{criteria.dt2}' ) AND
                     (so.account_period_code between '#{criteria.str5[0,8]}' and '#{criteria.str6[0,8]}' AND (0 =#{criteria.multiselect3.length} or so.account_period_code in ('#{criteria.multiselect3}'))) AND
                     (so.logo_name between '#{criteria.str7}' and '#{criteria.str8}' AND (0 =#{criteria.multiselect4.length} or so.logo_name in ('#{criteria.multiselect4}'))) AND
                     (so.ext_ref_no between '#{criteria.str9}' and '#{criteria.str10}' AND (0 =#{criteria.multiselect5.length} or so.ext_ref_no in ('#{criteria.multiselect5}'))) AND
                  so.orderentrycomplete_flag='N' and so.trans_flag='A'"
    Sales::SalesOrder.find_by_sql ["select CAST((
                                  select(select so.id,so.trans_no,so.ship_date,so.order_status,customer_code,so.workflow_location,
                                  types.description as order_type,trans_date,net_amt,ext_ref_no,ext_ref_date
                                  from sales_orders so
                                  left outer join types on (
                                        types.type_cd = 'trans_type'
                                        and types.subtype_cd = 'so'
                                        and so.trans_type = types.value
                                       )
                                  where #{condition}
                                  order by so.trans_no
                                   FOR XML PATH('sales_order'), TYPE,ELEMENTS XSINIL
                                  )FOR XML PATH('sales_orders')) AS varchar(MAX)) as xmlcol"
    ]
  end


end

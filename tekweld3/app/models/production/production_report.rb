class Production::ProductionReport
  include General
  ## Tekweld Production Inboxes Stages Service
  def self.list_production_stages(doc)
    criteria = Setup::Criteria.fill_criteria_for_query(doc/:criteria)
    condition = "(so.company_id = #{criteria.company_id}) AND
                     (customers.code between '#{criteria.str1}' and '#{criteria.str2}' AND (0 =#{criteria.multiselect1.length} or customers.code in ('#{criteria.multiselect1}'))) AND
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
                    (isnull(so.order_status,'') between '#{criteria.str21}' and '#{criteria.str22}' AND (0 =#{criteria.multiselect11.length} or isnull(so.order_status,'') in ('#{criteria.multiselect11}')))
                     AND so.trans_flag = 'A'
                     AND sol.item_type = 'I' AND sol.trans_flag = 'A'
                     AND so.trans_type in ('S','E')"

    condition = convert_sql_to_db_specific(condition)
    Sales::SalesOrder.find_by_sql ["select CAST((
                                  select(select distinct types.description as order_type,so.trans_type,so.trans_date,customers.name,customers.code as customer_code,
                                         so.rushorder_flag,so.trans_no,so.logo_name,so.ship_date,sol.catalog_item_code,sol.item_description,so.order_flagged,
                                         (case sol.imposition_flag
                                                when 'N'
                                                      then ''
                                                when 'Y'
                                                      then 'Y'
                                          end) as imposition_flag,
                                         (case sol.stitch_flag
                                                when 'N'
                                                      then ''
                                                when 'Y'
                                                      then 'Y'
                                          end) as stitch_flag,
                                         (case sol.cut_flag
                                                when 'N'
                                                      then ''
                                                when 'Y'
                                                      then 'Y'
                                          end) as cut_flag,
                                         (case sol.print_flag
                                                when 'N'
                                                      then ''
                                                when 'Y'
                                                      then 'Y'
                                          end) as print_flag ,
                                         (case sol.send_digitization_flag
                                                when 'N'
                                                      then ''
                                                when 'Y'
                                                      then 'Y'
                                          end) as send_digitization_flag ,
                                         (case sol.receive_digitization_flag
                                                when 'N'
                                                      then ''
                                                when 'Y'
                                                      then 'Y'
                                          end) as receive_digitization_flag ,
                                         (case sol.film_flag
                                                when 'N'
                                                      then ''
                                                when 'Y'
                                                      then 'Y'
                                          end) as film_flag                                        
                                  from sales_orders so
                                  inner join sales_order_lines sol on sol.sales_order_id = so.id
                                  inner join catalog_items on catalog_items.id = sol.catalog_item_id
                                  inner join customers on customers.id = so.customer_id
                                  inner join users on users.id = so.updated_by
                                  left outer join types on (
                                          types.type_cd = 'trans_type'
                                          and types.subtype_cd = 'so'
                                          and so.trans_type = types.value 
                                          )
                                  where #{condition}
                                  order by so.ship_date
                                  FOR XML PATH('sales_order'), TYPE,ELEMENTS XSINIL
                                  )FOR XML PATH('sales_orders')) AS varchar(MAX)) as xmlcol"
    ]
  end
  
  ## Tekweld Production Plansheet service by SQL
  def self.list_production_plan_sheet(doc)
    criteria = Setup::Criteria.fill_criteria_for_query(doc/:criteria)
    condition = "(trans_no between '#{criteria.str3}' and '#{criteria.str4}' AND (0 =#{criteria.multiselect2.length} or trans_no in ('#{criteria.multiselect2}'))) AND
                 (trans_date between '#{criteria.dt1}' and '#{criteria.dt2}' ) AND
                 (account_period_code between '#{criteria.str5[0,8]}' and '#{criteria.str6[0,8]}' AND (0 =#{criteria.multiselect3.length} or account_period_code in ('#{criteria.multiselect3}'))) AND
                 (logo_name between '#{criteria.str7}' and '#{criteria.str8}' AND (0 =#{criteria.multiselect4.length} or logo_name in ('#{criteria.multiselect4}'))) AND
                 (ext_ref_no between '#{criteria.str9}' and '#{criteria.str10}' AND (0 =#{criteria.multiselect5.length} or ext_ref_no in ('#{criteria.multiselect5}'))) AND
                (isnull(accounting_status,'') between '#{criteria.str11}' and '#{criteria.str12}' AND (0 =#{criteria.multiselect6.length} or isnull(accounting_status,'') in ('#{criteria.multiselect6}'))) AND
                (isnull(artwork_status,'') between '#{criteria.str13}' and '#{criteria.str14}' AND (0 =#{criteria.multiselect7.length} or isnull(artwork_status,'') in ('#{criteria.multiselect7}'))) AND
                (isnull(paper_proof_status,'') between '#{criteria.str15}' and '#{criteria.str16}' AND (0 =#{criteria.multiselect8.length} or isnull(paper_proof_status,'') in ('#{criteria.multiselect8}'))) AND
                (isnull(acknowledgment_status,'') between '#{criteria.str17}' and '#{criteria.str18}' AND (0 =#{criteria.multiselect9.length} or isnull(acknowledgment_status,'') in ('#{criteria.multiselect9}'))) AND
                (isnull(shipping_status,'') between '#{criteria.str19}' and '#{criteria.str20}' AND (0 =#{criteria.multiselect10.length} or isnull(shipping_status,'') in ('#{criteria.multiselect10}'))) AND
                (isnull(order_status,'') between '#{criteria.str21}' and '#{criteria.str22}' AND (0 =#{criteria.multiselect11.length} or isnull(order_status,'') in ('#{criteria.multiselect11}')))"
    condition = convert_sql_to_db_specific(condition)
    Sales::SalesOrder.find_by_sql ["select CAST((
                                  select(select trans_date,
                                  COUNT(trans_date) as orderreceived_flag ,
                                  (select CASE WHEN COUNT(orderentrycomplete_flag)=0 THEN NULL ELSE COUNT(orderentrycomplete_flag) END from sales_orders where trans_date = X.trans_date AND orderentrycomplete_flag = 'Y') as orderentrycomplete_flag,
                                  (select CASE WHEN COUNT(orderqcstatus_flag)= 0 THEN NULL ELSE COUNT(orderqcstatus_flag) END from sales_orders where trans_date = X.trans_date AND orderqcstatus_flag = 'Y') as orderqcstatus_flag,
                                  (select CASE WHEN COUNT(paper_proof_flag) = 0 THEN NULL ELSE COUNT (paper_proof_flag) END from sales_orders where trans_date = X.trans_date AND paper_proof_flag = 'N') as paper_proof_flag,
                                  (select CASE WHEN COUNT(artworkreceived_flag)= 0 THEN NULL ELSE COUNT(artworkreceived_flag) END from sales_orders where trans_date = X.trans_date AND artworkreceived_flag = 'Y') as artworkreceived_flag,
                                  (select CASE WHEN COUNT(artworkreviewed_flag)= 0 THEN NULL ELSE COUNT(artworkreviewed_flag) END from sales_orders where trans_date = X.trans_date AND artworkreviewed_flag = 'Y') as artworkreviewed_flag,
                                  (select CASE WHEN COUNT(artworkapprovedbycust_flag)= 0 THEN NULL ELSE COUNT(artworkapprovedbycust_flag) END from sales_orders where trans_date = X.trans_date AND artworksenttocust_flag = 'Y' AND artworkapprovedbycust_flag <> 'A') as artworkapprovedbycust_flag,
                                  (select CASE WHEN COUNT(accountreviewed_flag)= 0 THEN NULL ELSE COUNT(accountreviewed_flag) END from sales_orders where trans_date = X.trans_date AND accountreviewed_flag = 'Y') as accountreviewed_flag,
                                  COUNT(trans_date) + (select  COUNT(orderentrycomplete_flag) from sales_orders where trans_date = X.trans_date AND orderentrycomplete_flag = 'Y')+
                                  (select COUNT(orderqcstatus_flag)  from sales_orders where trans_date = X.trans_date AND orderqcstatus_flag = 'Y')+
                                  (select COUNT(paper_proof_flag)  from sales_orders where trans_date = X.trans_date AND paper_proof_flag = 'N')+
                                  (select COUNT(artworkreceived_flag)  from sales_orders where trans_date = X.trans_date AND artworkreceived_flag = 'Y')+
                                  (select COUNT(artworkreviewed_flag)  from sales_orders where trans_date = X.trans_date AND artworkreviewed_flag = 'Y')+
                                  (select COUNT(artworkapprovedbycust_flag)  from sales_orders where trans_date = X.trans_date AND artworksenttocust_flag = 'Y' AND artworkapprovedbycust_flag <> 'A')+
                                  (select COUNT(accountreviewed_flag)  from sales_orders where trans_date = X.trans_date AND accountreviewed_flag = 'Y') as total

                                  from sales_orders X where #{condition} group by trans_date 
                                  FOR XML PATH('sales_order'), TYPE,ELEMENTS XSINIL
                                  )FOR XML PATH('sales_orders')) AS varchar(MAX)) as xmlcol"
    ]
  end



  #  ## Tekweld Production PlanSheet Service By code
  #  def self.list_production_plan_sheet(doc)
  #    criteria = Setup::Criteria.fill_criteria(doc/:criteria)
  #    condition = ["(trans_no between ? and ? AND (0 =? or trans_no in (?))) AND
  #                     (trans_date between ? and ? ) AND
  #                     (account_period_code between ? and ? AND (0 =? or account_period_code in (?))) AND
  #                     (logo_name between ? and ? AND (0 =? or logo_name in (?))) AND
  #                     (ext_ref_no between ? and ? AND (0 =? or ext_ref_no in (?))) AND "
  #    ]
  #    orderreceive = Sales::SalesOrder.find(:all,:select => "trans_date,count(trans_date) as orderreceived_flag",
  #      :conditions => ["#{condition}trans_flag = 'A'", criteria.str3,criteria.str4,criteria.multiselect2.length,criteria.multiselect2,
  #        criteria.dt1,criteria.dt2,
  #        criteria.str5[0,8],criteria.str6[0,8],criteria.multiselect3.length,criteria.multiselect3,
  #        criteria.str7,criteria.str8,criteria.multiselect4.length,criteria.multiselect4,
  #        criteria.str9,criteria.str10,criteria.multiselect5.length,criteria.multiselect5],:group => "trans_date")
  #    orderentry = Sales::SalesOrder.find(:all,:select => "trans_date,count(orderentrycomplete_flag) as orderentrycomplete_flag",
  #      :conditions => ["#{condition}orderentrycomplete_flag = 'Y'", criteria.str3,criteria.str4,criteria.multiselect2.length,criteria.multiselect2,
  #        criteria.dt1,criteria.dt2,
  #        criteria.str5[0,8],criteria.str6[0,8],criteria.multiselect3.length,criteria.multiselect3,
  #        criteria.str7,criteria.str8,criteria.multiselect4.length,criteria.multiselect4,
  #        criteria.str9,criteria.str10,criteria.multiselect5.length,criteria.multiselect5],:group => "trans_date")
  #    orderqc = Sales::SalesOrder.find(:all,:select => "trans_date,count(orderqcstatus_flag) as orderqcstatus_flag",
  #      :conditions => ["#{condition}orderqcstatus_flag = 'Y'", criteria.str3,criteria.str4,criteria.multiselect2.length,criteria.multiselect2,
  #        criteria.dt1,criteria.dt2,
  #        criteria.str5[0,8],criteria.str6[0,8],criteria.multiselect3.length,criteria.multiselect3,
  #        criteria.str7,criteria.str8,criteria.multiselect4.length,criteria.multiselect4,
  #        criteria.str9,criteria.str10,criteria.multiselect5.length,criteria.multiselect5],:group => "trans_date")
  #    artworkreceive = Sales::SalesOrder.find(:all,:select => "trans_date,count(artworkreceived_flag) as artworkreceived_flag",
  #      :conditions => ["#{condition}artworkreceived_flag = 'Y'", criteria.str3,criteria.str4,criteria.multiselect2.length,criteria.multiselect2,
  #        criteria.dt1,criteria.dt2,
  #        criteria.str5[0,8],criteria.str6[0,8],criteria.multiselect3.length,criteria.multiselect3,
  #        criteria.str7,criteria.str8,criteria.multiselect4.length,criteria.multiselect4,
  #        criteria.str9,criteria.str10,criteria.multiselect5.length,criteria.multiselect5],:group => "trans_date")
  #    artworkreviewed = Sales::SalesOrder.find(:all,:select => "trans_date,count(artworkreviewed_flag) as artworkreviewed_flag",
  #      :conditions =>["#{condition}artworkreviewed_flag = 'Y'", criteria.str3,criteria.str4,criteria.multiselect2.length,criteria.multiselect2,
  #        criteria.dt1,criteria.dt2,
  #        criteria.str5[0,8],criteria.str6[0,8],criteria.multiselect3.length,criteria.multiselect3,
  #        criteria.str7,criteria.str8,criteria.multiselect4.length,criteria.multiselect4,
  #        criteria.str9,criteria.str10,criteria.multiselect5.length,criteria.multiselect5],:group => "trans_date")
  #    artworkapprovedbycust = Sales::SalesOrder.find(:all,:select => "trans_date,count(artworkapprovedbycust_flag) as artworkapprovedbycust_flag",
  #      :conditions => ["#{condition}artworksenttocust_flag = 'Y' AND artworkapprovedbycust_flag <> 'A'", criteria.str3,criteria.str4,criteria.multiselect2.length,criteria.multiselect2,
  #        criteria.dt1,criteria.dt2,
  #        criteria.str5[0,8],criteria.str6[0,8],criteria.multiselect3.length,criteria.multiselect3,
  #        criteria.str7,criteria.str8,criteria.multiselect4.length,criteria.multiselect4,
  #        criteria.str9,criteria.str10,criteria.multiselect5.length,criteria.multiselect5],:group => "trans_date")
  #    accountreviewed = Sales::SalesOrder.find(:all,:select => "trans_date,count(accountreviewed_flag) as accountreviewed_flag",
  #      :conditions => ["#{condition}accountreviewed_flag = 'Y'", criteria.str3,criteria.str4,criteria.multiselect2.length,criteria.multiselect2,
  #        criteria.dt1,criteria.dt2,
  #        criteria.str5[0,8],criteria.str6[0,8],criteria.multiselect3.length,criteria.multiselect3,
  #        criteria.str7,criteria.str8,criteria.multiselect4.length,criteria.multiselect4,
  #        criteria.str9,criteria.str10,criteria.multiselect5.length,criteria.multiselect5],:group => "trans_date")
  #    paperproof = Sales::SalesOrder.find(:all,:select => "trans_date,count(paper_proof_flag) as paper_proof_flag",
  #      :conditions => ["#{condition}paper_proof_flag = 'N'", criteria.str3,criteria.str4,criteria.multiselect2.length,criteria.multiselect2,
  #        criteria.dt1,criteria.dt2,
  #        criteria.str5[0,8],criteria.str6[0,8],criteria.multiselect3.length,criteria.multiselect3,
  #        criteria.str7,criteria.str8,criteria.multiselect4.length,criteria.multiselect4,
  #        criteria.str9,criteria.str10,criteria.multiselect5.length,criteria.multiselect5],:group => "trans_date")
  #    return orderreceive,orderentry,orderqc,artworkreceive,artworkreviewed,artworkapprovedbycust,accountreviewed,paperproof
  #  end
end
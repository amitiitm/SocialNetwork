class Setup::DashboardCrud
  include General
  def self.list_todays_shipments
    Sales::SalesOrderShipping.find_by_sql ["select CAST((select(
                                           select workflow_location,ext_ref_no,trans_no,trans_date,ship_date,customer_code,item_qty,order_status
					                                 FROM sales_orders
					                                 WHERE DATEDIFF(day,ship_date,GETDATE()) = 0 and shipped_flag = 'N' and artworkapprovedbycust_flag = 'A'
                                           FOR XML PATH('sales_order'), TYPE,ELEMENTS XSINIL
                                           )FOR XML PATH('sales_orders')) AS varchar(MAX)) as xmlcol"
    ]
  end

  def self.list_tomorrows_shipments
    Sales::SalesOrderShipping.find_by_sql ["select CAST((select(select workflow_location,ext_ref_no,trans_no,trans_date,ship_date,customer_code,item_qty,order_status
                                           FROM sales_orders
                                           WHERE DATEDIFF(day,ship_date,GETDATE()) = -1 and shipped_flag = 'N' and artworkapprovedbycust_flag = 'A'
                                           FOR XML PATH('sales_order'), TYPE,ELEMENTS XSINIL
                                           )FOR XML PATH('sales_orders')) AS varchar(MAX)) as xmlcol"
    ]
  end

  def self.list_order_activity
    Sales::SalesOrder.find_by_sql ["select CAST((
                                  select(select order_status as stage,COUNT(*) as count
                                  from sales_orders
                                  inner join order_master_stages on order_master_stages.stage_code = sales_orders.order_status
                                  WHERE
                                  invoiced_flag='N' and
                                  order_status is not null and
                                  order_status <> '' and
                                  sales_orders.trans_flag='A'
                                  group by order_status,sequence_no
                                  order by sequence_no
                                  FOR XML PATH('sales_order'), TYPE,ELEMENTS XSINIL
                                  )FOR XML PATH('sales_orders')) AS varchar(MAX)) as xmlcol "

    ]
  end

  def self.list_production_activity
    Sales::SalesOrder.find_by_sql ["select CAST((
                                  select(
                                        select catalog_items.workflow , COUNT(*)as count
                                        from sales_orders
                                        inner join sales_order_lines on sales_orders.id=sales_order_lines.sales_order_id
                                        inner join catalog_items on sales_order_lines.catalog_item_id=catalog_items.id
                                        WHERE invoiced_flag='N'and
                                        sales_order_lines.item_type = 'I' and
                                        workflow is not null and
                                        workflow <> '' and
                                        sales_orders.trans_flag='A' group by workflow
                                  FOR XML PATH('sales_order'), TYPE,ELEMENTS XSINIL
                                  )FOR XML PATH('sales_orders')) AS varchar(MAX)) as xmlcol "

    ]
  end

  def self.list_order_types
    Sales::SalesOrder.find_by_sql ["select CAST((
                                  select(select TYPES.DESCRIPTION,COUNT(*) as total_orders from SALES_ORDERS
                                  inner join TYPES on  (
                                                        types.type_cd = 'trans_type'
                                                        and types.subtype_cd = 'so'
                                                        and SALES_ORDERS.trans_type = types.value
                                                        )
                                  where sales_orders.shipped_flag='N'and sales_orders.trans_flag='A' group by TYPES.DESCRIPTION
                                                                    FOR XML PATH('sales_order'), TYPE,ELEMENTS XSINIL
                                                                    )FOR XML PATH('sales_orders')) AS varchar(MAX)) as xmlcol "

    ]
  end

  def self.list_rush_orders
    Sales::SalesOrder.find_by_sql ["select CAST((
                                  select(select workflow_location,ext_ref_no,ship_date,trans_no,customer_code from sales_orders WHERE rushorder_flag='Y' and shipped_flag='N' and trans_flag='A'
                                  FOR XML PATH('sales_order'), TYPE,ELEMENTS XSINIL
                                  )FOR XML PATH('sales_orders')) AS varchar(MAX)) as xmlcol "

    ]
  end

  def self.list_top10_orders
    Sales::SalesOrder.find_by_sql ["select CAST((
                                  select(select top 10 workflow_location,ext_ref_no,trans_no,trans_date,ship_date,customer_code,item_qty,net_amt,order_status from sales_orders order by net_amt desc
                                  FOR XML PATH('sales_order'), TYPE,ELEMENTS XSINIL
                                  )FOR XML PATH('sales_orders')) AS varchar(MAX)) as xmlcol "

    ]
  end

  def self.list_generic_search(doc)
    search_type = parse_xml(doc/:params/'search_type') if (doc/:params/'search_type').first
    search_value = parse_xml(doc/:params/'search_value') if (doc/:params/'search_value').first
    case search_type
    when 'trans_no'
      sql = "select logo_name,workflow_location,order_status,ext_ref_no,trans_no,trans_date,ship_date,customer_code,trans_type from sales_orders where trans_flag = 'A' and trans_no like ?"
    when 'customer_code'
      sql = "select logo_name,workflow_location,order_status,ext_ref_no,trans_no,trans_date,ship_date,customer_code,trans_type from sales_orders where trans_flag = 'A' and customer_code like ?"
    when 'ext_ref_no'
      sql = "select logo_name,workflow_location,order_status,ext_ref_no,trans_no,trans_date,ship_date,customer_code,trans_type from sales_orders where trans_flag = 'A' and ext_ref_no like ?"
    when 'catalog_item_code'
      sql = "select distinct sales_orders.logo_name,sales_orders.workflow_location,sales_orders.order_status,'' as ext_ref_no,sales_orders.trans_no,sales_orders.trans_date,ship_date,customer_code,trans_type from sales_orders
             inner join sales_order_lines sol on sol.sales_order_id = sales_orders.id
             where sol.item_type = 'I' and sales_orders.trans_flag = 'A' and sol.trans_flag = 'A' and catalog_item_code like ?"
    when 'tracking_no'
      sql = "select logo_name,workflow_location,sos.tracking_no,order_status,ext_ref_no,trans_no,trans_date,sos.internal_ship_date as ship_date,customer_code,trans_type
             from sales_orders so
             inner join sales_order_shippings sos on sos.sales_order_id = so.id
             where  sales_orders.trans_flag = 'A' and sos.trans_flag = 'A' and sos.tracking_no like ?"
    when 'workflow_location'
      sql = "select logo_name,workflow_location,order_status,ext_ref_no,trans_no,trans_date,ship_date,customer_code,trans_type from sales_orders where trans_flag = 'A' and workflow_location like ?"
    when 'logo_name'
      sql = "select logo_name,workflow_location,order_status,ext_ref_no,trans_no,trans_date,ship_date,customer_code,trans_type from sales_orders where trans_flag = 'A' and logo_name like ?"
    when 'estimate_no'
      sql = "select logo_name,workflow_location,order_status,ext_ref_no,trans_no,trans_date,ship_date,customer_code,trans_type from sales_orders where trans_flag = 'A' and ref_type = 'Q' and ref_trans_no like ?"
    end
    Sales::SalesOrder.find_by_sql ["select CAST((
                                  select( #{sql}
                                  FOR XML PATH('sales_order'), TYPE,ELEMENTS XSINIL
                                  )FOR XML PATH('sales_orders')) AS varchar(MAX)) as xmlcol ",'%'+search_value+'%'

    ]
  end

  def self.list_top10_selling_items
    Sales::SalesOrder.find_by_sql ["select CAST((
                                  select(select top 10 catalog_item_code, SUM(item_qty) as total_sold_qty, isnull(max(x.stock_qty),0.00) as on_stock_qty, max(y.open_order_qty) as open_order_qty
                                  from sales_order_lines sol
                                  inner join catalog_items on catalog_items.id = sol.catalog_item_id
                                  left outer join  (
                                  select catalog_item_id, sum(inv.stock_rec_qty - inv.stock_iss_qty) as stock_qty
                                  from inventory_summaries inv
                                  group by catalog_item_id
                                  ) x on x.catalog_item_id = sol.catalog_item_id
                                  left outer join  (
                                  select catalog_item_id, sum(sales_order_lines.item_qty) as open_order_qty
                                  from sales_order_lines, sales_orders
                                  where sales_order_lines.sales_order_id = sales_orders.id and
                                  sales_orders.shipped_flag = 'N'
                                  group by catalog_item_id
                                  ) y on y.catalog_item_id = sol.catalog_item_id
                                  where sol.item_type = 'I'
                                  group by catalog_item_code
                                  order by SUM(item_qty) desc
                                  FOR XML PATH('sales_order'), TYPE,ELEMENTS XSINIL
                                  )FOR XML PATH('sales_orders')) AS varchar(MAX)) as xmlcol "

    ]
  end

  def self.list_out_of_stock_orders
    Sales::SalesOrder.find_by_sql ["select CAST((
                                  select(select so.trans_no, so.ext_ref_no, ship_date, catalog_item_code,sol.item_qty as order_qty, x.stock_qty
                                  from sales_orders so
                                  inner join sales_order_lines sol on so.id = sol.sales_order_id
                                  inner join (
                                  select catalog_item_id, sum(inv.stock_rec_qty - inv.stock_iss_qty) as stock_qty
                                  from inventory_summaries inv
                                  group by catalog_item_id
                                  ) x on x.catalog_item_id = sol.catalog_item_id
                                  where Isnull(sol.item_type,'') <> 'S' and
                                    so.shipped_flag='N' and
                                    so.ship_date is not null
                                  order by ship_date
                                  FOR XML PATH('sales_order'), TYPE,ELEMENTS XSINIL
                                  )FOR XML PATH('sales_orders')) AS varchar(MAX)) as xmlcol "

    ]
  end

  def self.list_out_of_stock_items
    Sales::SalesOrder.find_by_sql ["select CAST((
                                  select(select ci.id,ci.store_code,ci.reorder_level, x.stock_qty
                                  from catalog_items ci
                                  join
                                  (
                                  select catalog_item_id, sum(inv.stock_rec_qty - inv.stock_iss_qty) as stock_qty
                                  from inventory_summaries inv
                                  group by catalog_item_id
                                  ) x on x.catalog_item_id = ci.id
                                  where x.stock_qty < ci.reorder_level and Isnull(ci.item_type,'') <> 'S'
                                  order by ci.store_code
                                  FOR XML PATH('sales_order'), TYPE,ELEMENTS XSINIL
                                  )FOR XML PATH('sales_orders')) AS varchar(MAX)) as xmlcol "

    ]
  end

  def self.list_artwork_receive_pending_orders
    Sales::SalesOrder.find_by_sql ["select CAST((
                                  select(select workflow_location,ext_ref_no,ship_date,trans_no,customer_code,artwork_status
                                  from sales_orders
                                  where artworkreceived_flag = 'N'
                                  FOR XML PATH('sales_order'), TYPE,ELEMENTS XSINIL
                                  )FOR XML PATH('sales_orders')) AS varchar(MAX)) as xmlcol "

    ]
  end

  def self.list_artwork_approval_pending_orders
    Sales::SalesOrder.find_by_sql ["select CAST((
                                  select(select workflow_location,ext_ref_no,ship_date,trans_no,customer_code,artwork_status
                                  from sales_orders
                                  where artworkapprovedbycust_flag not in ('A','R')
                                  FOR XML PATH('sales_order'), TYPE,ELEMENTS XSINIL
                                  )FOR XML PATH('sales_orders')) AS varchar(MAX)) as xmlcol "

    ]
  end

  def self.list_payment_hold_orders
    Sales::SalesOrder.find_by_sql ["select CAST((
                                  select(select workflow_location,ext_ref_no,ship_date,trans_no,customer_code,payment_status,accounting_status
                                  from sales_orders
                                  where accountreviewed_flag = 'N'
                                  FOR XML PATH('sales_order'), TYPE,ELEMENTS XSINIL
                                  )FOR XML PATH('sales_orders')) AS varchar(MAX)) as xmlcol "

    ]
  end

  def self.list_artwork_queries
    Sales::SalesOrder.find_by_sql ["select CAST((
                                  select(select queries.question,queries.query_category,so.trans_no,so.ship_date,so.ext_ref_no,so.workflow_location
                                  from queries
                                  inner join sales_orders so on so.id = queries.sales_order_id
                                  where answer_flag = 'N'and queries.trans_flag='A' and query_type = 'Artwork'
                                  FOR XML PATH('sales_order'), TYPE,ELEMENTS XSINIL
                                  )FOR XML PATH('sales_orders')) AS varchar(MAX)) as xmlcol "

    ]

  end

  def self.list_order_queries
    Sales::SalesOrder.find_by_sql ["select CAST((
                                  select(select queries.question,queries.query_category,so.trans_no,so.ship_date,so.ext_ref_no,so.workflow_location
                                  from queries
                                  inner join sales_orders so on so.id = queries.sales_order_id
                                  where answer_flag = 'N'and queries.trans_flag='A' and query_type = 'Order'
                                  FOR XML PATH('sales_order'), TYPE,ELEMENTS XSINIL
                                  )FOR XML PATH('sales_orders')) AS varchar(MAX)) as xmlcol "

    ]

  end

  def self.list_top10_customers
    Sales::SalesOrder.find_by_sql ["select CAST((
                                  select(
                                  select top 10 COUNT(customer_code) as total_count,customer_code from sales_orders
                                  group by customer_code
                                  order by total_count desc
                                  FOR XML PATH('sales_order'), TYPE,ELEMENTS XSINIL
                                  )FOR XML PATH('sales_orders')) AS varchar(MAX)) as xmlcol "

    ]

  end

  def self.list_preproduction_not_approved_orders
    Sales::SalesOrder.find_by_sql ["select CAST((select(select distinct so.workflow_location,so.trans_no,
						                                           so.ext_ref_no,
                                                       so.order_status
                                                       from sales_orders so
                                                       where (so.trans_flag = 'A' AND
                                                       so.approve_spec_order_flag = 'N' AND
                                                       so.trans_type = 'F'
                                                       )
                                               FOR XML PATH('sales_order'), TYPE,ELEMENTS XSINIL
                                               )FOR XML PATH('sales_orders')) AS varchar(MAX)) as xmlcol "]
  end

  def self.list_embroidery_art_not_approved_orders
    Sales::SalesOrder.find_by_sql ["select CAST((select(select distinct artwork_status,trans_type,
                                                        so.trans_no,
                                                        ext_ref_no,
                                                        order_status from sales_orders so
                                                inner join sales_order_lines sol on sol.sales_order_id = so.id
                                                inner join catalog_items ci on ci.id  = sol.catalog_item_id
                                                where sol.item_type = 'I' and ci.workflow = 'EMBROIDERY' AND
                                                ((so.artworksenttocust_flag = 'Y' and so.paper_proof_flag = 'N') or so.artworksenttocust_flag = 'Y')
                                                and so.artworkapprovedbycust_flag = ''
                                    FOR XML PATH('sales_order'), TYPE,ELEMENTS XSINIL
                                    )FOR XML PATH('sales_orders')) AS varchar(MAX)) as xmlcol"]
  end

  def self.list_embroidery_sent_for_estimation_orders
    Sales::SalesOrder.find_by_sql ["select CAST((select(select so.trans_no,
                                                 so.ext_ref_no,
                                                 so.order_status,
                                                 so.artworkapprovedbycust_flag,
                                                 sol.send_for_estimation_flag
                                                from sales_orders so
                                                INNER JOIN sales_order_lines sol on
                                                    so.id = sol.sales_order_id
                                                where so.trans_flag = 'A' and
                                                          sol.trans_flag = 'A' and
                                                sol.send_for_estimation_flag = 'Y' and
                                                sol.receive_stitch_estimation_flag = 'N'
                                    FOR XML PATH('sales_order'), TYPE,ELEMENTS XSINIL
                                    )FOR XML PATH('sales_orders')) AS varchar(MAX)) as xmlcol"]
  end

  def self.list_embroidery_waiting_for_estimation_orders
    Sales::SalesOrder.find_by_sql [" select CAST((select(select distinct so.trans_no,
                                                         so.ext_ref_no,
                                                         so.order_status,
                                                         so.artworkapprovedbycust_flag,
                                                         sol.send_for_estimation_flag
                                                from sales_orders so
                                                INNER JOIN sales_order_lines sol on
                                                    so.id = sol.sales_order_id
                                                INNER JOIN catalog_items ci on
                                                  (ci.id = sol.catalog_item_id and
                                                   ci.trans_flag = 'A' and
                                                   ci.workflow = 'EMBROIDERY')
                                                where so.trans_flag = 'A' and
                                                sol.trans_flag = 'A' and
                                                ((so.artworksenttocust_flag = '' and so.paper_proof_flag = 'N') or (so.artworksenttocust_flag = 'Y' and artworkapprovedbycust_flag = ''))and
                                                sol.send_for_estimation_flag = ''
                                FOR XML PATH('sales_order'), TYPE,ELEMENTS XSINIL
                                )FOR XML PATH('sales_orders')) AS varchar(MAX)) as xmlcol"]
  end

  def self.list_embroidery_stitch_not_approved_orders
    Sales::SalesOrder.find_by_sql ["select CAST((select(select so.trans_no,
                                                       so.ext_ref_no,
                                                       so.order_status,
                                                       so.artworkapprovedbycust_flag,
                                                       sol.send_digitization_flag
                                                      from sales_orders so
                                                      INNER JOIN sales_order_lines sol on
                                                          (so.id = sol.sales_order_id)
                                                      INNER JOIN catalog_items ci on
                                                      (ci.id = sol.catalog_item_id and
                                                       ci.trans_flag = 'A' and
                                                       ci.workflow = 'EMBROIDERY')
                                                      where so.trans_flag = 'A' and
                                                      sol.trans_flag = 'A' and
                                                      sol.receive_stitch_estimation_flag = 'Y' and
                                                      sol.customer_stitch_approval_flag = ''
                                              FOR XML PATH('sales_order'), TYPE,ELEMENTS XSINIL
                                              )FOR XML PATH('sales_orders')) AS varchar(MAX)) as xmlcol"]
  end

  def self.list_embroidery_send_to_digitize_orders
    Sales::SalesOrder.find_by_sql ["select CAST((select(select so.trans_no,
                                               so.ext_ref_no,
                                               so.order_status,
                                               so.artworkapprovedbycust_flag,
                                               sol.send_digitization_flag
                                              from sales_orders so
                                              INNER JOIN sales_order_lines sol on
                                                  (so.id = sol.sales_order_id)
                                              INNER JOIN catalog_items ci on
                                              (ci.id = sol.catalog_item_id and
                                               ci.trans_flag = 'A' and
                                               ci.workflow = 'EMBROIDERY')
                                              where so.trans_flag = 'A' AND so.accountreviewed_flag = 'Y' AND so.artworkreviewed_flag = 'Y'
                                              AND (so.orderentrycomplete_flag = 'Y' AND (so.qc_off_flag = 'Y' or so.orderqcstatus_flag = 'Y')) AND
                                              sol.trans_flag = 'A' and
                                              so.accountreviewed_flag = 'Y' and
                                              sol.send_digitization_flag = 'Y' and
                                              sol.receive_digitization_flag = 'N'
                                FOR XML PATH('sales_order'), TYPE,ELEMENTS XSINIL
                                )FOR XML PATH('sales_orders')) AS varchar(MAX)) as xmlcol"]
  end

  def self.list_film_inbox_orders
    Sales::SalesOrder.find_by_sql ["select CAST((select(select so.workflow_location,so.trans_no,
                                                       so.ext_ref_no,
                                                       so.order_status,
                                                       sol.film_flag
                                                      from sales_orders so
                                                      INNER JOIN sales_order_lines sol on
                                                      (so.id = sol.sales_order_id)
                                                      INNER JOIN sales_order_attributes_values soav on
                                                      (so.id = soav.sales_order_id
                                                       and soav.catalog_attribute_value_code = 'DIRECT')
                                                      INNER JOIN catalog_items ci on
                                                      (ci.id = sol.catalog_item_id
                                                      AND ci.workflow = 'DIRECTPRINT/DECAL/DIGITEK'
                                                      AND ci.trans_flag = 'A')
                                                      where (sol.trans_flag = 'A' AND
                                                      soav.trans_flag = 'A' AND
                                                      so.trans_type in ('S','E','F') AND
                                                      so.trans_flag = 'A' AND so.accountreviewed_flag = 'Y' AND so.artworkreviewed_flag = 'Y'
                                                      AND (so.orderentrycomplete_flag = 'Y' AND (so.qc_off_flag = 'Y' or so.orderqcstatus_flag = 'Y')) AND
                                                      sol.film_flag = 'N' AND
                                                      ((so.artworksenttocust_flag = '' and so.paper_proof_flag = 'N') or (so.artworksenttocust_flag = 'Y' and artworkapprovedbycust_flag = '')))
                                      FOR XML PATH('sales_order'), TYPE,ELEMENTS XSINIL
                                      )FOR XML PATH('sales_orders')) AS varchar(MAX)) as xmlcol"]
  end

  def self.list_direct_print_inbox_orders
    Sales::SalesOrder.find_by_sql ["select CAST((select(select so.workflow_location,so.trans_no,
                                                       so.ext_ref_no,
                                                       so.order_status,
                                                       so.artworkapprovedbycust_flag,
                                                       sol.send_for_estimation_flag
                                                      from sales_orders so
                                                      INNER JOIN sales_order_lines sol on
                                                      so.id = sol.sales_order_id
                                                      INNER JOIN catalog_items ci on
                                                      (ci.id = sol.catalog_item_id
                                                      AND ci.workflow = 'DIRECTPRINT/DECAL/DIGITEK'
                                                      AND ci.trans_flag = 'A')
                                                      INNER JOIN sales_order_attributes_values soav on
                                                      (so.id = soav.sales_order_id and soav.catalog_attribute_value_code = 'DIRECT')
                                                      where (sol.trans_flag = 'A' AND
                                                      soav.trans_flag = 'A'
                                                      AND so.trans_flag = 'A' AND (so.accountreviewed_flag = 'Y') AND so.artworkreviewed_flag = 'Y'
                                                      AND (so.orderentrycomplete_flag = 'Y' AND (so.qc_off_flag = 'Y' or so.orderqcstatus_flag = 'Y')) AND
                                                      sol.film_flag = 'Y' AND
                                                      sol.print_flag = 'N' AND
                                                      so.trans_type IN ('S','E','F') AND
                                                      ((so.artworksenttocust_flag = '' and so.paper_proof_flag = 'N') or (so.artworksenttocust_flag = 'Y' and artworkapprovedbycust_flag = '')))
                                      FOR XML PATH('sales_order'), TYPE,ELEMENTS XSINIL
                                      )FOR XML PATH('sales_orders')) AS varchar(MAX)) as xmlcol"]
  end

  def self.list_noresponse_paperproof_orders
    Sales::SalesOrderShipping.find_by_sql ["select CAST((select(
                                           select workflow_location,ext_ref_no,trans_no,trans_date,ship_date,customer_code,item_qty,order_status,artwork_status
					                                 FROM sales_orders
					                                 WHERE artworksenttocust_flag = 'Y' AND artworkapprovedbycust_flag = '' AND
                                           do_not_change_ship_date = 'Y' AND
                                           DATEDIFF(day,paperproofsenttocust_date,GETDATE()) > 0
                                           FOR XML PATH('sales_order'), TYPE,ELEMENTS XSINIL
                                           )FOR XML PATH('sales_orders')) AS varchar(MAX)) as xmlcol"
    ]
  end

  def self.list_approved_coupons
    Setup::DiscountCoupon.find_by_sql ["select CAST((select(select  dc.coupon_code,dc.catalog_item_code,dc.no_of_uses,dc.no_of_used,dc.from_date,dc.to_date,
						                                           dc.customer_code,
                                                       dc.discount_type,users.user_cd as created_by_code
                                                       from discount_coupons dc
                                                       inner join users on dc.created_by = users.id
                                                       where (dc.trans_flag = 'A' AND
                                                       dc.approval_flag = 'Y'  AND
                                                       (CONVERT(date,GETDATE(),101) between CONVERT(date,from_date,101) and CONVERT(date,to_date,101))
                                                       )
                                               FOR XML PATH('approved_coupon'), TYPE,ELEMENTS XSINIL
                                               )FOR XML PATH('approved_coupons')) AS varchar(MAX)) as xmlcol "]

  end
end
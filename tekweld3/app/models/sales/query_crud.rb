class Sales::QueryCrud
  include General
  #  Trans Type Codes
  #  S	Regular Order
  #  E	Re-Order
  #  P	Sample Order
  #  V	Virtual Order
  #  F	Spec Order

  ############################# Tekweld Services ###################################

  def self.list_order_query_inbox(doc)
    criteria = Setup::Criteria.fill_criteria_for_query(doc/:criteria)
    condition = "( so.company_id = #{criteria.company_id}) AND
                     (customers.code between '#{criteria.str1}' and '#{criteria.str2}' AND (0 =#{criteria.multiselect1.length} or customers.code in ('#{criteria.multiselect1}'))) AND
                     (queries.trans_no between '#{criteria.str3}' and '#{criteria.str4}' AND (0 =#{criteria.multiselect2.length} or queries.trans_no in ('#{criteria.multiselect2}'))) AND
                     (queries.trans_date between '#{criteria.dt1}' and '#{criteria.dt2}' ) AND
                     (so.account_period_code between '#{criteria.str5[0,8]}' and '#{criteria.str6[0,8]}' AND (0 =#{criteria.multiselect3.length} or so.account_period_code in ('#{criteria.multiselect3}')))
                     AND (so.logo_name between '#{criteria.str7}' and '#{criteria.str8}' AND (0 =#{criteria.multiselect4.length} or so.logo_name in ('#{criteria.multiselect4}')))
                     AND (so.ext_ref_no between '#{criteria.str9}' and '#{criteria.str10}' AND (0 =#{criteria.multiselect5.length} or so.ext_ref_no in ('#{criteria.multiselect5}')))
                     AND query_type = 'Order' AND answer_flag = 'N' and queries.trans_flag = 'A'"
    condition = convert_sql_to_db_specific(condition)
    Sales::Query.find_by_sql ["select CAST((
                                  select(
                                  select so.ship_date,so.ext_ref_no,so.logo_name,types.description as order_type,queries.* from queries
                                  inner join sales_orders so on so.id = queries.sales_order_id
                                  inner join customers on customers.id = so.customer_id
                                  left outer join types on (
                                        types.type_cd = 'trans_type'
                                        and types.subtype_cd = 'so'
                                        and so.trans_type = types.value
                                       )
                                  where #{condition}
                                  FOR XML PATH('query'), TYPE,ELEMENTS XSINIL
                                  )FOR XML PATH('queries')) AS varchar(MAX)) as xmlcol"
    ]
  end
                     
  def self.list_artwork_query_inbox(doc)
    criteria = Setup::Criteria.fill_criteria_for_query(doc/:criteria)
    condition = "( so.company_id = #{criteria.company_id}) AND
                     (customers.code between '#{criteria.str1}' and '#{criteria.str2}' AND (0 =#{criteria.multiselect1.length} or customers.code in ('#{criteria.multiselect1}'))) AND
                     (queries.trans_no between '#{criteria.str3}' and '#{criteria.str4}' AND (0 =#{criteria.multiselect2.length} or queries.trans_no in ('#{criteria.multiselect2}'))) AND
                     (queries.trans_date between '#{criteria.dt1}' and '#{criteria.dt2}' ) AND
                     (so.account_period_code between '#{criteria.str5[0,8]}' and '#{criteria.str6[0,8]}' AND (0 =#{criteria.multiselect3.length} or so.account_period_code in ('#{criteria.multiselect3}')))
                     AND (so.logo_name between '#{criteria.str7}' and '#{criteria.str8}' AND (0 =#{criteria.multiselect4.length} or so.logo_name in ('#{criteria.multiselect4}')))
                     AND (so.ext_ref_no between '#{criteria.str9}' and '#{criteria.str10}' AND (0 =#{criteria.multiselect5.length} or so.ext_ref_no in ('#{criteria.multiselect5}')))
                     AND query_type = 'Artwork' AND answer_flag = 'N' and queries.trans_flag = 'A'"
    condition = convert_sql_to_db_specific(condition)
    Sales::Query.find_by_sql ["select CAST((
                                  select(select so.ship_date,so.ext_ref_no,so.logo_name,types.description as order_type,queries.* from queries
                                  inner join sales_orders so on so.id = queries.sales_order_id
                                  inner join customers on customers.id = so.customer_id
                                  left outer join types on (
                                        types.type_cd = 'trans_type'
                                        and types.subtype_cd = 'so'
                                        and so.trans_type = types.value
                                       )
                                  where #{condition}
                                  FOR XML PATH('query'), TYPE,ELEMENTS XSINIL
                                  )FOR XML PATH('queries')) AS varchar(MAX)) as xmlcol"
    ]
  end

  def self.show_query(query_id)
    Sales::Query.where(:id => query_id)
  end

  def self.create_queries(doc)
    queries = []
    (doc/:queries/:query).each{|query_doc|
      query = create_query(query_doc)
      queries <<  query if query
    }
    queries
  end

  def self.create_query(doc)
    query = add_or_modify_query(doc)
    id = parse_xml(doc/'sales_order_id')
    serial_no = parse_xml(doc/'serial_no')
    order = Sales::SalesOrder.find_by_id(id)
    return  if !query
    return if !order
    save_proc = Proc.new{
      query.save!
      if (query.query_type == 'Order' and query.answer_flag == 'Y')
        query_count = Sales::Query.find_by_sql ["select count(*) as query_count from queries where trans_flag = 'A' and query_type = 'Order' and answer_flag = 'N' and sales_order_id = ?",id]
        order.update_attributes!(:order_status => ORDER_ANSWERED) if query_count[0].query_count.to_i == 0
        activity = order.create_sales_order_transaction_activity("ORDER QUERY NO: #{serial_no} IS ANSWERED")
        activity.save! if activity
      elsif (query.query_type == 'Artwork' and query.answer_flag == 'Y')
        query_count = Sales::Query.find_by_sql ["select count(*) as query_count from queries where trans_flag = 'A' and query_type = 'Artwork' and answer_flag = 'N' and sales_order_id = ?",id]
        order.update_attributes!(:artwork_status => ARTWORK_ANSWERED) if query_count[0].query_count.to_i == 0
        activity = order.create_sales_order_transaction_activity("ARTWORK QUERY NO: #{serial_no} IS ANSWERED")
        activity.save! if activity
      end
      workflow_location = Sales::CurrentLocationLogic.find_order_location(order,order.order_status,order.artwork_status)
      order.update_attributes!(:workflow_location => workflow_location)
    }
    query.save_transaction(&save_proc)
    return query
  end

  def self.add_or_modify_query(doc)
    id =  parse_xml(doc/'id') if (doc/'id').first
    query = Sales::Query.find_or_create(id)
    return if !query
    query.apply_attributes(doc)
    query.fill_default_header_values() if query.new_record?
    return query
  end
end

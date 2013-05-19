class Production::ProductionEmbroideryCrud
  include General
  @config = YAML::load(File.open("#{Rails.root}/config/production_settings.yml"))
  #  Trans Type Codes
  #  S	Regular Order
  #  E	Re-Order
  #  P	Sample Order
  #  V	Virtual Order
  #  F	Spec Order
  def self.embroidery_send_digitization_inbox(doc)
    condition = "((so.paper_proof_flag = 'Y' AND so.artworkapprovedbycust_flag = 'A') or (so.paper_proof_flag = 'N'))
                     AND so.trans_flag = 'A' AND so.artworkreviewed_flag = 'Y'
                     AND (so.orderentrycomplete_flag = 'Y' AND (so.qc_off_flag = 'Y' or so.orderqcstatus_flag = 'Y'))
                     AND sol.blank_good_flag <> 'Y' AND so.blank_order_flag <> 'Y' AND sol.item_type = 'I' AND sol.trans_flag = 'A' AND sol.send_digitization_flag = 'N'
                     AND (soav.catalog_attribute_code = '#{CATALOG_ATTRIBUTE_CODE}' and soav.catalog_attribute_value_code = '#{ATTRIBUTE_VALUE_EMBROIDERY}' and catalog_items.workflow = '#{WORKFLOW_EMBROIDERY}' and soav.trans_flag = 'A')
                     AND so.trans_type in ('S','E') AND (soa.final_artwork_flag = 'Y') AND so.ordercancelstatus_flag = 'N' AND sol.customer_stitch_approval_flag = 'Y'"
    spec_order_condition = "((so.paper_proof_flag = 'Y' AND so.artworkapprovedbycust_flag = 'A') or (so.paper_proof_flag = 'N'))
                     AND so.trans_flag = 'A' AND so.artworkreviewed_flag = 'Y'
                     AND (so.orderentrycomplete_flag = 'Y' AND (so.qc_off_flag = 'Y' or so.orderqcstatus_flag = 'Y'))
                     AND sol.blank_good_flag <> 'Y' AND so.blank_order_flag <> 'Y' AND sol.item_type = 'I' AND sol.trans_flag = 'A' AND sol.send_digitization_flag = 'N'
                     AND (soav.catalog_attribute_code = '#{CATALOG_ATTRIBUTE_CODE}' and soav.catalog_attribute_value_code = '#{ATTRIBUTE_VALUE_EMBROIDERY}' and catalog_items.workflow = '#{WORKFLOW_EMBROIDERY}' and soav.trans_flag = 'A')
                     AND so.trans_type in ('F') AND ((sales_order_shippings.pre_prod_flag='Y' and sales_order_shippings.shipping_flag='N') or (so.approve_spec_order_flag = 'Y' and sales_order_shippings.pre_prod_flag='N'))
                     AND (soa.final_artwork_flag = 'Y') AND so.ordercancelstatus_flag = 'N' AND sol.customer_stitch_approval_flag = 'Y'"
    condition = convert_sql_to_db_specific(condition)
    Sales::SalesOrder.find_by_sql ["select CAST(( select (
                                  select * from (select distinct '' as vs, '' as user_name,soa.artwork_version,so.ext_ref_no,types.description as order_type,so.trans_type,so.trans_date,customers.name,customers.code as customer_code,
                                         so.multi_description,so.payment_status,so.vendor_id,so.vendor_code,so.rushorder_flag,so.artwork_status,so.order_status,so.trans_no,sol.serial_no,so.logo_name,sol.catalog_item_code,sol.id,
                                         101  as shipping_serial_no,sol.stitch_count,sol.indigo_code,sol.item_description,sol.item_qty,so.ship_date,so.order_flagged from sales_orders so
                                  inner join sales_order_lines sol on sol.sales_order_id = so.id
                                  inner join catalog_items on catalog_items.id = sol.catalog_item_id
                                  inner join customers on customers.id = so.customer_id
                                  inner join users on users.id = so.updated_by
                                  inner join sales_order_artworks soa on soa.sales_order_id = so.id
                                  inner join sales_order_attributes_values soav on soav.sales_order_id = so.id
                                  left outer join types on (
                                          types.type_cd = 'trans_type'
                                          and types.subtype_cd = 'so'
                                          and so.trans_type = types.value
                                          )
                                  where #{condition}
UNION
                                  select distinct '' as vs, '' as user_name,soa.artwork_version,so.ext_ref_no,types.description as order_type,so.trans_type,so.trans_date,customers.name,customers.code as customer_code,
                                         so.multi_description,so.payment_status,so.vendor_id,so.vendor_code,so.rushorder_flag,so.artwork_status,so.order_status,so.trans_no,sol.serial_no,so.logo_name,sol.catalog_item_code,sol.id,
                                         sales_order_shippings.serial_no as shipping_serial_no,sol.stitch_count,sol.indigo_code,sol.item_description,sales_order_shippings.ship_qty as item_qty,so.ship_date,so.order_flagged from sales_orders so
                                  inner join sales_order_lines sol on sol.sales_order_id = so.id
                                  inner join catalog_items on catalog_items.id = sol.catalog_item_id
                                  inner join customers on customers.id = so.customer_id
                                  inner join users on users.id = so.updated_by
                                  inner join sales_order_artworks soa on soa.sales_order_id = so.id
                                  inner join sales_order_shippings ON sales_order_shippings.sales_order_id = so.id
                                  inner join sales_order_attributes_values soav on soav.sales_order_id = so.id
                                  left outer join types on (
                                          types.type_cd = 'trans_type'
                                          and types.subtype_cd = 'so'
                                          and so.trans_type = types.value
                                          )
                                  where #{spec_order_condition}) as result
                                  order by result.order_flagged desc,result.rushorder_flag desc, result.ship_date
                                  FOR XML PATH('sales_order'), TYPE,ELEMENTS XSINIL
                                  )FOR XML PATH('sales_orders')) AS varchar(MAX)) as xmlcol"
    ]
  end

  def self.embroidery_receive_digitization_inbox(doc)
    criteria = Setup::Criteria.fill_criteria_for_query(doc/:criteria)
    user = Admin::User.find_by_id(criteria.user_id)
    if user and user.login_type == 'V'
      ship_to_vendor_condition = "AND so.vendor_id = #{user.type_id}"
    end
    condition = "((so.paper_proof_flag = 'Y' AND so.artworkapprovedbycust_flag = 'A') or (so.paper_proof_flag = 'N'))
                     AND so.trans_flag = 'A' AND so.artworkreviewed_flag = 'Y'
                     AND (so.orderentrycomplete_flag = 'Y' AND (so.qc_off_flag = 'Y' or so.orderqcstatus_flag = 'Y'))
                     AND sol.blank_good_flag <> 'Y' AND sol.item_type = 'I' and sol.trans_flag = 'A' and sol.receive_digitization_flag = 'N' and sol.send_digitization_flag = 'Y'
                     AND (soav.catalog_attribute_code = '#{CATALOG_ATTRIBUTE_CODE}' and soav.catalog_attribute_value_code = '#{ATTRIBUTE_VALUE_EMBROIDERY}' and catalog_items.workflow = '#{WORKFLOW_EMBROIDERY}' and soav.trans_flag = 'A')
                     AND so.trans_type in ('S','E') AND (soa.final_artwork_flag = 'Y') AND so.ordercancelstatus_flag = 'N' #{ship_to_vendor_condition}"
    spec_order_condition = "((so.paper_proof_flag = 'Y' AND so.artworkapprovedbycust_flag = 'A') or (so.paper_proof_flag = 'N'))
                     AND so.trans_flag = 'A' AND so.artworkreviewed_flag = 'Y'
                     AND (so.orderentrycomplete_flag = 'Y' AND (so.qc_off_flag = 'Y' or so.orderqcstatus_flag = 'Y'))
                     AND sol.blank_good_flag <> 'Y' AND sol.item_type = 'I' and sol.trans_flag = 'A' and sol.receive_digitization_flag = 'N' and sol.send_digitization_flag = 'Y'
                     AND (soav.catalog_attribute_code = '#{CATALOG_ATTRIBUTE_CODE}' and soav.catalog_attribute_value_code = '#{ATTRIBUTE_VALUE_EMBROIDERY}' and catalog_items.workflow = '#{WORKFLOW_EMBROIDERY}' and soav.trans_flag = 'A')
                     AND so.trans_type in ('F') AND ((sales_order_shippings.pre_prod_flag='Y' and sales_order_shippings.shipping_flag='N') or (so.approve_spec_order_flag = 'Y' and sales_order_shippings.pre_prod_flag='N'))
                     AND (soa.final_artwork_flag = 'Y') AND so.ordercancelstatus_flag = 'N' #{ship_to_vendor_condition}"
    condition = convert_sql_to_db_specific(condition)
    Sales::SalesOrder.find_by_sql ["select CAST(( select (
                                  select * from (select distinct '' as vs, '' as user_name,soa.artwork_version,so.ext_ref_no,types.description as order_type,so.trans_type,so.trans_date,customers.name,customers.code as customer_code,
                                         so.multi_description,so.payment_status,so.salesperson_code,so.externalsalesperson_code,so.rushorder_flag,so.artwork_status,so.order_status,so.trans_no,sol.serial_no,so.logo_name,sol.catalog_item_code,so.id,
                                         101  as shipping_serial_no,sol.stitch_count,sol.indigo_code,sol.item_description,sol.item_qty,so.ship_date,so.order_flagged from sales_orders so
                                  inner join sales_order_lines sol on sol.sales_order_id = so.id
                                  inner join catalog_items on catalog_items.id = sol.catalog_item_id
                                  inner join customers on customers.id = so.customer_id
                                  inner join users on users.id = so.updated_by
                                  inner join sales_order_artworks soa on soa.sales_order_id = so.id
                                  inner join sales_order_attributes_values soav on soav.sales_order_id = so.id
                                  left outer join types on (
                                          types.type_cd = 'trans_type'
                                          and types.subtype_cd = 'so'
                                          and so.trans_type = types.value
                                          )
                                  where #{condition}
UNION
                                  select distinct '' as vs, '' as user_name,soa.artwork_version,so.ext_ref_no,types.description as order_type,so.trans_type,so.trans_date,customers.name,customers.code as customer_code,
                                         so.multi_description,so.payment_status,so.salesperson_code,so.externalsalesperson_code,so.rushorder_flag,so.artwork_status,so.order_status,so.trans_no,sol.serial_no,so.logo_name,sol.catalog_item_code,so.id,
                                         sales_order_shippings.serial_no as shipping_serial_no,sol.stitch_count,sol.indigo_code,sol.item_description,sales_order_shippings.ship_qty as item_qty,so.ship_date,so.order_flagged from sales_orders so
                                  inner join sales_order_lines sol on sol.sales_order_id = so.id
                                  inner join catalog_items on catalog_items.id = sol.catalog_item_id
                                  inner join customers on customers.id = so.customer_id
                                  inner join users on users.id = so.updated_by
                                  inner join sales_order_shippings ON sales_order_shippings.sales_order_id = so.id
                                  inner join sales_order_artworks soa on soa.sales_order_id = so.id
                                  inner join sales_order_attributes_values soav on soav.sales_order_id = so.id
                                  left outer join types on (
                                          types.type_cd = 'trans_type'
                                          and types.subtype_cd = 'so'
                                          and so.trans_type = types.value
                                          )
                                  where #{spec_order_condition}) as result
                                  order by result.order_flagged desc,result.rushorder_flag desc, result.ship_date
                                  FOR XML PATH('sales_order'), TYPE,ELEMENTS XSINIL
                                  )FOR XML PATH('sales_orders')) AS varchar(MAX)) as xmlcol"
    ]
  end

  def self.embroidery_stitch_inbox(doc)
    condition = "((so.paper_proof_flag = 'Y' AND so.artworkapprovedbycust_flag = 'A') or (so.paper_proof_flag = 'N'))
                     AND so.trans_flag = 'A' AND so.artworkreviewed_flag = 'Y'
                     AND (so.orderentrycomplete_flag = 'Y' AND (so.qc_off_flag = 'Y' or so.orderqcstatus_flag = 'Y'))
                     AND sol.blank_good_flag <> 'Y' AND sol.item_type = 'I' AND sol.trans_flag = 'A' AND sol.stitch_flag = 'N'
                     AND (soav.catalog_attribute_code = '#{CATALOG_ATTRIBUTE_CODE}' and soav.catalog_attribute_value_code = '#{ATTRIBUTE_VALUE_EMBROIDERY}' and catalog_items.workflow = '#{WORKFLOW_EMBROIDERY}' and soav.trans_flag = 'A')
                     AND sol.receive_digitization_flag = 'Y' AND so.trans_type in ('S','E') AND (soa.final_artwork_flag = 'Y') AND so.ordercancelstatus_flag = 'N'"
    spec_order_condition = "((so.paper_proof_flag = 'Y' AND so.artworkapprovedbycust_flag = 'A') or (so.paper_proof_flag = 'N'))
                     AND so.trans_flag = 'A' AND so.artworkreviewed_flag = 'Y'
                     AND (so.orderentrycomplete_flag = 'Y' AND (so.qc_off_flag = 'Y' or so.orderqcstatus_flag = 'Y'))
                     AND sol.blank_good_flag <> 'Y' AND sol.item_type = 'I' AND sol.trans_flag = 'A' AND sol.stitch_flag = 'N'
                     AND (soav.catalog_attribute_code = '#{CATALOG_ATTRIBUTE_CODE}' and soav.catalog_attribute_value_code = '#{ATTRIBUTE_VALUE_EMBROIDERY}' and catalog_items.workflow = '#{WORKFLOW_EMBROIDERY}' and soav.trans_flag = 'A')
                     AND sol.receive_digitization_flag = 'Y' AND so.trans_type in ('F')
                     AND ((sales_order_shippings.pre_prod_flag='Y' and sales_order_shippings.shipping_flag='N') or (so.approve_spec_order_flag = 'Y' and sales_order_shippings.pre_prod_flag='N'))
                     AND (soa.final_artwork_flag = 'Y') AND so.ordercancelstatus_flag = 'N'"
    condition = convert_sql_to_db_specific(condition)
    Sales::SalesOrder.find_by_sql ["select CAST(( select (
                                  select * from (select distinct '' as vs, '' as user_name,soa.artwork_version,so.ext_ref_no,types.description as order_type,so.trans_type,so.trans_date,customers.name,customers.code as customer_code,
                                         so.multi_description,so.payment_status,so.rushorder_flag,so.artwork_status,so.order_status,so.trans_no,sol.serial_no,so.logo_name,sol.catalog_item_code,sol.id,
                                         soa.artwork_file_name,101  as shipping_serial_no,sol.stitch_count,sol.indigo_code,sol.item_description,sol.item_qty,so.ship_date,so.order_flagged from sales_orders so
                                  inner join sales_order_lines sol on sol.sales_order_id = so.id
                                  inner join catalog_items on catalog_items.id = sol.catalog_item_id
                                  inner join customers on customers.id = so.customer_id
                                  inner join users on users.id = so.updated_by
                                  inner join sales_order_artworks soa on soa.sales_order_id = so.id
                                  inner join sales_order_attributes_values soav on soav.sales_order_id = so.id
                                  left outer join types on (
                                          types.type_cd = 'trans_type'
                                          and types.subtype_cd = 'so'
                                          and so.trans_type = types.value
                                          )
                                  where #{condition}
UNION
                                  select distinct '' as vs, '' as user_name,soa.artwork_version,so.ext_ref_no,types.description as order_type,so.trans_type,so.trans_date,customers.name,customers.code as customer_code,
                                         so.multi_description,so.payment_status,so.rushorder_flag,so.artwork_status,so.order_status,so.trans_no,sol.serial_no,so.logo_name,sol.catalog_item_code,sol.id,
                                         soa.artwork_file_name,sales_order_shippings.serial_no as shipping_serial_no,sol.stitch_count,sol.indigo_code,sol.item_description,sales_order_shippings.ship_qty as item_qty,so.ship_date,so.order_flagged from sales_orders so
                                  inner join sales_order_lines sol on sol.sales_order_id = so.id
                                  inner join catalog_items on catalog_items.id = sol.catalog_item_id
                                  inner join customers on customers.id = so.customer_id
                                  inner join users on users.id = so.updated_by
                                  inner join sales_order_artworks soa on soa.sales_order_id = so.id
                                  inner join sales_order_shippings ON sales_order_shippings.sales_order_id = so.id
                                  inner join sales_order_attributes_values soav on soav.sales_order_id = so.id
                                  left outer join types on (
                                          types.type_cd = 'trans_type'
                                          and types.subtype_cd = 'so'
                                          and so.trans_type = types.value
                                          )
                                  where #{spec_order_condition}) as result
                                  order by result.order_flagged desc,result.rushorder_flag desc, result.ship_date
                                  FOR XML PATH('sales_order'), TYPE,ELEMENTS XSINIL
                                  )FOR XML PATH('sales_orders')) AS varchar(MAX)) as xmlcol"
    ]
  end

  def self.list_embroidery_threads(doc)
    trans_no = parse_xml(doc/:params/'trans_no')
    order = Sales::SalesOrder.find_by_trans_no(trans_no)
    Sales::SalesOrderThread.find_by_sql ["select CAST(( select ( select thread_company,thread_category,color_number,color_card_sequence from sales_order_threads
                                          where trans_flag = 'A' and sales_order_id = #{order.id}
                                          FOR XML PATH('sales_order'), TYPE,ELEMENTS XSINIL
                                          )FOR XML PATH('sales_orders')) AS varchar(MAX)) as xmlcol"
    ]
  end

  def self.send_for_estimation_inbox(doc)
    #    criteria = Setup::Criteria.fill_criteria_for_query(doc/:criteria)
    condition = "((so.paper_proof_flag = 'Y' AND so.artworkapprovedbycust_flag = 'A') or (so.paper_proof_flag = 'N'))
                     AND so.trans_flag = 'A' AND so.artworkreviewed_flag = 'Y' AND so.blank_order_flag <> 'Y'
                     AND sol.send_for_estimation_flag = 'N'
                     AND sol.blank_good_flag <> 'Y' AND sol.item_type = 'I' and sol.trans_flag = 'A'
                     AND (soav.catalog_attribute_code = '#{CATALOG_ATTRIBUTE_CODE}' and soav.catalog_attribute_value_code = '#{ATTRIBUTE_VALUE_EMBROIDERY}' and catalog_items.workflow = '#{WORKFLOW_EMBROIDERY}' and soav.trans_flag = 'A')
                     AND so.trans_type in ('S','E','F') AND (soa.final_artwork_flag = 'Y') AND so.ordercancelstatus_flag = 'N'"
    condition = convert_sql_to_db_specific(condition)
    Sales::SalesOrder.find_by_sql ["select CAST(( select (
                                  select * from (select distinct '' as vs, '' as user_name,soa.artwork_version,so.ext_ref_no,types.description as order_type,so.trans_type,so.trans_date,customers.name,customers.code as customer_code,
                                  so.vendor_id,so.vendor_code,so.payment_status,so.rushorder_flag,so.artwork_status,so.order_status,so.trans_no,sol.serial_no,so.logo_name,sol.catalog_item_code,sol.id,
                                  soa.artwork_file_name,sol.stitch_count,sol.indigo_code,sol.item_description,sol.item_qty,so.ship_date,so.order_flagged
                                  from sales_orders so
                                  inner join sales_order_lines sol on sol.sales_order_id = so.id
                                  inner join catalog_items on catalog_items.id = sol.catalog_item_id
                                  inner join customers on customers.id = so.customer_id
                                  inner join users on users.id = so.updated_by
                                  inner join sales_order_artworks soa on soa.sales_order_id = so.id
                                  inner join sales_order_attributes_values soav on soav.sales_order_id = so.id
                                  left outer join types on (
                                          types.type_cd = 'trans_type'
                                          and types.subtype_cd = 'so'
                                          and so.trans_type = types.value
                                          )
                                  where #{condition}
                                  ) as result
                                  order by result.order_flagged desc,result.rushorder_flag desc, result.ship_date
                                  FOR XML PATH('sales_order'), TYPE,ELEMENTS XSINIL
                                  )FOR XML PATH('sales_orders')) AS varchar(MAX)) as xmlcol"
    ]
  end

  def self.receive_stitch_estimation_inbox(doc)
    criteria = Setup::Criteria.fill_criteria_for_query(doc/:criteria)
    user = Admin::User.find_by_id(criteria.user_id)
    if user and user.login_type == 'V'
      ship_to_vendor_condition = "AND so.vendor_id = #{user.type_id}"
    end
    condition = "so.trans_flag = 'A' AND so.artworkreviewed_flag = 'Y'
                     AND sol.send_for_estimation_flag = 'Y'
                     AND sol.receive_stitch_estimation_flag = 'N'
                     AND sol.blank_good_flag <> 'Y' AND sol.item_type = 'I' and sol.trans_flag = 'A'
                     AND (soav.catalog_attribute_code = '#{CATALOG_ATTRIBUTE_CODE}' and soav.catalog_attribute_value_code = '#{ATTRIBUTE_VALUE_EMBROIDERY}' and catalog_items.workflow = '#{WORKFLOW_EMBROIDERY}' and soav.trans_flag = 'A')
                     AND so.trans_type in ('S','E','F') AND (soa.final_artwork_flag = 'Y') AND so.ordercancelstatus_flag = 'N' #{ship_to_vendor_condition}"
    condition = convert_sql_to_db_specific(condition)
    Sales::SalesOrder.find_by_sql ["select CAST(( select (
                                  select * from (select distinct '' as vs, '' as user_name,soa.artwork_version,so.ext_ref_no,types.description as order_type,so.trans_type,so.trans_date,customers.name,customers.code as customer_code,
                                  so.customer_stitch_reject_reason,so.payment_status,so.rushorder_flag,so.artwork_status,so.order_status,so.trans_no,sol.serial_no,so.logo_name,sol.catalog_item_code,sol.id,
                                  soa.artwork_file_name,sol.stitch_count,sol.indigo_code,sol.item_description,sol.item_qty,so.ship_date,so.order_flagged from sales_orders so
                                  inner join sales_order_lines sol on sol.sales_order_id = so.id
                                  inner join catalog_items on catalog_items.id = sol.catalog_item_id
                                  inner join customers on customers.id = so.customer_id
                                  inner join users on users.id = so.updated_by
                                  inner join sales_order_artworks soa on soa.sales_order_id = so.id
                                  inner join sales_order_attributes_values soav on soav.sales_order_id = so.id
                                  left outer join types on (
                                          types.type_cd = 'trans_type'
                                          and types.subtype_cd = 'so'
                                          and so.trans_type = types.value
                                          )
                                  where #{condition}
                                  ) as result
                                  order by result.order_flagged desc,result.rushorder_flag desc, result.ship_date
                                  FOR XML PATH('sales_order'), TYPE,ELEMENTS XSINIL
                                  )FOR XML PATH('sales_orders')) AS varchar(MAX)) as xmlcol"
    ]
  end

  def self.customer_stitch_approval_inbox(doc)
    #    criteria = Setup::Criteria.fill_criteria_for_query(doc/:criteria)
    condition = "so.trans_flag = 'A' AND so.artworkreviewed_flag = 'Y'
                     AND sol.send_for_estimation_flag = 'Y'
                     AND sol.receive_stitch_estimation_flag = 'Y'
                     AND sol.customer_stitch_approval_flag = 'N'
                     AND sol.blank_good_flag <> 'Y' AND sol.item_type = 'I' and sol.trans_flag = 'A'
                     AND (soav.catalog_attribute_code = '#{CATALOG_ATTRIBUTE_CODE}' and soav.catalog_attribute_value_code = '#{ATTRIBUTE_VALUE_EMBROIDERY}' and catalog_items.workflow = '#{WORKFLOW_EMBROIDERY}' and soav.trans_flag = 'A')
                     AND so.trans_type in ('S','E','F') AND (soa.final_artwork_flag = 'Y') AND so.ordercancelstatus_flag = 'N'"
    condition = convert_sql_to_db_specific(condition)
    Sales::SalesOrder.find_by_sql ["select CAST(( select (
                                  select * from (select distinct '' as vs, '' as user_name,soa.artwork_version,so.ext_ref_no,types.description as order_type,so.trans_type,so.trans_date,customers.name,customers.code as customer_code,
                                  so.payment_status,so.rushorder_flag,so.artwork_status,so.order_status,so.trans_no,sol.serial_no,so.logo_name,sol.catalog_item_code,sol.id,
                                  soa.artwork_file_name,sol.stitch_count,sol.indigo_code,sol.item_description,sol.item_qty,so.ship_date,so.order_flagged from sales_orders so
                                  inner join sales_order_lines sol on sol.sales_order_id = so.id
                                  inner join catalog_items on catalog_items.id = sol.catalog_item_id
                                  inner join customers on customers.id = so.customer_id
                                  inner join users on users.id = so.updated_by
                                  inner join sales_order_artworks soa on soa.sales_order_id = so.id
                                  inner join sales_order_attributes_values soav on soav.sales_order_id = so.id
                                  left outer join types on (
                                          types.type_cd = 'trans_type'
                                          and types.subtype_cd = 'so'
                                          and so.trans_type = types.value
                                          )
                                  where #{condition}
                                  ) as result
                                  order by result.order_flagged desc,result.rushorder_flag desc, result.ship_date
                                  FOR XML PATH('sales_order'), TYPE,ELEMENTS XSINIL
                                  )FOR XML PATH('sales_orders')) AS varchar(MAX)) as xmlcol"
    ]
  end

  def self.create_send_for_estimation_inbox(doc)
    message = ""
    text = ""
    (doc/:sales_orders/:sales_order).each{|order_doc|
      message,text = create_send_for_estimation(order_doc)
      break if text == 'error'
      trans_no =  parse_xml(order_doc/'trans_no') if (order_doc/'trans_no').first
      workflow_location = Sales::CurrentLocationLogic.find_order_status(trans_no)
      order = Sales::SalesOrder.find_by_trans_no(trans_no)
      order.update_attributes!(:workflow_location => workflow_location)
    }
    return message,text
  end
  
  def self.create_send_for_estimation(order_doc)
    begin
      id =  parse_xml(order_doc/'id') if (order_doc/'id').first
      trans_no =  parse_xml(order_doc/'trans_no') if (order_doc/'trans_no').first
      vendor_id =  parse_xml(order_doc/'vendor_id') if (order_doc/'vendor_id').first
      vendor_code =  parse_xml(order_doc/'vendor_code') if (order_doc/'vendor_code').first
      send_for_estimation_flag =  parse_xml(order_doc/'send_for_estimation_flag') if (order_doc/'send_for_estimation_flag').first
      return 'Please Select the line before save.','error' if send_for_estimation_flag != 'Y'

      order = Sales::SalesOrder.find_by_trans_no(trans_no)
      order_line = Sales::SalesOrderLine.find_by_id(id)
      if !order_line
        return 'Order Line Does Not Exists.','error'
      end

      order.order_status = FILE_SEND_FOR_STITCH_ESTIMATION ; order.vendor_code = vendor_code ; order.vendor_id = vendor_id
      order_line.send_for_estimation_flag = send_for_estimation_flag ; order_line.send_for_estimation_date = Time.now

      activity_message = Artwork::ArtworkCrud.create_activity_message(order,'FILE SEND FOR STITCH ESTIMATION')
      activity = order.create_sales_order_transaction_activity(activity_message)

      email = Email::Email.send_email('ESTIMATION FILE ACKNOWLEDGMENT',order)
      artwork_path = Sales::SalesOrderArtwork.find_by_sales_order_id_and_final_artwork_flag_and_trans_flag(order.id,'Y','A')
      artwork_file_path = artwork_path.artwork_file_path
      directory =  "#{Dir.getwd}" + "/"
      # create the file path
      artworkfilepath = File.join(directory, artwork_file_path)
      email.file_name_path = artworkfilepath
      save_proc = Proc.new{
        order.save!
        order_line.save!
        activity.save!
        email.save!
      }
      order.save_transaction(&save_proc)
      if order.errors.empty?
        return 'Estimation File Sent Successfully','success'
      else
        return 'error in sending estimation','error'
      end
    rescue Exception => ex
      return ex,'error'
    end
  end

  def self.create_receive_stitch_estimation_inbox(doc,schema_name,url_with_port)
    message = ""
    text = ""
    (doc/:sales_orders/:sales_order).each{|order_doc|
      message,text = create_receive_stitch_estimation(order_doc,schema_name,url_with_port)
      break if text == 'error'
    }
    return message,text
  end
  def self.create_receive_stitch_estimation(order_doc,schema_name,url_with_port)
    begin
      id =  parse_xml(order_doc/'id') if (order_doc/'id').first
      trans_no =  parse_xml(order_doc/'trans_no') if (order_doc/'trans_no').first
      stitch_count =  parse_xml(order_doc/'stitch_count') if (order_doc/'stitch_count').first
      receive_stitch_estimation_flag =  parse_xml(order_doc/'receive_stitch_estimation_flag') if (order_doc/'receive_stitch_estimation_flag').first
      return 'Please Check stitch count should greater than zero and line is selected.','error' if (receive_stitch_estimation_flag != 'Y' || stitch_count == '')
      order= Sales::SalesOrder.find_by_trans_no(trans_no)
      sales_order_line = Sales::SalesOrderLine.find_by_id(id)
      if !sales_order_line
        return 'Order Line Does Not Exists.','error'
      end
      text = 'successfull'
      setup = Setup::Type.find_by_type_cd_and_subtype_cd('prod','free_stitch_count')
      free_stitch_count = setup.value.to_i
      if stitch_count != '' and free_stitch_count < stitch_count.to_i
        chargeable_stiches = stitch_count.to_i - free_stitch_count
        message,text = update_order_net_amount(order,schema_name,url_with_port,order_doc,chargeable_stiches)
        if text == 'error'
          return message,'error'
        end
      end
      order.update_attributes!(:order_status => DIGI_ESTIMATION_RECEIVED)
      sales_order_line.update_attributes!(:receive_stitch_estimation_flag => receive_stitch_estimation_flag,:receive_stitch_estimation_date => Time.now,:stitch_count => stitch_count)
      activity_message = Artwork::ArtworkCrud.create_activity_message(order,"DIGI ESTIMATION RECEIVED.TOTAL: #{stitch_count} STITCHES")
      activity = order.create_sales_order_transaction_activity(activity_message)
      activity.save!
      if stitch_count.to_i <= free_stitch_count
        send_for_customer_stitch_approval(order,sales_order_line)
      else
        workflow_location = Sales::CurrentLocationLogic.find_order_status(order.trans_no)
        order.update_attributes!(:workflow_location => workflow_location)
      end
      return 'Stitch Estimation Received Successfully','success'
    rescue Exception => ex
      return ex,'error'
    end
  end

  def self.update_order_net_amount(order,schema_name,url_with_port,order_doc,stitch_count)
    begin
      stitch_amt = 0
      updated_by =  parse_xml(order_doc/'updated_by') if (order_doc/'updated_by').first
      stitches_per_unit = Setup::Type.find_by_type_cd_and_subtype_cd('prod','stitches_per_unit')
      setup_item = Item::CatalogItem.find_by_store_code('STITCH-CHARGE')
      if setup_item
        setup_item_price = Item::CatalogItemPrice.find_by_catalog_item_id(setup_item.id)
        if setup_item_price
          per_stitch_amt = ((setup_item_price.column1.to_f)/(stitches_per_unit.value.to_f))
        else
          return 'Setup Item Price Doesnot Exists.','error'
        end
      else
        return 'Setup Item Does Not Exists','error'
      end
      stitch_amt = order.item_qty.to_i * stitch_count.to_i * per_stitch_amt
      flag = false
      order_line = Sales::SalesOrderLine.find_by_sales_order_id_and_catalog_item_id_and_trans_flag(order.id,setup_item.id,'A')
      max_serial_no = order.sales_order_lines.maximum_serial_no
      serial_no = max_serial_no + 1
      if !order_line
        if stitch_amt > 0
          stitch_amt = '%.2f'%stitch_amt
          order_line = Sales::SalesOrderLine.new
          order_line.update_attributes!(:company_id => order.company_id,:created_by => order.created_by,:updated_by => updated_by.to_i,:created_at => Time.now.localtime,:updated_at => Time.now.localtime,
            :sales_order_id => order.id,:trans_bk => order.trans_bk,:trans_no => order.trans_no,:trans_date => order.trans_date,:account_period_code => order.account_period_code,
            :serial_no => serial_no,:item_type => 'S',:catalog_item_id =>setup_item.id,:catalog_item_code => setup_item.store_code,:item_description=>setup_item.purchase_description,
            :item_qty =>stitch_count,:item_price =>setup_item_price.column1.to_f,:item_amt => stitch_amt.to_f,:line_type => 'S')
          order.update_attributes!(:net_amt => (order.net_amt.to_f + stitch_amt.to_f),:item_amt => (order.item_amt.to_f + stitch_amt.to_f))
          flag = true
        end
      else
        if stitch_amt > 0
          net_amt = order.net_amt - order_line.item_amt
          item_amt = order.item_amt - order_line.item_amt
          order.update_attributes!(:net_amt => (net_amt.to_f + stitch_amt.to_f),:item_amt => (item_amt.to_f + stitch_amt.to_f))
          order_line.update_attributes!(:updated_by => updated_by,:updated_at => Time.now.localtime,:item_qty =>stitch_count,:item_price =>per_stitch_amt,:item_amt => stitch_amt.to_f)
          flag = true
        else
          net_amt = order.net_amt - order_line.item_amt
          item_amt = order.item_amt - order_line.item_amt
          order.update_attributes!(:net_amt => (net_amt.to_f + stitch_amt.to_f),:item_amt => (item_amt.to_f + stitch_amt.to_f))
          order_line.destroy
          flag = false
        end
      end
      if flag == true
        result,pdf_file_name_path = Sales::SalesOrderCrud.generate_regular_order_pdf(order,schema_name,url_with_port,false)
        if result == true
          email = Email::Email.send_email('ORDERACKNOWLEDGMENT',order)
          email.file_name_path = pdf_file_name_path
          email.save!
          activity_message = Artwork::ArtworkCrud.create_activity_message(order,'ORDER ACKNOWLEDGMENT RE-SENT')
          activity = order.create_sales_order_transaction_activity(activity_message)
          activity.save!
        end
      end
      return 'Stitch Amount Added Successfully','successfull'
    rescue Exception => ex
      return ex,'error'
    end
  end


  ## this function will automatically approve customer stitches based on no of stitches defined in types table.
  def self.send_for_customer_stitch_approval(order,sales_order_line)
    xml = %{<sales_orders>
              <sales_order>
                <id>#{sales_order_line.id}</id>
                <trans_no>#{order.trans_no}</trans_no>
                <customer_stitch_approval_flag>Y</customer_stitch_approval_flag>
              </sales_order>
            </sales_orders>}
    doc = Hpricot::XML(xml)
    message,text = create_customer_stitch_approval_inbox(doc)
    if text == 'error'
      result = "some error occurred while automatic customer stitch approval"
      activity_message = Artwork::ArtworkCrud.create_activity_message(order,result)
      activity = order.create_sales_order_transaction_activity(activity_message)
      activity.save!
      #    else
      #      result = "Customer Stitch Approval Done Automatically"
    end

    #    send_for_embroidery_digitization(order,sales_order_line)
  end

  ## this function will automatically send embroidery file for digitization to the vendor defined in application settings.
  def self.send_for_embroidery_digitization(order,sales_order_line)
    embd_digitization = Setup::Type.find_by_type_cd_and_subtype_cd('prod','embd_digitization')
    digitization_vendor = Setup::Type.find_by_type_cd_and_subtype_cd('prod','digitization_vendor')
    if embd_digitization.value == 'Y' and digitization_vendor.value != ''
      vendor = Vendor::Vendor.find_by_code(digitization_vendor.value)
      xml = %{<sales_orders>
              <sales_order>
                <id>#{sales_order_line.id}</id>
                <trans_no>#{order.trans_no}</trans_no>
                <vendor_id>#{vendor.id}</vendor_id>
                <vendor_code>#{digitization_vendor.value}</vendor_code>
              </sales_order>
            </sales_orders>}
      doc = Hpricot::XML(xml)
      message,text = create_production_send_digitization_inboxes(doc)
      if text == 'error'
        result = "some error occurred while automatic sending for digitization"
        activity_message = Artwork::ArtworkCrud.create_activity_message(order,result)
        activity = order.create_sales_order_transaction_activity(activity_message)
        activity.save!
        #      else
        #        result = "File sent for Digitization Automatically"
      end
    else
      workflow_location = Sales::CurrentLocationLogic.find_order_status(order.trans_no)
      order.update_attributes!(:workflow_location => workflow_location)
    end
  end

  def self.create_customer_stitch_approval_inbox(doc)
    message = ""
    text = ""
    (doc/:sales_orders/:sales_order).each{|order_doc|
      message,text = create_customer_stitch_approval(order_doc)
      break if text == 'error'
    }
    return message,text
  end
  def self.create_customer_stitch_approval(order_doc)
    begin
      id =  parse_xml(order_doc/'id') if (order_doc/'id').first
      trans_no =  parse_xml(order_doc/'trans_no') if (order_doc/'trans_no').first
      customer_stitch_approval_flag =  parse_xml(order_doc/'customer_stitch_approval_flag') if (order_doc/'customer_stitch_approval_flag').first
      customer_stitch_reject_flag =  parse_xml(order_doc/'customer_stitch_reject_flag') if (order_doc/'customer_stitch_reject_flag').first
      customer_stitch_reject_reason =  parse_xml(order_doc/'customer_stitch_reject_reason') if (order_doc/'customer_stitch_reject_reason').first
      return 'Please Select the line before save.','error' if customer_stitch_approval_flag == ''
      order = Sales::SalesOrder.find_by_trans_no(trans_no)
      sales_order_line = Sales::SalesOrderLine.find_by_id(id)
      if !sales_order_line
        return 'Order Line Does Not Exists.','error'
      end
      if customer_stitch_approval_flag == 'Y'
        email = Email::Email.send_email('STITCH APPROVAL ACKNOWLEDGMENT',order)
        email.save!
        order.update_attributes!(:order_status => STITCHES_APPROVED_BY_CUSTOMER)
        sales_order_line.update_attributes!(:customer_stitch_approval_flag => customer_stitch_approval_flag,:customer_stitch_approval_date => Time.now)
        activity_message = Artwork::ArtworkCrud.create_activity_message(order,'STITCHES APPROVED BY CUSTOMER')
        activity = order.create_sales_order_transaction_activity(activity_message)
        activity.save!
        send_for_embroidery_digitization(order,sales_order_line)
      elsif customer_stitch_reject_flag == 'Y'
        revert_to =  parse_xml(order_doc/'revert_to') if (order_doc/'revert_to').first
        if revert_to == 'Reestimation'
          order.update_attributes!(:order_status => STITCHES_REJECTED_FOR_RE_ESTIMATION,:customer_stitch_reject_reason => customer_stitch_reject_reason)
          sales_order_line.update_attributes!(:customer_stitch_approval_flag => 'N',:receive_stitch_estimation_flag => 'N',:stitch_count => '')
          activity_message = Artwork::ArtworkCrud.create_activity_message(order,"STITCHES REJECTED FOR RE-ESTIMATION")
          activity = order.create_sales_order_transaction_activity(activity_message)
          activity.save!
        elsif revert_to == 'New Artwork'
          artwork_file_name =  parse_xml(order_doc/'artwork_file_name') if (order_doc/'artwork_file_name').first
          order.update_attributes!(:order_status => STITCHES_REJECTED_REDESIGN_ARTWORK,:artwork_status => ARTWORK_RECEIVED,:customer_stitch_reject_reason => customer_stitch_reject_reason,:artworkassignedtouser_id => 0,:artworkassigned_flag => 'N',:artworkcompleted_flag => 'N',:artworkreviewed_flag =>'N',:artworksenttocust_flag => 'N',:artworkapprovedbycust_flag => '')
          sales_order_line.update_attributes!(:send_for_estimation_flag => 'N',:customer_stitch_approval_flag => 'N',:receive_stitch_estimation_flag => 'N',:stitch_count => '')
          order.sales_order_artworks.each{|artwork|
            artwork.update_attributes!(:select_yn => 'N',:final_artwork_flag => 'N')
          }
          if artwork_file_name != ''
            artwork = Sales::SalesOrderArtwork.new
            max_serial_no = order.sales_order_artworks.maximum_serial_no
            serial_no = max_serial_no + 1
            artwork.update_attributes!(:company_id => order.company_id,:created_by => order.created_by,:updated_by => order.updated_by,:created_at => Time.now.localtime,:updated_at => Time.now.localtime,
              :sales_order_id => order.id,:serial_no => serial_no,:customer_id => order.customer_id,:artwork_version => 'Customer Art-2',:artwork_file_path => "public/attachments/TEKW1122/#{artwork_file_name}",
              :artwork_file_name => artwork_file_name,:comment => customer_stitch_reject_reason)
          end
          activity_message = Artwork::ArtworkCrud.create_activity_message(order,"STITCHES REJECTED BY CUSTOMER SEND TO #{revert_to}")
          activity = order.create_sales_order_transaction_activity(activity_message)
          activity.save!
        elsif revert_to == 'Change Layout'
          order.update_attributes!(:order_status => STITCHES_REJECTED_CHANGE_LAYOUT,:artwork_status => ARTWORK_RECEIVED,:customer_stitch_reject_reason => customer_stitch_reject_reason,:artworkassignedtouser_id => 0,:artworkassigned_flag => 'N',:artworkcompleted_flag => 'N',:artworkreviewed_flag =>'N',:artworksenttocust_flag => 'N',:artworkapprovedbycust_flag => '')
          sales_order_line.update_attributes!(:send_for_estimation_flag => 'N',:customer_stitch_approval_flag => 'N',:receive_stitch_estimation_flag => 'N',:stitch_count => '')
          order.sales_order_artworks.each{|artwork|
            artwork.update_attributes!(:select_yn => 'N',:final_artwork_flag => 'N')
          }
          activity_message = Artwork::ArtworkCrud.create_activity_message(order,"STITCHES REJECTED FOR CHANGE LAYOUT")
          activity = order.create_sales_order_transaction_activity(activity_message)
          activity.save!
        elsif revert_to == 'Cancel Order'
          order.update_attributes!(:ordercancelstatus_flag => 'Y',:order_status => ORDER_CANCELLED,:customer_stitch_reject_reason => customer_stitch_reject_reason,:update_flag => 'V')
          activity_message = Artwork::ArtworkCrud.create_activity_message(order,'ORDER CANCELLED')
          activity = order.create_sales_order_transaction_activity(activity_message)
          activity.save!
        end
        order_line = Sales::SalesOrderLine.find_by_sales_order_id_and_catalog_item_code_and_trans_flag(order.id,'STITCH-CHARGE','A')
        order_line.update_attributes!(:trans_flag => 'D')
        workflow_location = Sales::CurrentLocationLogic.find_order_status(order.trans_no)
        order.update_attributes!(:workflow_location => workflow_location)
      end
      return 'Stitches Approved Successfully','success'
    rescue Exception => ex
      return ex,'error'
    end
  end

  def self.resend_artwork_for_embroidery_estimation(order_doc)
    begin
      id =  parse_xml(order_doc/:params/'id') if (order_doc/:params/'id').first
      order = Sales::SalesOrder.find_by_id(id)
      return 'Vendor not found to whom the estimation file is to be sent.','error' if !order.vendor_id and order.vendor_id == ''
      artwork_path = Sales::SalesOrderArtwork.find_by_sales_order_id_and_final_artwork_flag_and_trans_flag(order.id,'Y','A')
      return 'Order Doesnot Contain any Final Artwork Version.','error'
      email = Email::Email.send_email('ESTIMATION FILE ACKNOWLEDGMENT',order)
      artwork_file_path = artwork_path.artwork_file_path
      directory =  "#{Dir.getwd}" + "/"
      # create the file path
      artworkfilepath = File.join(directory, artwork_file_path)
      email.file_name_path = artworkfilepath
      email.save!
      return 'Estimation File Sent Successfully','success'
    rescue Exception => ex
      return ex,'error'
    end
  end

  def self.create_production_send_digitization_inboxes(doc)
    message = ""
    text = ""
    (doc/:sales_orders/:sales_order).each{|order_doc|
      message,text = create_production_send_digitization_inbox(order_doc)
      break if text == 'error'
    }
    return message,text
  end
  def self.create_production_send_digitization_inbox(order_doc)
    begin
      id =  parse_xml(order_doc/'id') if (order_doc/'id').first
      trans_no =  parse_xml(order_doc/'trans_no') if (order_doc/'trans_no').first
      vendor_id =  parse_xml(order_doc/'vendor_id') if (order_doc/'vendor_id').first
      vendor_code =  parse_xml(order_doc/'vendor_code') if (order_doc/'vendor_code').first
      order = Sales::SalesOrder.find_by_trans_no(trans_no)
      sales_order_line = Sales::SalesOrderLine.find_by_id(id)
      query = Sales::Query.find_by_sales_order_id_and_query_type_and_query_category_and_answer_flag(order.id,'Artwork','Digitization','N')
      return 'Please Answer Query related to this order.','error' if query
      if !sales_order_line
        return 'Order Line Does Not Exists.','error'
      end
      order.update_attributes!(:order_status => SENT_DIGITIZING,:vendor_code => vendor_code,:vendor_id => vendor_id)
      sales_order_line.update_attributes!(:send_digitization_flag => 'Y',:send_digitization_date => Time.now)
      activity_message = Artwork::ArtworkCrud.create_activity_message(order,'SENT DIGITIZING')
      activity = order.create_sales_order_transaction_activity(activity_message)
      activity.save!
      email = Email::Email.send_email('DIGITIZATION FILE ACKNOWLEDGMENT',order)
      artwork_path = Sales::SalesOrderArtwork.find_by_sales_order_id_and_final_artwork_flag_and_trans_flag(order.id,'Y','A')
      artwork_file_path = artwork_path.artwork_file_path
      directory =  "#{Dir.getwd}" + "/"
      # create the file path
      artworkfilepath = File.join(directory, artwork_file_path)
      email.file_name_path = artworkfilepath
      email.save!
      workflow_location = Sales::CurrentLocationLogic.find_order_status(order.trans_no)
      order.update_attributes!(:workflow_location => workflow_location)
      return 'Digitization File Sent Successfully','success'
    rescue Exception => ex
      return ex,'error'
    end
  end

  def self.create_production_receive_digitization_inboxes(doc,schema_name,url_with_port)
    sales_orders = []
    (doc/:sales_orders/:sales_order).each{|order_doc|
      sales_order = create_production_receive_digitization_inbox(order_doc,schema_name,url_with_port)
      sales_orders <<  sales_order if sales_order
    }
    sales_orders
  end
  def self.create_production_receive_digitization_inbox(order_doc,schema_name,url_with_port)
    id =  parse_xml(order_doc/'id') if (order_doc/'id').first
    receive_digitization_flag =  parse_xml(order_doc/'receive_digitization_flag') if (order_doc/'receive_digitization_flag').first
    trans_no =  parse_xml(order_doc/'trans_no') if (order_doc/'trans_no').first
    order = Sales::SalesOrder.find_by_trans_no(trans_no)
    sales_order_line = Sales::SalesOrderLine.find_by_sales_order_id_and_line_type_and_item_type_and_trans_flag(id,'M','I','A')
    return  if !sales_order_line
    sales_order_line.update_attributes!(:receive_digitization_flag => receive_digitization_flag,:receive_digitization_date => Time.now)
    order.run_block do
      order.max_serial_no = order.sales_order_artworks.maximum_serial_no
      order.build_lines(order_doc/:sales_order_artworks/:sales_order_artwork)
      order.max_serial_no = order.sales_order_threads.maximum_serial_no
      order.build_lines(order_doc/:sales_order_threads/:sales_order_thread)
      order.max_serial_no = order.queries.maximum_serial_no
      order.build_lines(order_doc/:queries/:query)
    end
    check_vendor_queries(order,sales_order_line)
    order.apply_header_fields_to_lines
    order.save_lines
    if receive_digitization_flag == 'Y'
      order.update_attributes!(:order_status => DIGITIZED_FILE_RECEIVED)
      activity_message = Artwork::ArtworkCrud.create_activity_message(order,'DIGITIZED FILE RECEIVED')
      activity = order.create_sales_order_transaction_activity(activity_message)
      activity.save!
    end
    workflow_location = Sales::CurrentLocationLogic.find_order_status(order.trans_no)
    order.update_attributes!(:workflow_location => workflow_location)
    return order
  end

  def self.check_vendor_queries(order,sales_order_line)
    order.queries.each{ |query|
      if (query.answer_flag == 'N' and query.query_type == 'Artwork' and query.query_category == 'Digitization' and query.new_record?)
        sales_order_line.update_attributes!(:send_digitization_flag => 'N',:receive_digitization_flag => 'N')
        activity = order.create_sales_order_transaction_activity("ARTWORK EMBROIDERY QUERY NO: #{query.serial_no} IS RAISED")
        activity.save!
        email = Email::Email.send_email('VENDOR QUERY ACKNOWLEDGMENT',order)
        email.save!
      end
    }
  end
end
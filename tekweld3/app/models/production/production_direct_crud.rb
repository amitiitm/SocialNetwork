class Production::ProductionDirectCrud
  include General
  @config = YAML::load(File.open("#{Rails.root}/config/production_settings.yml"))
  #  Trans Type Codes
  #  S	Regular Order
  #  E	Re-Order
  #  P	Sample Order
  #  V	Virtual Order
  #  F	Spec Order
  def self.direct_pad_film_inbox(doc)
    condition = " so.trans_flag = 'A' AND so.artworkreviewed_flag = 'Y'
                     AND (so.orderentrycomplete_flag = 'Y' AND (so.qc_off_flag = 'Y' or so.orderqcstatus_flag = 'Y'))
                     AND ((so.paper_proof_flag = 'Y' AND so.artworkapprovedbycust_flag = 'A') or (so.paper_proof_flag = 'N'))
                     AND sol.blank_good_flag <> 'Y' AND so.blank_order_flag <> 'Y' AND sol.item_type = 'I' and sol.trans_flag = 'A' and sol.film_flag = 'N'
                     AND soav.trans_flag = 'A'
                     AND soav.catalog_attribute_code = '#{CATALOG_ATTRIBUTE_CODE}'
                     AND ((soav.catalog_attribute_value_code = '#{ATTRIBUTE_VALUE_DIRECT}' and catalog_items.workflow = '#{WORKFLOW_DIRECT_DECAL_DIGITEK}')
                          or (soav.catalog_attribute_value_code = '#{ATTRIBUTE_VALUE_PAD}' and catalog_items.workflow = '#{WORKFLOW_PAD}'))
                     AND so.trans_type in ('S','E') AND (soa.final_artwork_flag = 'Y') AND so.ordercancelstatus_flag = 'N'"

    spec_order_condition = " so.trans_flag = 'A' AND so.artworkreviewed_flag = 'Y'
                     AND (so.orderentrycomplete_flag = 'Y' AND (so.qc_off_flag = 'Y' or so.orderqcstatus_flag = 'Y'))
                     AND ((so.paper_proof_flag = 'Y' AND so.artworkapprovedbycust_flag = 'A') or (so.paper_proof_flag = 'N'))
                     AND sol.blank_good_flag <> 'Y' AND so.blank_order_flag <> 'Y' AND sol.item_type = 'I' and sol.trans_flag = 'A' and sol.film_flag = 'N'
                     AND soav.trans_flag = 'A'
                     AND ((soav.catalog_attribute_value_code = '#{ATTRIBUTE_VALUE_DIRECT}' and catalog_items.workflow = '#{WORKFLOW_DIRECT_DECAL_DIGITEK}')
                          or (soav.catalog_attribute_value_code = '#{ATTRIBUTE_VALUE_PAD}' and catalog_items.workflow = '#{WORKFLOW_PAD}'))
                     AND so.trans_type in ('F') AND ((sales_order_shippings.pre_prod_flag='Y' and sales_order_shippings.shipping_flag='N') or (so.approve_spec_order_flag = 'Y' and sales_order_shippings.pre_prod_flag='N'))
                     AND (soa.final_artwork_flag = 'Y') AND so.ordercancelstatus_flag = 'N'"
    condition = convert_sql_to_db_specific(condition)
    Sales::SalesOrder.find_by_sql ["select CAST(( select (
                                  select * from (select distinct '' as vs, '' as user_name,soa.artwork_version,so.ext_ref_no,types.description as order_type,so.trans_type,so.trans_date,customers.name,customers.code as customer_code,
                                         so.multi_description,so.payment_status,so.rushorder_flag,so.order_flagged,so.artwork_status,so.order_status,so.trans_no,sol.serial_no,so.logo_name,sol.catalog_item_code,so.id,
                                         101  as shipping_serial_no,sol.indigo_code,sol.item_description,sol.reason,sol.item_qty,so.ship_date from sales_orders so
                                  inner join sales_order_lines sol on sol.sales_order_id = so.id
                                  inner join catalog_items on catalog_items.id = sol.catalog_item_id
                                  inner join customers on customers.id = so.customer_id
                                  inner join sales_order_attributes_values soav on soav.sales_order_id = so.id
                                  inner join users on users.id = so.updated_by
                                  inner join sales_order_artworks soa on soa.sales_order_id = so.id
                                  left outer join types on (
                                          types.type_cd = 'trans_type'
                                          and types.subtype_cd = 'so'
                                          and so.trans_type = types.value
                                          )
                                  where #{condition}
UNION
                                  select distinct '' as vs, '' as user_name,soa.artwork_version,so.ext_ref_no,types.description as order_type,so.trans_type,so.trans_date,customers.name,customers.code as customer_code,
                                         so.multi_description,so.payment_status,so.rushorder_flag,so.order_flagged,so.artwork_status,so.order_status,so.trans_no,sol.serial_no,so.logo_name,sol.catalog_item_code,so.id,
                                         sales_order_shippings.serial_no as shipping_serial_no,sol.indigo_code,sol.item_description,sol.reason,sales_order_shippings.ship_qty as item_qty,so.ship_date from sales_orders so
                                  inner join sales_order_lines sol on sol.sales_order_id = so.id
                                  inner join catalog_items on catalog_items.id = sol.catalog_item_id
                                  inner join customers on customers.id = so.customer_id
                                  inner join sales_order_attributes_values soav on soav.sales_order_id = so.id
                                  inner join users on users.id = so.updated_by
                                  inner join sales_order_artworks soa on soa.sales_order_id = so.id
                                  inner join sales_order_shippings ON sales_order_shippings.sales_order_id = so.id
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

  def self.direct_pad_print_inbox(doc)
    condition = "((so.paper_proof_flag = 'Y' AND so.artworkapprovedbycust_flag = 'A') or (so.paper_proof_flag = 'N'))
                     AND so.trans_flag = 'A' AND so.artworkreviewed_flag = 'Y'
                     AND (so.orderentrycomplete_flag = 'Y' AND (so.qc_off_flag = 'Y' or so.orderqcstatus_flag = 'Y'))
                     AND sol.blank_good_flag <> 'Y' AND sol.item_type = 'I' and sol.trans_flag = 'A' and sol.print_flag = 'N'
                     AND sol.film_flag = 'Y'
                     AND soav.trans_flag = 'A'
                     AND soav.catalog_attribute_code = '#{CATALOG_ATTRIBUTE_CODE}'
                     AND ((soav.catalog_attribute_value_code = '#{ATTRIBUTE_VALUE_DIRECT}' and catalog_items.workflow = '#{WORKFLOW_DIRECT_DECAL_DIGITEK}')
                          or (soav.catalog_attribute_value_code = '#{ATTRIBUTE_VALUE_PAD}' and catalog_items.workflow = '#{WORKFLOW_PAD}'))
                     AND so.trans_type in ('S','E') AND (soa.final_artwork_flag = 'Y') AND so.ordercancelstatus_flag = 'N'"

    spec_order_condition = "((so.paper_proof_flag = 'Y' AND so.artworkapprovedbycust_flag = 'A') or (so.paper_proof_flag = 'N'))
                     AND so.trans_flag = 'A' AND so.artworkreviewed_flag = 'Y'
                     AND (so.orderentrycomplete_flag = 'Y' AND (so.qc_off_flag = 'Y' or so.orderqcstatus_flag = 'Y'))
                     AND sol.blank_good_flag <> 'Y' AND sol.item_type = 'I' and sol.trans_flag = 'A' and sol.print_flag = 'N'
                     AND sol.film_flag = 'Y'
                     AND soav.trans_flag = 'A'
                     AND soav.catalog_attribute_code = '#{CATALOG_ATTRIBUTE_CODE}'
                     AND ((soav.catalog_attribute_value_code = '#{ATTRIBUTE_VALUE_DIRECT}' and catalog_items.workflow = '#{WORKFLOW_DIRECT_DECAL_DIGITEK}')
                          or (soav.catalog_attribute_value_code = '#{ATTRIBUTE_VALUE_PAD}' and catalog_items.workflow = '#{WORKFLOW_PAD}'))
                     AND so.trans_type in ('F') AND ((sales_order_shippings.pre_prod_flag='Y' and sales_order_shippings.shipping_flag='N') or (so.approve_spec_order_flag = 'Y' and sales_order_shippings.pre_prod_flag='N'))
                     AND (soa.final_artwork_flag = 'Y') AND so.ordercancelstatus_flag = 'N'"
    condition = convert_sql_to_db_specific(condition)
    Sales::SalesOrder.find_by_sql ["select CAST(( select (
                                  select * from (select distinct '' as vs, '' as user_name,soa.artwork_version,so.ext_ref_no,types.description as order_type,so.trans_type,so.trans_date,customers.name,customers.code as customer_code,
                                         so.multi_description,so.payment_status,so.rushorder_flag,so.order_flagged,so.artwork_status,so.order_status,so.trans_no,sol.serial_no,so.logo_name,sol.catalog_item_code,sol.id,
                                         soa.artwork_file_name,101  as shipping_serial_no,sol.indigo_code,sol.item_description,sol.reason,sol.item_qty,so.ship_date from sales_orders so
                                  inner join sales_order_lines sol on sol.sales_order_id = so.id
                                  inner join catalog_items on catalog_items.id = sol.catalog_item_id
                                  inner join customers on customers.id = so.customer_id
                                  inner join sales_order_attributes_values soav on soav.sales_order_id = so.id
                                  inner join users on users.id = so.updated_by
                                  inner join sales_order_artworks soa on soa.sales_order_id = so.id
                                  left outer join types on (
                                          types.type_cd = 'trans_type'
                                          and types.subtype_cd = 'so'
                                          and so.trans_type = types.value
                                          )
                                  where #{condition}
UNION
                                  select distinct '' as vs, '' as user_name,soa.artwork_version,so.ext_ref_no,types.description as order_type,so.trans_type,so.trans_date,customers.name,customers.code as customer_code,
                                         so.multi_description,so.payment_status,so.rushorder_flag,so.order_flagged,so.artwork_status,so.order_status,so.trans_no,sol.serial_no,so.logo_name,sol.catalog_item_code,sol.id,
                                         soa.artwork_file_name,sales_order_shippings.serial_no as shipping_serial_no,sol.indigo_code,sol.item_description,sol.reason,sales_order_shippings.ship_qty as item_qty,so.ship_date from sales_orders so
                                  inner join sales_order_lines sol on sol.sales_order_id = so.id
                                  inner join catalog_items on catalog_items.id = sol.catalog_item_id
                                  inner join customers on customers.id = so.customer_id
                                  inner join sales_order_attributes_values soav on soav.sales_order_id = so.id
                                  inner join users on users.id = so.updated_by
                                  inner join sales_order_artworks soa on soa.sales_order_id = so.id
                                  inner join sales_order_shippings ON sales_order_shippings.sales_order_id = so.id
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

  def self.direct_pad_print_option_inbox(doc)
    option =  parse_xml(doc/'options') if (doc/'options').first
    condition = "((so.paper_proof_flag = 'Y' AND so.artworkapprovedbycust_flag = 'A') or (so.paper_proof_flag = 'N'))
                     AND so.trans_flag = 'A' AND so.artworkreviewed_flag = 'Y'
                     AND (so.orderentrycomplete_flag = 'Y' AND (so.qc_off_flag = 'Y' or so.orderqcstatus_flag = 'Y'))
                     AND sol.blank_good_flag <> 'Y' AND sol.item_type = 'I' and sol.trans_flag = 'A' and sol.print_flag = 'N'
                     AND sol.film_flag = 'Y'
                     AND soav.trans_flag = 'A'
                     AND soav.catalog_attribute_code = '#{CATALOG_ATTRIBUTE_CODE}'
                     AND ((soav.catalog_attribute_value_code = '#{option}' and catalog_items.workflow = '#{WORKFLOW_DIRECT_DECAL_DIGITEK}')
                          or (soav.catalog_attribute_value_code = '#{option}' and catalog_items.workflow = '#{WORKFLOW_PAD}'))
                     AND so.trans_type in ('S','E') AND (soa.final_artwork_flag = 'Y') AND so.ordercancelstatus_flag = 'N'"

    spec_order_condition = "((so.paper_proof_flag = 'Y' AND so.artworkapprovedbycust_flag = 'A') or (so.paper_proof_flag = 'N'))
                     AND so.trans_flag = 'A' AND so.artworkreviewed_flag = 'Y'
                     AND (so.orderentrycomplete_flag = 'Y' AND (so.qc_off_flag = 'Y' or so.orderqcstatus_flag = 'Y'))
                     AND sol.blank_good_flag <> 'Y' AND sol.item_type = 'I' and sol.trans_flag = 'A' and sol.print_flag = 'N'
                     AND sol.film_flag = 'Y'
                     AND soav.trans_flag = 'A'
                     AND soav.catalog_attribute_code = '#{CATALOG_ATTRIBUTE_CODE}'
                     AND ((soav.catalog_attribute_value_code = '#{option}' and catalog_items.workflow = '#{WORKFLOW_DIRECT_DECAL_DIGITEK}')
                          or (soav.catalog_attribute_value_code = '#{option}' and catalog_items.workflow = '#{WORKFLOW_PAD}'))
                     AND so.trans_type in ('F') AND ((sales_order_shippings.pre_prod_flag='Y' and sales_order_shippings.shipping_flag='N') or (so.approve_spec_order_flag = 'Y' and sales_order_shippings.pre_prod_flag='N'))
                     AND (soa.final_artwork_flag = 'Y') AND so.ordercancelstatus_flag = 'N'"
    condition = convert_sql_to_db_specific(condition)
    Sales::SalesOrder.find_by_sql ["select CAST(( select (
                                  select * from (select distinct '' as vs, '' as user_name,soa.artwork_version,so.ext_ref_no,types.description as order_type,so.trans_type,so.trans_date,customers.name,customers.code as customer_code,
                                         so.multi_description,so.payment_status,so.rushorder_flag,so.order_flagged,so.artwork_status,so.order_status,so.trans_no,sol.serial_no,so.logo_name,sol.catalog_item_code,sol.id,
                                         soa.artwork_file_name,101  as shipping_serial_no,sol.indigo_code,sol.item_description,sol.reason,sol.item_qty,so.ship_date from sales_orders so
                                  inner join sales_order_lines sol on sol.sales_order_id = so.id
                                  inner join catalog_items on catalog_items.id = sol.catalog_item_id
                                  inner join customers on customers.id = so.customer_id
                                  inner join sales_order_attributes_values soav on soav.sales_order_id = so.id
                                  inner join users on users.id = so.updated_by
                                  inner join sales_order_artworks soa on soa.sales_order_id = so.id
                                  left outer join types on (
                                          types.type_cd = 'trans_type'
                                          and types.subtype_cd = 'so'
                                          and so.trans_type = types.value
                                          )
                                  where #{condition}
UNION
                                  select distinct '' as vs, '' as user_name,soa.artwork_version,so.ext_ref_no,types.description as order_type,so.trans_type,so.trans_date,customers.name,customers.code as customer_code,
                                         so.multi_description,so.payment_status,so.rushorder_flag,so.order_flagged,so.artwork_status,so.order_status,so.trans_no,sol.serial_no,so.logo_name,sol.catalog_item_code,sol.id,
                                         soa.artwork_file_name,sales_order_shippings.serial_no as shipping_serial_no,sol.indigo_code,sol.item_description,sol.reason,sales_order_shippings.ship_qty as item_qty,so.ship_date from sales_orders so
                                  inner join sales_order_lines sol on sol.sales_order_id = so.id
                                  inner join catalog_items on catalog_items.id = sol.catalog_item_id
                                  inner join customers on customers.id = so.customer_id
                                  inner join sales_order_attributes_values soav on soav.sales_order_id = so.id
                                  inner join users on users.id = so.updated_by
                                  inner join sales_order_artworks soa on soa.sales_order_id = so.id
                                  inner join sales_order_shippings ON sales_order_shippings.sales_order_id = so.id
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


  def self.production_inbox(doc)
    condition = "((so.paper_proof_flag = 'Y' AND so.artworkapprovedbycust_flag = 'A') or (so.paper_proof_flag = 'N'))
                     AND so.trans_flag = 'A' AND so.artworkreviewed_flag = 'Y'
                     AND (so.orderentrycomplete_flag = 'Y' AND (so.qc_off_flag = 'Y' or so.orderqcstatus_flag = 'Y'))
                     AND sol.blank_good_flag <> 'Y' AND sol.item_type = 'I' and sol.trans_flag = 'A' and sol.direct_production_flag = 'N'
                     AND ((
                     (sol.print_flag = 'Y' AND (soav.catalog_attribute_code = '#{CATALOG_ATTRIBUTE_CODE}' AND (soav.catalog_attribute_value_code = '#{ATTRIBUTE_VALUE_DIRECT}' or soav.catalog_attribute_value_code = '#{ATTRIBUTE_VALUE_DIGITEK}')))
                     OR (sol.print_flag = 'Y'  AND catalog_items.workflow = '#{WORKFLOW_PAD}' AND soav.catalog_attribute_value_code = '#{ATTRIBUTE_VALUE_PAD}')
                     OR (sol.stitch_flag = 'Y'  AND (soav.catalog_attribute_code = '#{CATALOG_ATTRIBUTE_CODE}' and soav.catalog_attribute_value_code = '#{ATTRIBUTE_VALUE_EMBROIDERY}' and catalog_items.workflow = '#{WORKFLOW_EMBROIDERY}'))
                     OR (sol.cut_flag = 'Y'  AND (soav.catalog_attribute_code = '#{CATALOG_ATTRIBUTE_CODE}' AND (soav.catalog_attribute_value_code = '#{ATTRIBUTE_VALUE_DOCUCOLOR}' or soav.catalog_attribute_value_code = '#{ATTRIBUTE_VALUE_DECAL}')))
                     ) or so.blank_order_flag = 'Y')
                    AND so.trans_type in ('S','E') AND (soa.final_artwork_flag = 'Y') AND so.ordercancelstatus_flag = 'N' and soav.trans_flag = 'A' and soa.trans_flag = 'A'"

    spec_order_condition = "((so.paper_proof_flag = 'Y' AND so.artworkapprovedbycust_flag = 'A') or (so.paper_proof_flag = 'N'))
                     AND so.trans_flag = 'A' AND so.artworkreviewed_flag = 'Y'
                     AND (so.orderentrycomplete_flag = 'Y' AND (so.qc_off_flag = 'Y' or so.orderqcstatus_flag = 'Y'))
                     AND sol.blank_good_flag <> 'Y' AND sol.item_type = 'I' and sol.trans_flag = 'A' and sol.direct_production_flag = 'N'
                     AND ((
                     (sol.print_flag = 'Y'  AND (soav.catalog_attribute_code = '#{CATALOG_ATTRIBUTE_CODE}' AND (soav.catalog_attribute_value_code = '#{ATTRIBUTE_VALUE_DIRECT}' or soav.catalog_attribute_value_code = '#{ATTRIBUTE_VALUE_DIGITEK}')))
                     OR (sol.print_flag = 'Y' AND catalog_items.workflow = '#{WORKFLOW_PAD}' AND soav.catalog_attribute_value_code = '#{ATTRIBUTE_VALUE_PAD}')
                     OR (sol.stitch_flag = 'Y'  AND (soav.catalog_attribute_code = '#{CATALOG_ATTRIBUTE_CODE}' and soav.catalog_attribute_value_code = '#{ATTRIBUTE_VALUE_EMBROIDERY}' and catalog_items.workflow = '#{WORKFLOW_EMBROIDERY}'))
                     OR (sol.cut_flag = 'Y' AND (soav.catalog_attribute_code = '#{CATALOG_ATTRIBUTE_CODE}' AND (soav.catalog_attribute_value_code = '#{ATTRIBUTE_VALUE_DOCUCOLOR}' or soav.catalog_attribute_value_code = '#{ATTRIBUTE_VALUE_DECAL}')))
                     ) or so.blank_order_flag = 'Y')
                     AND so.trans_type in ('F') AND ((sales_order_shippings.pre_prod_flag='Y' and sales_order_shippings.shipping_flag='N') or (so.approve_spec_order_flag = 'Y' and sales_order_shippings.pre_prod_flag='N'))
                     AND (soa.final_artwork_flag = 'Y') AND so.ordercancelstatus_flag = 'N' and soav.trans_flag = 'A' and soa.trans_flag = 'A'"
    condition = convert_sql_to_db_specific(condition)
    Sales::SalesOrder.find_by_sql ["select CAST(( select (
                                  select * from (select distinct '' as vs, '' as user_name,soa.artwork_version,so.ext_ref_no,types.description as order_type,so.trans_type,so.trans_date,customers.name,customers.code as customer_code,
                                         so.multi_description,so.payment_status,so.rushorder_flag,so.artwork_status,so.order_status,so.trans_no,sol.serial_no,so.logo_name,sol.catalog_item_code,sol.id,
                                         soa.artwork_file_name,101  as shipping_serial_no,sol.indigo_code,sol.item_description,sol.reason,sol.item_qty,so.ship_date,so.order_flagged,sol.direct_production_flag  from sales_orders so
                                  inner join sales_order_lines sol on sol.sales_order_id = so.id
                                  inner join catalog_items on catalog_items.id = sol.catalog_item_id
                                  inner join customers on customers.id = so.customer_id
                                  inner join sales_order_attributes_values soav on soav.sales_order_id = so.id
                                  inner join users on users.id = so.updated_by
                                  inner join sales_order_artworks soa on soa.sales_order_id = so.id
                                  left outer join types on (
                                          types.type_cd = 'trans_type'
                                          and types.subtype_cd = 'so'
                                          and so.trans_type = types.value
                                          )
                                  where #{condition}
UNION
                                  select distinct '' as vs, '' as user_name,soa.artwork_version,so.ext_ref_no,types.description as order_type,so.trans_type,so.trans_date,customers.name,customers.code as customer_code,
                                         so.multi_description,so.payment_status,so.rushorder_flag,so.artwork_status,so.order_status,so.trans_no,sol.serial_no,so.logo_name,sol.catalog_item_code,sol.id,
                                         soa.artwork_file_name,sales_order_shippings.serial_no as shipping_serial_no,sol.indigo_code,sol.item_description,sol.reason,sales_order_shippings.ship_qty as item_qty,
                                         so.ship_date,so.order_flagged,sol.direct_production_flag  from sales_orders so
                                  inner join sales_order_lines sol on sol.sales_order_id = so.id
                                  inner join catalog_items on catalog_items.id = sol.catalog_item_id
                                  inner join customers on customers.id = so.customer_id
                                  inner join sales_order_attributes_values soav on soav.sales_order_id = so.id
                                  inner join users on users.id = so.updated_by
                                  inner join sales_order_artworks soa on soa.sales_order_id = so.id
                                  inner join sales_order_shippings ON sales_order_shippings.sales_order_id = so.id
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

  def self.production_option_inbox(doc)
    option =  parse_xml(doc/'options') if (doc/'options').first
    condition = "((so.paper_proof_flag = 'Y' AND so.artworkapprovedbycust_flag = 'A') or (so.paper_proof_flag = 'N'))
                     AND so.trans_flag = 'A' AND so.artworkreviewed_flag = 'Y'
                     AND (so.orderentrycomplete_flag = 'Y' AND (so.qc_off_flag = 'Y' or so.orderqcstatus_flag = 'Y'))
                     AND sol.blank_good_flag <> 'Y' AND sol.item_type = 'I' and sol.trans_flag = 'A' and sol.direct_production_flag = 'N'
                     AND (
                     ((sol.cut_flag = 'Y' or so.blank_order_flag = 'Y')  AND catalog_items.workflow = '#{WORKFLOW_DOCUCOLOR}' AND (soav.catalog_attribute_code = '#{CATALOG_ATTRIBUTE_CODE}' AND soav.catalog_attribute_value_code = '#{option}'))
                     OR ((sol.cut_flag = 'Y' or so.blank_order_flag = 'Y')  AND (catalog_items.workflow = '#{WORKFLOW_DIRECT_DECAL_DIGITEK}' or catalog_items.workflow = '#{WORKFLOW_WATER}') AND (soav.catalog_attribute_code = '#{CATALOG_ATTRIBUTE_CODE}' AND soav.catalog_attribute_value_code = '#{option}'))
                     OR ((sol.print_flag = 'Y' or so.blank_order_flag = 'Y')  AND catalog_items.workflow = '#{WORKFLOW_DIRECT_DECAL_DIGITEK}' AND (soav.catalog_attribute_code = '#{CATALOG_ATTRIBUTE_CODE}' AND soav.catalog_attribute_value_code = '#{option}' and (soav.catalog_attribute_value_code in ('#{ATTRIBUTE_VALUE_DIRECT}','#{ATTRIBUTE_VALUE_DIGITEK}'))))
                     OR ((sol.print_flag = 'Y' or so.blank_order_flag = 'Y')  AND catalog_items.workflow = '#{WORKFLOW_PAD}' AND (soav.catalog_attribute_code = '#{CATALOG_ATTRIBUTE_CODE}' AND soav.catalog_attribute_value_code = '#{option}'))
                     OR ((sol.stitch_flag = 'Y' or so.blank_order_flag = 'Y')  AND catalog_items.workflow = '#{WORKFLOW_EMBROIDERY}' AND (soav.catalog_attribute_code = '#{CATALOG_ATTRIBUTE_CODE}' and soav.catalog_attribute_value_code = '#{option}'))
                     )
                    AND so.trans_type in ('S','E') AND (soa.final_artwork_flag = 'Y') AND so.ordercancelstatus_flag = 'N' and soav.trans_flag = 'A' and soa.trans_flag = 'A'"

    spec_order_condition = "((so.paper_proof_flag = 'Y' AND so.artworkapprovedbycust_flag = 'A') or (so.paper_proof_flag = 'N'))
                     AND so.trans_flag = 'A' AND so.artworkreviewed_flag = 'Y'
                     AND (so.orderentrycomplete_flag = 'Y' AND (so.qc_off_flag = 'Y' or so.orderqcstatus_flag = 'Y'))
                     AND sol.blank_good_flag <> 'Y' AND sol.item_type = 'I' and sol.trans_flag = 'A' and sol.direct_production_flag = 'N'
                     AND (
                     ((sol.cut_flag = 'Y' or so.blank_order_flag = 'Y')  AND catalog_items.workflow = '#{WORKFLOW_DOCUCOLOR}' AND (soav.catalog_attribute_code = '#{CATALOG_ATTRIBUTE_CODE}' AND soav.catalog_attribute_value_code = '#{option}'))
                     OR ((sol.cut_flag = 'Y' or so.blank_order_flag = 'Y')  AND (catalog_items.workflow = '#{WORKFLOW_DIRECT_DECAL_DIGITEK}' or catalog_items.workflow = '#{WORKFLOW_WATER}') AND (soav.catalog_attribute_code = '#{CATALOG_ATTRIBUTE_CODE}' AND soav.catalog_attribute_value_code = '#{option}'))
                     OR ((sol.print_flag = 'Y' or so.blank_order_flag = 'Y')  AND catalog_items.workflow = '#{WORKFLOW_DIRECT_DECAL_DIGITEK}' AND (soav.catalog_attribute_code = '#{CATALOG_ATTRIBUTE_CODE}' AND soav.catalog_attribute_value_code = '#{option}' and (soav.catalog_attribute_value_code in ('#{ATTRIBUTE_VALUE_DIRECT}','#{ATTRIBUTE_VALUE_DIGITEK}'))))
                     OR ((sol.print_flag = 'Y' or so.blank_order_flag = 'Y')  AND catalog_items.workflow = '#{WORKFLOW_PAD}' AND (soav.catalog_attribute_code = '#{CATALOG_ATTRIBUTE_CODE}' AND soav.catalog_attribute_value_code = '#{option}'))
                     OR ((sol.stitch_flag = 'Y' or so.blank_order_flag = 'Y')  AND catalog_items.workflow = '#{WORKFLOW_EMBROIDERY}' AND (soav.catalog_attribute_code = '#{CATALOG_ATTRIBUTE_CODE}' and soav.catalog_attribute_value_code = '#{option}'))
                     )
                     AND so.trans_type in ('F') AND ((sales_order_shippings.pre_prod_flag='Y' and sales_order_shippings.shipping_flag='N') or (so.approve_spec_order_flag = 'Y' and sales_order_shippings.pre_prod_flag='N'))
                     AND (soa.final_artwork_flag = 'Y') AND so.ordercancelstatus_flag = 'N' and soav.trans_flag = 'A' and soa.trans_flag = 'A'"
    condition = convert_sql_to_db_specific(condition)
    Sales::SalesOrder.find_by_sql ["select CAST(( select (
                                  select * from (select distinct '' as vs, '' as user_name,soa.artwork_version,so.ext_ref_no,types.description as order_type,so.trans_type,so.trans_date,customers.name,customers.code as customer_code,
                                         so.multi_description,so.payment_status,so.rushorder_flag,so.artwork_status,so.order_status,so.trans_no,sol.serial_no,so.logo_name,sol.catalog_item_code,sol.id,
                                         soa.artwork_file_name,101  as shipping_serial_no,sol.indigo_code,sol.item_description,sol.reason,sol.item_qty,so.ship_date,so.order_flagged,sol.direct_production_flag  from sales_orders so
                                  inner join sales_order_lines sol on sol.sales_order_id = so.id
                                  inner join catalog_items on catalog_items.id = sol.catalog_item_id
                                  inner join customers on customers.id = so.customer_id
                                  inner join sales_order_attributes_values soav on soav.sales_order_id = so.id
                                  inner join users on users.id = so.updated_by
                                  inner join sales_order_artworks soa on soa.sales_order_id = so.id
                                  left outer join types on (
                                          types.type_cd = 'trans_type'
                                          and types.subtype_cd = 'so'
                                          and so.trans_type = types.value
                                          )
                                  where #{condition}
UNION
                                  select distinct '' as vs, '' as user_name,soa.artwork_version,so.ext_ref_no,types.description as order_type,so.trans_type,so.trans_date,customers.name,customers.code as customer_code,
                                         so.multi_description,so.payment_status,so.rushorder_flag,so.artwork_status,so.order_status,so.trans_no,sol.serial_no,so.logo_name,sol.catalog_item_code,sol.id,
                                         soa.artwork_file_name,sales_order_shippings.serial_no as shipping_serial_no,sol.indigo_code,sol.item_description,sol.reason,sales_order_shippings.ship_qty as item_qty,
                                         so.ship_date,so.order_flagged,sol.direct_production_flag  from sales_orders so
                                  inner join sales_order_lines sol on sol.sales_order_id = so.id
                                  inner join catalog_items on catalog_items.id = sol.catalog_item_id
                                  inner join customers on customers.id = so.customer_id
                                  inner join sales_order_attributes_values soav on soav.sales_order_id = so.id
                                  inner join users on users.id = so.updated_by
                                  inner join sales_order_artworks soa on soa.sales_order_id = so.id
                                  inner join sales_order_shippings ON sales_order_shippings.sales_order_id = so.id
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

  def self.create_direct_production_inbox(doc)
    message = ""
    text = ""
    (doc/:sales_orders/:sales_order).each{|order_doc|
      message,text = create_direct_production(order_doc)
      break if text == 'error'
    }
    return message,text
  end
  def self.create_direct_production(order_doc)
    begin
      id =  parse_xml(order_doc/'id') if (order_doc/'id').first
      trans_no =  parse_xml(order_doc/'trans_no') if (order_doc/'trans_no').first
      order = Sales::SalesOrder.find_by_trans_no(trans_no)
      sales_order_line = Sales::SalesOrderLine.find_by_id(id)
      if !sales_order_line
        return 'Order Line Does Not Exists.','error'
      end
      if order.accountreviewed_flag != 'Y' and order.sub_ref_type != 'S'
        result = Accounting::AccountingCrud.check_accounting(order)
        return result,'error' if result != 'success'
      end
      if sales_order_line.direct_production_flag != 'Y'
        order.order_status = PRODUCTION_DONE
        sales_order_line.direct_production_flag = 'Y'
        activity_message = Artwork::ArtworkCrud.create_activity_message(order,'PRODUCTION DONE')
        order.create_sales_order_transaction_activity(activity_message)
      end
      workflow_location = Sales::CurrentLocationLogic.find_order_location(order,order.order_status,order.artwork_status)
      order.workflow_location = workflow_location
      order.update_flag = 'V' if order.sub_ref_type == 'S'
      save_proc = Proc.new{
        order.save!
        sales_order_line.save!
      }
      if order.errors.empty?
        order.save_transaction(&save_proc)
        return 'Direct Production Done Successfully','success'
      else
        return 'Some error occured while saving order.','error'
      end
    rescue Exception => ex
      return ex,'error'
    end
  end

  ##### NOT IN USE ###
  def self.direct_print_inbox(doc)  ## not in use
    criteria = Setup::Criteria.fill_criteria_for_query(doc/:criteria)
    condition = "(so.company_id = #{criteria.company_id}) AND
                     (customers.code between '#{criteria.str1}' and '#{criteria.str2}' AND (0 =#{criteria.multiselect1.length} or customers.code in ('#{criteria.multiselect1}'))) AND
                     (so.trans_no between '#{criteria.str3}' and '#{criteria.str4}' AND (0 =#{criteria.multiselect2.length} or so.trans_no in ('#{criteria.multiselect2}'))) AND
                     (so.trans_date between '#{criteria.dt1}' and '#{criteria.dt2}' ) AND
                     (so.account_period_code between '#{criteria.str5[0,8]}' and '#{criteria.str6[0,8]}' AND (0 =#{criteria.multiselect3.length} or so.account_period_code in ('#{criteria.multiselect3}')))
                     AND (so.logo_name between '#{criteria.str7}' and '#{criteria.str8}' AND (0 =#{criteria.multiselect4.length} or so.logo_name in ('#{criteria.multiselect4}')))
                     AND (so.ext_ref_no between '#{criteria.str9}' and '#{criteria.str10}' AND (0 =#{criteria.multiselect5.length} or so.ext_ref_no in ('#{criteria.multiselect5}')))
                     AND ((so.paper_proof_flag = 'Y' AND so.artworkapprovedbycust_flag = 'A') or (so.paper_proof_flag = 'N'))
                     AND so.trans_flag = 'A' AND so.artworkreviewed_flag = 'Y'
                     AND (so.orderentrycomplete_flag = 'Y' AND (so.qc_off_flag = 'Y' or so.orderqcstatus_flag = 'Y'))
                     AND sol.blank_good_flag <> 'Y' AND sol.item_type = 'I' and sol.trans_flag = 'A' and sol.print_flag = 'N'
                     AND sol.film_flag = 'Y' AND soav.trans_flag = 'A'
                     AND (soav.catalog_attribute_code = '#{CATALOG_ATTRIBUTE_CODE}' and soav.catalog_attribute_value_code = '#{ATTRIBUTE_VALUE_DIRECT}' and catalog_items.workflow = '#{WORKFLOW_DIRECT_DECAL_DIGITEK}')
                     AND so.trans_type in ('S','E') AND (soa.final_artwork_flag = 'Y') AND so.ordercancelstatus_flag = 'N'"

    spec_order_condition = "(so.company_id = #{criteria.company_id}) AND
                     (customers.code between '#{criteria.str1}' and '#{criteria.str2}' AND (0 =#{criteria.multiselect1.length} or customers.code in ('#{criteria.multiselect1}'))) AND
                     (so.trans_no between '#{criteria.str3}' and '#{criteria.str4}' AND (0 =#{criteria.multiselect2.length} or so.trans_no in ('#{criteria.multiselect2}'))) AND
                     (so.trans_date between '#{criteria.dt1}' and '#{criteria.dt2}' ) AND
                     (so.account_period_code between '#{criteria.str5[0,8]}' and '#{criteria.str6[0,8]}' AND (0 =#{criteria.multiselect3.length} or so.account_period_code in ('#{criteria.multiselect3}')))
                     AND (so.logo_name between '#{criteria.str7}' and '#{criteria.str8}' AND (0 =#{criteria.multiselect4.length} or so.logo_name in ('#{criteria.multiselect4}')))
                     AND (so.ext_ref_no between '#{criteria.str9}' and '#{criteria.str10}' AND (0 =#{criteria.multiselect5.length} or so.ext_ref_no in ('#{criteria.multiselect5}')))
                     AND ((so.paper_proof_flag = 'Y' AND so.artworkapprovedbycust_flag = 'A') or (so.paper_proof_flag = 'N'))
                     AND so.trans_flag = 'A' AND so.artworkreviewed_flag = 'Y'
                     AND (so.orderentrycomplete_flag = 'Y' AND (so.qc_off_flag = 'Y' or so.orderqcstatus_flag = 'Y'))
                     AND sol.blank_good_flag <> 'Y' AND sol.item_type = 'I' and sol.trans_flag = 'A' and sol.print_flag = 'N'
                     AND sol.film_flag = 'Y' AND soav.trans_flag = 'A'
                     AND (soav.catalog_attribute_code = '#{CATALOG_ATTRIBUTE_CODE}' and soav.catalog_attribute_value_code = '#{ATTRIBUTE_VALUE_DIRECT}' and catalog_items.workflow = '#{WORKFLOW_DIRECT_DECAL_DIGITEK}')
                     AND so.trans_type in ('F') AND ((sales_order_shippings.pre_prod_flag='Y' and sales_order_shippings.shipping_flag='N') or (so.approve_spec_order_flag = 'Y' and sales_order_shippings.pre_prod_flag='N'))
                     AND (soa.final_artwork_flag = 'Y') AND so.ordercancelstatus_flag = 'N'"
    condition = convert_sql_to_db_specific(condition)
    Sales::SalesOrder.find_by_sql ["select CAST(( select (
                                  select * from (select distinct '' as vs, '' as user_name,soa.artwork_version,so.ext_ref_no,types.description as order_type,so.trans_type,so.trans_date,customers.name,customers.code as customer_code,
                                         so.payment_status,so.rushorder_flag,so.artwork_status,so.order_status,so.trans_no,sol.serial_no,so.logo_name,sol.catalog_item_code,sol.id,
                                         soa.artwork_file_name,101  as shipping_serial_no,sol.indigo_code,sol.item_description,sol.reason,sol.item_qty,so.ship_date,so.order_flagged  from sales_orders so
                                  inner join sales_order_lines sol on sol.sales_order_id = so.id
                                  inner join catalog_items on catalog_items.id = sol.catalog_item_id
                                  inner join customers on customers.id = so.customer_id
                                  inner join sales_order_attributes_values soav on soav.sales_order_id = so.id
                                  inner join users on users.id = so.updated_by
                                  inner join sales_order_artworks soa on soa.sales_order_id = so.id
                                  left outer join types on (
                                          types.type_cd = 'trans_type'
                                          and types.subtype_cd = 'so'
                                          and so.trans_type = types.value
                                          )
                                  where #{condition}
UNION
                                  select distinct '' as vs, '' as user_name,soa.artwork_version,so.ext_ref_no,types.description as order_type,so.trans_type,so.trans_date,customers.name,customers.code as customer_code,
                                         so.payment_status,so.rushorder_flag,so.artwork_status,so.order_status,so.trans_no,sol.serial_no,so.logo_name,sol.catalog_item_code,sol.id,
                                         soa.artwork_file_name,sales_order_shippings.serial_no as shipping_serial_no,sol.indigo_code,sol.item_description,sol.reason,sales_order_shippings.ship_qty as item_qty,so.ship_date,so.order_flagged  from sales_orders so
                                  inner join sales_order_lines sol on sol.sales_order_id = so.id
                                  inner join catalog_items on catalog_items.id = sol.catalog_item_id
                                  inner join customers on customers.id = so.customer_id
                                  inner join sales_order_attributes_values soav on soav.sales_order_id = so.id
                                  inner join users on users.id = so.updated_by
                                  inner join sales_order_artworks soa on soa.sales_order_id = so.id
                                  inner join sales_order_shippings ON sales_order_shippings.sales_order_id = so.id
                                  left outer join types on (
                                          types.type_cd = 'trans_type'
                                          and types.subtype_cd = 'so'
                                          and so.trans_type = types.value
                                          )
                                  where #{spec_order_condition}) as result order by result.ship_date
                                  FOR XML PATH('sales_order'), TYPE,ELEMENTS XSINIL
                                  )FOR XML PATH('sales_orders')) AS varchar(MAX)) as xmlcol"
    ]
  end
end
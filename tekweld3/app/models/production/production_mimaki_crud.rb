class Production::ProductionMimakiCrud
  include General
  @config = YAML::load(File.open("#{Rails.root}/config/production_settings.yml"))
  #  Trans Type Codes
  #  S	Regular Order
  #  E	Re-Order
  #  P	Sample Order
  #  V	Virtual Order
  #  F	Spec Order

  def self.mimaki_print_inbox(doc)
    condition = "((so.paper_proof_flag = 'Y' AND so.artworkapprovedbycust_flag = 'A') or (so.paper_proof_flag = 'N'))
                     AND so.trans_flag = 'A' AND so.artworkreviewed_flag = 'Y' and soav.trans_flag = 'A' and soa.trans_flag = 'A'
                     AND (so.orderentrycomplete_flag = 'Y' AND (so.qc_off_flag = 'Y' or so.orderqcstatus_flag = 'Y'))
                     AND sol.blank_good_flag <> 'Y' AND so.blank_order_flag <> 'Y' AND sol.item_type = 'I' and sol.trans_flag = 'A' and sol.print_flag = 'N'

                     AND (soav.catalog_attribute_code = '#{CATALOG_ATTRIBUTE_CODE}' and soav.catalog_attribute_value_code = '#{ATTRIBUTE_VALUE_DIGITEK}' and catalog_items.workflow = '#{WORKFLOW_DIRECT_DECAL_DIGITEK}')
                     AND so.trans_type in ('S','E') AND (soa.final_artwork_flag = 'Y') AND so.ordercancelstatus_flag = 'N'"
    spec_order_condition = "((so.paper_proof_flag = 'Y' AND so.artworkapprovedbycust_flag = 'A') or (so.paper_proof_flag = 'N'))
                     AND so.trans_flag = 'A' AND so.artworkreviewed_flag = 'Y' and soav.trans_flag = 'A' and soa.trans_flag = 'A'
                     AND (so.orderentrycomplete_flag = 'Y' AND (so.qc_off_flag = 'Y' or so.orderqcstatus_flag = 'Y'))
                     AND sol.blank_good_flag <> 'Y' AND so.blank_order_flag <> 'Y' AND sol.item_type = 'I' and sol.trans_flag = 'A' and sol.print_flag = 'N'
                   
                     AND (soav.catalog_attribute_code = '#{CATALOG_ATTRIBUTE_CODE}' and soav.catalog_attribute_value_code = '#{ATTRIBUTE_VALUE_DIGITEK}' and catalog_items.workflow = '#{WORKFLOW_DIRECT_DECAL_DIGITEK}')
                     AND so.trans_type in ('F') AND (soa.final_artwork_flag = 'Y') AND so.ordercancelstatus_flag = 'N'
                     AND ((sales_order_shippings.pre_prod_flag='Y' and sales_order_shippings.shipping_flag='N') or (so.approve_spec_order_flag = 'Y' and sales_order_shippings.pre_prod_flag='N'))
    "
    condition = convert_sql_to_db_specific(condition)
    Sales::SalesOrder.find_by_sql ["select CAST(( select (
                                  select * from (select distinct soav.remarks,soa.artwork_version,so.ext_ref_no,types.description as order_type,so.trans_type,
                                         so.trans_date,customers.name,customers.code as customer_code,
                                         so.multi_description,so.payment_status,so.rushorder_flag,so.artwork_status,so.order_status,so.trans_no,sol.serial_no,so.logo_name,sol.catalog_item_code,sol.id,
                                         101  as shipping_serial_no,sol.reason,sol.indigo_code,sol.item_description,sol.item_qty,so.ship_date,so.order_flagged from sales_orders so
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
                                  select distinct soav.remarks,soa.artwork_version,so.ext_ref_no,types.description as order_type,so.trans_type,
                                         so.trans_date,customers.name,customers.code as customer_code,
                                         so.multi_description,so.payment_status,so.rushorder_flag,so.artwork_status,so.order_status,so.trans_no,sol.serial_no,so.logo_name,sol.catalog_item_code,sol.id,
                                         sales_order_shippings.serial_no as shipping_serial_no,sol.reason,sol.indigo_code,sol.item_description,sales_order_shippings.ship_qty as item_qty,so.ship_date,so.order_flagged from sales_orders so
                                  inner join sales_order_lines sol on sol.sales_order_id = so.id
                                  inner join catalog_items on catalog_items.id = sol.catalog_item_id
                                  inner join customers on customers.id = so.customer_id
                                  inner join sales_order_attributes_values soav on soav.sales_order_id = so.id
                                  inner join users on users.id = so.updated_by
                                  inner join sales_order_shippings ON sales_order_shippings.sales_order_id = so.id
                                  inner join sales_order_artworks soa on soa.sales_order_id = so.id
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


  def self.create_mimaki_print_inboxes(doc)
    sales_orders = []
    (doc/:sales_orders/:sales_order).each{|order_doc|
      sales_order = create_mimaki_print_inbox(order_doc)
      sales_orders <<  sales_order if sales_order
    }
    sales_orders
  end
  def self.create_mimaki_print_inbox(order_doc)
    id =  parse_xml(order_doc/'id') if (order_doc/'id').first
    trans_no =  parse_xml(order_doc/'trans_no') if (order_doc/'trans_no').first
    #    reject_yn =  parse_xml(order_doc/'reject_yn') if (order_doc/'reject_yn').first
    #    reason =  parse_xml(order_doc/'reason') if (order_doc/'reason').first
    order= Sales::SalesOrder.find_by_trans_no(trans_no)
    #    indigo_code =  parse_xml(order_doc/'indigo_code') if (order_doc/'indigo_code').first
    sales_order_line = Sales::SalesOrderLine.find_by_id(id)
    return  if !sales_order_line
    #    if reject_yn != 'Y'
    #      order.update_attributes!(:order_status => 'PRINT COMPLETE')
    #      sales_order_line.update_attributes!(:print_flag => 'Y',:print_date => Time.now,:indigo_code => indigo_code,:reason => reason)
    #      activity = order.create_sales_order_transaction_activity('PRINT COMPLETE')
    #      activity.save!
    #    else
    order.update_attributes!(:order_status => PRINT_COMPLETE)
    sales_order_line.update_attributes!(:print_flag => 'Y',:print_date => Time.now)
    activity = order.create_sales_order_transaction_activity('PRINT COMPLETE')
    activity.save!
    workflow_location = Sales::CurrentLocationLogic.find_order_status(order.trans_no)
    order.update_attributes!(:workflow_location => workflow_location)
    #    end
  end
end
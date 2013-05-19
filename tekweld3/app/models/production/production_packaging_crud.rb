class Production::ProductionPackagingCrud
  include General
  @config = YAML::load(File.open("#{Rails.root}/config/production_settings.yml"))
  #  Trans Type Codes
  #  S	Regular Order
  #  E	Re-Order
  #  P	Sample Order
  #  V	Virtual Order
  #  F	Spec Order
  def self.packaging_inbox(doc)
    criteria = Setup::Criteria.fill_criteria_for_query(doc/:criteria)
    user = Admin::User.find_by_id(criteria.user_id)
    if user and user.login_type == 'V'
      ship_to_vendor_join = "inner join users on users.type_id = sos.vendor_id"
      ship_to_vendor_condition = "AND catalog_items.workflow = '#{WORKFLOW_WATER}' AND (sos.ship_to_vendor_flag = 'Y' and sos.po_confirmation_flag = 'Y' and sos.label_received_flag = 'Y') AND sos.vendor_id = #{user.type_id}"
    else
      ship_to_vendor_condition = "AND catalog_items.workflow <> '#{WORKFLOW_WATER}'"
    end
    condition = "((so.paper_proof_flag = 'Y' AND so.artworkapprovedbycust_flag = 'A') or (so.paper_proof_flag = 'N'))
                     AND so.trans_flag = 'A' AND so.artworkreviewed_flag = 'Y' AND so.ordercancelstatus_flag <> 'Y' and so.sub_ref_type <> 'S'
                     AND sol.blank_good_flag <> 'Y' AND so.hold_order_flag <> 'Y' AND sol.item_type = 'I' and sol.trans_flag = 'A'
                     AND so.trans_type in ('S','E') AND (soa.final_artwork_flag = 'Y')
                     AND (so.orderentrycomplete_flag = 'Y' AND (so.qc_off_flag = 'Y' or so.orderqcstatus_flag = 'Y'))
                     AND sol.direct_production_flag = 'Y'
                     AND ((
                     (soav.catalog_attribute_code = '#{CATALOG_ATTRIBUTE_CODE}' AND (soav.catalog_attribute_value_code = '#{ATTRIBUTE_VALUE_PAD}' or soav.catalog_attribute_value_code = '#{ATTRIBUTE_VALUE_DIRECT}' or soav.catalog_attribute_value_code = '#{ATTRIBUTE_VALUE_DIGITEK}'))
                     OR (soav.catalog_attribute_code = '#{CATALOG_ATTRIBUTE_CODE}' and soav.catalog_attribute_value_code = '#{ATTRIBUTE_VALUE_EMBROIDERY}' and catalog_items.workflow = '#{WORKFLOW_EMBROIDERY}')
                     OR (soav.catalog_attribute_code = '#{CATALOG_ATTRIBUTE_CODE}' AND (soav.catalog_attribute_value_code = '#{ATTRIBUTE_VALUE_DOCUCOLOR}' or soav.catalog_attribute_value_code = '#{ATTRIBUTE_VALUE_DECAL}' #{ship_to_vendor_condition}))
                     ) OR so.blank_order_flag = 'Y')
                     AND sos.packaging_flag = 'N' AND sos.trans_flag = 'A' AND so.ordercancelstatus_flag = 'N' AND soav.trans_flag = 'A'"
    spec_order_condition = "((so.paper_proof_flag = 'Y' AND so.artworkapprovedbycust_flag = 'A') or (so.paper_proof_flag = 'N'))
                     AND so.trans_flag = 'A' AND so.artworkreviewed_flag = 'Y' AND so.ordercancelstatus_flag <> 'Y' and so.sub_ref_type <> 'S'
                     AND sol.blank_good_flag <> 'Y' AND so.hold_order_flag <> 'Y' AND sol.item_type = 'I' and sol.trans_flag = 'A'
                     AND so.trans_type = 'F' AND (soa.final_artwork_flag = 'Y')
                     AND (so.orderentrycomplete_flag = 'Y' AND (so.qc_off_flag = 'Y' or so.orderqcstatus_flag = 'Y'))
                     AND sol.direct_production_flag = 'Y'
                     AND ((
                     (soav.catalog_attribute_code = '#{CATALOG_ATTRIBUTE_CODE}' AND (soav.catalog_attribute_value_code = '#{ATTRIBUTE_VALUE_PAD}' or soav.catalog_attribute_value_code = '#{ATTRIBUTE_VALUE_DIRECT}' or soav.catalog_attribute_value_code = '#{ATTRIBUTE_VALUE_DIGITEK}'))
                     OR (soav.catalog_attribute_code = '#{CATALOG_ATTRIBUTE_CODE}' and soav.catalog_attribute_value_code = '#{ATTRIBUTE_VALUE_EMBROIDERY}' and catalog_items.workflow = '#{WORKFLOW_EMBROIDERY}')
                     OR (soav.catalog_attribute_code = '#{CATALOG_ATTRIBUTE_CODE}' AND (soav.catalog_attribute_value_code = '#{ATTRIBUTE_VALUE_DOCUCOLOR}' or soav.catalog_attribute_value_code = '#{ATTRIBUTE_VALUE_DECAL}' #{ship_to_vendor_condition}))
                     ) OR so.blank_order_flag = 'Y')
                     AND sos.packaging_flag = 'N' AND sos.trans_flag = 'A' AND so.ordercancelstatus_flag = 'N' AND soav.trans_flag = 'A'
                     AND ((sos.pre_prod_flag='Y' and sos.shipping_flag='N') or (so.approve_spec_order_flag = 'Y' and sos.pre_prod_flag='N'))"
    condition = convert_sql_to_db_specific(condition)
    Sales::SalesOrder.find_by_sql ["select CAST((
                                  select( 
                                  select * from (select distinct '' as vs, '' as user_name,soa.artwork_version,so.ext_ref_no,types.description as order_type,so.trans_type,so.trans_date,customers.name,customers.code as customer_code,
                                         so.multi_description,so.payment_status,so.rushorder_flag,so.artwork_status,so.order_status,so.trans_no,sol.serial_no,so.logo_name,sol.catalog_item_code,sos.id,
                                         catalog_items.workflow,sol.indigo_code,sol.item_description,sol.item_qty,sos.internal_ship_date as ship_date,sos.internal_ship_date,sos.ship_name,sos.ship_address1,sos.ship_address2,
                                  sos.ship_city,sos.ship_state,sos.ship_zip,sos.ship_country,sos.ship_phone,sos.ship_fax,sos.ship_qty,sos.ship_method,sos.shipping_code,sos.estimated_ship_date,so.order_flagged
                                  from sales_orders so
                                  inner join sales_order_lines sol on sol.sales_order_id = so.id
                                  inner join catalog_items on catalog_items.id = sol.catalog_item_id
                                  inner join customers on customers.id = so.customer_id
                                  inner join sales_order_artworks soa on soa.sales_order_id = so.id
                                  inner join sales_order_shippings sos on sos.sales_order_id = so.id
                                  inner join sales_order_attributes_values soav on soav.sales_order_id = so.id
                                  #{ship_to_vendor_join}
                                  left outer join types on (
                                          types.type_cd = 'trans_type'
                                          and types.subtype_cd = 'so'
                                          and so.trans_type = types.value
                                          )
                                  where #{condition}
UNION
                                  select distinct '' as vs, '' as user_name,soa.artwork_version,so.ext_ref_no,types.description as order_type,so.trans_type,so.trans_date,customers.name,customers.code as customer_code,
                                         so.multi_description,so.payment_status,so.rushorder_flag,so.artwork_status,so.order_status,so.trans_no,sol.serial_no,so.logo_name,sol.catalog_item_code,sos.id,
                                         catalog_items.workflow,sol.indigo_code,sol.item_description,sol.item_qty,sos.internal_ship_date as ship_date,sos.internal_ship_date,sos.ship_name,sos.ship_address1,sos.ship_address2,
                                  sos.ship_city,sos.ship_state,sos.ship_zip,sos.ship_country,sos.ship_phone,sos.ship_fax,sos.ship_qty,sos.ship_method,sos.shipping_code,sos.estimated_ship_date,so.order_flagged
                                  from sales_orders so
                                  inner join sales_order_lines sol on sol.sales_order_id = so.id
                                  inner join catalog_items on catalog_items.id = sol.catalog_item_id
                                  inner join customers on customers.id = so.customer_id
                                  inner join sales_order_artworks soa on soa.sales_order_id = so.id
                                  inner join sales_order_shippings sos on sos.sales_order_id = so.id
                                  inner join sales_order_attributes_values soav on soav.sales_order_id = so.id
                                  #{ship_to_vendor_join}
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

  def self.create_packaging_inboxes(doc)
    message = ""
    text = ""
    (doc/:sales_orders/:sales_order).each{|order_doc|
      message,text = create_packaging_inbox(order_doc)
      break if text == 'error'
    }
    return message,text
  end
  
  def self.create_packaging_inbox(order_doc)
    begin
      id =  parse_xml(order_doc/'id') if (order_doc/'id').first
      trans_no =  parse_xml(order_doc/'trans_no') if (order_doc/'trans_no').first
      order = Sales::SalesOrder.find_by_trans_no(trans_no)
      sales_order_shipping = Sales::SalesOrderShipping.find_by_id(id)
      return  if !sales_order_shipping
      sales_order_shipping.update_attributes!(:packaging_flag => 'Y',:packaging_date => Time.now)
      shippings = Sales::SalesOrderShipping.find_all_by_sales_order_id_and_trans_flag_and_packaging_flag(order.id,'A','N')
      if shippings[0]
        order.update_attributes!(:order_status => PARTIAL_PACKAGING)
      else
        order.update_attributes!(:order_status => PACKAGING_COMPLETED)
      end
      activity_message = Artwork::ArtworkCrud.create_activity_message(order,"PACKAGING OF QTY: #{sales_order_shipping.ship_qty} DONE")
      activity = order.create_sales_order_transaction_activity(activity_message)
      activity.save!
      workflow_location = Sales::CurrentLocationLogic.find_order_status(order.trans_no)
      order.update_attributes!(:workflow_location => workflow_location)
      return 'Order Packaged Successfully','success'
    rescue Exception => ex
      return ex,'error'
    end
  end

  def self.vendor_inbox(doc)
    user_id = parse_xml(doc/:criteria/'user_id')
    user = Admin::User.find_by_id(user_id)
    if user and user.login_type == 'V'
      ship_to_vendor_join = "inner join users on users.type_id = sos.vendor_id"
      ship_to_vendor_condition = "catalog_items.workflow = '#{WORKFLOW_WATER}' AND (sos.ship_to_vendor_flag = 'Y') AND sos.vendor_id = #{user.type_id}"
    else
      ship_to_vendor_condition = "catalog_items.workflow <> '#{WORKFLOW_WATER}'"
    end
    condition = "((so.paper_proof_flag = 'Y' AND so.artworkapprovedbycust_flag = 'A') or (so.paper_proof_flag = 'N'))
                     AND so.trans_flag = 'A' AND so.artworkreviewed_flag = 'Y' AND so.ordercancelstatus_flag <> 'Y' and so.sub_ref_type <> 'S'
                     AND sol.blank_good_flag <> 'Y' AND so.hold_order_flag <> 'Y' AND sol.item_type = 'I' and sol.trans_flag = 'A'
                     AND so.trans_type in ('S','E') AND (soa.final_artwork_flag = 'Y')
                     AND (so.orderentrycomplete_flag = 'Y' AND (so.qc_off_flag = 'Y' or so.orderqcstatus_flag = 'Y'))
                     AND sol.direct_production_flag = 'Y'
                     AND #{ship_to_vendor_condition}
                     AND sos.packaging_flag = 'N' AND sos.trans_flag = 'A' AND so.ordercancelstatus_flag = 'N'
                     AND soav.trans_flag = 'A' and sos.ship_to_vendor_flag = 'Y' and (sos.po_confirmation_flag <> 'Y' or sos.label_received_flag <> 'Y')"
    spec_order_condition = "((so.paper_proof_flag = 'Y' AND so.artworkapprovedbycust_flag = 'A') or (so.paper_proof_flag = 'N'))
                     AND so.trans_flag = 'A' AND so.artworkreviewed_flag = 'Y' AND so.ordercancelstatus_flag <> 'Y' and so.sub_ref_type <> 'S'
                     AND sol.blank_good_flag <> 'Y' AND so.hold_order_flag <> 'Y' AND sol.item_type = 'I' and sol.trans_flag = 'A'
                     AND so.trans_type = 'F' AND (soa.final_artwork_flag = 'Y')
                     AND (so.orderentrycomplete_flag = 'Y' AND (so.qc_off_flag = 'Y' or so.orderqcstatus_flag = 'Y'))
                     AND sol.direct_production_flag = 'Y'
                     AND #{ship_to_vendor_condition}
                     AND sos.packaging_flag = 'N' AND sos.trans_flag = 'A' AND so.ordercancelstatus_flag = 'N' AND soav.trans_flag = 'A'
                     AND ((sos.pre_prod_flag='Y' and sos.shipping_flag='N') or (so.approve_spec_order_flag = 'Y' and sos.pre_prod_flag='N'))
                     AND (sos.po_confirmation_flag <> 'Y' or sos.label_received_flag <> 'Y')"
    condition = convert_sql_to_db_specific(condition)
    Sales::SalesOrder.find_by_sql ["select CAST((
                                  select(
                                  select * from (select distinct po.trans_no as ref_po_no,soa.artwork_version,so.ext_ref_no,types.description as order_type,so.trans_type,so.trans_date,customers.name,customers.code as customer_code,
                                         so.payment_status,so.rushorder_flag,so.artwork_status,so.order_status,so.trans_no,sol.serial_no,so.logo_name,sol.catalog_item_code,sos.id,
                                         catalog_items.workflow,sol.indigo_code,sol.item_description,sol.item_qty,sos.internal_ship_date as ship_date,sos.internal_ship_date,sos.ship_name,sos.ship_address1,sos.ship_address2,sos.po_confirmation_flag,sos.label_received_flag,
                                  sos.ship_city,sos.ship_state,sos.ship_zip,sos.ship_country,sos.ship_phone,sos.ship_fax,sos.ship_qty,sos.ship_method,sos.shipping_code,sos.estimated_ship_date,so.order_flagged
                                  from sales_orders so
                                  inner join sales_order_lines sol on sol.sales_order_id = so.id
                                  inner join catalog_items on catalog_items.id = sol.catalog_item_id
                                  inner join customers on customers.id = so.customer_id
                                  inner join sales_order_artworks soa on soa.sales_order_id = so.id
                                  inner join sales_order_shippings sos on sos.sales_order_id = so.id
                                  inner join sales_order_attributes_values soav on soav.sales_order_id = so.id
                                  left outer join purchase_orders po on po.ref_trans_no = so.trans_no
                                  #{ship_to_vendor_join}
                                  left outer join types on (
                                          types.type_cd = 'trans_type'
                                          and types.subtype_cd = 'so'
                                          and so.trans_type = types.value
                                          )
                                  where #{condition}
UNION
                                  select distinct po.trans_no as ref_po_no,soa.artwork_version,so.ext_ref_no,types.description as order_type,so.trans_type,so.trans_date,customers.name,customers.code as customer_code,
                                         so.payment_status,so.rushorder_flag,so.artwork_status,so.order_status,so.trans_no,sol.serial_no,so.logo_name,sol.catalog_item_code,sos.id,
                                         catalog_items.workflow,sol.indigo_code,sol.item_description,sol.item_qty,sos.internal_ship_date as ship_date,sos.internal_ship_date,sos.ship_name,sos.ship_address1,sos.ship_address2,sos.po_confirmation_flag,sos.label_received_flag,
                                  sos.ship_city,sos.ship_state,sos.ship_zip,sos.ship_country,sos.ship_phone,sos.ship_fax,sos.ship_qty,sos.ship_method,sos.shipping_code,sos.estimated_ship_date,so.order_flagged
                                  from sales_orders so
                                  inner join sales_order_lines sol on sol.sales_order_id = so.id
                                  inner join catalog_items on catalog_items.id = sol.catalog_item_id
                                  inner join customers on customers.id = so.customer_id
                                  inner join sales_order_artworks soa on soa.sales_order_id = so.id
                                  inner join sales_order_shippings sos on sos.sales_order_id = so.id
                                  inner join sales_order_attributes_values soav on soav.sales_order_id = so.id
                                  left outer join purchase_orders po on po.ref_trans_no = so.trans_no
                                  #{ship_to_vendor_join}
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

  def self.create_vendor_inboxes (doc)
    message = ""
    text = ""
    (doc/:sales_orders/:sales_order).each{|order_doc|
      message = create_vendor_inbox(order_doc)
      break if message != 'success'
    }
    return message
  end


  def  self.create_vendor_inbox(order_doc)
    begin
      shipping_id =  parse_xml(order_doc/'id') if (order_doc/'id').first
      po_confirmation_flag = parse_xml(order_doc/'po_confirmation_flag ')
      label_received_flag = parse_xml(order_doc/'label_received_flag')
      sales_order_shipping = Sales::SalesOrderShipping.find_by_id(shipping_id)
      order = Sales::SalesOrder.find_by_id(sales_order_shipping.sales_order_id)
      return  if !sales_order_shipping
      po_confirmation_flag_old=sales_order_shipping.po_confirmation_flag
      label_received_flag_old= sales_order_shipping.label_received_flag
      if (po_confirmation_flag != po_confirmation_flag_old || label_received_flag != label_received_flag_old )
        activity = status_change(po_confirmation_flag,label_received_flag, po_confirmation_flag_old,label_received_flag_old, order)
      end
      sales_order_shipping.po_confirmation_flag = po_confirmation_flag
      sales_order_shipping.label_received_flag = label_received_flag

      sales_order_shipping.save!
      activity.save! if activity
      return 'success'
    rescue Exception => ex
      return ex
    end
  end

  def self.status_change(po_new,label_new,po_old,label_old , order)
    if(po_new != po_old and label_new != label_old)
      if(po_new == 'Y' and label_new == 'Y')
        activity_message = 'VENDOR PO CONFIRMED AND LABEL RECEIVED BY VENDOR'
      end
      if (po_new == 'Y' and label_new == 'N')
        activity_message = 'VENDOR PO CONFIRMED AND LABEL NOT RECEIVED'
      end
      if (po_new == 'N' and label_new == 'Y')
        activity_message = 'VENDOR PO NOT CONFIRMED AND LABEL RECEIVED BY VENDOR'
      end
    end
    if(po_new != po_old and label_new == label_old)
      if(po_new == 'Y')
        activity_message = 'VENDOR PO CONFIRMED'
      else
        activity_message = 'VENDOR PO NOT CONFIRMED'
      end
    end
    if (po_new == po_old and label_new != label_old)
      if (label_new == 'Y')
        activity_message = 'LABEL RECEIVED BY VENDOR'
      else
        activity_message = 'LABEL NOT RECEIVED'
      end
    end
    activity = order.create_sales_order_transaction_activity(activity_message)
    activity
  end
  
end
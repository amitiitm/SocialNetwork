class Sales::SalesRegularOrderCrud
  include General
  #  Trans Type Codes
  #  S	Regular Order
  #  E	Re-Order
  #  P	Sample Order
  #  V	Virtual Order
  #  F	Spec Order



  # CRUD for Sales Receive, Regular services
  def self.list_orders(doc)
    criteria = Setup::Criteria.fill_criteria_for_query(doc/:criteria)
    condition = "( sales_orders.company_id = #{criteria.company_id}) AND
                     (customer_code between '#{criteria.str1}' and '#{criteria.str2}' AND (0 =#{criteria.multiselect1.length} or customer_code in ('#{criteria.multiselect1}'))) AND
                     (sales_orders.trans_no between '#{criteria.str3}' and '#{criteria.str4}' AND (0 =#{criteria.multiselect2.length} or sales_orders.trans_no in ('#{criteria.multiselect2}'))) AND
                     (sales_orders.trans_date between '#{criteria.dt1}' and '#{criteria.dt2}' ) AND
                     (sales_orders.account_period_code between '#{criteria.str5[0,8]}' and '#{criteria.str6[0,8]}' AND (0 =#{criteria.multiselect3.length} or sales_orders.account_period_code in ('#{criteria.multiselect3}')))  AND
                     (logo_name between '#{criteria.str7}' and '#{criteria.str8}' AND (0 =#{criteria.multiselect4.length} or logo_name in ('#{criteria.multiselect4}')))  AND
                     (ext_ref_no between '#{criteria.str9}' and '#{criteria.str10}' AND (0 =#{criteria.multiselect5.length} or ext_ref_no in ('#{criteria.multiselect5}')))
                      AND sales_orders.trans_type in ('S','F') and sales_orders.sub_ref_type <> 'S'"

    condition = convert_sql_to_db_specific(condition)
    Sales::SalesOrder.find_by_sql ["select CAST((
                                  select(select distinct sales_orders.id,
                                                sales_orders.ext_ref_no,
                                                sales_orders.trans_no,
                                                sales_orders.trans_date,
                                                sales_orders.ship_date,
                                                sales_orders.customer_code,
                                                sales_orders.customer_contact,
                                                sales_orders.customer_phone,
                                                sales_orders.salesperson_code,
                                                sales_orders.externalsalesperson_code,
                                                sales_orders.logo_name,
                                                sales_orders.order_status,
                                                sales_orders.shipping_status,
                                                sales_orders.artwork_status,
                                                sales_orders.paper_proof_status,
                                                sales_orders.acknowledgment_status,
                                                sales_orders.accounting_status,
                                                sales_orders.rushorder_flag,
                                                sales_orders.order_flagged,
                                                sales_orders.workflow_location,
                                                types.description as order_type
                                  from sales_orders
                                  left outer join sales_order_lines sol on (sol.sales_order_id = sales_orders.id  and sol.item_type = 'I' and sol.trans_flag = 'A' AND (sol.catalog_item_code between '#{criteria.str11}' and '#{criteria.str12}' AND (0 =#{criteria.multiselect6.length} or sol.catalog_item_code in ('#{criteria.multiselect6}'))))
                                  left outer join types on (
                                        types.type_cd = 'trans_type'
                                        and types.subtype_cd = 'so'
                                        and sales_orders.trans_type = types.value
                                       )
                                  where #{condition}
                                  order by sales_orders.trans_no
                                  FOR XML PATH('sales_order'), TYPE,ELEMENTS XSINIL
                                  )FOR XML PATH('sales_orders')) AS varchar(MAX)) as sales_orders"
    ]
  end

  def self.show_order(order_id)
    Sales::SalesOrder.where(:id => order_id)
  end

  def self.create_orders(doc,schema_name,url_with_port)
    orders = []
    doc = Quotation::SalesQuotationCrud.generate_order_xml_from_quotation(doc)
    (doc/:sales_orders/:sales_order).each{|order_doc|
      order = create_order(order_doc,schema_name,url_with_port)
      orders <<  order if order
    }
    orders
  end

  def self.create_order(doc,schema_name,url_with_port)
    order = add_or_modify_order(doc,schema_name,url_with_port)
    return  if !order
    ### this is used to fire email with acknowledgment as attachment when net_amt/qty is changed
    email_ack = Sales::SalesOrderCrud.check_net_amt_and_qty_change(doc,order,schema_name,url_with_port)
    order.generate_trans_no('SAOIOD') if order.new_record?
    order.apply_header_fields_to_lines
    order.apply_line_fields_to_header
    if order.new_record?
      email = Email::Email.send_email('NEWORDER',order)
      if order.ref_type == TRANS_TYPE_QUOTATION_ORDER and order.ref_trans_no != ''
        order.create_sales_order_transaction_activity("NEW ORDER CREATED FROM ESTIMATE# #{order.ref_trans_no}")
        quotation = Quotation::SalesQuotation.find_by_trans_no(order.ref_trans_no)
        quotation.create_sales_quotation_transaction_activity("ORDER NO: #{order.trans_no} CREATED FROM ESTIMATE# #{order.ref_trans_no}")
      else
        order.create_sales_order_transaction_activity(order.order_status)
      end
    end
    discount_coupon,validity_message = check_coupon_validity(order)
    Sales::SalesOrderCrud.update_order_status_and_activity(doc,order,schema_name,url_with_port)
    customer_shippings = Sales::SalesOrderCrud.create_customer_shippings(doc,order)
    Sales::SalesOrderCrud.reassign_order_to_other_user(doc,order)
    set_blank_order_flag(order) if order.trans_type == TRANS_TYPE_REGULAR_ORDER and order.blank_order_flag == 'Y'
    Sales::SalesReorderCrud.create_reorder_activity(order) if order.new_record? and order.trans_type == TRANS_TYPE_REORDER
    workflow_location = Sales::CurrentLocationLogic.find_order_location(order,order.order_status,order.artwork_status)
    order.workflow_location = workflow_location
    save_proc = Proc.new{
      ## when we raise query and if stale error occurs even then the activity is saved.so we put these functions inside proc
      if order.new_record?
        order.save!
        email.save!
        quotation.save! if quotation
      else
        order.save!
        order.save_lines
        order.sales_order_shippings.each{|shipping|
          shipping.sales_order_shipping_packages.each{|package|
            package.save!
          }
        }
      end
      email_ack.save! if email_ack
      customer_shippings.each{|customer_shipping| 
        customer_shipping.save! if customer_shipping.new_record?
      }
      discount_coupon.save! if validity_message == 'success'
      #      Sales::SalesOrderCrud.check_net_amt_change(doc,order,schema_name,url_with_port,previous_net_amt)
      ##### This code is working Fine as normal inventory works
      #      inventory = Inventory::InventorySales::Posting.new
      #      inventory_postings = inventory.create_inventory_postings(order)
      #      Inventory::InventoryPosting.post_inventory_transactions(inventory_postings) if inventory_postings
    }
    if(order.errors.empty?)
      order.save_transaction(&save_proc)
    end
    return order
  end

  def self.add_or_modify_order(doc,schema_name,url_with_port)
    id =  parse_xml(doc/'id') if (doc/'id').first
    order = Sales::SalesOrder.find_or_create(id)
    return if !order
    reorder_type = order.reorder_type
    if !order.new_record? and order.update_flag == 'V'
      order.errors.add('This Order is View Only. Cannot update.')
      return order
    end
    #    order.schema_name = schema_name
    #    order.url_with_port = url_with_port
    Sales::DateUtility.check_ship_date_change(doc,order,schema_name,url_with_port) if order.sales_order_shippings[0]
    order.apply_attributes(doc)
    order.fill_default_header_values() if (order.new_record? ||(order.trans_type == TRANS_TYPE_REORDER and (reorder_type != order.reorder_type)))
    order.run_block do
      order.max_serial_no = order.sales_order_lines.maximum_serial_no
      order.build_lines(doc/:sales_order_lines/:sales_order_line)
      order.max_serial_no = order.sales_order_shippings.maximum_serial_no
      order.build_lines(doc/:sales_order_shippings/:sales_order_shipping)
      order.max_serial_no = order.sales_order_attributes_values.maximum_serial_no
      order.build_lines(doc/:sales_order_attributes_values/:sales_order_attributes_value)
      order.max_serial_no = order.sales_order_artworks.maximum_serial_no
      order.build_lines(doc/:sales_order_artworks/:sales_order_artwork)
      order.max_serial_no = order.queries.maximum_serial_no
      order.build_lines(doc/:queries/:query)
    end
    return order
  end
 

  def self.check_coupon_validity(order)
    if !order.coupon_code.blank? and !order.coupon_id.blank?
      discount_coupon = Setup::DiscountCoupon.find_by_coupon_code(order.coupon_code)
      if discount_coupon.no_of_uses - discount_coupon.no_of_used == 0
        order.errors[:base] << "Coupon Not Available"
        return order,'error'
      else
        discount_coupon.no_of_used = discount_coupon.no_of_used + 1
        discount_coupon.update_flag = 'V'
        return discount_coupon,'success'
      end
    end
  end

  def self.set_blank_order_flag(order)
    order.paper_proof_flag = 'N'
    order.artworkreviewed_flag = 'Y'
    order.artwork_status = NOT_APPLICABLE
  end
  # Quick Order services
  def self.list_quick_regular_and_reorders(doc)
    criteria = Setup::Criteria.fill_criteria_for_query(doc/:criteria)
    condition = "( sales_orders.company_id = #{criteria.company_id}) AND
                     (customer_code between '#{criteria.str1}' and '#{criteria.str2}' AND (0 =#{criteria.multiselect1.length} or customer_code in ('#{criteria.multiselect1}'))) AND
                     (trans_no between '#{criteria.str3}' and '#{criteria.str4}' AND (0 =#{criteria.multiselect2.length} or trans_no in ('#{criteria.multiselect2}'))) AND
                     (trans_date between '#{criteria.dt1}' and '#{criteria.dt2}' ) AND
                     (account_period_code between '#{criteria.str5[0,8]}' and '#{criteria.str6[0,8]}' AND (0 =#{criteria.multiselect3.length} or account_period_code in ('#{criteria.multiselect3}')))  AND
                     (logo_name between '#{criteria.str7}' and '#{criteria.str8}' AND (0 =#{criteria.multiselect4.length} or logo_name in ('#{criteria.multiselect4}')))  AND
                     (ext_ref_no between '#{criteria.str9}' and '#{criteria.str10}' AND (0 =#{criteria.multiselect5.length} or ext_ref_no in ('#{criteria.multiselect5}')))
                      AND sales_orders.trans_type in ('S','E','F','P','V') and sales_orders.quick_order_flag = 'Y'"

    condition = convert_sql_to_db_specific(condition)
    Sales::SalesOrder.find_by_sql ["select CAST((
                                  select(select sales_orders.id,
                                                sales_orders.trans_type,
                                                sales_orders.ext_ref_no,
                                                sales_orders.trans_no,
                                                sales_orders.trans_date,
                                                sales_orders.customer_code,
                                                sales_orders.logo_name,
                                                sales_orders.customer_phone,
                                                sales_orders.customer_contact,
                                                sales_orders.rushorder_flag,
                                                sales_orders.order_flagged,
                                                types.description as order_type
                                  from sales_orders

                                  left outer join types on (
                                        types.type_cd = 'trans_type'
                                        and types.subtype_cd = 'so'
                                        and sales_orders.trans_type = types.value
                                       )
                                  where #{condition}
                                  order by sales_orders.order_flagged desc,sales_orders.rushorder_flag desc, sales_orders.ship_date
                                  FOR XML PATH('sales_order'), TYPE,ELEMENTS XSINIL
                                  )FOR XML PATH('sales_orders')) AS varchar(MAX)) as sales_orders"
    ]
  end
  private_class_method :create_order, :add_or_modify_order
end
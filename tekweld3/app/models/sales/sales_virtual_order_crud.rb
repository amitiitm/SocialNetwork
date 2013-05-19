class Sales::SalesVirtualOrderCrud
  include General
  #  Trans Type Codes
  #  S	Regular Order
  #  E	Re-Order
  #  P	Sample Order
  #  V	Virtual Order
  #  F	Spec Order


  #Virtual Order services
  def self.list_virtual_orders(doc)
    criteria = Setup::Criteria.fill_criteria_for_query(doc/:criteria)
    condition = "( sales_orders.company_id = #{criteria.company_id}) AND
                     (customer_code between '#{criteria.str1}' and '#{criteria.str2}' AND (0 =#{criteria.multiselect1.length} or customer_code in ('#{criteria.multiselect1}'))) AND
                     (sales_orders.trans_no between '#{criteria.str3}' and '#{criteria.str4}' AND (0 =#{criteria.multiselect2.length} or sales_orders.trans_no in ('#{criteria.multiselect2}'))) AND
                     (sales_orders.trans_date between '#{criteria.dt1}' and '#{criteria.dt2}' ) AND
                     (sales_orders.account_period_code between '#{criteria.str5[0,8]}' and '#{criteria.str6[0,8]}' AND (0 =#{criteria.multiselect3.length} or sales_orders.account_period_code in ('#{criteria.multiselect3}')))  AND
                     (logo_name between '#{criteria.str7}' and '#{criteria.str8}' AND (0 =#{criteria.multiselect4.length} or logo_name in ('#{criteria.multiselect4}')))  AND
                     (ext_ref_no between '#{criteria.str9}' and '#{criteria.str10}' AND (0 =#{criteria.multiselect5.length} or ext_ref_no in ('#{criteria.multiselect5}')))
                     AND sales_orders.trans_type = 'V'"

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
                                                sales_orders.artwork_status,
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

  def self.show_virtual_order(order_id)
    #    Sales::SalesOrder.find_all_by_id(order_id)
    Sales::SalesOrder.where(:id => order_id)
  end

  def self.create_virtual_orders(doc,schema_name,url_with_port)
    orders = []
    (doc/:sales_orders/:sales_order).each{|order_doc|
      order = create_virtual_order(order_doc,schema_name,url_with_port)
      orders <<  order if order
    }
    orders
  end

  def self.create_virtual_order(doc,schema_name,url_with_port)
    order = add_or_modify_virtual_order(doc,schema_name,url_with_port)
    return  if !order
    ### this is used to fire email with acknowledgment as attachment when net_amt/qty is changed
    email_ack = Sales::SalesOrderCrud.check_net_amt_and_qty_change(doc,order,schema_name,url_with_port)
    order.generate_trans_no('SAOIOD') if order.new_record?
    order.apply_header_fields_to_lines
    order.apply_line_fields_to_header
    if order.new_record?
      email = Email::Email.send_email('NEWORDER',order)
      order.create_sales_order_transaction_activity(order.order_status)
    end
    Sales::SalesOrderCrud.update_order_status_and_activity(doc,order,schema_name,url_with_port)
    Sales::SalesOrderCrud.reassign_order_to_other_user(doc,order)
    workflow_location = Sales::CurrentLocationLogic.find_order_location(order,order.order_status,order.artwork_status)
    order.workflow_location = workflow_location
    save_proc = Proc.new{
      if order.new_record?
        order.save!
        email.save!
      else
        order.save!
        order.save_lines
        order.sales_order_shippings.each{|shipping|
          shipping.sales_order_shipping_packages.each{|package|
            package.save!
          }
        }
        order.sales_order_lines.each{|line|
          line.sales_order_attributes_values.each{|value|
            value.save!
          }
        }
      end
      email_ack.save! if email_ack
    }
    if(order.errors.empty?)
      order.save_transaction(&save_proc)
    end
    return order
  end

  def self.add_or_modify_virtual_order(doc,schema_name,url_with_port)
    id =  parse_xml(doc/'id') if (doc/'id').first
    order = Sales::SalesOrder.find_or_create(id)
    return if !order
    if !order.new_record? and order.update_flag == 'V'
      order.errors.add('This Order is View Only. Cannot update.')
      return order
    end
    order.apply_attributes(doc)
    order.fill_default_header_values() if order.new_record?
    order.max_serial_no = order.sales_order_lines.maximum_serial_no
    order.run_block do
      order.max_serial_no = order.sales_order_lines.maximum_serial_no
      build_lines(doc/:sales_order_lines/:sales_order_line)
      order.max_serial_no = order.sales_order_artworks.maximum_serial_no
      build_lines(doc/:sales_order_artworks/:sales_order_artwork)
      order.max_serial_no = order.queries.maximum_serial_no
      build_lines(doc/:queries/:query)
    end
    return order
  end
  private_class_method :create_virtual_order, :add_or_modify_virtual_order
end
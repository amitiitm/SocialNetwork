class Sales::SalesMultipleArtworkCrud
  include General
  #  Trans Type Codes
  #  S	Regular Order
  #  E	Re-Order
  #  P	Sample Order
  #  V	Virtual Order
  #  F	Spec Order

  def self.list_multiple_artwork_orders(doc)
    criteria = Setup::Criteria.fill_criteria_for_query(doc/:criteria)
    condition = "( sales_orders.company_id = #{criteria.company_id}) AND
                     (customer_code between '#{criteria.str1}' and '#{criteria.str2}' AND (0 =#{criteria.multiselect1.length} or customer_code in ('#{criteria.multiselect1}'))) AND
                     (sales_orders.trans_no between '#{criteria.str3}' and '#{criteria.str4}' AND (0 =#{criteria.multiselect2.length} or sales_orders.trans_no in ('#{criteria.multiselect2}'))) AND
                     (sales_orders.trans_date between '#{criteria.dt1}' and '#{criteria.dt2}' ) AND
                     (sales_orders.account_period_code between '#{criteria.str5[0,8]}' and '#{criteria.str6[0,8]}' AND (0 =#{criteria.multiselect3.length} or sales_orders.account_period_code in ('#{criteria.multiselect3}')))  AND
                     (logo_name between '#{criteria.str7}' and '#{criteria.str8}' AND (0 =#{criteria.multiselect4.length} or logo_name in ('#{criteria.multiselect4}')))  AND
                     (ext_ref_no between '#{criteria.str9}' and '#{criteria.str10}' AND (0 =#{criteria.multiselect5.length} or ext_ref_no in ('#{criteria.multiselect5}')))
                      AND sales_orders.trans_type in ('S','E') and sales_orders.sub_ref_type = 'S'"

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
                                                sales_orders.sub_ref_no,
                                                sales_orders.sub_ref_type,
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

  def self.show_multiple_artwork_order(order_id)
    Sales::SalesOrder.where(:id => order_id)
  end

  def self.create_multiple_artwork_orders(doc,schema_name,url_with_port)
    orders = []
    (doc/:sales_orders/:sales_order).each{|order_doc|
      order = create_multiple_artwork_order(order_doc,schema_name,url_with_port)
      orders <<  order if order
    }
    orders
  end

  def self.create_multiple_artwork_order(doc,schema_name,url_with_port)
    order = add_or_modify_multiple_artwork_order(doc)
    return  if !order
    main_order = Sales::SalesOrder.find_by_trans_no(order.sub_ref_no)
    generate_trans_no(order,main_order) if order.new_record?
    order.apply_header_fields_to_lines
    order.apply_line_fields_to_header
    main_order = update_multiple_artwork_order_flags(order,main_order)
    #    Sales::SalesOrderCrud.update_order_status_and_activity(doc,order,schema_name,url_with_port)
    workflow_location = Sales::CurrentLocationLogic.find_order_location(order,order.order_status,order.artwork_status)
    order.workflow_location = workflow_location
    order.workflow_location = 'SUB ORDER' if order.workflow_location.blank?
    save_proc = Proc.new{
      if order.new_record?
        order.save!
      else
        order.save!
        order.save_lines
      end
      main_order.save! if main_order
    }
    if(order.errors.empty?)
      order.save_transaction(&save_proc)
    end
    return order
  end

  def self.add_or_modify_multiple_artwork_order(doc)
    id =  parse_xml(doc/'id') if (doc/'id').first
    order = Sales::SalesOrder.find_or_create(id)
    return if !order
    if !order.new_record? and order.update_flag == 'V'
      order.errors.add('This Order is View Only. Cannot update.')
      return order
    end
    order.apply_attributes(doc)
    order.fill_default_header_values() if order.new_record?
    order.run_block do
      order.max_serial_no = order.sales_order_lines.maximum_serial_no
      order.build_lines(doc/:sales_order_lines/:sales_order_line)
      order.max_serial_no = order.sales_order_attributes_values.maximum_serial_no
      order.build_lines(doc/:sales_order_attributes_values/:sales_order_attributes_value)
      order.max_serial_no = order.sales_order_artworks.maximum_serial_no
      order.build_lines(doc/:sales_order_artworks/:sales_order_artwork)
    end
    return order
  end

  def self.update_multiple_artwork_order_flags(order,main_order)
    if order.new_record?
      order.orderpickstatus_flag = 'Y' ; order.orderentrycomplete_flag = 'Y'
      order.orderqcstatus_flag = 'Y' ; order.orderacksent_flag = 'Y'
      order.order_status = QC_COMPLETE ; order.acknowledgment_status = 'NOT APPLICABLE'
      order.accounting_status = 'NOT APPLICABLE' ; order.inventory_status = 'NOT APPLICABLE'
      order.shipping_status = 'NOT APPLICABLE' ; order.workflow_location = 'SUB ORDER'
      order.paper_proof_flag = main_order.paper_proof_flag ; order.logo_name = main_order.logo_name
    end
    order.sales_order_artworks.each{ |artwork|
      if (artwork.new_record? and artwork.trans_flag == 'A')
        if (artwork.artwork_version =~ (/Customer Art(.*)/))
          order.artworkreceived_flag = 'Y'
          order.artwork_status = ARTWORK_RECEIVED
        end
        order.create_sales_order_transaction_activity("#{artwork.artwork_version} IS RECEIVED")
      end
    }
    setup_amt = 0.00
    order.sales_order_lines.each{|sales_order_line|
      if sales_order_line.new_record? and sales_order_line.trans_flag == 'A' and sales_order_line.item_type == 'S'
        setup_amt = setup_amt + sales_order_line.item_amt
      end
    }
    total_item_amt = Sales::SalesOrder.find_by_sql ["select ISNULL(SUM(sol.item_amt),0) as item_amt from sales_order_lines sol
                                                     inner join sales_orders so on so.id = sol.sales_order_id
                                                     where sol.trans_flag = 'A' and sol.item_type = 'S' and so.sub_ref_no = #{main_order.trans_no}"]
    net_amt = main_order.net_amt - main_order.other_amt + (total_item_amt[0].item_amt + setup_amt)
    other_amt = total_item_amt[0].item_amt + setup_amt
    main_order.net_amt = net_amt ; main_order.other_amt = other_amt
    main_order
  end

  def self.generate_trans_no(order,main_order)
    last_trans_no = Sales::SalesOrder.find_by_sql ["select TOP 1 trans_no from sales_orders where sub_ref_no = #{main_order.trans_no} and sub_ref_type = 'S' order by trans_no desc"]
    if last_trans_no[0]
      character = last_trans_no[0].trans_no[-1,1]
      character = character.ord
      character += 1
      character = character.chr
      order.trans_no = main_order.trans_no + "-#{character}"
      order.ext_ref_no = main_order.ext_ref_no + "-#{character}"
    else
      order.trans_no = main_order.trans_no + '-A'
      order.ext_ref_no = main_order.ext_ref_no + '-A'
    end
  end
  private_class_method :create_multiple_artwork_order, :add_or_modify_multiple_artwork_order
end
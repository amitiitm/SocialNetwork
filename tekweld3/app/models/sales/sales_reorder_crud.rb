class Sales::SalesReorderCrud
  include General
  #  Trans Type Codes
  #  S	Regular Order
  #  E	Re-Order
  #  P	Sample Order
  #  V	Virtual Order
  #  F	Spec Order
  
  def self.list_sales_reorders(doc)
    criteria = Setup::Criteria.fill_criteria_for_query(doc/:criteria)
    condition = "( sales_orders.company_id = #{criteria.company_id}) AND
                     (customers.code between '#{criteria.str1}' and '#{criteria.str2}' AND (0 =#{criteria.multiselect1.length} or customers.code in ('#{criteria.multiselect1}'))) AND
                     (sales_orders.trans_no between '#{criteria.str3}' and '#{criteria.str4}' AND (0 =#{criteria.multiselect2.length} or sales_orders.trans_no in ('#{criteria.multiselect2}'))) AND
                     (sales_orders.trans_date between '#{criteria.dt1}' and '#{criteria.dt2}' ) AND
                     (sales_orders.account_period_code between '#{criteria.str5[0,8]}' and '#{criteria.str6[0,8]}' AND (0 =#{criteria.multiselect3.length} or sales_orders.account_period_code in ('#{criteria.multiselect3}'))) AND
                     (logo_name between '#{criteria.str7}' and '#{criteria.str8}' AND (0 =#{criteria.multiselect4.length} or logo_name in ('#{criteria.multiselect4}'))) AND
                     (ext_ref_no between '#{criteria.str9}' and '#{criteria.str10}' AND (0 =#{criteria.multiselect5.length} or ext_ref_no in ('#{criteria.multiselect5}')))
                      AND sales_orders.trans_type = 'E'"

    condition = convert_sql_to_db_specific(condition)
    Sales::SalesOrder.find_by_sql ["select CAST((
                                  select(select distinct sales_orders.id,
                                                sales_orders.ext_ref_no,
                                                sales_orders.trans_no,
                                                sales_orders.ref_trans_no,
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
                                  inner join customers on customers.id = sales_orders.customer_id
                                  left outer join sales_order_lines sol on (sol.sales_order_id = sales_orders.id and sol.item_type = 'I' and sol.trans_flag = 'A' AND (sol.catalog_item_code between '#{criteria.str11}' and '#{criteria.str12}' AND (0 =#{criteria.multiselect6.length} or sol.catalog_item_code in ('#{criteria.multiselect6}'))))
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
  
  def self.show_reorder(order_id)
    #    Sales::SalesOrder.find_all_by_id(order_id)
    Sales::SalesOrder.where(:id => order_id)
  end
  
  def self.create_reorders(doc,schema_name,url_with_port)
    orders = [] 
    (doc/:sales_orders/:sales_order).each{|order_doc|
      order = create_reorder(order_doc,schema_name,url_with_port)
      orders <<  order if order
    }
    orders
  end

  def self.create_reorder(doc,schema_name,url_with_port)
    order = add_or_modify_reorder(doc,schema_name,url_with_port)
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
    discount_coupon,validity_message = Sales::SalesRegularOrderCrud.check_coupon_validity(order)
    Sales::SalesOrderCrud.update_order_status_and_activity(doc,order,schema_name,url_with_port)
    customer_shippings = Sales::SalesOrderCrud.create_customer_shippings(doc,order)
    Sales::SalesOrderCrud.reassign_order_to_other_user(doc,order)
    create_reorder_activity(order) if order.new_record?
    ## this will send artwork automatically to customer and send reorder directly to customer approval screen
    if (order.reorder_type != REORDER_TYPE3 and (order.orderqcstatus_flag == 'Y' || (order.orderentrycomplete_flag == 'Y' and order.qc_off_flag == 'Y')) and order.artworksenttocust_flag == 'N')
      email = send_reorder_with_proof_to_customer(order,schema_name,url_with_port)
    end
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
        ## this email.save! is saving email for send AW to customer and is written inside else b-cos we have to save it only when order is updated.
        email.save! if email
      end
      email_ack.save! if email_ack
      discount_coupon.save! if validity_message == 'success'
      customer_shippings.each{|customer_shipping|
        customer_shipping.save! if customer_shipping.new_record?
      }
    }
    if(order.errors.empty?)
      order.save_transaction(&save_proc)
    end
    return order
  end

  def self.add_or_modify_reorder(doc,schema_name,url_with_port)
    id =  parse_xml(doc/'id') if (doc/'id').first
    #    reorder_type =  parse_xml(doc/'reorder_type') if (doc/'reorder_type').first
    order = Sales::SalesOrder.find_or_create(id) 
    return if !order
    reorder_type = order.reorder_type
    if !order.new_record? and order.update_flag == 'V'
      order.errors.add('This Order is View Only. Cannot update.') 
      return order
    end
    Sales::DateUtility.check_ship_date_change(doc,order,schema_name,url_with_port) if order.sales_order_shippings[0]
    order.apply_attributes(doc) 
    order.fill_default_header_values() if (order.new_record? ||(reorder_type != order.reorder_type))
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

  def self.send_reorder_with_proof_to_customer(order,schema_name,url_with_port)
    path = Setup::Type.find_by_type_cd_and_subtype_cd('UPLOAD_FOLDER','ATTACHMENT')
    if path
      directory =  "#{Dir.getwd}" + "/" + path.value + schema_name
    end
    ref_order = Sales::SalesOrder.find_by_trans_no(order.ref_trans_no)
    ref_artwork_obj = Sales::SalesOrderArtwork.find_by_sales_order_id_and_final_artwork_flag_and_trans_flag(ref_order.id,'Y','A')
    if !ref_artwork_obj
      order.errors[:base] << "Reorder of type Normal with Proof cannot save without final Artwork."
    end
    artwork_name = ref_artwork_obj.artwork_file_name
    #    artwork_obj = Sales::SalesOrderArtwork.find_by_sales_order_id_and_trans_flag_and_artwork_version(order.id,'A',ref_artwork_obj.artwork_version)
    artwork_obj = nil
    order.sales_order_artworks.each{|sales_order_artwork|
      if sales_order_artwork.trans_flag == 'A' and sales_order_artwork.artwork_version == ref_artwork_obj.artwork_version
        artwork_obj = sales_order_artwork
      end
    }
    if artwork_obj == nil
      order.errors[:base] << "No Matching Artwork Found in Reorder and Ref Order"
    end
    order.customer_email = order.artwork_dept_email
    order.url_with_port = url_with_port
    salt = Artwork::ArtworkCrud.create_salt(order)
    order.artwork_customer_email = order.artwork_dept_email ; order.paper_proof_status = 'PROOF SENT TO CUSTOMER'
    order.artwork_status = SENT_TO_CUSTOMER ; order.artworksenttocust_flag = 'Y'
    order.paperproofsenttocust_date = Time.now ; order.salt = salt
    artwork_obj.select_yn = 'Y'
    email = Email::Email.send_email('SENDMULTIPLEARTWORK',order)
    # create the file path
    filename = File.join(directory, artwork_name)
    email.file_name_path = filename
    activity_message = Artwork::ArtworkCrud.create_activity_message(order,"ARTWORK #{ref_artwork_obj.artwork_version} SENT SUCCESSFULLY TO #{order.artwork_dept_email}")
    order.create_sales_order_transaction_activity(activity_message)
    return email
  end

  def self.create_reorder_activity(order)
    order.create_sales_order_transaction_activity('ARTWORK RECEIVED')
    if order.reorder_type != REORDER_TYPE3
      order.create_sales_order_transaction_activity('ARTWORK REVIEWED INTERNALLY')
    end
    ## we are setting one Artwork as final in this bcos when reorder is normal then No proof is required from customer so we set the ref artwork as final.
    if (order.reorder_type != REORDER_TYPE3 and order.paper_proof_flag == 'N')
      ref_order = Sales::SalesOrder.find_by_trans_no(order.ref_trans_no)
      return if !ref_order
      ref_order_artwork = Sales::SalesOrderArtwork.find_by_sales_order_id_and_final_artwork_flag(ref_order.id,'Y')
      if !ref_order_artwork
        order.errors[:base] << "Reorder With Normal cannot save without final Artwork."
      end
      order.sales_order_artworks.each{|artwork|
        if artwork.artwork_version == ref_order_artwork.artwork_version
          artwork.final_artwork_flag = 'Y'
          artwork.select_yn = 'Y'
          break
        end
      }
    end
  end

  ## Sales Reorder Services Reorder Can be made only from completely shipped orders##
  def self.list_shipped_order_hdrs(doc)
    criteria = Setup::Criteria.fill_criteria(doc/:criteria)
    Sales::SalesOrder.find_by_sql ["select CAST((
                                  select(select distinct sol.id,so.id as order_id,so.trans_no,so.trans_date,so.logo_name,customer_contacts.first_name,so.customer_phone,
                                                so.account_period_code,so.ext_ref_no,sol.id as ref_virtual_line_id,types.value as order_type,
                                                catalog_items.id as catalog_item_id,catalog_items.store_code as catalog_item_code
                                                from sales_orders so
                                                inner join sales_order_lines sol on sol.sales_order_id = so.id
                                                left outer join customer_contacts on
                                                (customer_contacts.customer_id = so.customer_id AND customer_contacts.default_contact_flag = 'Y' AND customer_contacts.trans_flag = 'A')
                                                inner join catalog_items on
                                                (catalog_items.id = sol.catalog_item_id AND catalog_items.item_type = 'I' AND sol.trans_flag = 'A')
                                                left outer join types on (
                                                  types.type_cd = 'trans_type'
                                                  and types.subtype_cd = 'so'
                                                  and so.trans_type = types.value
                                                )
                                                where so.trans_type != 'P' AND so.blank_order_flag <> 'Y' AND
                                                so.trans_flag = 'A' AND so.shipped_flag = 'Y' AND so.company_id = ? AND
                                                (so.customer_id between ? AND ?)
                                                order by so.trans_no
                                   FOR XML PATH('sales_order'), TYPE,ELEMENTS XSINIL
                                  )FOR XML PATH('sales_orders')) AS varchar(MAX)) as xmlcol",criteria.company_id,criteria.int1,criteria.int2]

  end

  def self.list_shipped_order_dtls(doc)
    criteria = Setup::Criteria.fill_criteria(doc/:criteria)
    Sales::SalesOrder.find_by_sql ["select CAST((
                                  select(select sales_orders.id as order_id,sales_orders.trans_no,sales_orders.trans_date,types.description as order_type,
                                                sales_orders.account_period_code,sales_orders.ext_ref_no
                                                from sales_orders
                                                left outer join types on (
                                                  types.type_cd = 'trans_type'
                                                  and types.subtype_cd = 'so'
                                                  and sales_orders.trans_type = types.value
                                                )
                                                where
                                                sales_orders.trans_flag = 'A' AND sales_orders.company_id = ? AND
                                                (sales_orders.id between ? AND ?)
                                                order by sales_orders.trans_no
                                   FOR XML PATH('sales_order'), TYPE,ELEMENTS XSINIL
                                  )FOR XML PATH('sales_orders')) AS varchar(MAX)) as xmlcol",criteria.company_id,criteria.int1,criteria.int2]

  end

  private_class_method :create_reorder, :add_or_modify_reorder
end
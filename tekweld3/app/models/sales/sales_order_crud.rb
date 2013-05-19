class Sales::SalesOrderCrud
  include General
  #  Trans Type Codes
  #  S	Regular Order
  #  E	Re-Order
  #  P	Sample Order
  #  V	Virtual Order
  #  F	Spec/Pre Production Order
    
  ############################# Tekweld Services ###################################

  def self.generate_regular_order_pdf(sales_order,schema_name,url_with_port,flag)
    begin
      pdf = Prawn::Document.new
      y = 730
      total_height = 0
      pdf.repeat :all do
        y, total_height = Sales::PrawnPdfCrud.generate_header_for_order_ack_pdf(schema_name,sales_order,y,pdf,total_height)
      end
      y ,total_height = Sales::PrawnPdfCrud.fetch_item_lines_for_order_ack_pdf(sales_order, y, pdf, total_height)
      y,total_height = Sales::PrawnPdfCrud.fetch_shipping_lines_for_order_ack_pdf(total_height, sales_order, y, pdf)
      y = Sales::PrawnPdfCrud.generate_footer_for_order_ack_pdf(pdf,schema_name,sales_order)
      Sales::PrawnPdfCrud.insert_page_numbers(pdf)

      path = Setup::Type.find(:first, :conditions=>['type_cd = ? and subtype_cd = ?','UPLOAD_FOLDER','REPORT_PRINT'])
      if path
        directory =  "#{Dir.getwd}" + path.value + schema_name
      end
      filename = "#{Time.now().strftime('%Y%m%d%H%M%S')}"
      absolute_filename = File.join(directory, filename)+ "." + "pdf"
      pdf.render_file "#{absolute_filename}"
      if flag == true
        email = Email::Email.send_email('ORDERACKNOWLEDGMENT',sales_order)
        email.file_name_path = absolute_filename
        email.save!
        activity_message = Artwork::ArtworkCrud.create_activity_message(sales_order,'ORDER ACKNOWLEDGMENT RE-SENT')
        activity = sales_order.create_sales_order_transaction_activity(activity_message)
        activity.save!
      end
      return true,absolute_filename
    rescue Exception => ex
      return false,ex
    end
  end
 
  ## function which reassignes order to other user from quality check screen
  def self.reassign_order_to_other_user(doc,order)
    orderassignedtouser_id =  parse_xml(doc/'orderassignedtouser_id') if (doc/'orderassignedtouser_id').first
    orderassignedtouser_code =  parse_xml(doc/'orderassignedtouser_code') if (doc/'orderassignedtouser_code').first
    if (!order.new_record? and order.orderreassigned_flag == 'Y' and order.orderentrycomplete_flag == 'Y' and order.orderqcstatus_flag == 'N')
      order.orderassignedtouser_code = orderassignedtouser_code ; order.orderassignedtouser_id = orderassignedtouser_id
      order.order_status = ORDER_REASSIGNED_FOR_ENTRY ; order.orderentrycomplete_flag = 'N'
      order.orderqcstatus_flag = 'N'
      activity_message = Artwork::ArtworkCrud.create_activity_message(order,'ORDER REASSIGNED FOR ENTRY')
      order.create_sales_order_transaction_activity(activity_message)
    end
  end
 
  ## Function which handles all the status of all type of orders
  def self.update_order_status_and_activity(doc,order,schema_name,url_with_port)
    ## artwork status
    if order.trans_type != TRANS_TYPE_REORDER
      order.sales_order_artworks.each{ |artwork|
        if (artwork.new_record? and artwork.trans_flag == 'A')
          if (artwork.artwork_version =~ (/Customer Art(.*)/))
            order.artworkreceived_flag = 'Y'
            order.artwork_status = ARTWORK_RECEIVED
          end
          order.create_sales_order_transaction_activity("#{artwork.artwork_version} IS RECEIVED")
        end
      }
    end
    ## ORDER STATUS CONDITIONS
    orderentrycomplete_flag =  parse_xml(doc/'orderentrycomplete_flag') if (doc/'orderentrycomplete_flag').first
    orderqcstatus_flag =  parse_xml(doc/'orderqcstatus_flag') if (doc/'orderqcstatus_flag').first
    quick_order_flag =  parse_xml(doc/'quick_order_flag') if (doc/'quick_order_flag').first
    ## if regular order is saved directly from regular screen then it is automatically assigned to the user who is creating order
    if quick_order_flag == 'N' and order.trans_type == TRANS_TYPE_REGULAR_ORDER and order.artworkreceived_flag == 'Y' and order.new_record?
      orderassignedtouser_id = parse_xml(doc/'created_by') if (doc/'created_by').first
      orderassignedtouser_code = parse_xml(doc/'updated_by_code') if (doc/'updated_by_code').first
      order.order_status = ORDER_PICKED ; order.orderpickstatus_flag = 'Y'
      order.orderassignedtouser_id = orderassignedtouser_id ; order.orderassignedtouser_code = orderassignedtouser_code
      order.create_sales_order_transaction_activity('ORDER PICKED')
    end

    if (orderentrycomplete_flag == 'Y' and order.orderqcstatus_flag == 'N' and order.order_status != ENTRY_COMPLETED)
      order.order_status = ENTRY_COMPLETED
      order.orderassignedtouser_code = ''
      order.orderassignedtouser_id = 0
      order.orderreassigned_flag = 'N'
      order.create_sales_order_transaction_activity(order.order_status)

      if order.qc_off_flag == 'Y'
        message,text = update_accounting_status_and_send_acknowledgement(order,schema_name,url_with_port)
        if text == 'error'
          order.create_sales_order_transaction_activity("ERROR OCCURRED: DURING QC")
        end
      end   
    elsif (order.orderentrycomplete_flag == 'Y' and orderqcstatus_flag == 'Y' and order.order_status != QC_COMPLETE)
      order.order_status = QC_COMPLETE
      order.create_sales_order_transaction_activity(order.order_status)
      message,text = update_accounting_status_and_send_acknowledgement(order,schema_name,url_with_port)
      if text == 'error'
        order.create_sales_order_transaction_activity("ERROR OCCURRED: DURING QC")
      end
    end
    #    workflow_location = Sales::CurrentLocationLogic.find_order_status(order.trans_no)
    #    order.update_attributes!(:workflow_location => workflow_location)
  end
  ## NOT IN USE
  #  def self.check_net_amt_change(doc,order,schema_name,url_with_port,net_amt)
  #    orderqcstatus_flag =  parse_xml(doc/'orderqcstatus_flag') if (doc/'orderqcstatus_flag').first
  #    orderentrycomplete_flag =  parse_xml(doc/'orderentrycomplete_flag') if (doc/'orderentrycomplete_flag').first
  #    if (order.orderacksent_flag == 'Y' and (orderqcstatus_flag == 'Y' || orderentrycomplete_flag == 'Y') and net_amt.to_f != order.net_amt.to_f and net_amt.to_f != 0)
  #      result,pdf_file_name_path = generate_regular_order_pdf(order,schema_name,url_with_port,false)
  #      if result == true
  #        email = Email::Email.send_email('ORDERACKNOWLEDGMENT',order)
  #        email.file_name_path = pdf_file_name_path
  #        email.save!
  #        activity_message = Artwork::ArtworkCrud.create_activity_message(order,'ORDER ACKNOWLEDGMENT RE-SENT')
  #        activity = order.create_sales_order_transaction_activity(activity_message)
  #      end
  #    end
  #  end

  def self.check_net_amt_and_qty_change(doc,order,schema_name,url_with_port)
    id =  parse_xml(doc/'id') if (doc/'id').first
    if id != ''
      sales_order = Sales::SalesOrder.find_by_id(id)
      customer_contact = sales_order.customer_contact
      item_qty = sales_order.item_qty
      net_amt =  sales_order.net_amt
      orderqcstatus_flag =  parse_xml(doc/'orderqcstatus_flag') if (doc/'orderqcstatus_flag').first
      orderentrycomplete_flag =  parse_xml(doc/'orderentrycomplete_flag') if (doc/'orderentrycomplete_flag').first
      if (order.orderacksent_flag == 'Y' and (orderqcstatus_flag == 'Y' || orderentrycomplete_flag == 'Y') and ((net_amt.to_f != order.net_amt.to_f and net_amt.to_f != 0) or (item_qty.to_i != order.item_qty.to_i and item_qty.to_i != 0 ) or (order.customer_contact != customer_contact and customer_contact != '')))
        result,pdf_file_name_path = Sales::SalesOrderCrud.generate_regular_order_pdf(order,schema_name,url_with_port,false)
        if result == true
          email = Email::Email.send_email('ORDERACKNOWLEDGMENT',order)
          email.file_name_path = pdf_file_name_path
          activity_message = Artwork::ArtworkCrud.create_activity_message(order,'ORDER ACKNOWLEDGMENT RE-SENT')
          order.create_sales_order_transaction_activity(activity_message)
          return email
        end
      end
    end
  end

  def self.update_accounting_status_and_send_acknowledgement(order,schema_name,url_with_port)
    begin
      Sales::InventoryValidationUtility.validate_inventory(order) if (order.trans_type == TRANS_TYPE_REGULAR_ORDER || order.trans_type == TRANS_TYPE_REORDER)
      if order.term_code == 'CC' and order.trans_type != TRANS_TYPE_VIRTUAL_ORDER
        #        payment = Payment::CustomerPaymentTransaction.find_by_sales_order_id_and_customer_id_and_response_code_and_payment_release_flag(order.id,order.customer_id,1,'N')
        if order.payment_authorize_flag == 'Y'
          order.accountreviewed_flag = 'Y';order.accounting_status = CLEAR
          order.create_sales_order_transaction_activity('PAYMENT BY: CREDIT CARD,ACCOUNT REVIEWED INTERNALLY')
        else
          order.payment_status = PAY_ISSUE
        end
      elsif(order.trans_type != TRANS_TYPE_VIRTUAL_ORDER)
        customer = Customer::Customer.find_by_id(order.customer_id)
        pending_amount = get_orders_pending_amount(order.customer_id)
        credit_limit = Accounting::AccountingCrud.fetch_customer_daily_credit_limit(customer)
        if (credit_limit >= pending_amount)
          order.accountreviewed_flag = 'Y';order.accounting_status = CLEAR;order.payment_status = CREDIT_AUTHORIZED
          order.create_sales_order_transaction_activity("PAYMENT BY: TERM #{order.term_code},ACCOUNT REVIEWED INTERNALLY")
        else
          order.payment_status = OVER_CREDIT_LIMIT
        end
      end
      if (order.acknowledgment_status == NOT_SENT)
        result,pdf_file_name_path = generate_regular_order_pdf(order,schema_name,url_with_port,false)
        if result == true
          email = Email::Email.send_email('ORDERACKNOWLEDGMENT',order)
          email.file_name_path = pdf_file_name_path
          email.save!
          order.acknowledgment_status = SENT;order.orderacksent_flag = 'Y'
          order.create_sales_order_transaction_activity('ORDER ACKNOWLEDGMENT SENT')
        else
          order.create_sales_order_transaction_activity("SOME ERROR OCCURRED WHILE SENDING ACKNOWLEDGMENT")
        end
      end
      return 'successfull','success'
    rescue Exception => ex
      return ex,'error'
    end
  end

  def self.get_orders_pending_amount(customer_id)
    pending_orders = Sales::SalesOrder.find_all_by_customer_id_and_invoiced_flag(customer_id,'N')
    order_amount = 0.00
    pending_orders.each{|pending_order|
      order_amount = order_amount + nulltozero(pending_order.net_amt)
    }
    return order_amount
  end

  def self.create_customer_shippings(doc,order)
    customer_shippings = []
    (doc/:sales_order_shippings/:sales_order_shipping).each{|shipping|
      customer_shipping_id =  parse_xml(shipping/'customer_shipping_id') if (shipping/'customer_shipping_id').first
      if (!customer_shipping_id || customer_shipping_id == '')
        customer_shipping,text = Customer::CustomerCrud.create_customer_shippings(shipping,order)
        if text == 'error'
          break
        else
          customer_shippings << customer_shipping
        end
      end
    }
    customer_shippings
  end

  
  ## Used In REORDER screen to fetch shipped orders fetch by id and trans no(when order is quick reorder then trans_no is used bcos id is not available)
  def self.show_shipped_order_dtls(order_id,trans_no)
    if (order_id and order_id != 'null')
      Sales::SalesOrder.find_all_by_id(order_id)
    elsif(trans_no and trans_no != 'null')
      Sales::SalesOrder.find_all_by_trans_no(trans_no)
    end
  end
  ## Tekweld PickOrder Services ##
  def self.list_pick_orders(doc)
    #    criteria = Setup::Criteria.fill_criteria_for_query(doc/:criteria)
    condition = "sales_orders.trans_flag = 'A' AND sales_orders.orderpickstatus_flag = 'N' AND
                 ((sales_orders.artworkreceived_flag = 'Y' AND sales_orders.trans_type in ('E','V','F')) or
                 ((sales_orders.artworkreceived_flag = 'Y' or sales_orders.blank_order_flag = 'Y') AND sales_orders.trans_type = 'S') or
                 sales_orders.trans_type = 'P')
                 AND sales_orders.orderentrycomplete_flag = 'N' AND 
                 sales_orders.ordercancelstatus_flag = 'N' AND
                 0 = (select COUNT(*) from queries
                 where queries.sales_order_id=sales_orders.id and trans_flag = 'A' and query_type = 'Order' and answer_flag='N')"
    Sales::SalesOrder.find_by_sql ["select CAST((
                                  select(select sales_orders.trans_type,
                                                sales_orders.id,
                                                sales_orders.ext_ref_no,
                                                sales_orders.trans_no,
                                                sales_orders.trans_date,
                                                sales_orders.customer_code,
                                                sales_orders.logo_name,
                                                sales_orders.ship_date,
                                                sales_orders.rushorder_flag,
                                                sales_orders.order_status,
                                                sales_orders.order_flagged,
                                                sales_orders.workflow_location,
                                                types.description as order_type
                                  from sales_orders
                                  left outer join types on (
                                        types.type_cd = 'trans_type'
                                        and types.subtype_cd = 'so'
                                        and sales_orders.trans_type = types.value
                                       )
                                  where #{condition}
                                  order by sales_orders.rushorder_flag desc, sales_orders.order_flagged desc, sales_orders.ext_ref_date
                                   FOR XML PATH('sales_order'), TYPE,ELEMENTS XSINIL
                                  )FOR XML PATH('sales_orders')) AS varchar(MAX)) as xmlcol"
    ]
  end
  
  def self.hold_pick_order(doc)
    id = parse_xml(doc/:params/'id')
    orderassignedtouser_id = parse_xml(doc/:params/'orderassignedtouser_id')
    orderassignedtouser_code = parse_xml(doc/:params/'orderassignedtouser_code')
    order = Sales::SalesOrder.find_by_id(id)
    if !order
      return 'Order not found. Please Refresh your screen.','error'
    end
    if order.order_status != NEW_ORDER and order.orderpickstatus_flag == 'Y'
      return 'Order Already Assigned. Please Refresh your screen.','error'
    end
    query = Sales::Query.find_by_sales_order_id_and_query_type_and_answer_flag(order.id,'Order','N')
    return 'This order contains some queries once they answered then you can pick this order.','error' if query
    begin
      order.order_status = ORDER_PICKED ; order.orderpickstatus_flag = 'Y'
      order.orderassignedtouser_id = orderassignedtouser_id ; order.orderassignedtouser_code = orderassignedtouser_code
      activity_message = Artwork::ArtworkCrud.create_activity_message(order,'ORDER PICKED')
      order.create_sales_order_transaction_activity(activity_message)
      workflow_location = Sales::CurrentLocationLogic.find_order_location(order,order.order_status,order.artwork_status)
      order.workflow_location = workflow_location
      save_proc = Proc.new{
        order.save!
      }
      order.save_transaction(&save_proc)
      return 'Order Assigned Successfully','success'
    rescue Exception => ex
      return ex,'error'
    end
  end

  ## Tekweld Quality Check Services ##
  def self.list_quality_check_orders(doc)
    #    criteria = Setup::Criteria.fill_criteria_for_query(doc/:criteria)
    condition = "sales_orders.trans_flag = 'A'
                     AND sales_orders.orderentrycomplete_flag = 'Y' AND sales_orders.ordercancelstatus_flag = 'N'
                     AND sales_orders.orderqcstatus_flag = 'N' AND sales_orders.qc_off_flag = 'N' AND sales_orders.trans_type in ('S','E','V','P','F')"
    Sales::SalesOrder.find_by_sql ["select CAST((
                                  select(select sales_orders.trans_type,
                                                sales_orders.id,
                                                sales_orders.ext_ref_no,
                                                sales_orders.trans_no,
                                                sales_orders.trans_date,
                                                sales_orders.customer_code,
                                                sales_orders.logo_name,
                                                sales_orders.ship_date,
                                                sales_orders.rushorder_flag,
                                                sales_orders.order_status,
                                                sales_orders.order_flagged,
                                                sales_orders.workflow_location,
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
                                  )FOR XML PATH('sales_orders')) AS varchar(MAX)) as xmlcol"
    ]
  end
  
  def self.list_assigned_orders(doc)
    criteria = Setup::Criteria.fill_criteria_for_query(doc/:criteria)
    condition = "sales_orders.trans_flag = 'A' AND sales_orders.orderpickstatus_flag = 'Y' AND
                 sales_orders.orderentrycomplete_flag = 'N' AND sales_orders.trans_type in ('S','E','V','P','F')  AND 
                 sales_orders.ordercancelstatus_flag = 'N' AND sales_orders.orderassignedtouser_id = #{criteria.user_id}"
    Sales::SalesOrder.find_by_sql ["select CAST((
                                  select(select sales_orders.trans_type,
                                                sales_orders.id,
                                                sales_orders.ext_ref_no,
                                                sales_orders.trans_no,
                                                sales_orders.trans_date,
                                                sales_orders.customer_code,
                                                sales_orders.logo_name,
                                                sales_orders.ship_date,
                                                sales_orders.rushorder_flag,
                                                sales_orders.order_status,
                                                sales_orders.order_flagged,
                                                sales_orders.workflow_location,
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
                                  )FOR XML PATH('sales_orders')) AS varchar(MAX)) as xmlcol"
    ]
  end
  
  ## Fetch shipvia methods and description
  def self.fetch_shipvia_methods(code)
    condition = "(type_cd = ? AND subtype_cd = ?)"
    Sales::SalesOrder.find_by_sql ["select CAST((
                                  select(select value as ship_method,description as ship_method_description from types
                                  where #{condition}
                                   FOR XML PATH('ship_via'), TYPE,ELEMENTS XSINIL
                                  )FOR XML PATH('ship_vias')) AS varchar(MAX)) as xmlcol",
      code,code]

  end
  
  #Sales Standard/Regular AND ReOrder Order services for order revert stages
  def self.list_all_orders(doc)
    criteria = Setup::Criteria.fill_criteria_for_query(doc/:criteria)
    condition = "( sales_orders.company_id = #{criteria.company_id}) AND
                     (customer_code between '#{criteria.str1}' and '#{criteria.str2}' AND (0 =#{criteria.multiselect1.length} or customer_code in ('#{criteria.multiselect1}'))) AND
                     (sales_orders.trans_no between '#{criteria.str3}' and '#{criteria.str4}' AND (0 =#{criteria.multiselect2.length} or sales_orders.trans_no in ('#{criteria.multiselect2}'))) AND
                     (sales_orders.trans_date between '#{criteria.dt1}' and '#{criteria.dt2}' ) AND
                     (sales_orders.account_period_code between '#{criteria.str5[0,8]}' and '#{criteria.str6[0,8]}' AND (0 =#{criteria.multiselect3.length} or sales_orders.account_period_code in ('#{criteria.multiselect3}')))  AND
                     (sales_orders.logo_name between '#{criteria.str7}' and '#{criteria.str8}' AND (0 =#{criteria.multiselect4.length} or sales_orders.logo_name in ('#{criteria.multiselect4}')))  AND
                     (sales_orders.ext_ref_no between '#{criteria.str9}' and '#{criteria.str10}' AND (0 =#{criteria.multiselect5.length} or sales_orders.ext_ref_no in ('#{criteria.multiselect5}'))) AND
                      sales_orders.trans_type in ('S','E','F') and sales_orders.shipped_flag = 'N' and sales_orders.trans_flag = 'A' and
                      sol.item_type = 'I' and sol.trans_flag = 'A' and sol.direct_production_flag = 'N' AND sales_orders.sub_ref_type <> 'S'"

    condition = convert_sql_to_db_specific(condition)
    Sales::SalesOrder.find_by_sql ["select CAST((
                                  select(select sales_orders.*,types.description as order_type
                                  from sales_orders
                                  inner join sales_order_lines sol on sol.sales_order_id = sales_orders.id
                                  left outer join types on (
                                        types.type_cd = 'trans_type'
                                        and types.subtype_cd = 'so'
                                        and sales_orders.trans_type = types.value 
                                       )
                                  where #{condition}
                                  FOR XML PATH('sales_order'), TYPE,ELEMENTS XSINIL
                                  )FOR XML PATH('sales_orders')) AS varchar(MAX)) as sales_orders"
    ]
  end

  
  def self.show_order_and_artwork_flow(order_id)
    Sales::SalesOrder.find_by_sql ["select CAST((
                                  select(select orderpickstatus_flag,orderentrycomplete_flag,orderacksent_flag,orderqcstatus_flag,accountreviewed_flag,
                                                artworkreceived_flag,artworkassigned_flag,artworkcompleted_flag,artworkreviewed_flag,artworksenttocust_flag,
                                                artworkapprovedbycust_flag from sales_orders
                                  where sales_orders.id = ?
                                   FOR XML PATH('sales_order'), TYPE,ELEMENTS XSINIL
                                  )FOR XML PATH('sales_orders')) AS varchar(MAX)) as xmlcol",order_id]
  end
  ## this service is used to show the order trail used for reorder.
  def self.show_order_trail(trans_no)
    Sales::SalesOrder.find_by_sql ["WITH sales_orders1 (trans_no,ref_trans_no,ext_ref_no,trans_date)
                                    AS
                                    (
                                      select trans_no , ref_trans_no,ext_ref_no,trans_date from sales_orders where trans_no = ?
                                      UNION ALL
                                      select a.trans_no , a.ref_trans_no,a.ext_ref_no,a.trans_date from sales_orders a
                                      Inner JOIN sales_orders1 ON
                                      a.trans_no = sales_orders1.ref_trans_no
                                    )
                                   select CAST((select(
                                   select * from sales_orders1
                                   FOR XML PATH('sales_order'), TYPE,ELEMENTS XSINIL
                                   )FOR XML PATH('sales_orders')) AS varchar(MAX)) as xmlcol",trans_no]
  end

  #### services to fetch orders from sales_invoice screen
  def self.list_open_standard_orders_hdr(doc)
    criteria = Setup::Criteria.fill_criteria_for_query(doc/:criteria)
    Sales::SalesOrder.find_by_sql ["select CAST( (select(select distinct sales_orders.id, sales_orders.trans_no, sales_orders.trans_date, sales_orders.ext_ref_no as customer_order_no from sales_orders
                                    join sales_order_lines b on b.sales_order_id = sales_orders.id
                                    join catalog_items on catalog_items.id = b.catalog_item_id
                                    where (sales_orders.trans_flag = 'A') AND b.sales_order_id = sales_orders.id and
                                    b.item_qty > b.clear_qty and
                                    b.trans_flag='A' and
                                    sales_orders.trans_type = 'S' and
                                   (sales_orders.company_id = #{criteria.company_id})
                                    AND		sales_orders.customer_id BETWEEN #{criteria.int1} AND #{criteria.int2}
                                    order by sales_orders.trans_no
                                    FOR XML PATH('sales_order'),type,elements xsinil)FOR XML PATH('sales_orders')) AS xml) as xmlcol"
    ]
  end

  def self.list_open_standard_order_lines(doc)
    criteria = Setup::Criteria.fill_criteria_for_query(doc/:criteria)
    Sales::SalesOrder.find_by_sql ["select CAST( (select(select b.*, (b.item_qty - b.clear_qty) as open_qty,
                                    catalog_items.taxable as taxable,catalog_items.image_thumnail as image_thumnail, catalog_items.packet_require_yn as packet_require_yn,
                                    sales_orders.discount_per as hdr_discount_per, 
                                    sales_orders.discount_amt as hdr_discount_amt, 
                                    sales_orders.tax_per as hdr_tax_per, 
                                    sales_orders.tax_amt as hdr_tax_amt from sales_orders
                                    join sales_order_lines b on b.sales_order_id = sales_orders.id 
                                    join catalog_items on catalog_items.id = b.catalog_item_id
                                    where (sales_orders.trans_flag = 'A') AND b.sales_order_id = sales_orders.id and
                                    b.item_qty > b.clear_qty and
                                    b.trans_flag='A' and
                                    sales_orders.trans_type = 'S' and
                                    (sales_orders.company_id = #{criteria.company_id})
                                    AND		sales_orders.id BETWEEN #{criteria.int1} AND #{criteria.int2}
                                    order by sales_orders.trans_date, sales_orders.trans_no, b.serial_no
                                    FOR XML PATH('sales_order'),type,elements xsinil)FOR XML PATH('sales_orders')) AS xml) as xmlcol" 
    ]
  end

  def self.list_open_standard_orders(doc)
    criteria = Setup::Criteria.fill_criteria_for_query(doc/:criteria)
    Sales::SalesOrder.find_by_sql ["select CAST( (select(select b.*, (b.item_qty - b.clear_qty) as open_qty,
                                       catalog_items.taxable as taxable,catalog_items.image_thumnail as image_thumnail, catalog_items.packet_require_yn as packet_require_yn,
                                        sales_orders.discount_per as hdr_discount_per,
                                        sales_orders.discount_amt as hdr_discount_amt,
                                        sales_orders.tax_per as hdr_tax_per,
                                        sales_orders.tax_amt as hdr_tax_amt from sales_orders
                                        join sales_order_lines b on b.sales_order_id = sales_orders.id
                                        join catalog_items on catalog_items.id = b.catalog_item_id
                                        where (sales_orders.trans_flag = 'A') AND
                                        b.sales_order_id = sales_orders.id and
                                        b.item_qty > b.clear_qty and
                                        b.trans_flag='A' and
                                        sales_orders.trans_type = 'S' and
                                        ( sales_orders.company_id = ?) and
                                        sales_orders.customer_id between ? and ?
                                        order by sales_orders.trans_date, sales_orders.trans_no, b.serial_no
                                        FOR XML PATH('sales_order'),type,elements xsinil)FOR XML PATH('sales_orders')) AS xml) as xmlcol
      " ,criteria.company_id,criteria.int1,criteria.int2]
  end


  ##################  FUNCTIONS WHICH ARE CURRENTLY NOT IN USE #########################

  ## Not Using
  #  def self.generate_shipdate_change_pdf(sales_order,schema_name,url_with_port)
  #    order_id = sales_order.id
  #    path = Setup::Type.find(:first, :conditions=>['type_cd = ? and subtype_cd = ?','UPLOAD_FOLDER','REPORT_PRINT'])
  #    if path
  #      directory =  "#{Dir.getwd}" + path.value + schema_name
  #    end
  #    #    image_path="http://#{request.env['HTTP_HOST']}/images/#{schema_name}/"
  #    image_path = "http://#{url_with_port}/images/#{schema_name}/"
  #    rptfile_name = Setup::Type.find(:first, :conditions=>["type_cd = 'print_format' and subtype_cd = 'shipdate_alert'"])
  #    filename = "#{Time.now().strftime('%Y%m%d%H%M%S')}"
  #    absolute_filename = File.join(directory, filename)+ "." + "pdf"
  #    command = "#{Dir.getwd}/fop/printformatpdf_new.bat #{Dir.getwd}/fop/#{rptfile_name.value} #{schema_name}  #{absolute_filename} #{order_id} #{image_path}"
  #    result = system command
  #    puts "****************#{result}"
  #    return absolute_filename
  #  end
  ## NOt using function which fires email with attachment whenever ship date is changed
  #  def self.check_ship_date_change(doc,order,schema_name,url_with_port)
  #    ship_date =  parse_xml(doc/'ship_date') if (doc/'ship_date').first
  #    if !order.new_record? and (order.ship_date and (order.ship_date.to_date.strftime("%Y-%m-%d 00:00:00") != ship_date.to_date.strftime("%Y-%m-%d 00:00:00")))
  #      pdf_file_name_path = generate_shipdate_change_pdf(order,schema_name,url_with_port)
  #      email = Email::Email.send_email('SHIPDATEALERT',order)
  #      email.file_name_path = pdf_file_name_path
  #      email.save!
  #      activity = order.create_sales_order_transaction_activity('SHIP DATE CHANGED')
  #      activity.save!
  #    end
  #  end

  #  def self.generate_regular_order_pdf(sales_order,schema_name,url_with_port) ## this will generate pdf using report commander
  #    order_id = sales_order.id
  #    sales_order_shipping = Sales::SalesOrderShipping.active.find_all_by_sales_order_id(order_id)
  #    path = Setup::Type.find(:first, :conditions=>['type_cd = ? and subtype_cd = ?','UPLOAD_FOLDER','REPORT_PRINT'])
  #    if path
  #      directory =  "#{Dir.getwd}" + path.value + schema_name
  #    end
  #    #    image_path="http://#{request.env['HTTP_HOST']}/images/#{schema_name}/"
  #    image_path = "http://#{url_with_port}/images/#{schema_name}/"
  #    filename = "#{Time.now().strftime('%Y%m%d%H%M%S')}"
  #    absolute_filename = File.join(directory, filename)+ "." + "pdf"
  #    begin
  #      if sales_order_shipping[1]## detects whether the order contains multiple shipping
  #        rptfile_name = Setup::Type.find(:first, :conditions=>["type_cd = 'print_format' and subtype_cd = 'ack_order_shipping'"])
  #        command = "#{Dir.getwd}/fop/printformatpdf_new.bat #{Dir.getwd}/fop/#{rptfile_name.value} #{schema_name}  #{absolute_filename} #{order_id} #{image_path}"
  #      else
  #        rptfile_name = Setup::Type.find(:first, :conditions=>["type_cd = 'print_format' and subtype_cd = 'ack_order'"])
  #        command = "#{Dir.getwd}/fop/printformatpdf_new.bat #{Dir.getwd}/fop/#{rptfile_name.value} #{schema_name}  #{absolute_filename} #{order_id} #{image_path}"
  #      end
  #      result = system command
  #    rescue Exception => ex
  #      return result,ex
  #    end
  #    return result,absolute_filename
  #  end

  ## NOT IN USE Function to make different XML for sales_order_attributes_values used in tekweld in sample and virtual orders
  #  def self.create_soav_xml(so_lines_doc,order)
  #    xml_string = "<sales_order_attributes_values>"
  #    so_lines_doc.each{|so_line|
  #      #      catalog_item_id = parse_xml(so_line/'catalog_item_id')
  #      company_id = parse_xml(so_line/'company_id')
  #      line_id = parse_xml(so_line/'id')
  #      if line_id == ''
  #        max_serial_no = order.sales_order_lines.maximum_serial_no
  #        serial_no  = (max_serial_no.to_i + 1).to_s
  #      else
  #        serial_no = parse_xml(so_line/'serial_no')
  #      end
  #      line_trans_flag = parse_xml(so_line/'trans_flag') || 'A'
  #      (so_line/:sales_order_attributes_values/:sales_order_attributes_value).each{|so_attribute_value_doc|
  #        catalog_attribute_code = parse_xml(so_attribute_value_doc/'catalog_attribute_code')
  #        catalog_attribute_value_code = parse_xml(so_attribute_value_doc/'catalog_attribute_value_code')
  #        trans_flag = parse_xml(so_attribute_value_doc/'trans_flag')
  #        remarks = parse_xml(so_attribute_value_doc/'remarks')
  #        catalog_item_id = parse_xml(so_attribute_value_doc/'catalog_item_id')
  #        id = parse_xml(so_attribute_value_doc/'id')
  #        update_flag = parse_xml(so_attribute_value_doc/'update_flag') || 'Y'
  #        lock_version = parse_xml(so_attribute_value_doc/'lock_version') || 0
  #        xml_string = xml_string+"<sales_order_attributes_value>"
  #        xml_string = xml_string +"<catalog_attribute_code>#{catalog_attribute_code}</catalog_attribute_code>"
  #        xml_string = xml_string +"<catalog_attribute_value_code>#{catalog_attribute_value_code}</catalog_attribute_value_code>"
  #        xml_string = xml_string +"<id>#{id}</id>"
  #        xml_string = xml_string +"<company_id>#{company_id}</company_id>"
  #        xml_string = xml_string +"<update_flag>#{update_flag}</update_flag>"
  #        xml_string = xml_string +"<remarks>#{remarks}</remarks>"
  #        if line_trans_flag == 'D'
  #          xml_string = xml_string +"<trans_flag>#{line_trans_flag}</trans_flag>"
  #        else
  #          xml_string = xml_string +"<trans_flag>#{trans_flag}</trans_flag>"
  #        end
  #        xml_string = xml_string +"<trans_date>#{Time.new.to_date.strftime("%Y-%m-%d 00:00:00")}</trans_date>"
  #        xml_string = xml_string +"<lock_version>#{lock_version}</lock_version>"
  #        xml_string = xml_string +"<ref_serial_no>#{serial_no}</ref_serial_no>"
  #        xml_string = xml_string +"<catalog_item_id>#{catalog_item_id}</catalog_item_id>"
  #        xml_string = xml_string+"</sales_order_attributes_value>"
  #      }
  #    }
  #    xml_string = xml_string+"</sales_order_attributes_values>"
  #    xml = %{#{xml_string}}
  #    doc = Hpricot::XML(xml)
  #    return doc
  #  end

  #  def self.update_artwork_status(doc,order) NOT is use
  #    order.sales_order_artworks.each{ |line|
  #      if (line.new_record? and line.artwork_version =~ (/Customer Art(.*)/) and line.trans_flag == 'A' and line.artworkreceivedflag == 'N')
  #        order.artworkreceived_flag = 'Y'
  #        order.artwork_status = 'ARTWORK RECEIVED'
  #        activity = order.create_sales_order_transaction_activity(order.artwork_status)
  #        activity.save!
  #      elsif(line.new_record? and line.trans_flag == 'A' and !line.artwork_version =~ (/Customer Art(.*)/) and order.artwork_status != 'WAITING ARTWORK')
  #        order.artworkreceived_flag = 'N'
  #        order.artwork_status = 'WAITING ARTWORK'
  #        activity = order.create_sales_order_transaction_activity(order.artwork_status)
  #        activity.save!
  #      else
  #        activity = order.create_sales_order_transaction_activity("#{line.artwork_version} IS RECEIVED")
  #        activity.save!
  #      end
  #    }
  #  end

  #  ## this service is not in use it prints PDF using report commander we are using PRAWN PDF and call same function which we call after QC is done.
  #  def self.resend_order_acknowledgment(order_id,schema_name,url_with_port)
  #    sales_order = Sales::SalesOrder.find_by_id(order_id)
  #    order_id = sales_order.id
  #    sales_order_shipping = Sales::SalesOrderShipping.active.find_all_by_sales_order_id(order_id)
  #    path = Setup::Type.find(:first, :conditions=>['type_cd = ? and subtype_cd = ?','UPLOAD_FOLDER','REPORT_PRINT'])
  #    if path
  #      directory =  "#{Dir.getwd}" + path.value + schema_name
  #    end
  #    image_path = "http://#{url_with_port}/images/#{schema_name}/"
  #    filename = "#{Time.now().strftime('%Y%m%d%H%M%S')}"
  #    absolute_filename = File.join(directory, filename)+ "." + "pdf"
  #    begin
  #      if sales_order_shipping[1]## detects whether the order contains multiple shipping
  #        rptfile_name = Setup::Type.find(:first, :conditions=>["type_cd = 'print_format' and subtype_cd = 'ack_order_shipping'"])
  #        command = "#{Dir.getwd}/fop/printformatpdf_new.bat #{Dir.getwd}/fop/#{rptfile_name.value} #{schema_name}  #{absolute_filename} #{order_id} #{image_path}"
  #      else
  #        rptfile_name = Setup::Type.find(:first, :conditions=>["type_cd = 'print_format' and subtype_cd = 'ack_order'"])
  #        command = "#{Dir.getwd}/fop/printformatpdf_new.bat #{Dir.getwd}/fop/#{rptfile_name.value} #{schema_name}  #{absolute_filename} #{order_id} #{image_path}"
  #      end
  #      result = system command
  #      if result == true
  #        email = Email::Email.send_email('ORDERACKNOWLEDGMENT',sales_order)
  #        email.file_name_path = absolute_filename
  #        email.save!
  #      end
  #    rescue Exception => ex
  #      return ex
  #    end
  #    return result
  #  end
end

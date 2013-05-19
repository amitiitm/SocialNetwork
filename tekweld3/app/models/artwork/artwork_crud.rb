class Artwork::ArtworkCrud
  include General
  #  Trans Type Codes
  #  S	Regular Order
  #  E	Re-Order
  #  P	Sample Order
  #  V	Virtual Order
  #  F	Spec Order

  ## ArtWork  Services ##
  def self.hold_artwork(doc)
    id = parse_xml(doc/:params/'id')
    artworkassignedtouser_id = parse_xml(doc/:params/'artworkassignedtouser_id')
    artworkassignedtouser_code = parse_xml(doc/:params/'artworkassignedtouser_code')
    order = Sales::SalesOrder.find_by_id(id)
    if !order
      return 'Order not found. Please Refresh your screen.','error'
    end
    if order.artworkassigned_flag == 'Y'
      return 'Artwork Already Assigned. Please Refresh your screen.','error'
    end
    query = Sales::Query.find_by_sales_order_id_and_query_type_and_answer_flag(order.id,'Artwork','N')
    return 'This Artwork contains some queries once they answered then you can pick this Artwork.','error' if query
    begin
      order.artwork_status = PROOF_IN_PROGRESS ; order.artworkassigned_flag = 'Y'
      order.artworkassignedtouser_id = artworkassignedtouser_id; order.artworkassignedtouser_code = artworkassignedtouser_code
      activity_message = create_activity_message(order,'PROOF IN PROGRESS')
      order.create_sales_order_transaction_activity(activity_message)
      workflow_location = Sales::CurrentLocationLogic.find_order_location(order,order.order_status,order.artwork_status)
      order.workflow_location = workflow_location
      save_proc = Proc.new{
        order.save!
      }
      order.save_transaction(&save_proc)
      return 'Artwork Assigned Successfully','success'
    rescue Exception => ex
      return ex,'error'
    end
  end

  # pick artwork screen
  def self.list_unfinished_artwork_inbox(doc)
    #    criteria = Setup::Criteria.fill_criteria_for_query(doc/:criteria)
    condition = "sales_orders.trans_flag = 'A' AND sales_orders.artworkreceived_flag = 'Y' AND sales_orders.blank_order_flag <> 'Y' AND
                 (sales_orders.orderentrycomplete_flag = 'Y' AND (sales_orders.qc_off_flag = 'Y' or sales_orders.orderqcstatus_flag = 'Y')) AND
                 sales_orders.artworkassigned_flag = 'N' AND sales_orders.trans_type in ('S','E','V','F') AND
                 sales_orders.ordercancelstatus_flag <> 'Y' AND
                 0 = (select COUNT(*) from queries
                 where queries.sales_order_id=sales_orders.id and trans_flag = 'A' and query_type = 'Artwork' and answer_flag='N')  "
    Sales::SalesOrder.find_by_sql ["select CAST((
                                  select(select sales_orders.id,
                                                sales_orders.trans_type,
                                                sales_orders.ext_ref_no,
                                                sales_orders.trans_no,
                                                sales_orders.trans_date,
                                                sales_orders.ship_date,
                                                sales_orders.customer_code,
                                                sales_orders.logo_name,
                                                sales_orders.order_status,
                                                sales_orders.rushorder_flag,
                                                sales_orders.order_flagged,
                                                sales_orders.workflow_location,
                                                types.description as order_type
                                  from sales_orders
                                  inner join customers on customers.id = sales_orders.customer_id
                                  left outer join types on (
                                        types.type_cd = 'trans_type'
                                        and types.subtype_cd = 'so'
                                        and sales_orders.trans_type = types.value
                                       )
                                  where #{condition}
                                  order by sales_orders.rushorder_flag desc, sales_orders.order_flagged desc, sales_orders.ship_date
                                   FOR XML PATH('sales_order'), TYPE,ELEMENTS XSINIL
                                  )FOR XML PATH('sales_orders')) AS varchar(MAX)) as xmlcol"
    ]
  end

  ## for review artwork screen
  def self.list_finished_artwork_inbox(doc)
    criteria = Setup::Criteria.fill_criteria_for_query(doc/:criteria)
    condition = "( sales_orders.company_id = #{criteria.company_id}) AND
                     (customers.code between '#{criteria.str1}' and '#{criteria.str2}' AND (0 =#{criteria.multiselect1.length} or customers.code in ('#{criteria.multiselect1}'))) AND
                     (trans_no between '#{criteria.str3}' and '#{criteria.str4}' AND (0 =#{criteria.multiselect2.length} or trans_no in ('#{criteria.multiselect2}'))) AND
                     (trans_date between '#{criteria.dt1}' and '#{criteria.dt2}' ) AND
                     (account_period_code between '#{criteria.str5[0,8]}' and '#{criteria.str6[0,8]}' AND (0 =#{criteria.multiselect3.length} or account_period_code in ('#{criteria.multiselect3}')))
                     AND (logo_name between '#{criteria.str7}' and '#{criteria.str8}' AND (0 =#{criteria.multiselect4.length} or logo_name in ('#{criteria.multiselect4}')))
                     AND (ext_ref_no between '#{criteria.str9}' and '#{criteria.str10}' AND (0 =#{criteria.multiselect5.length} or ext_ref_no in ('#{criteria.multiselect5}')))
                     AND sales_orders.trans_flag = 'A' AND sales_orders.artworkreviewed_flag = 'N' and sales_orders.ordercancelstatus_flag <> 'Y'
                     AND sales_orders.artworkcompleted_flag = 'Y' AND sales_orders.trans_type in ('S','E','V','F')"
    Sales::SalesOrder.find_by_sql ["select CAST((
                                  select(select sales_orders.id,
                                                sales_orders.trans_type,
                                                sales_orders.ext_ref_no,
                                                sales_orders.trans_no,
                                                sales_orders.trans_date,
                                                sales_orders.customer_code,
                                                sales_orders.logo_name,
                                                sales_orders.ship_date,
                                                sales_orders.order_status,
                                                sales_orders.artwork_status,
                                                sales_orders.payment_status,
                                                sales_orders.rushorder_flag,
                                                sales_orders.order_flagged,
                                                sales_orders.workflow_location,
                                                types.description as order_type
                                  from sales_orders
                                  inner join customers on customers.id = sales_orders.customer_id
                                  left outer join types on (
                                        types.type_cd = 'trans_type'
                                        and types.subtype_cd = 'so'
                                        and sales_orders.trans_type = types.value
                                       )
                                  where #{condition}
                                  order by sales_orders.rushorder_flag desc, sales_orders.order_flagged desc, sales_orders.ship_date
                                   FOR XML PATH('sales_order'), TYPE,ELEMENTS XSINIL
                                  )FOR XML PATH('sales_orders')) AS varchar(MAX)) as xmlcol"
    ]
  end

  def self.upload_artwork_attachments(uploaded_file,schema_name)
    begin
      file_name,folder_name = IO::FileIO.save_attachment(uploaded_file,schema_name)
    rescue Exception => ex
      puts "************Exception-- #{ex},File Name--#{file_name},Folder Name--#{folder_name}********"
      return 'error'
    end
    return 'success'
  end

  def self.show_assigned_artwork(order_id)
    Sales::SalesOrder.find_all_by_id(order_id)
  end

  def self.create_artworks(doc,schema_name)
    orders = []
    (doc/:sales_orders/:sales_order).each{|order_doc|
      order = create_artwork(order_doc,schema_name)
      orders <<  order if order
    }
    orders
  end

  def self.create_artwork(doc,schema_name)
    order = add_or_modify_artwork(doc)
    return  if !order
    order.apply_header_fields_to_lines
    order.apply_line_fields_to_header
    # Update Artwork Status
    update_artwork_status(doc,order)
    # Sending proof to customer automatically when the paper proof required = 'N' and artwork status = 'Artwork QC'
    if (order.paper_proof_flag == 'N' and order.artworkreviewed_flag == 'Y' and order.artworksenttocust_flag == 'N' and order.artwork_status == ARTWORK_QC)
      email,result = send_artwork_to_customer(order,schema_name)  
      return order if result == 'error'
    end
    save_proc = Proc.new{
      if order.new_record?
        order.save!
      else
        order.save!
        order.save_lines
      end
      email.save! if email
      if ((order.trans_type != TRANS_TYPE_VIRTUAL_ORDER and order.trans_type != TRANS_TYPE_SAMPLE_ORDER) and
            order.paper_proof_flag == 'N' and order.artworkreviewed_flag == 'Y' and order.artworksenttocust_flag == 'Y' and order.artwork_status == SENT_TO_CUSTOMER )
        send_for_stitch_estimation(order)
        # object of order is changed inside send_for_stitch_estimation so we have to find it again due to error - data changed.
        order = Sales::SalesOrder.find_by_trans_no(order.trans_no)
      end
      workflow_location = Sales::CurrentLocationLogic.find_order_location(order,order.order_status,order.artwork_status)
      order.update_attributes!(:workflow_location => workflow_location)
    }
    order.save_transaction(&save_proc)
    return order
  end

  def self.add_or_modify_artwork(doc)
    id =  parse_xml(doc/'id') if (doc/'id').first
    order = Sales::SalesOrder.find_or_create(id)
    return if !order
    if !order.new_record? and order.update_flag == 'V'
      order.errors[:base] << 'This Order is View Only. Cannot update.'
      #      order.errors.add('This Order is View Only. Cannot update.')
      return order
    end
    order.apply_attributes(doc)
    order.run_block do
      order.max_serial_no = order.sales_order_artworks.maximum_serial_no
      order.build_lines(doc/:sales_order_artworks/:sales_order_artwork)
      order.max_serial_no = order.queries.maximum_serial_no
      order.build_lines(doc/:queries/:query)
    end
    return order
  end

  def self.update_artwork_status(doc,order)
    artworkcompleted_flag =  parse_xml(doc/'artworkcompleted_flag') if (doc/'artworkcompleted_flag').first
    artworkreviewed_flag =  parse_xml(doc/'artworkreviewed_flag') if (doc/'artworkreviewed_flag').first

    # This condition might be used for pre-production or re-order flow. Still to confirm.
    order.sales_order_lines.each{|line|
      if line.item_type == 'I'
        line.imposition_flag = 'N' ; line.print_flag = 'N'; line.film_flag = 'N'
        line.cut_flag = 'N' ; line.stitch_flag = 'N' ; line.reject_from_imposition_flag = 'N'
        line.print_ready_flag = 'N'
      end
    }
    # ARTWORK STATUS CONDITIONS
    if (artworkcompleted_flag == 'Y' and order.artworkreviewed_flag == 'N' and order.artwork_status == PROOF_IN_PROGRESS)
      order.artwork_status = READY_FOR_INTERNAL_PROOFING
      activity_message = create_activity_message(order,'READY FOR INTERNAL PROOFING')
      order.create_sales_order_transaction_activity(activity_message)
    elsif (artworkreviewed_flag == 'Y' and order.artworksenttocust_flag == 'N' and 
          (order.artwork_status == READY_FOR_INTERNAL_PROOFING || order.artwork_status == PROOF_REJECTED ||
            order.artwork_status == REJECTED_FROM_IMPOSITION || order.artwork_status == REJECTED_FROM_FILM))
      order.artwork_status = ARTWORK_QC ; order.artworkapprovedbycust_flag = ''
      activity_message = create_activity_message(order,'ARTWORK QC')
      order.create_sales_order_transaction_activity(activity_message)
    end
  end

  def self.send_artwork_to_customer(order,schema_name)
    begin
      #Identifying Final Artwork
      artwork_obj = nil
      order.sales_order_artworks.each{|sales_order_artwork|
        if sales_order_artwork.trans_flag == 'A' and sales_order_artwork.final_artwork_flag == 'Y'
          sales_order_artwork.select_yn = 'Y'
          artwork_obj = sales_order_artwork
          break
        end
      }
      return 'Final Artwork Not Found.','error' if !artwork_obj

      #sending email with attachment
      order.customer_email = order.artwork_dept_email
      order.artwork_customer_email = order.artwork_dept_email ;
      email = Email::Email.send_email('SENDMULTIPLEARTWORK',order)
      #create the file path
      path = Setup::Type.find_by_type_cd_and_subtype_cd('UPLOAD_FOLDER','ATTACHMENT')
      directory =  "#{Dir.getwd}" + "/" + path.value + schema_name if path
      filename = File.join(directory, artwork_obj.artwork_file_name)
      email.file_name_path = filename

      #Creating Activity
      activity_message = Artwork::ArtworkCrud.create_activity_message(order,"ARTWORK #{artwork_obj.artwork_version} SENT SUCCESSFULLY TO #{order.artwork_dept_email}")
      order.create_sales_order_transaction_activity(activity_message)

      #Updating Order Status
      order.paper_proof_status = 'PROOF SENT TO CUSTOMER' ; order.artwork_status = SENT_TO_CUSTOMER
      order.artworksenttocust_flag = 'Y' ; order.paperproofsenttocust_date = Time.now
      if order.trans_type == TRANS_TYPE_VIRTUAL_ORDER
        order.update_flag = 'V' ; order.order_status = ORDER_COMPLETED ; order.shipped_flag = 'Y'
      end
      return email, 'success'
    rescue Exception => ex
      order.errors[:base] << ex
      return nil,'error'
    end
  end

  ## Incomplete ark-works based on logged in user.
  def self.list_assigned_artworks(doc)
    criteria = Setup::Criteria.fill_criteria_for_query(doc/:criteria)
    condition = "( sales_orders.company_id = #{criteria.company_id}) AND (sales_orders.artworkassignedtouser_id = #{criteria.user_id}) AND
                     (customers.code between '#{criteria.str1}' and '#{criteria.str2}' AND (0 =#{criteria.multiselect1.length} or customers.code in ('#{criteria.multiselect1}'))) AND
                     (trans_no between '#{criteria.str3}' and '#{criteria.str4}' AND (0 =#{criteria.multiselect2.length} or trans_no in ('#{criteria.multiselect2}'))) AND
                     (trans_date between '#{criteria.dt1}' and '#{criteria.dt2}' ) AND
                     (account_period_code between '#{criteria.str5[0,8]}' and '#{criteria.str6[0,8]}' AND (0 =#{criteria.multiselect3.length} or account_period_code in ('#{criteria.multiselect3}')))
                     AND (logo_name between '#{criteria.str7}' and '#{criteria.str8}' AND (0 =#{criteria.multiselect4.length} or logo_name in ('#{criteria.multiselect4}')))
                     AND (ext_ref_no between '#{criteria.str9}' and '#{criteria.str10}' AND (0 =#{criteria.multiselect5.length} or ext_ref_no in ('#{criteria.multiselect5}')))
                     AND sales_orders.trans_flag = 'A' AND sales_orders.artworkcompleted_flag = 'N'
                     AND sales_orders.artworkassigned_flag = 'Y' AND sales_orders.trans_type in ('S','E','V','F')"
    Sales::SalesOrder.find_by_sql ["select CAST((
                                  select(select sales_orders.id,
                                                sales_orders.trans_type,
                                                sales_orders.ext_ref_no,
                                                sales_orders.trans_no,
                                                sales_orders.trans_date,
                                                sales_orders.ship_date,
                                                sales_orders.customer_code,
                                                sales_orders.order_status,
                                                sales_orders.shipping_code,
                                                sales_orders.term_code,
                                                sales_orders.rushorder_flag,
                                                sales_orders.order_flagged,
                                                sales_orders.workflow_location,
                                                types.description as order_type
                                  from sales_orders
                                  inner join customers on customers.id = sales_orders.customer_id
                                  left outer join types on (
                                        types.type_cd = 'trans_type'
                                        and types.subtype_cd = 'so'
                                        and sales_orders.trans_type = types.value
                                       )
                                  where #{condition}
                                  order by sales_orders.rushorder_flag desc, sales_orders.order_flagged desc, sales_orders.ship_date
                                   FOR XML PATH('sales_order'), TYPE,ELEMENTS XSINIL
                                  )FOR XML PATH('sales_orders')) AS varchar(MAX)) as xmlcol"
    ]
  end

  ## LIST orders with paper proof required = 'Y' and not responded after reminders.
  def self.list_noresponse_paperproof_records(doc)
    criteria = Setup::Criteria.fill_criteria_for_query(doc/:criteria)
    condition = "( sales_orders.company_id = #{criteria.company_id}) AND
                     (customers.code between '#{criteria.str1}' and '#{criteria.str2}' AND (0 =#{criteria.multiselect1.length} or customers.code in ('#{criteria.multiselect1}'))) AND
                     (trans_no between '#{criteria.str3}' and '#{criteria.str4}' AND (0 =#{criteria.multiselect2.length} or trans_no in ('#{criteria.multiselect2}'))) AND
                     (trans_date between '#{criteria.dt1}' and '#{criteria.dt2}' ) AND
                     (account_period_code between '#{criteria.str5[0,8]}' and '#{criteria.str6[0,8]}' AND (0 =#{criteria.multiselect3.length} or account_period_code in ('#{criteria.multiselect3}')))
                     AND (logo_name between '#{criteria.str7}' and '#{criteria.str8}' AND (0 =#{criteria.multiselect4.length} or logo_name in ('#{criteria.multiselect4}')))
                     AND (ext_ref_no between '#{criteria.str9}' and '#{criteria.str10}' AND (0 =#{criteria.multiselect5.length} or ext_ref_no in ('#{criteria.multiselect5}')))
                     AND sales_orders.trans_flag = 'A' AND sales_orders.firstpaperproofreminder = 'Y'
                     AND sales_orders.paper_proof_flag = 'Y'
                     AND sales_orders.secondpaperproofreminder = 'Y' AND sales_orders.artworkapprovedbycust_flag = ''
                     AND sales_orders.trans_type in ('S','E','V','F')"
    Sales::SalesOrder.find_by_sql ["select CAST((
                                  select(select sales_orders.trans_bk,
                                                sales_orders.id,
                                                sales_orders.shipping_code,
                                                sales_orders.term_code,
                                                sales_orders.cancel_date,
                                                sales_orders.trans_no,
                                                sales_orders.trans_date,
                                                sales_orders.customer_code,
                                                sales_orders.logo_name,
                                                sales_orders.ship_date,
                                                sales_orders.rushorder_flag,
                                                sales_orders.order_flagged,
                                                sales_orders.workflow_location,
                                                types.description as order_type
                                  from sales_orders
                                  inner join customers on customers.id = sales_orders.customer_id
                                  left outer join types on (
                                        types.type_cd = 'trans_type'
                                        and types.subtype_cd = 'so'
                                        and sales_orders.trans_type = types.value
                                       )
                                  where #{condition}
                                  order by sales_orders.rushorder_flag desc, sales_orders.order_flagged desc, sales_orders.ship_date
                                   FOR XML PATH('sales_order'), TYPE,ELEMENTS XSINIL
                                  )FOR XML PATH('sales_orders')) AS varchar(MAX)) as xmlcol"
    ]
  end

  ######### CRUD Services for AI-CUST RESPONSE SCREEN
  ## List Service for screen to Accept or Reject customer artwork response
  def self.list_accept_reject_paperproof_records(doc)
    criteria = Setup::Criteria.fill_criteria_for_query(doc/:criteria)
    condition = "( sales_orders.company_id = #{criteria.company_id}) AND
                     (customers.code between '#{criteria.str1}' and '#{criteria.str2}' AND (0 =#{criteria.multiselect1.length} or customers.code in ('#{criteria.multiselect1}'))) AND
                     (trans_no between '#{criteria.str3}' and '#{criteria.str4}' AND (0 =#{criteria.multiselect2.length} or trans_no in ('#{criteria.multiselect2}'))) AND
                     (trans_date between '#{criteria.dt1}' and '#{criteria.dt2}' ) AND
                     (account_period_code between '#{criteria.str5[0,8]}' and '#{criteria.str6[0,8]}' AND (0 =#{criteria.multiselect3.length} or account_period_code in ('#{criteria.multiselect3}')))
                     AND (logo_name between '#{criteria.str7}' and '#{criteria.str8}' AND (0 =#{criteria.multiselect4.length} or logo_name in ('#{criteria.multiselect4}')))
                     AND (ext_ref_no between '#{criteria.str9}' and '#{criteria.str10}' AND (0 =#{criteria.multiselect5.length} or ext_ref_no in ('#{criteria.multiselect5}')))
                     AND sales_orders.trans_flag = 'A' AND sales_orders.artworksenttocust_flag = 'Y'
                     AND sales_orders.paper_proof_flag = 'Y'
                     AND sales_orders.ordercancelstatus_flag <> 'Y'
                     AND sales_orders.artworkreviewed_flag = 'Y'
                     AND (sales_orders.artworkapprovedbycust_flag = '' or sales_orders.artworkapprovedbycust_flag = 'R')
                     AND sales_orders.trans_type in ('S','E','V','F')"
    Sales::SalesOrder.find_by_sql ["select CAST((
                                  select(select sales_orders.id,
                                                sales_orders.trans_type,
                                                sales_orders.trans_no,
                                                sales_orders.trans_date,
                                                sales_orders.customer_code,
                                                sales_orders.ship_date,
                                                sales_orders.shipping_code,
                                                sales_orders.term_code,
                                                sales_orders.cancel_date,
                                                sales_orders.account_period_code,
                                                sales_orders.trans_bk,
                                                sales_orders.rushorder_flag,
                                                sales_orders.order_flagged,
                                                sales_orders.ext_ref_no,
                                                sales_orders.logo_name,
                                                sales_orders.workflow_location,
                                                types.description as order_type
                                  from sales_orders
                                  inner join customers on customers.id = sales_orders.customer_id
                                  left outer join types on (
                                        types.type_cd = 'trans_type'
                                        and types.subtype_cd = 'so'
                                        and sales_orders.trans_type = types.value
                                       )
                                  where #{condition}
                                  order by sales_orders.rushorder_flag desc, sales_orders.order_flagged desc, sales_orders.ship_date
                                   FOR XML PATH('sales_order'), TYPE,ELEMENTS XSINIL
                                  )FOR XML PATH('sales_orders')) AS varchar(MAX)) as xmlcol"
    ]
  end

  def self.show_accept_reject_paperproof_records(order_id)
    Sales::SalesOrder.find_all_by_id(order_id)
  end

  def self.create_accept_reject_paperproof_records(doc,schema_name)
    orders = []
    (doc/:sales_orders/:sales_order).each{|order_doc|
      order = create_accept_reject_paperproof_record(order_doc,schema_name)
      orders <<  order if order
    }
    orders
  end

  def self.create_accept_reject_paperproof_record(doc,schema_name)
    order = add_or_modify_accept_reject_paperproof_record(doc)
    artworkapprovedbycust_flag =  parse_xml(doc/'artworkapprovedbycust_flag') if (doc/'artworkapprovedbycust_flag').first
    no_response_flag = parse_xml(doc/'noresponse') if (doc/'noresponse')
    return  if !order
    if no_response_flag == 'Y'
      order.update_flag = 'V'
      order.order_status = 'ORDER CLOSED'
      order.workflow_location = 'ORDER CLOSED'
    end
    if artworkapprovedbycust_flag == 'A'
      if (order.do_not_change_ship_date != 'Y' and (order.ext_ref_date.to_date != Time.now.to_date))
        sales_order_shippings,emails,message = update_shipping_dates(order,schema_name)
        if message != 'success'
          order.errors[:base] << message
          return order
        end
      end
      if order.distributed_by_flag == 'Y'
        activity_message = create_activity_message(order, "Distributed By :#{order.distributed_by_text}")
        order.create_sales_order_transaction_activity(activity_message)
      end
      order,message = create_accept_activity(order)
      if message != 'success'
        order.errors[:base] << message
        return order
      end
    elsif artworkapprovedbycust_flag == 'R'
      order.sales_order_artworks.each{|artwork|
        artwork.select_yn = 'N'
        artwork.final_artwork_flag = 'N'
      }
      create_reject_activity(order)
    end
    save_proc = Proc.new{
      if order.new_record?
        order.save!
      else
        order.save!
        #order.save_lines
        sales_order_shippings.each{|shipping| shipping.save!} if sales_order_shippings
        order.sales_order_artworks.each{|artwork| artwork.save!}
      end
      emails.each{|email| email.save!} if emails
      if no_response_flag != 'Y'
        if ((order.trans_type != TRANS_TYPE_VIRTUAL_ORDER and order.trans_type != TRANS_TYPE_SAMPLE_ORDER) and artworkapprovedbycust_flag =='A')
          send_for_stitch_estimation(order)
          ## object of order is changed inside send_for_stitch_estimation so we have to find it again due to error - data changed.
          order = Sales::SalesOrder.find_by_trans_no(order.trans_no)
        end
        workflow_location = Sales::CurrentLocationLogic.find_order_status(order.trans_no)
        order.update_attributes!(:workflow_location => workflow_location)
      end
    }
    order.save_transaction(&save_proc)
    return order
  end

  def self.add_or_modify_accept_reject_paperproof_record(doc)
    id =  parse_xml(doc/'id') if (doc/'id').first
    order = Sales::SalesOrder.find_or_create(id)
    return if !order
    if !order.new_record? and order.update_flag == 'V'
      order.errors[:base] << 'This Order is View Only. Cannot update.'
      #      order.errors.add('This Order is View Only. Cannot update.')
      return order
    end
    order.apply_attributes(doc)
    order.max_serial_no = order.sales_order_lines.maximum_serial_no
    order.run_block do
      order.build_lines(doc/:sales_order_artworks/:sales_order_artwork)
    end
    return order
  end

  def self.create_accept_activity(order)
    begin
      #Identifying Final Art-work.
      artwork_approved_by_cust = ''
      order.sales_order_artworks.each{|sales_order_artwork|
        if sales_order_artwork.trans_flag == 'A' and sales_order_artwork.final_artwork_flag == 'Y'
          artwork_approved_by_cust = sales_order_artwork
          break
        end
      }
      if artwork_approved_by_cust != ''
        activity_message = create_activity_message(order,"PROOF #{artwork_approved_by_cust.artwork_version} APPROVED BY CUSTOMER")
        order.create_sales_order_transaction_activity(activity_message)
      else ## this if condition is used bcos if there is mistake from front end and AW is approved without final version then it will not give error.
        activity_message = create_activity_message(order,"ARTWORK APPROVED WITHOUT FINAL VERSION.PLEASE CHECK")
        order.create_sales_order_transaction_activity(activity_message)
      end
      order.paper_proof_status = 'PROOF APPROVED' ; order.artwork_status = PROOF_APPROVED
      order.artworkapprovedbycust_flag = 'A'
      if order.trans_type == TRANS_TYPE_VIRTUAL_ORDER
        order.shipped_flag = 'Y' ; order.update_flag = 'V'
      end
      return order,'success'
    rescue Exception => ex
      return order,ex
    end
  end

  def self.create_reject_activity(order)
    order.paper_proof_status = 'PROOF REJECTED' ; order.artwork_status = PROOF_REJECTED
    order.artworkapprovedbycust_flag = 'R' ; order.artworkreviewed_flag = 'N' ; order.artworksenttocust_flag = 'N'
    activity_message = create_activity_message(order,'PROOF REJECTED')
    order.create_sales_order_transaction_activity(activity_message)
  end

  def self.update_shipping_dates(order,schema_name)
    begin
      emails = []
      sales_order_shippings = []
      #Shippings = Sales::SalesOrderShipping.find_by_sql ["select * from sales_order_shippings where trans_flag = 'A' and sales_order_id =?",order.id]
      order.sales_order_shippings.active.each{|shipping|
        if !shipping.ship_date ## requested ship date
          if shipping.estimated_ship_date and shipping.estimated_ship_date != ''
            order_line = Sales::SalesOrderLine.find_by_sales_order_id_and_trans_flag_and_line_type_and_item_type(order.id,'A','M','I')
            estimated_ship_date = Sales::DateUtility.calculate_estimated_ship_date(order_line.catalog_item_id,Time.now.to_date.strftime('%Y/%m/%d'),order.customer_id,order.item_qty,order.rush_order_type,order.next_day_flag,'N','N')
            shipping.estimated_ship_date = estimated_ship_date
            shipping.internal_ship_date = estimated_ship_date
          end
          #          message,text = Shipping::Ups.calculate_inhand_date(shipping,estimated_ship_date)
          order_doc = Sales::DateUtility.get_sales_order_xml(shipping)
          doc = Hpricot::XML(order_doc)
          response = Sales::DateUtility.calculate_inhand_dates(doc,estimated_ship_date,order_line.catalog_item_id,order.company_id)
          doc = Hpricot::XML(response)
          error = parse_xml(doc/:errors/'error')
          if error and error != ''
            return nil,nil,error
          else
            inhand_date = parse_xml(doc/:sales_order_shippings/:sales_order_shipping/'estimated_arrival_date')
            if !inhand_date
              inhand_date = shipping.internal_inhand_date.to_date.strftime("%Y/%m/%d")
            else
              inhand_date = inhand_date.to_date.strftime("%Y/%m/%d")
            end
            shipping.internal_inhand_date = inhand_date
            shipping.estimated_arrival_date = inhand_date
          end
          #          if text == 'error'
          #            return message,'error'
          #          else
          #            shipping.internal_inhand_date = message.to_date
          #            shipping.estimated_arrival_date = message.to_date
          #          end
          pdf_file_name_path = Sales::DateUtility.generate_shipdate_change_pdf(order.id,shipping.id,schema_name,shipping.internal_ship_date)
          email = Email::Email.send_email('SHIPDATEALERT',order)
          email.file_name_path = pdf_file_name_path
          emails << email
          sales_order_shippings << shipping
          activity_message = create_activity_message(order,'SHIP DATE CHANGED')
          order.create_sales_order_transaction_activity(activity_message)
        end
      }
      if sales_order_shippings[0]
        min_ship_date = sales_order_shippings[0].internal_ship_date
        sales_order_shippings.each {|sales_order_shipping|
          if sales_order_shipping.internal_ship_date < min_ship_date
            min_ship_date = sales_order_shipping.internal_ship_date
          end
        }
        order.ship_date = min_ship_date
      end
      return sales_order_shippings,emails,'success'
    rescue Exception => ex
      return nil,nil,ex
    end
  end

  ## this function will automatically send embroidery file for stitch estimation to the vendor defined in application settings.
  def self.send_for_stitch_estimation(order)
    sales_order_line = Sales::SalesOrderLine.active.find_by_sales_order_id_and_line_type_and_item_type(order.id,'M','I')
    return 'sales_order_line not found' if !sales_order_line
    item = Item::CatalogItem.find_by_id(sales_order_line.catalog_item_id)
    @config = YAML::load(File.open("#{Rails.root}/config/production_settings.yml"))
    workflow_embroidery = @config["workflow_embroidery"]
    if item.workflow == workflow_embroidery
      stitch_estimation = Setup::Type.find_by_type_cd_and_subtype_cd('prod','stitch_estimation')
      estimation_vendor = Setup::Type.find_by_type_cd_and_subtype_cd('prod','estimation_vendor')
      if stitch_estimation.value == 'Y' and estimation_vendor.value != ''
        vendor = Vendor::Vendor.find_by_code(estimation_vendor.value)
        xml = %{
              <sales_order>
                <id>#{sales_order_line.id}</id>
                <trans_no>#{order.trans_no}</trans_no>
                <vendor_id>#{vendor.id}</vendor_id>
                <vendor_code>#{estimation_vendor.value}</vendor_code>
                <send_for_estimation_flag>Y</send_for_estimation_flag>
              </sales_order>
        }
        doc = Hpricot::XML(xml)
        message,result = Production::ProductionEmbroideryCrud.create_send_for_estimation(doc)
        if result == 'error'
          activity_message = create_activity_message(order,'some error occurred while sending for automatic stitch estimation')
          order.create_sales_order_transaction_activity(activity_message)
        else
          return 'success'
        end
      end
    end
  end

  def self.list_orders_tosend_multiple_artworks(doc)
    criteria = Setup::Criteria.fill_criteria_for_query(doc/:criteria)
    condition = "( sales_orders.company_id = #{criteria.company_id}) AND
                     (customers.code between '#{criteria.str1}' and '#{criteria.str2}' AND (0 =#{criteria.multiselect1.length} or customers.code in ('#{criteria.multiselect1}'))) AND
                     (trans_no between '#{criteria.str3}' and '#{criteria.str4}' AND (0 =#{criteria.multiselect2.length} or trans_no in ('#{criteria.multiselect2}'))) AND
                     (trans_date between '#{criteria.dt1}' and '#{criteria.dt2}' ) AND
                     (account_period_code between '#{criteria.str5[0,8]}' and '#{criteria.str6[0,8]}' AND (0 =#{criteria.multiselect3.length} or account_period_code in ('#{criteria.multiselect3}')))
                     AND (logo_name between '#{criteria.str7}' and '#{criteria.str8}' AND (0 =#{criteria.multiselect4.length} or logo_name in ('#{criteria.multiselect4}')))
                     AND (ext_ref_no between '#{criteria.str9}' and '#{criteria.str10}' AND (0 =#{criteria.multiselect5.length} or ext_ref_no in ('#{criteria.multiselect5}')))
                     AND sales_orders.trans_flag = 'A' AND sales_orders.blank_order_flag <> 'Y'
                     AND sales_orders.ordercancelstatus_flag <> 'Y'
                     AND sales_orders.artworkreviewed_flag = 'Y' AND sales_orders.artworkapprovedbycust_flag NOT IN('A','R')
                     AND sales_orders.trans_type in ('S','E','V','F')"
    Sales::SalesOrder.find_by_sql ["select CAST((
                                  select(select sales_orders.id,
                                                sales_orders.trans_type,
                                                sales_orders.ext_ref_no,
                                                sales_orders.trans_no,
                                                sales_orders.trans_date,
                                                sales_orders.ship_date,
                                                sales_orders.customer_code,
                                                sales_orders.logo_name,
                                                sales_orders.order_status,
                                                sales_orders.artwork_status,
                                                sales_orders.payment_status,
                                                sales_orders.rushorder_flag,
                                                sales_orders.order_flagged,
                                                types.description as order_type
                                  from sales_orders
                                  inner join customers on customers.id = sales_orders.customer_id
                                  left outer join types on (
                                        types.type_cd = 'trans_type'
                                        and types.subtype_cd = 'so'
                                        and sales_orders.trans_type = types.value
                                       )
                                  where #{condition}
                                  order by sales_orders.rushorder_flag desc, sales_orders.order_flagged desc, sales_orders.ship_date
                                   FOR XML PATH('sales_order'), TYPE,ELEMENTS XSINIL
                                  )FOR XML PATH('sales_orders')) AS varchar(MAX)) as xmlcol"
    ]
  end

  def self.show_orders_tosend_multiple_artworks(order_id)
    Sales::SalesOrder.find_all_by_id(order_id)
  end

  ######### Services for AI-SEND PROOF SCREEN
  def self.send_multiple_artworks_to_customer(doc,schema_name,url_with_port)
    orders = []
    begin
      order_id  = parse_xml(doc/:sales_orders/:sales_order/'id')
      customer_email  = parse_xml(doc/:sales_orders/:sales_order/'artwork_customer_email')
      artwork_subject  = parse_xml(doc/:sales_orders/:sales_order/'artwork_subject')
      artwork_comment  = parse_xml(doc/:sales_orders/:sales_order/'artwork_comment')
      artwork_internal_comment  = parse_xml(doc/:sales_orders/:sales_order/'artwork_internal_comment')
      path = Setup::Type.find_by_type_cd_and_subtype_cd('UPLOAD_FOLDER','ATTACHMENT')
      directory =  "#{Dir.getwd}" + "/" + path.value + schema_name if path
      filename = ""
      total_sent_artwork = ""
      order = Sales::SalesOrder.find_by_id(order_id)
      if (order.trans_type == TRANS_TYPE_VIRTUAL_ORDER and order.orderqcstatus_flag == 'N' and order.qc_off_flag == 'N')
        return 'Quality Check is not Done for Virtual Order. Please Quality Check Order Before Sending it to Customer',orders
      elsif(order.trans_type == TRANS_TYPE_VIRTUAL_ORDER and order.orderentrycomplete_flag == 'N' and order.qc_off_flag == 'Y')
        return 'Order Entry Complete is not Done for Virtual Order. Please Complete Order Before Sending it to Customer',orders
      end
      order_line = Sales::SalesOrderLine.active.find_by_sales_order_id_and_item_type_and_line_type(order_id,'I','M')
      return 'Please Enter Item Before Sending Artwork',orders if !order_line
      #      sales_order_artworks = []
      order.artwork_comment = artwork_comment ## we are making pdf and comments are required so we are assigning comments
      (doc/:sales_orders/:sales_order/:sales_order_artworks/:sales_order_artwork).each{|artwork|
        select_yn = parse_xml(artwork/'select_yn')
        artwork_file_name = parse_xml(artwork/'artwork_file_name')
        artwork_id = parse_xml(artwork/'id')
        #        sales_order_artwork = Sales::SalesOrderArtwork.find_or_build_by_id_and_sales_order_id(artwork_id,order_id)
        sales_order_artwork = order.sales_order_artworks.find_or_build(artwork_id)
        if select_yn == 'Y'
          #          if order_line.catalog_item_code == 'CCS101'
          artwork_filename = File.join(directory,artwork_file_name)
          absolute_filename,text = generate_artwork_acknowledgment_pdf(sales_order_artwork,order,artwork_filename,order_line,schema_name)
          #          if text == 'error'
          #            return absolute_filename,orders
          #          else
          #            filename = filename +  "," + absolute_filename
          #          end
          if text == 'success'
            filename = filename +  "," + absolute_filename
          else
            filename = filename +  "," + File.join(directory,artwork_file_name)
          end
          total_sent_artwork = total_sent_artwork + ',' + sales_order_artwork.artwork_version
          #          end
        end
        sales_order_artwork.select_yn = select_yn
        #        sales_order_artworks << sales_order_artwork
      }
      total_sent_artwork = total_sent_artwork[1..-1]
      salt = create_salt(order)
      order.customer_email = customer_email
      order.url_with_port = url_with_port
      order.artwork_customer_email = customer_email ; order.artwork_subject = artwork_subject
      order.artwork_internal_comment = artwork_internal_comment ; order.paper_proof_status = 'PROOF SENT TO CUSTOMER'
      order.artwork_status = SENT_TO_CUSTOMER ; order.artworksenttocust_flag = 'Y' ; order.paperproofsenttocust_date = Time.now
      order.salt = salt
      ### virtual order is completed after send to customer so we are making status as complete and shipped flag is y bcos we are making reorder from virtual order and condition is shipped flag = 'Y'
      order.order_status = ORDER_COMPLETED if order.trans_type == TRANS_TYPE_VIRTUAL_ORDER
      workflow_location = Sales::CurrentLocationLogic.find_order_location(order,order.order_status,order.artwork_status)
      order.workflow_location = workflow_location
      email = Email::Email.send_email('SENDMULTIPLEARTWORK',order)
      # create the file path
      filename = filename[1..-1]
      email.file_name_path = filename 
      activity_message = create_activity_message(order,"ARTWORK #{total_sent_artwork} SENT SUCCESSFULLY TO #{customer_email}")
      activity = order.create_sales_order_transaction_activity(activity_message)
      save_proc = Proc.new{
        order.save!
        order.sales_order_artworks.each{|sales_order_artwork| sales_order_artwork.save! }
        email.save!
        activity.save!
      }
      order.save_transaction(&save_proc)
      orders << order
    rescue Exception => ex
      return ex,orders
    end
    return 'success',orders
  end

  def self.create_salt(order)
    salt = Digest::SHA1.hexdigest("--#{Time.now.to_s}--#{order.trans_no}--")
  end


  def self.generate_artwork_acknowledgment_pdf(artwork_obj,order,filename,order_line,schema_name)
    begin
      length = 0
      width = 0
      x_coordinate = 0
      y_coordinate = 0
      absolute_filename = ''
      length,width,x_coordinate,y_coordinate,template,message,text = get_template_path(order, order_line, length, width, x_coordinate, y_coordinate,schema_name)
      if text == 'error'
        return message , text
      elsif(text == 'success')
        if !File.exists?(template)
          return 'TEMPLATE NOT FOUND' , 'error'
        end
        pdf = Prawn::Document.new(:template => template, :page_size=>"A4")
        y = pdf.bounds.absolute_top - 20
        x = pdf.bounds.absolute_left + 375
        pdf.fill_color "a1a1a1"
        trans_no = order.trans_no if order.trans_no
        ext_ref_no = order.ext_ref_no if order.ext_ref_no
        artwork_version = artwork_obj.artwork_version if artwork_obj.artwork_version
        table_data = [["#{trans_no}"],
          ["#{ext_ref_no}"],
          ["#{artwork_version}"]]
        pdf.bounding_box([x,y],:width => 110) do
          pdf.table(table_data,:cell_style => {:width => 110,:align=> :left, :size => 10,:border_width => 0,:height => 20,:text_color => '000000'}) do
            style(row(0),:height => 20 ,:font_style => :bold)
            style(row(1),:height => 20 ,:font_style => :bold)
            style(row(2),:height => 20 ,:font_style => :bold)
          end
          y = y - 66
        end
        x = pdf.bounds.absolute_left - 57
        artwork_comments = order.artwork_comment if order.artwork_comment
        table_data2 = [["ARTWORK COMMENTS :","#{artwork_comments}"]] if artwork_comments
        if table_data2
          pdf.bounding_box([x,y],:width => 600) do
            pdf.table(table_data2,:cell_style => {:width => 50,:align=> :left, :size => 10,:border_width => 0,:height => 20,:text_color => 'FF5721'}) do
              style(column(0),:width => 129,:height => 20 ,:font_style => :bold,:text_color => 'FF5721')
              style(column(1),:width => 450 ,:text_color => '000000',:size => 8,:overflow => :shrink_to_fit)
            end
          end
        end
        logopath = filename
        if !File.exists?(logopath)
          logopath = "#{Dir.getwd}/public/images/#{schema_name}/blank.jpg"
        end
        pdf.image "#{logopath}" ,:height => length,:width => width,:at =>[x_coordinate,y_coordinate]
        path = Setup::Type.find(:first, :conditions=>['type_cd = ? and subtype_cd = ?','UPLOAD_FOLDER','REPORT_PRINT'])
        if path
          directory =  "#{Dir.getwd}" + path.value + schema_name
        end
        filename = "#{artwork_version}#{Time.now().strftime('%Y%m%d%H%M%S')}"
        absolute_filename = File.join(directory, filename)+ "." + "pdf"
        pdf.render_file "#{absolute_filename}"
        return absolute_filename,'success'
      else
        return 'SOME ERROR OCCURED IN GENERATING PREVIEW','error'
      end
    rescue Exception => ex
      return ex,'error'
    end
  end

  def self.get_template_path(order,order_line,length,width,x_coordinate,y_coordinate,schema_name)
    template = ''
    imprint_type = ''
    color_attribute_code = ''
    color = ''
    flavour = ''
    flavour_attribute_code = ''
    catalog_item_code = order_line.catalog_item_code if order_line.catalog_item_code
    catalog_item_id = order_line.catalog_item_id if order_line.catalog_item_id
    if (order.trans_type != 'S' and order.trans_type != 'E' and order.trans_type != 'F')
      attribute_values = Sales::SalesOrderAttributesValue.active.find_all_by_catalog_item_id_and_sales_order_line_id(catalog_item_id,order_line.id)
    else
      attribute_values = Sales::SalesOrderAttributesValue.active.find_all_by_sales_order_id_and_catalog_item_id(order.id,catalog_item_id)
    end
    attribute_values.each {|attribute_value|
      if attribute_value.catalog_attribute_code == CATALOG_ATTRIBUTE_CODE
        if attribute_value.catalog_attribute_value_code.blank?
          return 0,0,0,0,'','Please Select Imprint Type For Order','error'
        else
          imprint_type = attribute_value.catalog_attribute_value_code.to_s
        end
      end
      if attribute_value.catalog_attribute_code == "#{catalog_item_code}-COLORS"
        if attribute_value.catalog_attribute_value_code.blank?
          return 0,0,0,0,'','PLEASE SELECT COLOR','error'
        else
          color = attribute_value.catalog_attribute_value_code.to_s
          color_attribute_code = attribute_value.catalog_attribute_code
        end
      elsif attribute_value.catalog_attribute_code == "#{catalog_item_code}-FLAVOURS"
        if attribute_value.catalog_attribute_value_code.blank?
          return 0,0,0,0,'','PLEASE SELECT FLAVOUR','error'
        else
          flavour = attribute_value.catalog_attribute_value_code.to_s
          flavour_attribute_code = attribute_value.catalog_attribute_code
        end
      end
    }
    if !color.blank?
      color_attribute = Item::CatalogAttribute.find_by_trans_flag_and_code('A',color_attribute_code)
      color_attribute_value = Item::CatalogAttributeValue.find_by_trans_flag_and_catalog_attribute_id_and_code('A',color_attribute.id,color)
      color_inventory_item_id = color_attribute_value.invn_item_id
      catalog_item_template = Item::CatalogItemTemplate.find_by_catalog_item_id_and_imprint_type_code_and_trans_flag(color_inventory_item_id,imprint_type,'A') if color_inventory_item_id
    elsif !flavour.blank?
      flavour_attribute = Item::CatalogAttribute.find_by_trans_flag_and_code('A',flavour_attribute_code)
      flavour_attribute_value = Item::CatalogAttributeValue.find_by_trans_flag_and_catalog_attribute_id_and_code('A',flavour_attribute.id,flavour)
      flavour_inventory_item_id = flavour_attribute_value.invn_item_id
      catalog_item_template = Item::CatalogItemTemplate.find_by_catalog_item_id_and_imprint_type_code_and_trans_flag(flavour_inventory_item_id,imprint_type,'A') if flavour_inventory_item_id
    else
      catalog_item_template = Item::CatalogItemTemplate.find_by_catalog_item_id_and_imprint_type_code_and_trans_flag(catalog_item_id,imprint_type,'A')
    end
    if !catalog_item_template
      catalog_item_template = Item::CatalogItemTemplate.find_by_catalog_item_id_and_imprint_type_code_and_trans_flag(catalog_item_id,imprint_type,'A')
    end
    if(!catalog_item_template || !catalog_item_template.length || !catalog_item_template.width || !catalog_item_template.x_coordinate || !catalog_item_template.y_coordinate)
      return 0,0,0,0,'','Pdf cannot be Generated. Item Template Co-ordinates Are Not Defined','error'
    else
      length = catalog_item_template.length.to_i
      width = catalog_item_template.width.to_i
      x_coordinate = catalog_item_template.x_coordinate.to_i
      y_coordinate = catalog_item_template.y_coordinate.to_i
    end
    if catalog_item_template.template_name.blank?
      return 0,0,0,0,'','Pdf cannot be Generated. Template Name Is Not Defined For The Item','error'
    else
      path = Setup::Type.find(:first, :conditions=>['type_cd = ? and subtype_cd = ?','UPLOAD_FOLDER','TEMPLATE_PATH'])
      if path
        directory =  "#{Dir.getwd}/" + path.value + schema_name
        template = "#{directory}/#{catalog_item_template.template_name}"
      end
    end
    return length,width,x_coordinate,y_coordinate,template,'','success'
  end

  ## NOT IN USE NOW WE ARE GETTING COORDINATES FROM DATABASE.

  #  def self.generate_artwork_acknowledgment_pdf(artwork_obj,order,filename,order_line,schema_name)
  #    begin
  #      height = 0
  #      width = 0
  #      x_coordinate = 0
  #      y_coordinate = 0
  #      absolute_filename = ''
  #      height,width,x_coordinate,y_coordinate,template,message,text = get_template_path(order, order_line, height, width, x_coordinate, y_coordinate)
  #      if text == 'error'
  #        return message , text
  #      elsif(text == 'success')
  #        if !File.exists?(template)
  #          return 'TEMPLATE NOT FOUND' , 'error'
  #        end
  #        pdf = Prawn::Document.new(:template => template, :page_size=>"A4")
  #        y = pdf.bounds.absolute_top - 20
  #        x = pdf.bounds.absolute_left + 375
  #        pdf.fill_color "a1a1a1"
  #        trans_no = order.trans_no if order.trans_no
  #        ext_ref_no = order.ext_ref_no if order.ext_ref_no
  #        artwork_version = artwork_obj.artwork_version if artwork_obj.artwork_version
  #        table_data = [["#{trans_no}"],
  #          ["#{ext_ref_no}"],
  #          ["#{artwork_version}"]]
  #        pdf.bounding_box([x,y],:width => 110) do
  #          pdf.table(table_data,:cell_style => {:width => 110,:align=> :left, :size => 10,:border_width => 0,:height => 20,:text_color => '000000'}) do
  #            style(row(0),:height => 20 ,:font_style => :bold)
  #            style(row(1),:height => 20 ,:font_style => :bold)
  #            style(row(2),:height => 20 ,:font_style => :bold)
  #          end
  #          y = y - 66
  #        end
  #        x = pdf.bounds.absolute_left - 57
  #        artwork_comments = order.artwork_comment if order.artwork_comment
  #        table_data2 = [["ARTWORK COMMENTS :","#{artwork_comments}"]] if artwork_comments
  #        if table_data2
  #          pdf.bounding_box([x,y],:width => 600) do
  #            pdf.table(table_data2,:cell_style => {:width => 50,:align=> :left, :size => 10,:border_width => 0,:height => 20,:text_color => 'FF5721'}) do
  #              style(column(0),:width => 129,:height => 20 ,:font_style => :bold,:text_color => 'FF5721')
  #              style(column(1),:width => 450 ,:text_color => '000000',:size => 8,:overflow => :shrink_to_fit)
  #            end
  #          end
  #        end
  #        logopath = filename
  #        if !File.exists?(logopath)
  #          logopath = "#{Dir.getwd}/public/images/#{schema_name}/blank.jpg"
  #        end
  #        pdf.image "#{logopath}" ,:height => height,:width => width,:at =>[x_coordinate,y_coordinate]
  #        path = Setup::Type.find(:first, :conditions=>['type_cd = ? and subtype_cd = ?','UPLOAD_FOLDER','REPORT_PRINT'])
  #        if path
  #          directory =  "#{Dir.getwd}" + path.value + schema_name
  #        end
  #        filename = "#{artwork_version}#{Time.now().strftime('%Y%m%d%H%M%S')}"
  #        absolute_filename = File.join(directory, filename)+ "." + "pdf"
  #        pdf.render_file "#{absolute_filename}"
  #        return absolute_filename,'success'
  #      else
  #        return 'SOME ERROR OCCURED IN GENERATING PREVIEW','error'
  #      end
  #    rescue Exception => ex
  #      return ex,'error'
  #    end
  #  end
  #
  #  def self.get_template_path(order,order_line,height,width,x_coordinate,y_coordinate)
  #    imprint_flag = false
  #    color = ''
  #    flavour = ''
  #    imprint_type = ''
  #    catalog_item_code = order_line.catalog_item_code if order_line.catalog_item_code
  #    catalog_item_id = order_line.catalog_item_id if order_line.catalog_item_id
  #    template_name = "#{catalog_item_code}-"
  #    if (order.trans_type != 'S' and order.trans_type != 'E' and order.trans_type != 'F')
  #      attribute_values = Sales::SalesOrderAttributesValue.active.find_all_by_catalog_item_id_and_sales_order_line_id(catalog_item_id,order_line.id)
  #    else
  #      attribute_values = Sales::SalesOrderAttributesValue.active.find_all_by_sales_order_id_and_catalog_item_id(order.id,catalog_item_id)
  #    end
  #    attribute_values.each {|attribute_value|
  #      if attribute_value.catalog_attribute_code == CATALOG_ATTRIBUTE_CODE
  #        imprint_flag = true
  #        if attribute_value.catalog_attribute_value_code.to_s == ''
  #          return 0,0,0,0,'','PLEASE SELECT IMPRINT TYPE','error'
  #        else
  #          imprint_type = attribute_value.catalog_attribute_value_code.to_s
  #          template_name = template_name + "#{attribute_value.catalog_attribute_value_code}-"
  #          @config = YAML::load(File.open("#{Rails.root}/config/artwork_pdf_settings.yml"))
  #          height = @config["#{catalog_item_code}_#{attribute_value.catalog_attribute_value_code}_HEIGHT"]
  #          width = @config["#{catalog_item_code}_#{attribute_value.catalog_attribute_value_code}_WIDTH"]
  #          x_coordinate = @config["#{catalog_item_code}_#{attribute_value.catalog_attribute_value_code}_X"]
  #          y_coordinate = @config["#{catalog_item_code}_#{attribute_value.catalog_attribute_value_code}_Y"]
  #          if(!height || !width || !x_coordinate || !y_coordinate)
  #            return 0,0,0,0,'','PREVIEW CANNOT BE GENERATED - ARTWORK CO-ORDINATES FOR TEMPLATE ARE NOT DEFINED','error'
  #          end
  #          break
  #        end
  #      end
  #    }
  #    if imprint_flag == false
  #      return 0,0,0,0,'','IMPRINT TYPE NOT DEFINED FOR THE ITEM','error'
  #    end
  #    attribute_values.each {|attribute_value|
  #      if attribute_value.catalog_attribute_code == "#{catalog_item_code}-COLORS"
  #        if attribute_value.catalog_attribute_value_code.to_s == ''
  #          return 0,0,0,0,'','PLEASE SELECT COLOR','error'
  #        else
  #          color = attribute_value.catalog_attribute_value_code.to_s
  #          template_name = template_name + "#{attribute_value.catalog_attribute_value_code}-"
  #        end
  #      elsif attribute_value.catalog_attribute_code == "#{catalog_item_code}-FLAVOURS"
  #        if attribute_value.catalog_attribute_value_code.to_s == ''
  #          return 0,0,0,0,'','PLEASE SELECT FLAVOUR','error'
  #        else
  #          flavour = attribute_value.catalog_attribute_value_code.to_s
  #          template_name = template_name + "#{attribute_value.catalog_attribute_value_code}-"
  #        end
  #      end
  #    }
  #    template_name = "#{template_name}template.pdf".downcase
  #    template_dir = order_line.catalog_item_code.downcase
  #    template = "#{Dir.getwd}/public/art_templates/#{template_dir}/#{template_name}"
  #    ## this will search for ex-> CCS101-decal-blue-template.pdf if not found then
  #    #search CCS101-decal-template.pdf if this is also not found
  #    #then search for CCS101-template.pdf
  #    if !File.exists?(template)
  #      if color.to_s != ''
  #        template = template.gsub("#{color.downcase}",'')
  #        template = template.gsub("--",'-')
  #      elsif
  #        template = template.gsub("#{flavour.downcase}",'')
  #        template = template.gsub("--",'-')
  #      end
  #    end
  #    if !File.exists?(template)
  #      template = template.gsub("#{imprint_type.downcase}",'')
  #      template = template.gsub("--",'-')
  #    end
  #    return height,width,x_coordinate,y_coordinate,template,'','success'
  #  end




  #  def self.generate_artwork_acknowledgment_pdf(artwork_obj,order,filename,order_line,schema_name)
  #    begin
  #      template = "#{Dir.getwd}/public/art_templates/#{order_line.catalog_item_code}/ccs101-decal-blue-template.pdf"
  #      pdf = Prawn::Document.new(:template => template, :page_size=>"A4")
  #      pdf.font_size(15){
  #        pdf.fill_color "a1a1a1"
  #        pdf.text_box "#{order.trans_no}",:at=>[395,735]
  #        pdf.text_box "#{order.ext_ref_no}", :at=>[395,710]
  #        pdf.text_box "#{artwork_obj.artwork_version}",:at =>[395,685]}
  #      logopath = filename
  #      file_extension = logopath.split('.').last
  #      logopath = convert_image_file_to_jpeg(logopath) if ( file_extension !='jpg' || file_extension !='jpeg')
  #      if !File.exists?(logopath)
  #        logopath = "#{Dir.getwd}/public/images/#{schema_name}/blank.jpg"
  #      end
  #      pdf.image "#{logopath}" ,:height =>122,:width => 181,:at =>[198,525]
  #      path = Setup::Type.find(:first, :conditions=>['type_cd = ? and subtype_cd = ?','UPLOAD_FOLDER','REPORT_PRINT'])
  #      if path
  #        directory =  "#{Dir.getwd}" + path.value + schema_name
  #      end
  #      filename = "#{Time.now().strftime('%Y%m%d%H%M%S')}"
  #      absolute_filename = File.join(directory, filename)+ "." + "pdf"
  #      pdf.render_file "#{absolute_filename}"
  #      return absolute_filename,'success'
  #    rescue Exception => ex
  #      return ex,'error'
  #    end
  #  end

  ## Service called from AI Waiting Artwork Screen
  def self.waiting_for_artworks_inbox(doc)
    condition = "so.trans_flag = 'A'
                 AND so.artworkreceived_flag = 'N'
                 AND so.trans_type NOT IN ('E','P')
                 AND so.ordercancelstatus_flag = 'N'
                 AND so.blank_order_flag <> 'Y'
                 AND so.ordercancelstatus_flag <> 'Y'"
    Sales::SalesOrder.find_by_sql ["select CAST((select(select types.description as order_type,
                                   so.artwork_status,
								                   so.trans_no,
                                   so.trans_type,
                                   so.trans_date,
                                   so.ext_ref_no,
                                   so.customer_code,
                                   so.salesperson_code,
                                   so.ship_date,
                                   so.ship_method,
                                   so.logo_name,
                                   so.order_status,
                                   so.workflow_location,
                                   so.shipping_code,
                                   so.rushorder_flag,
                                   so.order_flagged
                                   from sales_orders so
                                   left outer join types on (
                                        types.type_cd = 'trans_type'
                                        and types.subtype_cd = 'so'
                                        and so.trans_type = types.value
                                       )
                                   where #{condition}
                                  FOR XML PATH('sales_order'), TYPE,ELEMENTS XSINIL
                                  )FOR XML PATH('sales_orders')) AS varchar(MAX)) as xmlcol"]
  end

  def self.create_activity_message(order,activity_code)
    #    activity = Sales::SalesOrderTransactionActivity.find_by_sales_order_id_and_sales_order_stage_code_and_trans_flag(order.id,activity_code,'A')
    #    if activity
    #      count = 1
    #      order.sales_order_transaction_activities.each{|activity|
    #        count = count + 1
    #        activity1 = Sales::SalesOrderTransactionActivity.find_by_sales_order_id_and_sales_order_stage_code_and_trans_flag(order.id,"#{activity_code} #{count} TIME",'A')
    #        if !activity1
    #          return "#{activity_code} #{count} TIME"
    #        end
    #      }
    #    else
    #      return activity_code
    #    end
    result = Sales::SalesOrderTransactionActivity.find_by_sql ["select count(*) as activity_count from sales_order_transaction_activities
                                                                  where sales_order_id=#{order.id} and trans_flag='A' and
                                                                  sales_order_stage_code like ?",activity_code+'%']
    if result[0].activity_count.to_i == 0
      activity_code
    else
      return "#{activity_code} #{result[0].activity_count.to_i+1} TIMES"
    end
  end

  def self.convert_image_file_to_jpeg(logopath)
    img =  Magick::Image.read(logopath).first
    file_name = logopath.split('.').first
    img.write("#{file_name}.jpg")
    return "#{file_name}.jpg"
  end

end
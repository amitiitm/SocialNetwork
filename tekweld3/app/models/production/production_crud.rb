class Production::ProductionCrud
  include General
  #  Trans Type Codes
  #  S	Regular Order
  #  E	Re-Order
  #  P	Sample Order
  #  V	Virtual Order
  #  F	Spec Order
  
  ## Tekweld Production generate indigo code service
  #  def self.generate_indigo_code
  #    book_cd = 'INDG'
  #    book_nm = 'indigo_code'
  #    docu_typ = 'INDIGOCODE'
  #    sequence = Setup::Sequence.maximum(:book_lno, :conditions =>[ "book_cd =? and book_nm = ? and docu_typ = ? and company_id =? and trans_flag = 'A'",book_cd,book_nm, docu_typ,1])
  #    #    sequence.update_attributes!(:book_lno => sequence.book_lno.to_i + 1)
  #    return sequence
  #  end

  ## Tekweld Production Inboxes Show Services
  def self.show_production_inbox(order_id)
    Sales::SalesOrder.find_all_by_id(order_id)
  end

  def self.list_all_production_data(doc)
    criteria = Setup::Criteria.fill_criteria_for_query(doc/:criteria)
    condition = "(sales_orders.company_id = #{criteria.company_id}) AND
                     (customers.code between '#{criteria.str1}' and '#{criteria.str2}' AND (0 =#{criteria.multiselect1.length} or customers.code in ('#{criteria.multiselect1}'))) AND
                     (sales_orders.trans_no between '#{criteria.str3}' and '#{criteria.str4}' AND (0 =#{criteria.multiselect2.length} or sales_orders.trans_no in ('#{criteria.multiselect2}'))) AND
                     (sales_orders.trans_date between '#{criteria.dt1}' and '#{criteria.dt2}' ) AND
                     (sales_orders.account_period_code between '#{criteria.str5[0,8]}' and '#{criteria.str6[0,8]}' AND (0 =#{criteria.multiselect3.length} or sales_orders.account_period_code in ('#{criteria.multiselect3}')))
                     AND (sales_orders.logo_name between '#{criteria.str7}' and '#{criteria.str8}' AND (0 =#{criteria.multiselect4.length} or sales_orders.logo_name in ('#{criteria.multiselect4}')))
                     AND (sales_orders.ext_ref_no between '#{criteria.str9}' and '#{criteria.str10}' AND (0 =#{criteria.multiselect5.length} or sales_orders.ext_ref_no in ('#{criteria.multiselect5}')))
                     AND sales_orders.trans_flag = 'A' AND sales_orders.artworkreviewed_flag = 'Y'
                     AND ((sales_orders.paper_proof_flag = 'Y' AND sales_orders.artworkapprovedbycust_flag = 'A') or (sales_orders.paper_proof_flag = 'N'))
                     AND sol.blank_good_flag <> 'Y' AND sol.item_type = 'I' and sol.trans_flag = 'A'
                     AND (sales_orders.orderentrycomplete_flag = 'Y' AND (sales_orders.qc_off_flag = 'Y' or sales_orders.orderqcstatus_flag = 'Y'))
                     AND sales_orders.trans_type in ('S','E') AND sales_orders.ordercancelstatus_flag = 'N'"
    spec_order_condition = "(so.company_id = #{criteria.company_id}) AND
                     (customers.code between '#{criteria.str1}' and '#{criteria.str2}' AND (0 =#{criteria.multiselect1.length} or customers.code in ('#{criteria.multiselect1}'))) AND
                     (so.trans_no between '#{criteria.str3}' and '#{criteria.str4}' AND (0 =#{criteria.multiselect2.length} or so.trans_no in ('#{criteria.multiselect2}'))) AND
                     (so.trans_date between '#{criteria.dt1}' and '#{criteria.dt2}' ) AND
                     (so.account_period_code between '#{criteria.str5[0,8]}' and '#{criteria.str6[0,8]}' AND (0 =#{criteria.multiselect3.length} or so.account_period_code in ('#{criteria.multiselect3}')))
                     AND (so.logo_name between '#{criteria.str7}' and '#{criteria.str8}' AND (0 =#{criteria.multiselect4.length} or so.logo_name in ('#{criteria.multiselect4}')))
                     AND (so.ext_ref_no between '#{criteria.str9}' and '#{criteria.str10}' AND (0 =#{criteria.multiselect5.length} or so.ext_ref_no in ('#{criteria.multiselect5}')))
                     AND so.trans_flag = 'A' AND so.artworkreviewed_flag = 'Y'
                     AND ((so.paper_proof_flag = 'Y' AND so.artworkapprovedbycust_flag = 'A') or (so.paper_proof_flag = 'N'))
                     AND sol.blank_good_flag <> 'Y' AND sol.item_type = 'I' and sol.trans_flag = 'A'
                     AND (so.orderentrycomplete_flag = 'Y' AND (so.qc_off_flag = 'Y' or so.orderqcstatus_flag = 'Y'))
                     AND so.trans_type in ('F') AND ((sales_order_shippings.pre_prod_flag='Y' and sales_order_shippings.shipping_flag='N') or (so.approve_spec_order_flag = 'Y' and sales_order_shippings.pre_prod_flag='N'))
                     AND so.ordercancelstatus_flag = 'N' "
    condition = convert_sql_to_db_specific(condition)
    Sales::SalesOrder.find_by_sql ["select CAST(( select (
                                  select * from (select sales_orders.*,101  as shipping_serial_no,types.description as order_type
                                  from sales_orders 
                                  inner join customers on customers.id = sales_orders.customer_id
                                  inner join sales_order_lines sol  on sol.sales_order_id = sales_orders.id
                                  left outer join types on (
                                        types.type_cd = 'trans_type'
                                        and types.subtype_cd = 'so'
                                        and sales_orders.trans_type = types.value 
                                       )
                                  where #{condition}
                                  

UNION
                                  select distinct so.*,sales_order_shippings.serial_no as shipping_serial_no,types.description as order_type
                                  from sales_orders so
                                  inner join customers on customers.id = so.customer_id
                                  inner join sales_order_lines sol  on sol.sales_order_id = so.id
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
   
  def self.create_production_imposition_inboxes(doc)
    message = ""
    text = ""
    (doc/:sales_orders/:sales_order).each{|order_doc|
      message,text = create_production_imposition_inbox(order_doc)
      break if text == 'error'
    }
    return message,text
  end
  def self.create_production_imposition_inbox(order_doc)
    begin
      id =  parse_xml(order_doc/'id') if (order_doc/'id').first
      trans_no =  parse_xml(order_doc/'trans_no') if (order_doc/'trans_no').first
      order= Sales::SalesOrder.find_by_trans_no(trans_no)
      indigo_code =  parse_xml(order_doc/'indigo_code') if (order_doc/'indigo_code').first
      doc_code =  parse_xml(order_doc/'doc_code') if (order_doc/'doc_code').first
      max_indigo_code = Setup::Sequence.maximum(:book_lno, :conditions =>[ "book_cd =? and book_nm = ? and docu_typ = ? and company_id =? and trans_flag = ?",'INDG','indigo_code','INDIGOCODE',1,'A'])
      max_doc_code = Setup::Sequence.maximum(:book_lno, :conditions =>[ "book_cd =? and book_nm = ? and docu_typ = ? and company_id =? and trans_flag = ?",'GUMD','doc_number','DOCNUM',1,'A'])
      if (max_indigo_code.to_i + 1) == indigo_code.to_i
        sequence = Setup::Sequence.find_by_book_cd_and_book_nm_and_docu_typ_and_company_id_and_trans_flag('INDG','indigo_code','INDIGOCODE',1,'A')
        sequence.update_attributes!(:book_lno => (max_indigo_code.to_i + 1))
      end
      if (max_doc_code.to_i + 1) == doc_code.to_i
        sequence = Setup::Sequence.find_by_book_cd_and_book_nm_and_docu_typ_and_company_id_and_trans_flag('GUMD','doc_number','DOCNUM',1,'A')
        sequence.update_attributes!(:book_lno => (max_doc_code.to_i + 1))
      end
      sales_order_line = Sales::SalesOrderLine.find_by_id(id)
      if !sales_order_line
        return 'Order Line Does Not Exists.','error'
      end
      order.update_attributes!(:order_status => IMPOSITION_COMPLETE)
      sales_order_line.update_attributes!(:imposition_flag => 'Y',:imposition_date => Time.now,:indigo_code => indigo_code,:doc_code => doc_code)
      activity_message = Artwork::ArtworkCrud.create_activity_message(order,'IMPOSITION COMPLETE')
      activity = order.create_sales_order_transaction_activity(activity_message)
      activity.save!
      workflow_location = Sales::CurrentLocationLogic.find_order_status(order.trans_no)
      order.update_attributes!(:workflow_location => workflow_location)
      return 'Imposition Completed Successfully','success'
    rescue Exception => ex
      return ex,'error'
    end
  end
  
  def self.create_production_print_inboxes(doc)
    message = ""
    text = ""
    (doc/:sales_orders/:sales_order).each{|order_doc|
      message,text = create_production_print_inbox(order_doc)
      break if text == 'error'
    }
    return message,text
  end
  def self.create_production_print_inbox(order_doc)
    begin
      id =  parse_xml(order_doc/'id') if (order_doc/'id').first
      trans_no =  parse_xml(order_doc/'trans_no') if (order_doc/'trans_no').first
      reject_yn =  parse_xml(order_doc/'reject_yn') if (order_doc/'reject_yn').first
      reason =  parse_xml(order_doc/'reason') if (order_doc/'reason').first
      order= Sales::SalesOrder.find_by_trans_no(trans_no)
      indigo_code =  parse_xml(order_doc/'indigo_code') if (order_doc/'indigo_code').first
      sales_order_line = Sales::SalesOrderLine.find_by_id(id)
      if !sales_order_line
        return 'Order Line Does Not Exists.','error'
      end
      if reject_yn != 'Y' and sales_order_line.print_flag != 'Y'
        order.update_attributes!(:order_status => PRINT_COMPLETE)
        sales_order_line.update_attributes!(:print_flag => 'Y',:print_date => Time.now,:indigo_code => indigo_code,:reason => reason)
        activity_message = Artwork::ArtworkCrud.create_activity_message(order,'PRINT COMPLETE')
        activity = order.create_sales_order_transaction_activity(activity_message)
        activity.save!
      elsif(reject_yn == 'Y')
        order.update_attributes!(:order_status => REJECTED_FROM_PRINT)
        sales_order_line.update_attributes!(:imposition_flag => 'N',:print_flag => 'N',:film_flag => 'N',:imposition_date => Time.now,:reason => reason)
        activity_message = Artwork::ArtworkCrud.create_activity_message(order,'REJECTED FROM PRINT')
        activity = order.create_sales_order_transaction_activity(activity_message)
        activity.save!
      end
      workflow_location = Sales::CurrentLocationLogic.find_order_status(order.trans_no)
      order.update_attributes!(:workflow_location => workflow_location)
      return 'Print Completed Successfully','success'
    rescue Exception => ex
      return ex,'error'
    end
  end

  def self.create_production_film_inboxes(doc)
    sales_orders = []
    (doc/:sales_orders/:sales_order).each{|order_doc|
      sales_order = create_production_film_inbox(order_doc)
      sales_orders <<  sales_order if sales_order
    }
    sales_orders
  end
  def self.create_production_film_inbox(order_doc)
    id =  parse_xml(order_doc/'id') if (order_doc/'id').first
    film_flag =  parse_xml(order_doc/'film_flag') if (order_doc/'film_flag').first
    ## we are using same flag for rejection and reject reason as we have used in imposition
    reject_from_film_flag =  parse_xml(order_doc/'reject_from_imposition_flag') if (order_doc/'reject_from_imposition_flag').first
    film_reject_reason =  parse_xml(order_doc/'imposition_reject_reason') if (order_doc/'imposition_reject_reason').first
    order = Sales::SalesOrder.find_by_id(id)
    sales_order_line = Sales::SalesOrderLine.find_by_sales_order_id_and_line_type_and_item_type_and_trans_flag(id,'M','I','A')
    return  if !sales_order_line
    order.run_block do
      order.max_serial_no = order.sales_order_artworks.maximum_serial_no
      order.build_lines(order_doc/:sales_order_artworks/:sales_order_artwork)
    end
    if reject_from_film_flag == 'Y'
      order.artworkreviewed_flag = 'N'
      order.artworksenttocust_flag = 'N'
      order.artworkapprovedbycust_flag = ''
      order.artwork_status = 'REJECTED FROM FILM'
      sales_order_line.update_attributes!(:reject_from_imposition_flag => reject_from_film_flag,:imposition_reject_reason=>film_reject_reason)
      activity_message = Artwork::ArtworkCrud.create_activity_message(order,'REJECTED FROM FILM')
      activity = order.create_sales_order_transaction_activity(activity_message)
      activity.save!
      order.sales_order_artworks.each{|artwork|
        artwork.select_yn = 'N'
        artwork.final_artwork_flag = 'N'
      }
    else
      sales_order_line.update_attributes!(:film_flag => film_flag,:film_date => Time.now)
    end
    save_proc = Proc.new{
      if film_flag == 'Y'
        order.update_attributes!(:order_status => FILM_COMPLETE)
        activity_message = Artwork::ArtworkCrud.create_activity_message(order,'FILM COMPLETE')
        activity = order.create_sales_order_transaction_activity(activity_message)
        activity.save!
      end
      order.save!
      order.sales_order_artworks.save_line
      workflow_location = Sales::CurrentLocationLogic.find_order_status(order.trans_no)
      order.update_attributes!(:workflow_location => workflow_location)
    }
    order.save_transaction(&save_proc)
    return order
  end
  
  def self.create_production_stitch_inboxes(doc)
    message = ""
    text = ""
    (doc/:sales_orders/:sales_order).each{|order_doc|
      message,text = create_production_stitch_inbox(order_doc)
      break if text == 'error'
    }
    return message,text
  end
  def self.create_production_stitch_inbox(order_doc)
    begin
      id =  parse_xml(order_doc/'id') if (order_doc/'id').first
      indigo_code =  parse_xml(order_doc/'indigo_code') if (order_doc/'indigo_code').first
      trans_no =  parse_xml(order_doc/'trans_no') if (order_doc/'trans_no').first
      order= Sales::SalesOrder.find_by_trans_no(trans_no)
      sales_order_line = Sales::SalesOrderLine.find_by_id(id)
      if !sales_order_line
        return 'Order Line Does Not Exists.','error'
      end
      order.update_attributes!(:order_status => STITCH_DONE)
      sales_order_line.update_attributes!(:stitch_flag => 'Y',:stitch_date => Time.now,:indigo_code => indigo_code)
      activity_message = Artwork::ArtworkCrud.create_activity_message(order,'STITCH DONE')
      activity = order.create_sales_order_transaction_activity(activity_message)
      activity.save!
      workflow_location = Sales::CurrentLocationLogic.find_order_status(order.trans_no)
      order.update_attributes!(:workflow_location => workflow_location)
      return 'Stitch Done Successfully','success'
    rescue Exception => ex
      return ex,'error'
    end
  end
  
  def self.create_production_cut_inboxes(doc)
    message = ""
    text = ""
    (doc/:sales_orders/:sales_order).each{|order_doc|
      message,text = create_production_cut_inbox(order_doc)
      break if text == 'error'
    }
    return message,text
  end
  def self.create_production_cut_inbox(order_doc)
    begin
      id =  parse_xml(order_doc/'id') if (order_doc/'id').first
      indigo_code =  parse_xml(order_doc/'indigo_code') if (order_doc/'indigo_code').first
      trans_no =  parse_xml(order_doc/'trans_no') if (order_doc/'trans_no').first
      order= Sales::SalesOrder.find_by_trans_no(trans_no)
      sales_order_line = Sales::SalesOrderLine.find_by_id(id)
      if !sales_order_line
        return 'Order Line Does Not Exists.','error'
      end
      if sales_order_line.cut_flag != 'Y'
        order.update_attributes!(:order_status => CUTTING_COMPLETE)
        sales_order_line.update_attributes!(:cut_flag => 'Y',:cut_date => Time.now,:indigo_code => indigo_code)
        activity_message = Artwork::ArtworkCrud.create_activity_message(order,'CUTTING COMPLETE')
        activity = order.create_sales_order_transaction_activity(activity_message)
        activity.save!
      end
      workflow_location = Sales::CurrentLocationLogic.find_order_status(order.trans_no)
      order.update_attributes!(:workflow_location => workflow_location)
      return 'Cutting Completed Successfully','success'
    rescue Exception => ex
      return ex,'error'
    end
  end
end
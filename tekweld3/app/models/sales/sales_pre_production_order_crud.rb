class Sales::SalesPreProductionOrderCrud
  include General
  #  Trans Type Codes
  #  S	Regular Order
  #  E	Re-Order
  #  P	Sample Order
  #  V	Virtual Order
  #  F	Spec Order
  def self.list_pre_production_orders(doc)
    #    criteria = Setup::Criteria.fill_criteria_for_query(doc/:criteria)
    condition = "((so.paper_proof_flag = 'Y' AND so.artworkapprovedbycust_flag = 'A') or (so.paper_proof_flag = 'N'))
                     AND so.trans_flag = 'A' AND (so.accountreviewed_flag = 'Y') AND so.artworkreviewed_flag = 'Y'
                     AND sol.blank_good_flag <> 'Y' AND sol.item_type = 'I' and sol.trans_flag = 'A'
                     AND so.trans_type in ('F')
                     AND (so.approve_spec_order_flag = 'N' and sales_order_shippings.pre_prod_flag='N' and sales_order_shippings.shipping_flag='N')
                     AND so.ordercancelstatus_flag = 'N'"
    condition = convert_sql_to_db_specific(condition)
    Sales::SalesOrder.find_by_sql ["select CAST((
                                    select(select distinct so.ext_ref_no,
                                                types.description as order_type,
                                                so.trans_type,
                                                so.trans_date,
                                                customers.name,
                                                customers.code as customer_code,
                                                so.payment_status,
                                                so.rushorder_flag,
                                                so.artwork_status,
                                                so.order_status,
                                                so.trans_no,
                                                sol.serial_no,
                                                so.logo_name,
                                                sol.catalog_item_code,
                                                sol.id,
                                                sol.item_description,
                                                so.ship_date
                                                from sales_orders so
                                inner join sales_order_lines sol on sol.sales_order_id = so.id
                                inner join customers on customers.id = so.customer_id
                                inner join users on users.id = so.updated_by
                                inner join sales_order_shippings ON sales_order_shippings.sales_order_id = so.id
                                left outer join types on (
                                  types.type_cd = 'trans_type'
                                  and types.subtype_cd = 'so'
                                  and so.trans_type = types.value
                                  )
                                  where #{condition}
                                  order by so.trans_no
                                  FOR XML PATH('sales_order'), TYPE,ELEMENTS XSINIL
                                  )FOR XML PATH('sales_orders')) AS varchar(MAX)) as xmlcol"
    ]
  end

  def self.approve_pre_production_orders(doc,schema_name)
    #    sales_orders = []
    message = ""
    text =""
    (doc/:sales_orders/:sales_order).each{|order_doc|
      message,text = approve_pre_production_order(order_doc,schema_name)
      break if text == 'error'
      #      sales_orders <<  sales_order if sales_order
    }
    return message,text
  end

  def self.approve_pre_production_order(order_doc,schema_name)
    begin
      emails = []
      id =  parse_xml(order_doc/'id') if (order_doc/'id').first
      trans_no =  parse_xml(order_doc/'trans_no') if (order_doc/'trans_no').first
      order = Sales::SalesOrder.find_by_trans_no(trans_no)
      return  if !order
      sales_order_preprod_shippings = Sales::SalesOrderShipping.find_by_sql ["select * from sales_order_shippings where trans_flag = 'A' and pre_prod_flag = 'Y' and shipping_flag = 'N' and sales_order_id = #{order.id}"]
      return 'Order Cannot Approve,bcos Pre Production Order is Not Shipped.','error' if sales_order_preprod_shippings[0]
      message,text = update_approve_order_shipping_dates(order,schema_name)
      if text == 'error'
        message = message
        raise ActiveRecord::Rollback
      else
        emails = message
      end
      return message,'error' if (message != '' and message != 'success' and text == 'error')
      order.approve_spec_order_flag = 'Y'
      order.order_status = 'PREPRODUCTION APPROVED'
      sales_order_line = order.sales_order_lines.find_by_id(id)
      sales_order_line.direct_production_flag = 'N'
      sales_order_line.imposition_flag = 'N'
      sales_order_line.stitch_flag = 'N'
      sales_order_line.print_flag = 'N'
      sales_order_line.cut_flag = 'N'
      sales_order_line.indigo_code = ''
      sales_order_line.doc_code = ''
      order.create_sales_order_transaction_activity('PREPRODUCTION APPROVED')
      save_proc = Proc.new{
        sales_order_line.save!
        order.save!
        order.sales_order_shippings.each{|shipping| shipping.save!}
        order.sales_order_transaction_activities.each{|activity| activity.save!}
        emails.each{|email| email.save! }
      }
      order.save_transaction(&save_proc)
      return order,'success'
    rescue Exception => ex
      return ex,'error'
    end
  end

  def self.update_approve_order_shipping_dates(order,schema_name)
    begin
      emails = []
      sales_order_lines = Sales::SalesOrderLine.where('trans_flag = ? AND sales_order_id = ? AND item_type = ?','A',order.id,'I').first
      catalog_item_id = sales_order_lines.catalog_item_id
      order.sales_order_shippings.each{|shipping|
        if (shipping.trans_flag == 'A' and shipping.shipping_flag == 'N')
          if !shipping.ship_date
            if shipping.estimated_ship_date and shipping.estimated_ship_date != ''
              estimated_ship_date = Sales::DateUtility.calculate_estimated_ship_date(catalog_item_id,order.ext_ref_date,order.customer_id,order.item_qty,order.rush_order_type,order.next_day_flag,order.paper_proof_flag,order.blank_order_flag)
              estimated_ship_date = Time.now.to_date
              shipping.estimated_ship_date = estimated_ship_date
              shipping.internal_ship_date = estimated_ship_date
            end
            if shipping.ship_method_code != ''
              if shipping.shipping_code == 'UPS'
                response,result = Sales::DateUtility.get_ups_inhand_dates(1,shipping.ship_zip,shipping.ship_country,shipping.ship_state,estimated_ship_date,shipping.ship_method_code,catalog_item_id,shipping.company_id)
              elsif shipping.shipping_code == 'FEDEX'
                sales_order_xml = Sales::DateUtility.get_sales_order_xml(shipping)
                shipping_doc = Hpricot::XML(sales_order_xml)
                shipping_doc = (shipping_doc/:sales_order/:sales_order_shippings/:sales_order_shipping)
                response,result = Sales::DateUtility.get_fedex_inhand_dates(shipping_doc,1,shipping.ship_zip,shipping.ship_country,shipping.ship_state,estimated_ship_date,shipping.ship_method_code,catalog_item_id,shipping.company_id)
              elsif shipping.shipping_code == 'USPS'
                response,result = Sales::DateUtility.get_usps_inhand_dates(1,shipping.ship_method_code,shipping.ship_zip,estimated_ship_date,catalog_item_id,shipping.company_id)
              end
            else
              return 'No ship method selected for the shipping' , 'error'
            end
            if result == 'error'
              error_doc = Hpricot::XML(response)
              message = parse_xml(error_doc/:errors/'error')
              return message,'error'
            else
              shipping_doc = Hpricot::XML(response)
              estimated_inhand_date = parse_xml(shipping_doc/:sales_order_shipping/'estimated_arrival_date')
              shipping.internal_inhand_date = estimated_inhand_date.to_date
              shipping.estimated_arrival_date = estimated_inhand_date.to_date
            end
            pdf_file_name_path = Sales::DateUtility.generate_shipdate_change_pdf(order.id,shipping.id,schema_name,shipping.internal_ship_date)
            email = Email::Email.send_email('SHIPDATEALERT',order)
            email.file_name_path = pdf_file_name_path
            emails << email
            activity_message = Artwork::ArtworkCrud.create_activity_message(order,'SHIP DATE CHANGED')
            order.create_sales_order_transaction_activity(activity_message)
          end
        end
      }
      return emails,'success'
    rescue Exception => ex
      return ex,'error'
    end
  end

  ## changed on 6 august 2012
  #  def self.approve_pre_production_order(order_doc,schema_name)
  #    begin
  #      id =  parse_xml(order_doc/'id') if (order_doc/'id').first
  #      trans_no =  parse_xml(order_doc/'trans_no') if (order_doc/'trans_no').first
  #      order = Sales::SalesOrder.find_by_trans_no(trans_no)
  #      sales_order_line = Sales::SalesOrderLine.find_by_id(id)
  #      return  if !order
  #      sales_order_preprod_shippings = Sales::SalesOrderShipping.find_by_sql ["select * from sales_order_shippings where trans_flag = 'A' and pre_prod_flag = 'Y' and shipping_flag = 'N' and sales_order_id = #{order.id}"]
  #      return 'Order Cannot Approve,bcos Pre Production Order is Not Shipped.','error' if sales_order_preprod_shippings[0]
  #      sales_order_shippings = Sales::SalesOrderShipping.find_by_sql ["select * from sales_order_shippings where trans_flag = 'A' and pre_prod_flag = 'N' and shipping_flag = 'N' and sales_order_id = #{order.id}"]
  #      message,text = update_approve_order_shipping_dates(order,sales_order_shippings,schema_name)
  #      if text == 'error'
  #        message = message
  #        raise ActiveRecord::Rollback
  #      end
  #      return message,'error' if (message != '' and message != 'success' and text == 'error')
  #      order.update_attributes!(:approve_spec_order_flag => 'Y',:order_status => 'PREPRODUCTION APPROVED')
  #      sales_order_line.update_attributes!(:direct_production_flag => 'N',:imposition_flag => 'N',:stitch_flag => 'N',:print_flag => 'N',:cut_flag => 'N',:indigo_code => '',:doc_code => '')
  #      activity = order.create_sales_order_transaction_activity('PREPRODUCTION APPROVED')
  #      activity.save!
  #      return order,'success'
  #    rescue Exception => ex
  #      return ex,'error'
  #    end
  #  end
  #
  #  def self.update_approve_order_shipping_dates(order,sales_order_shippings,schema_name)
  #    begin
  #      sales_order_lines = Sales::SalesOrderLine.where('trans_flag = ? AND sales_order_id = ? AND item_type = ?','A',order.id,'I').first
  #      catalog_item_id = sales_order_lines.catalog_item_id
  #      sales_order_shippings.each{|shipping|
  #        if !shipping.ship_date
  #          if shipping.estimated_ship_date and shipping.estimated_ship_date != ''
  #            estimated_ship_date = (Time.now.to_date + (shipping.estimated_ship_date.to_date - shipping.created_at.to_date).to_i)
  #            estimated_ship_date = Time.now.to_date
  #            shipping.estimated_ship_date = estimated_ship_date
  #            shipping.internal_ship_date = estimated_ship_date
  #          end
  #          if shipping.ship_method_code != ''
  #            if shipping.shipping_code == 'UPS'
  #              response,result = Sales::DateUtility.get_ups_inhand_dates(1,shipping.ship_zip,shipping.ship_country,shipping.ship_state,estimated_ship_date,shipping.ship_method_code,catalog_item_id,shipping.company_id)
  #            elsif shipping.shipping_code == 'FEDEX'
  #              sales_order_xml = Sales::DateUtility.get_sales_order_xml(shipping)
  #              shipping_doc = Hpricot::XML(sales_order_xml)
  #              shipping_doc = (shipping_doc/:sales_order/:sales_order_shippings/:sales_order_shipping)
  #              response,result = Sales::DateUtility.get_fedex_inhand_dates(shipping_doc,1,shipping.ship_zip,shipping.ship_country,shipping.ship_state,estimated_ship_date,shipping.ship_method_code,catalog_item_id,shipping.company_id)
  #            elsif shipping.shipping_code == 'USPS'
  #              response,result = Sales::DateUtility.get_usps_inhand_dates(1,shipping.ship_method_code,shipping.ship_zip,estimated_ship_date,catalog_item_id,shipping.company_id)
  #            end
  #          else
  #            return 'No ship method selected for the shipping' , 'error'
  #          end
  #          if result == 'error'
  #            error_doc = Hpricot::XML(response)
  #            message = parse_xml(error_doc/:errors/'error')
  #            return message,'error'
  #          else
  #            shipping_doc = Hpricot::XML(response)
  #            estimated_inhand_date = parse_xml(shipping_doc/:sales_order_shipping/'estimated_arrival_date')
  #            shipping.internal_inhand_date = estimated_inhand_date.to_date
  #            shipping.estimated_arrival_date = estimated_inhand_date.to_date
  #          end
  #          shipping.save!
  #          pdf_file_name_path = Sales::DateUtility.generate_shipdate_change_pdf(order.id,shipping.id,schema_name,shipping.internal_ship_date)
  #          email = Email::Email.send_email('SHIPDATEALERT',order)
  #          email.file_name_path = pdf_file_name_path
  #          email.save!
  #          activity_message = Artwork::ArtworkCrud.create_activity_message(order,'SHIP DATE CHANGED')
  #          activity = order.create_sales_order_transaction_activity(activity_message)
  #          activity.save!
  #        end
  #      }
  #      return 'success','success'
  #    rescue Exception => ex
  #      return ex,'error'
  #    end
  #  end

  ## changed on 6 August 2012
  #  def self.update_approve_order_shipping_dates(order,sales_order_shippings,schema_name)
  #    begin
  #      sales_order_shippings.each{|shipping|
  #        if !shipping.ship_date
  #          if shipping.estimated_ship_date and shipping.estimated_ship_date != ''
  #            estimated_ship_date = (Time.now.to_date + (shipping.estimated_ship_date.to_date - shipping.created_at.to_date).to_i)
  #            estimated_ship_date = Time.now.to_date
  #            shipping.estimated_ship_date = estimated_ship_date
  #            shipping.internal_ship_date = estimated_ship_date
  #          end
  #          message,text = Shipping::Ups.calculate_inhand_date(shipping,estimated_ship_date)
  #          if text == 'error'
  #            return message,'error'
  #          else
  #            shipping.internal_inhand_date = message.to_date
  #            shipping.estimated_arrival_date = message.to_date
  #          end
  #          shipping.save!
  #          pdf_file_name_path = Sales::DateUtility.generate_shipdate_change_pdf(order.id,shipping.id,schema_name,shipping.internal_ship_date)
  #          email = Email::Email.send_email('SHIPDATEALERT',order)
  #          email.file_name_path = pdf_file_name_path
  #          email.save!
  #          activity_message = Artwork::ArtworkCrud.create_activity_message(order,'SHIP DATE CHANGED')
  #          activity = order.create_sales_order_transaction_activity(activity_message)
  #          activity.save!
  #        end
  #      }
  #      return 'success','success'
  #    rescue Exception => ex
  #      return ex,'error'
  #    end
  #  end
end
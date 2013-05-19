class Production::ProductionIndigoCrud
  include General
  @config = YAML::load(File.open("#{Rails.root}/config/production_settings.yml"))
  #  Trans Type Codes
  #  S	Regular Order
  #  E	Re-Order
  #  P	Sample Order
  #  V	Virtual Order
  #  F	Spec Order
  def self.generate_indigo_codes(doc)
    begin
      id =  parse_xml(doc/:sales_orders/:sales_order/'id') if (doc/:sales_orders/:sales_order/'id').first
      sales_order_line = Sales::SalesOrderLine.find_by_id(id)
      @message = 'success'
      book_cd = 'INDG'
      book_nm = 'indigo_code'
      docu_typ = 'INDIGOCODE'
      sequence = Setup::Sequence.maximum(:book_lno, :conditions =>[ "book_cd =? and book_nm = ? and docu_typ = ? and company_id =? and trans_flag = 'A'",book_cd,book_nm, docu_typ,1])
      indigo_code =  sequence.to_i
      indigo_imposition = Production::IndigoImposition.new
      indigo_imposition.fill_default_header_values() if indigo_imposition.new_record?
      trans_no = Setup::Sequence.generate_docu_no(indigo_imposition.trans_bk,'INDIMP',indigo_imposition.class,sales_order_line.company_id) if indigo_imposition.new_record?
      indigo_imposition.indigo_code = indigo_code
      indigo_imposition.trans_no = trans_no
      indigo_imposition.company_id = sales_order_line.company_id
      indigo_imposition.save!
      (doc/:sales_orders/:sales_order).each{|order_doc|
        message = create_imposition_inbox_lines(order_doc,indigo_code)
        if message != 'success'
          @message = 'error'
          break
        end
      }
    rescue Exception => ex
      return ex,indigo_code
    end
    return @message,indigo_code
  end

  def self.create_imposition_inbox_lines(order_doc,indigo_code)
    begin
      id =  parse_xml(order_doc/'id') if (order_doc/'id').first
      #      trans_no =  parse_xml(order_doc/'trans_no') if (order_doc/'trans_no').first
      #      order= Sales::SalesOrder.find_by_trans_no(trans_no)
      max_indigo_code = Setup::Sequence.maximum(:book_lno, :conditions =>[ "book_cd =? and book_nm = ? and docu_typ = ? and company_id =? and trans_flag = ?",'INDG','indigo_code','INDIGOCODE',1,'A'])
      if (max_indigo_code.to_i) == indigo_code.to_i
        sequence = Setup::Sequence.find_by_book_cd_and_book_nm_and_docu_typ_and_company_id_and_trans_flag('INDG','indigo_code','INDIGOCODE',1,'A')
        sequence.update_attributes!(:book_lno => (max_indigo_code.to_i + 1))
      end
      sales_order_line = Sales::SalesOrderLine.find_by_id(id)
      return  if !sales_order_line
      #      order.update_attributes!(:order_status => 'IMPOSITION COMPLETE')
      sales_order_line.update_attributes!(:indigo_code => indigo_code)
      #      activity = order.create_sales_order_transaction_activity('IMPOSITION COMPLETE')
      #      activity.save!
    rescue Exception => ex
      return ex
    end
    return 'success'
  end

  def self.list_imposition_sheets(indigo_code)
    indigo_imposition = Production::IndigoImposition.find_by_indigo_code(indigo_code)
    indigo_imposition
  end
  def self.create_imposition_sheets(doc)
    begin
      orders = [] ; text = '' ; message = ''
      indigo_code  = parse_xml(doc/:params/'indigo_code')
      imposition_file_name  = parse_xml(doc/:params/'imposition_file_name')
      imposition_file_type  = parse_xml(doc/:params/'imposition_file_type')
      print_ready_flag  = parse_xml(doc/:params/'print_ready_flag')
      comments  = parse_xml(doc/:params/'comments')
      indigo_imposition = Production::IndigoImposition.find_by_indigo_code(indigo_code)
      return 'error' if !indigo_imposition
      indigo_imposition.update_attributes!(:imposition_file_name => imposition_file_name,:imposition_file_type => imposition_file_type,:comments => comments,:print_ready_flag => print_ready_flag)
      if print_ready_flag == 'Y'
        sales_order_lines = Sales::SalesOrderLine.find_all_by_indigo_code(indigo_code)
        sales_order_lines.each{|sales_order_line|
          order = Sales::SalesOrder.find_by_trans_no(sales_order_line.trans_no)
          if sales_order_line.reject_from_imposition_flag == 'Y'
            message = "Order #{order.trans_no} modified. Please refresh screen"
            text = 'error'
            break
          else
            order.order_status = IMPOSITION_COMPLETE
            sales_order_line.imposition_flag = 'Y' ; sales_order_line.imposition_date = Time.now ; sales_order_line.print_ready_flag = print_ready_flag
            order.sales_order_lines.each {|sales_order_line|
              if sales_order_line.item_type == 'I' and sales_order_line.trans_flag == 'A'
                sales_order_line.imposition_flag = 'Y' ; sales_order_line.imposition_date = Time.now ; sales_order_line.print_ready_flag = print_ready_flag
              end
            }
            activity_message = Artwork::ArtworkCrud.create_activity_message(order,'IMPOSITION COMPLETE')
            order.create_sales_order_transaction_activity(activity_message)
            workflow_location = Sales::CurrentLocationLogic.find_order_location(order,order.order_status,order.artwork_status)
            order.workflow_location = workflow_location
            orders << order
          end
        }
        if text != 'error'
          orders.each {|order|
            save_proc = Proc.new{
              order.save!
              order.sales_order_lines.each {|line| line.save!}
              order.sales_order_transaction_activities.each {|activity| activity.save!}
            }
            order.save_transaction(&save_proc)
          }
        else
          return message
        end  
      end
    rescue Exception => ex
      return ex
    end
    return 'success'
  end
  ## Working fine but it does not have transaction block
  #  def self.create_imposition_sheets(doc)
  #    begin
  #      indigo_code  = parse_xml(doc/:params/'indigo_code')
  #      imposition_file_name  = parse_xml(doc/:params/'imposition_file_name')
  #      imposition_file_type  = parse_xml(doc/:params/'imposition_file_type')
  #      print_ready_flag  = parse_xml(doc/:params/'print_ready_flag')
  #      comments  = parse_xml(doc/:params/'comments')
  #      indigo_imposition = Production::IndigoImposition.find_by_indigo_code(indigo_code)
  #      return 'error' if !indigo_imposition
  #      indigo_imposition.update_attributes!(:imposition_file_name => imposition_file_name,:imposition_file_type => imposition_file_type,:comments => comments,:print_ready_flag => print_ready_flag)
  #      if print_ready_flag == 'Y'
  #        sales_order_lines = Sales::SalesOrderLine.find_all_by_indigo_code(indigo_code)
  #        sales_order_lines.each{|sales_order_line|
  #          order = Sales::SalesOrder.find_by_trans_no(sales_order_line.trans_no)
  #          order.update_attributes!(:order_status => IMPOSITION_COMPLETE)
  #          sales_order_line.update_attributes!(:imposition_flag => 'Y',:imposition_date => Time.now,:print_ready_flag => print_ready_flag)
  #          activity_message = Artwork::ArtworkCrud.create_activity_message(order,'IMPOSITION COMPLETE')
  #          activity = order.create_sales_order_transaction_activity(activity_message)
  #          activity.save!
  #          workflow_location = Sales::CurrentLocationLogic.find_order_status(order.trans_no)
  #          order.update_attributes!(:workflow_location => workflow_location)
  #        }
  #      end
  #    rescue Exception => ex
  #      return ex
  #    end
  #    return 'success'
  #  end

  def self.create_accept_reject_imposition_sheets(doc)
    orders = []
    (doc/:sales_orders/:sales_order).each{|order_doc|
      order = create_accept_reject_imposition_sheet(order_doc)
      orders <<  order if order
    }
    orders
  end
  
  def self.create_accept_reject_imposition_sheet(doc)
    order = add_or_modify_accept_reject_imposition_sheet(doc)
    reject_from_imposition_flag =  parse_xml(doc/'reject_from_imposition_flag') if (doc/'reject_from_imposition_flag').first
    imposition_reject_reason =  parse_xml(doc/'imposition_reject_reason') if (doc/'imposition_reject_reason').first
    if reject_from_imposition_flag == 'Y'
      order.artworkreviewed_flag = 'N'
      order.artworksenttocust_flag = 'N'
      order.artworkapprovedbycust_flag = ''
      order.artwork_status = REJECTED_FROM_IMPOSITION
      sales_order_line = Sales::SalesOrderLine.find_by_sales_order_id_and_item_type(order.id,'I')
      sales_order_line.doc_code = '' ; sales_order_line.indigo_code = '' ; sales_order_line.reject_from_imposition_flag = reject_from_imposition_flag
      sales_order_line.imposition_flag = 'N' ; sales_order_line.imposition_date = '' ; sales_order_line.print_ready_flag = 'N'
      sales_order_line.imposition_reject_reason = imposition_reject_reason
      order.sales_order_artworks.each{|artwork|
        artwork.select_yn = 'N'
        artwork.final_artwork_flag = 'N'
      }
      activity_message = Artwork::ArtworkCrud.create_activity_message(order,order.artwork_status)
      order.create_sales_order_transaction_activity(activity_message)
      workflow_location = Sales::CurrentLocationLogic.find_order_location(order,order.order_status,order.artwork_status)
      order.workflow_location = workflow_location
    end
    return  if !order
    save_proc = Proc.new{
      sales_order_line.save!
      order.save!
      order.sales_order_transaction_activities.each {|activity| activity.save!}
      order.sales_order_artworks.each {|artwork| artwork.save!}
    }
    order.save_transaction(&save_proc)
    return order
  end

  ## Working Fine just code refining
  #  def self.create_accept_reject_imposition_sheet(doc)
  #    order = add_or_modify_accept_reject_imposition_sheet(doc)
  #    reject_from_imposition_flag =  parse_xml(doc/'reject_from_imposition_flag') if (doc/'reject_from_imposition_flag').first
  #    imposition_reject_reason =  parse_xml(doc/'imposition_reject_reason') if (doc/'imposition_reject_reason').first
  #    if reject_from_imposition_flag == 'Y'
  #      order.artworkreviewed_flag = 'N'
  #      order.artworksenttocust_flag = 'N'
  #      order.artworkapprovedbycust_flag = ''
  #      order.artwork_status = REJECTED_FROM_IMPOSITION
  #      sales_order_line = Sales::SalesOrderLine.find_by_sales_order_id_and_item_type(order.id,'I')
  #      sales_order_line.update_attributes!(:doc_code => '',:indigo_code => '',:reject_from_imposition_flag => reject_from_imposition_flag, :imposition_flag => 'N',:imposition_date => '',:print_ready_flag => 'N',:imposition_reject_reason=>imposition_reject_reason)
  #    end
  #    return  if !order
  #    save_proc = Proc.new{
  #      if reject_from_imposition_flag == 'Y'
  #        order.sales_order_artworks.each{|artwork|
  #          artwork.select_yn = 'N'
  #          artwork.final_artwork_flag = 'N'
  #        }
  #        activity_message = Artwork::ArtworkCrud.create_activity_message(order,order.artwork_status)
  #        activity = order.create_sales_order_transaction_activity(activity_message)
  #        activity.save!
  #        order.save!
  #        workflow_location = Sales::CurrentLocationLogic.find_order_status(order.trans_no)
  #        order.update_attributes!(:workflow_location => workflow_location)
  #      end
  #      order.sales_order_artworks.save_line
  #    }
  #    order.save_transaction(&save_proc)
  #    return order
  #  end

  def self.add_or_modify_accept_reject_imposition_sheet(doc)
    id =  parse_xml(doc/'id') if (doc/'id').first
    order = Sales::SalesOrder.find_or_create(id)
    return if !order
    #    order.apply_attributes(doc)
    order.max_serial_no = order.sales_order_artworks.maximum_serial_no
    order.build_lines(doc/:sales_order_artworks/:sales_order_artwork)
    return order
  end

  def self.decal_imposition_inbox(doc)
    condition = "so.trans_flag = 'A' AND so.artworkreviewed_flag = 'Y'
                     AND (so.orderentrycomplete_flag = 'Y' AND (so.qc_off_flag = 'Y' or so.orderqcstatus_flag = 'Y'))
                     AND ((so.paper_proof_flag = 'Y' AND so.artworkapprovedbycust_flag = 'A') or (so.paper_proof_flag = 'N'))
                     AND sol.blank_good_flag <> 'Y' AND so.blank_order_flag <> 'Y' AND sol.item_type = 'I' and sol.trans_flag = 'A' and sol.imposition_flag = 'N'
                     AND (soav.catalog_attribute_code = '#{ATTRIBUTE_VALUE_DECAL}' and soav.catalog_attribute_value_code <> '' and (catalog_items.workflow = '#{WORKFLOW_DIRECT_DECAL_DIGITEK}' or catalog_items.workflow = '#{WORKFLOW_WATER}'))
                     AND so.trans_type in ('S','E') AND (soa.final_artwork_flag = 'Y') AND so.ordercancelstatus_flag = 'N' and soav.trans_flag = 'A' and soa.trans_flag = 'A'"
    spec_order_condition = "so.trans_flag = 'A' AND so.artworkreviewed_flag = 'Y'
                     AND (so.orderentrycomplete_flag = 'Y' AND (so.qc_off_flag = 'Y' or so.orderqcstatus_flag = 'Y'))
                     AND ((so.paper_proof_flag = 'Y' AND so.artworkapprovedbycust_flag = 'A') or (so.paper_proof_flag = 'N'))
                     AND sol.blank_good_flag <> 'Y' AND so.blank_order_flag <> 'Y' AND sol.item_type = 'I' and sol.trans_flag = 'A' and sol.imposition_flag = 'N'
                     AND (soav.catalog_attribute_code = '#{ATTRIBUTE_VALUE_DECAL}' and soav.catalog_attribute_value_code <> '' and (catalog_items.workflow = '#{WORKFLOW_DIRECT_DECAL_DIGITEK}' or catalog_items.workflow = '#{WORKFLOW_WATER}'))
                     AND so.trans_type in ('F') AND ((sales_order_shippings.pre_prod_flag='Y' and sales_order_shippings.shipping_flag='N') or (so.approve_spec_order_flag = 'Y' and sales_order_shippings.pre_prod_flag='N'))
                     AND (soa.final_artwork_flag = 'Y') AND so.ordercancelstatus_flag = 'N' and soav.trans_flag = 'A' and soa.trans_flag = 'A'"
    condition = convert_sql_to_db_specific(condition)
    Sales::SalesOrder.find_by_sql ["select CAST(( select (
                                  select * from (select distinct so.customer_artwork_reject_reason,so.distributed_by_text,soa.artwork_version,so.ext_ref_no,types.description as order_type,so.trans_type,
                                         soav.catalog_attribute_value_code,so.trans_date,customers.name,customers.code as customer_code,
                                         so.multi_description,so.payment_status,so.rushorder_flag,so.artwork_status,so.order_status,so.trans_no,sol.serial_no,so.logo_name,sol.catalog_item_code,sol.id,
                                         101  as shipping_serial_no,sol.reason,sol.indigo_code,sol.item_description,sol.item_qty,so.ship_date,so.order_flagged from sales_orders so
                                  inner join sales_order_lines sol on sol.sales_order_id = so.id
                                  inner join catalog_items on catalog_items.id = sol.catalog_item_id
                                  inner join customers on customers.id = so.customer_id
                                  inner join sales_order_attributes_values soav on soav.sales_order_id = so.id
                                  inner join sales_order_artworks soa on soa.sales_order_id = so.id
                                  inner join users on users.id = so.updated_by
                                  left outer join types on (
                                          types.type_cd = 'trans_type'
                                          and types.subtype_cd = 'so'
                                          and so.trans_type = types.value
                                          )
                                  where #{condition}
UNION
                                  select distinct so.customer_artwork_reject_reason,so.distributed_by_text,soa.artwork_version,so.ext_ref_no,types.description as order_type,so.trans_type,
                                         soav.catalog_attribute_value_code,so.trans_date,customers.name,customers.code as customer_code,
                                         so.multi_description,so.payment_status,so.rushorder_flag,so.artwork_status,so.order_status,so.trans_no,sol.serial_no,so.logo_name,sol.catalog_item_code,sol.id,
                                         sales_order_shippings.serial_no as shipping_serial_no,sol.reason,sol.indigo_code,sol.item_description,sales_order_shippings.ship_qty as item_qty,so.ship_date,so.order_flagged from sales_orders so
                                  inner join sales_order_lines sol on sol.sales_order_id = so.id
                                  inner join catalog_items on catalog_items.id = sol.catalog_item_id
                                  inner join customers on customers.id = so.customer_id
                                  inner join sales_order_attributes_values soav on soav.sales_order_id = so.id
                                  inner join sales_order_artworks soa on soa.sales_order_id = so.id
                                  inner join sales_order_shippings ON sales_order_shippings.sales_order_id = so.id
                                  inner join users on users.id = so.updated_by
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
  ## to fetch data based on clear metallic and white BUTTONS
  def self.list_decal_imposition_option_data(doc) 
    option =  parse_xml(doc/'options') if (doc/'options').first
    condition = "so.trans_flag = 'A' AND so.artworkreviewed_flag = 'Y'
                     AND (so.orderentrycomplete_flag = 'Y' AND (so.qc_off_flag = 'Y' or so.orderqcstatus_flag = 'Y'))
                     AND ((so.paper_proof_flag = 'Y' AND so.artworkapprovedbycust_flag = 'A') or (so.paper_proof_flag = 'N'))
                     AND sol.blank_good_flag <> 'Y' AND sol.item_type = 'I' and sol.trans_flag = 'A' and sol.imposition_flag = 'N'
                     AND (soav.catalog_attribute_code = '#{ATTRIBUTE_VALUE_DECAL}' and soav.catalog_attribute_value_code = ?  and (catalog_items.workflow = '#{WORKFLOW_DIRECT_DECAL_DIGITEK}' or catalog_items.workflow = '#{WORKFLOW_WATER}'))
                     AND so.trans_type in ('S','E') AND (soa.final_artwork_flag = 'Y') AND so.ordercancelstatus_flag = 'N' and soav.trans_flag = 'A' and soa.trans_flag = 'A'"
    spec_condition = "so.trans_flag = 'A' AND so.artworkreviewed_flag = 'Y'
                     AND (so.orderentrycomplete_flag = 'Y' AND (so.qc_off_flag = 'Y' or so.orderqcstatus_flag = 'Y'))
                     AND ((so.paper_proof_flag = 'Y' AND so.artworkapprovedbycust_flag = 'A') or (so.paper_proof_flag = 'N'))
                     AND sol.blank_good_flag <> 'Y' AND sol.item_type = 'I' and sol.trans_flag = 'A' and sol.imposition_flag = 'N'
                     AND (soav.catalog_attribute_code = '#{ATTRIBUTE_VALUE_DECAL}' and soav.catalog_attribute_value_code = ? and (catalog_items.workflow = '#{WORKFLOW_DIRECT_DECAL_DIGITEK}' or catalog_items.workflow = '#{WORKFLOW_WATER}'))
                     AND so.trans_type in ('F') AND ((sales_order_shippings.pre_prod_flag='Y' and sales_order_shippings.shipping_flag='N') or (so.approve_spec_order_flag = 'Y' and sales_order_shippings.pre_prod_flag='N'))
                     AND (soa.final_artwork_flag = 'Y') AND so.ordercancelstatus_flag = 'N' and soav.trans_flag = 'A' and soa.trans_flag = 'A'"

    condition = convert_sql_to_db_specific(condition)
    Sales::SalesOrder.find_by_sql ["select CAST(( select (
                                  select * from (select distinct '' as vs, '' as user_name,soa.artwork_version,so.ext_ref_no,types.description as order_type,so.trans_type,
                                         soav.catalog_attribute_value_code,so.trans_date,customers.name,customers.code as customer_code,
                                         so.multi_description,so.payment_status,so.rushorder_flag,so.artwork_status,so.order_status,so.trans_no,sol.serial_no,so.logo_name,sol.catalog_item_code,sol.id,
                                         101  as shipping_serial_no,sol.reason,sol.indigo_code,sol.item_description,sol.item_qty,so.ship_date,so.order_flagged from sales_orders so
                                  inner join sales_order_lines sol on sol.sales_order_id = so.id
                                  inner join catalog_items on catalog_items.id = sol.catalog_item_id
                                  inner join customers on customers.id = so.customer_id
                                  inner join sales_order_attributes_values soav on soav.sales_order_id = so.id
                                  inner join sales_order_artworks soa on soa.sales_order_id = so.id
                                  inner join users on users.id = so.updated_by
                                  left outer join types on (
                                          types.type_cd = 'trans_type'
                                          and types.subtype_cd = 'so'
                                          and so.trans_type = types.value
                                          )
                                  where #{condition}
UNION
                                  select distinct '' as vs, '' as user_name,soa.artwork_version,so.ext_ref_no,types.description as order_type,so.trans_type,
                                         soav.catalog_attribute_value_code,so.trans_date,customers.name,customers.code as customer_code,
                                         so.multi_description,so.payment_status,so.rushorder_flag,so.artwork_status,so.order_status,so.trans_no,sol.serial_no,so.logo_name,sol.catalog_item_code,sol.id,
                                         sales_order_shippings.serial_no as shipping_serial_no,sol.reason,sol.indigo_code,sol.item_description,sales_order_shippings.ship_qty as item_qty,so.ship_date,so.order_flagged from sales_orders so
                                  inner join sales_order_lines sol on sol.sales_order_id = so.id
                                  inner join catalog_items on catalog_items.id = sol.catalog_item_id
                                  inner join customers on customers.id = so.customer_id
                                  inner join sales_order_attributes_values soav on soav.sales_order_id = so.id
                                  inner join sales_order_artworks soa on soa.sales_order_id = so.id
                                  inner join sales_order_shippings ON sales_order_shippings.sales_order_id = so.id
                                  inner join users on users.id = so.updated_by
                                  left outer join types on (
                                          types.type_cd = 'trans_type'
                                          and types.subtype_cd = 'so'
                                          and so.trans_type = types.value
                                          )
                                  where #{spec_condition}) as result
                                  order by result.order_flagged desc,result.rushorder_flag desc, result.ship_date
                                  FOR XML PATH('sales_order'), TYPE,ELEMENTS XSINIL
                                  )FOR XML PATH('sales_orders')) AS varchar(MAX)) as xmlcol",option,option
    ]
  end

  def self.decal_print_inbox(doc)
    condition = "so.trans_flag = 'A' AND so.artworkreviewed_flag = 'Y'
                     AND (so.orderentrycomplete_flag = 'Y' AND (so.qc_off_flag = 'Y' or so.orderqcstatus_flag = 'Y'))
                     AND ((so.paper_proof_flag = 'Y' AND so.artworkapprovedbycust_flag = 'A') or (so.paper_proof_flag = 'N'))
                     AND sol.blank_good_flag <> 'Y' AND sol.item_type = 'I' and sol.trans_flag = 'A' and sol.print_flag = 'N'
                     AND sol.imposition_flag = 'Y'
                     AND (soav.catalog_attribute_code = '#{ATTRIBUTE_VALUE_DECAL}' and soav.catalog_attribute_value_code <> '' and (catalog_items.workflow = '#{WORKFLOW_DIRECT_DECAL_DIGITEK}' or catalog_items.workflow = '#{WORKFLOW_WATER}'))
                     AND so.trans_type in ('S','E') AND (soa.final_artwork_flag = 'Y') AND so.ordercancelstatus_flag = 'N' and soav.trans_flag = 'A' and soa.trans_flag = 'A'"
    spec_order_condition = "so.trans_flag = 'A' AND so.artworkreviewed_flag = 'Y'
                     AND (so.orderentrycomplete_flag = 'Y' AND (so.qc_off_flag = 'Y' or so.orderqcstatus_flag = 'Y'))
                     AND ((so.paper_proof_flag = 'Y' AND so.artworkapprovedbycust_flag = 'A') or (so.paper_proof_flag = 'N'))
                     AND sol.blank_good_flag <> 'Y' AND sol.item_type = 'I' and sol.trans_flag = 'A' and sol.print_flag = 'N'
                     AND sol.imposition_flag = 'Y' 
                     AND (soav.catalog_attribute_code = '#{ATTRIBUTE_VALUE_DECAL}' and soav.catalog_attribute_value_code <> '' and (catalog_items.workflow = '#{WORKFLOW_DIRECT_DECAL_DIGITEK}' or catalog_items.workflow = '#{WORKFLOW_WATER}'))
                     AND so.trans_type in ('F') AND ((sales_order_shippings.pre_prod_flag='Y' and sales_order_shippings.shipping_flag='N') or (so.approve_spec_order_flag = 'Y' and sales_order_shippings.pre_prod_flag='N'))
                     AND (soa.final_artwork_flag = 'Y') AND so.ordercancelstatus_flag = 'N' and soav.trans_flag = 'A' and soa.trans_flag = 'A'"
    condition = convert_sql_to_db_specific(condition)
    Sales::SalesOrder.find_by_sql ["select CAST(( select (
                                  select * from (select distinct '' as vs, '' as user_name,soa.artwork_version,so.ext_ref_no,types.description as order_type,so.trans_type,
                                         soav.catalog_attribute_value_code,so.trans_date,customers.name,customers.code as customer_code,
                                         so.multi_description,so.payment_status,so.rushorder_flag,so.artwork_status,so.order_status,so.trans_no,sol.serial_no,so.logo_name,sol.catalog_item_code,sol.id,
                                         indigo_impositions.imposition_file_name,indigo_impositions.imposition_file_type,101  as shipping_serial_no,sol.reason,sol.indigo_code,sol.item_description,
                                         sol.item_qty,so.ship_date,so.order_flagged,soa.artwork_file_name from sales_orders so
                                  inner join sales_order_lines sol on sol.sales_order_id = so.id
                                  inner join catalog_items on catalog_items.id = sol.catalog_item_id
                                  inner join customers on customers.id = so.customer_id
                                  inner join sales_order_attributes_values soav on soav.sales_order_id = so.id
                                  inner join users on users.id = so.updated_by
                                  inner join sales_order_artworks soa on soa.sales_order_id = so.id
                                  inner join indigo_impositions on indigo_impositions.indigo_code = sol.indigo_code
                                  left outer join types on (
                                          types.type_cd = 'trans_type'
                                          and types.subtype_cd = 'so'
                                          and so.trans_type = types.value
                                          )
                                  where #{condition}
UNION
                                  select distinct '' as vs, '' as user_name,soa.artwork_version,so.ext_ref_no,types.description as order_type,so.trans_type,
                                         soav.catalog_attribute_value_code,so.trans_date,customers.name,customers.code as customer_code,
                                         so.multi_description,so.payment_status,so.rushorder_flag,so.artwork_status,so.order_status,so.trans_no,sol.serial_no,so.logo_name,sol.catalog_item_code,sol.id,
                                         indigo_impositions.imposition_file_name,indigo_impositions.imposition_file_type,sales_order_shippings.serial_no as shipping_serial_no,sol.reason,sol.indigo_code,sol.item_description,
                                         sales_order_shippings.ship_qty as item_qty,so.ship_date,so.order_flagged,soa.artwork_file_name from sales_orders so
                                  inner join sales_order_lines sol on sol.sales_order_id = so.id
                                  inner join catalog_items on catalog_items.id = sol.catalog_item_id
                                  inner join customers on customers.id = so.customer_id
                                  inner join sales_order_attributes_values soav on soav.sales_order_id = so.id
                                  inner join users on users.id = so.updated_by
                                  inner join sales_order_shippings ON sales_order_shippings.sales_order_id = so.id
                                  inner join sales_order_artworks soa on soa.sales_order_id = so.id
                                  inner join indigo_impositions on indigo_impositions.indigo_code = sol.indigo_code
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

  def self.heivelberg_cut_inbox(doc)
    condition = "((so.paper_proof_flag = 'Y' AND so.artworkapprovedbycust_flag = 'A') or (so.paper_proof_flag = 'N'))
                     AND so.trans_flag = 'A' AND so.artworkreviewed_flag = 'Y'
                     AND (so.orderentrycomplete_flag = 'Y' AND (so.qc_off_flag = 'Y' or so.orderqcstatus_flag = 'Y'))
                     AND sol.blank_good_flag <> 'Y' AND sol.item_type = 'I' AND sol.trans_flag = 'A' AND sol.cut_flag = 'N' AND sol.print_flag = 'Y'
                     AND (soav.catalog_attribute_code = '#{CATALOG_ATTRIBUTE_CODE}' AND soav.catalog_attribute_value_code = '#{ATTRIBUTE_VALUE_DECAL}' and (catalog_items.workflow = '#{WORKFLOW_DIRECT_DECAL_DIGITEK}' or catalog_items.workflow = '#{WORKFLOW_WATER}'))
                     AND so.trans_type in ('S','E') AND (soa.final_artwork_flag = 'Y') AND so.ordercancelstatus_flag = 'N' and soav.trans_flag = 'A' and soa.trans_flag = 'A'"
    spec_order_condition = "((so.paper_proof_flag = 'Y' AND so.artworkapprovedbycust_flag = 'A') or (so.paper_proof_flag = 'N'))
                     AND so.trans_flag = 'A' AND so.artworkreviewed_flag = 'Y'
                     AND (so.orderentrycomplete_flag = 'Y' AND (so.qc_off_flag = 'Y' or so.orderqcstatus_flag = 'Y'))
                     AND sol.blank_good_flag <> 'Y' AND sol.item_type = 'I' AND sol.trans_flag = 'A' AND sol.cut_flag = 'N' AND sol.print_flag = 'Y'
                     AND (soav.catalog_attribute_code = '#{CATALOG_ATTRIBUTE_CODE}' AND soav.catalog_attribute_value_code = '#{ATTRIBUTE_VALUE_DECAL}' and (catalog_items.workflow = '#{WORKFLOW_DIRECT_DECAL_DIGITEK}' or catalog_items.workflow = '#{WORKFLOW_WATER}'))
                     AND so.trans_type in ('F') AND ((sales_order_shippings.pre_prod_flag='Y' and sales_order_shippings.shipping_flag='N') or (so.approve_spec_order_flag = 'Y' and sales_order_shippings.pre_prod_flag='N'))
                     AND (soa.final_artwork_flag = 'Y') AND so.ordercancelstatus_flag = 'N' and soav.trans_flag = 'A' and soa.trans_flag = 'A'"
    condition = convert_sql_to_db_specific(condition)
    Sales::SalesOrder.find_by_sql ["select CAST(( select (
                                  select * from (select distinct '' as vs, '' as user_name,soa.artwork_version,so.ext_ref_no,types.description as order_type,so.trans_type,so.trans_date,customers.name,customers.code as customer_code,
                                         so.multi_description,so.payment_status,so.rushorder_flag,so.artwork_status,so.order_status,so.trans_no,sol.serial_no,so.logo_name,sol.catalog_item_code,sol.id,
                                         101  as shipping_serial_no,sol.doc_code,sol.indigo_code,sol.item_description,sol.item_qty,so.ship_date,so.order_flagged from sales_orders so
                                  inner join sales_order_lines sol on sol.sales_order_id = so.id
                                  inner join catalog_items on catalog_items.id = sol.catalog_item_id
                                  inner join customers on customers.id = so.customer_id
                                  inner join users on users.id = so.updated_by
                                  inner join sales_order_artworks soa on soa.sales_order_id = so.id
                                  inner join sales_order_attributes_values soav on soav.sales_order_id = so.id
                                  left outer join types on (
                                          types.type_cd = 'trans_type'
                                          and types.subtype_cd = 'so'
                                          and so.trans_type = types.value
                                          )
                                  where #{condition}
UNION
                                  select distinct '' as vs, '' as user_name,soa.artwork_version,so.ext_ref_no,types.description as order_type,so.trans_type,so.trans_date,customers.name,customers.code as customer_code,
                                         so.multi_description,so.payment_status,so.rushorder_flag,so.artwork_status,so.order_status,so.trans_no,sol.serial_no,so.logo_name,sol.catalog_item_code,sol.id,
                                         sales_order_shippings.serial_no as shipping_serial_no,sol.doc_code,sol.indigo_code,sol.item_description,sales_order_shippings.ship_qty as item_qty,so.ship_date,so.order_flagged from sales_orders so
                                  inner join sales_order_lines sol on sol.sales_order_id = so.id
                                  inner join catalog_items on catalog_items.id = sol.catalog_item_id
                                  inner join customers on customers.id = so.customer_id
                                  inner join users on users.id = so.updated_by
                                  inner join sales_order_artworks soa on soa.sales_order_id = so.id
                                  inner join sales_order_shippings ON sales_order_shippings.sales_order_id = so.id
                                  inner join sales_order_attributes_values soav on soav.sales_order_id = so.id
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

  def self.view_all_indigo_print_proofs(doc,schema_name,url_with_port)
    begin
      artwork_array = []
      path = Setup::Type.find_by_type_cd_and_subtype_cd('UPLOAD_FOLDER','ATTACHMENT')
      if path
        directory =  "#{Dir.getwd}" + '/'+ path.value + schema_name
      end
      (doc/:params/'id').each{|line_id|
        line_doc = Hpricot::XML(line_id.to_s)
        line_id = parse_xml(line_doc/'id')
        order_line = Sales::SalesOrderLine.find_by_id(line_id)
        order = Sales::SalesOrder.find_by_id(order_line.sales_order_id)
        artwork = Sales::SalesOrderArtwork.find_by_trans_flag_and_sales_order_id_and_final_artwork_flag('A',order.id,'Y')
        artwork_filename = File.join(directory,artwork.artwork_file_name)
        absolute_filename,text = Artwork::ArtworkCrud.generate_artwork_acknowledgment_pdf(artwork,order,artwork_filename,order_line,schema_name)
        if text == 'error'
          return absolute_filename,'error'
        else
          artwork_array << absolute_filename
        end
      }
      ## if there is only single line id then it will show the original pdf and not convert it into image and embed in other pdf.
      if artwork_array.size == 1
        return artwork_array[0],'success'
      else
        pdf_path = Setup::Type.find(:first, :conditions=>['type_cd = ? and subtype_cd = ?','UPLOAD_FOLDER','REPORT_PRINT'])
        if pdf_path
          pdf_directory =  "#{Dir.getwd}" + pdf_path.value + schema_name
        end
        pdf = Prawn::Document.new(:template => "#{artwork_array[0]}",:page_size=>"A4")
        for artwork in artwork_array[1..-1]
          pdf.start_new_page(:template => artwork)
        end
        file_name = "#{Time.now().strftime('%Y%m%d%H%M%S')}_indigo_viewproof.pdf"
        pdf_filename = File.join(pdf_directory, file_name)
        pdf.render_file "#{pdf_filename}"
        return pdf_filename,'success'
      end
    rescue Exception => ex
      return ex,'error'
    end
  end


  ## This will generate HTML page with multiple pdfs.
  #  def self.view_all_indigo_print_proofs(doc,schema_name,url_with_port)
  #    begin
  #      artwork_array = []
  #      path = Setup::Type.find_by_type_cd_and_subtype_cd('UPLOAD_FOLDER','ATTACHMENT')
  #      if path
  #        directory =  "#{Dir.getwd}" + '/'+ path.value + schema_name
  #      end
  #      (doc/:params).each{|line_id|
  #        line_id = parse_xml(line_id/'id')
  #        order_line = Sales::SalesOrderLine.find_by_id(line_id)
  #        order = Sales::SalesOrder.find_by_id(order_line.sales_order_id)
  #        artwork = Sales::SalesOrderArtwork.find_by_trans_flag_and_sales_order_id_and_final_artwork_flag('A',order.id,'Y')
  #        artwork_filename = File.join(directory,artwork.artwork_file_name)
  #        absolute_filename,text = Artwork::ArtworkCrud.generate_artwork_acknowledgment_pdf(artwork,order,artwork_filename,order_line,schema_name)
  #        if text == 'error'
  #          return absolute_filename,'error'
  #        else
  #          filename = absolute_filename.split('/').last
  #          artwork_array << filename
  #        end
  #      }
  #      file_name = "#{Time.now().strftime('%Y%m%d%H%M%S')}_indigo_viewproof.html"
  #      spacing = "<br/><br/><hr/><br/><br/>"
  #      record ="<!DOCTYPE html><html><body>"
  #      count = 0
  #      artwork_array.each {|artwork|
  #        count = count + 1
  #        record= record + "<embed src=http://#{url_with_port}/reports/#{schema_name}/#{artwork} width='100%' height='100%'>
  #<p>It appears you don't have a PDF plugin for this browser.
  # No biggie... you can <a href='http://#{url_with_port}/reports/#{schema_name}/#{artwork}' target='_blank'>click here to
  # download the PDF file.</a></p>
  #{spacing if artwork_array.size != count}#"
  #      }
  #      record = record +"</body></html>"
  #      File.open("#{directory}/#{file_name}", 'w+') do|f|
  #        f.write(record)
  #      end
  #      ## record= record + "<iframe src=http://docs.google.com/gview?url=http://#{url_with_port}/attachments/#{schema_name}/#{artwork}&embedded=true style='width:100%; height:90%;' frameborder='0'></iframe>
  #    rescue Exception => ex
  #      return ex,'error'
  #    end
  #    return file_name,'success'
  #  end
end
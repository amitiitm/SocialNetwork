class Production::ProductionGumCrud
  include General
  @config = YAML::load(File.open("#{Rails.root}/config/production_settings.yml"))
  #  Trans Type Codes
  #  S	Regular Order
  #  E	Re-Order
  #  P	Sample Order
  #  V	Virtual Order
  #  F	Spec Order
  ## Tekweld Production generate doc_no service
  #  def self.generate_gum_doc_code
  #    book_cd = 'GUMD'
  #    book_nm = 'doc_number'
  #    docu_typ = 'DOCNUM'
  #    sequence = Setup::Sequence.maximum(:book_lno, :conditions =>[ "book_cd =? and book_nm = ? and docu_typ = ? and company_id =? and trans_flag = 'A'",book_cd,book_nm, docu_typ,1])
  #    #    sequence.update_attributes!(:book_lno => sequence.book_lno.to_i + 1)
  #    return sequence
  #  end

  def self.generate_gum_doc_codes(doc)
    begin
      id =  parse_xml(doc/:sales_orders/:sales_order/'id') if (doc/:sales_orders/:sales_order/'id').first
      sales_order_line = Sales::SalesOrderLine.find_by_id(id)
      @message = 'success'
      book_cd = 'GUMD'
      book_nm = 'doc_number'
      docu_typ = 'DOCNUM'
      sequence = Setup::Sequence.maximum(:book_lno, :conditions =>[ "book_cd =? and book_nm = ? and docu_typ = ? and company_id =? and trans_flag = 'A'",book_cd,book_nm, docu_typ,1])
      doc_code =  sequence.to_i
      indigo_imposition = Production::IndigoImposition.new
      indigo_imposition.fill_default_header_values() if indigo_imposition.new_record?
      trans_no = Setup::Sequence.generate_docu_no(indigo_imposition.trans_bk,'INDIMP',indigo_imposition.class,sales_order_line.company_id) if indigo_imposition.new_record?
      indigo_imposition.doc_code = doc_code
      indigo_imposition.trans_no = trans_no
      indigo_imposition.company_id = sales_order_line.company_id
      indigo_imposition.save!
      (doc/:sales_orders/:sales_order).each{|order_doc|
        message = create_imposition_gum_inbox_lines(order_doc,doc_code)
        if message != 'success'
          @message = 'error'
          break
        end
      }
    rescue Exception => ex
      return ex,doc_code
    end
    return @message,doc_code
  end

  def self.create_imposition_gum_inbox_lines(order_doc,doc_code)
    begin
      id =  parse_xml(order_doc/'id') if (order_doc/'id').first
      #      trans_no =  parse_xml(order_doc/'trans_no') if (order_doc/'trans_no').first
      #      order= Sales::SalesOrder.find_by_trans_no(trans_no)
      max_doc_code = Setup::Sequence.maximum(:book_lno, :conditions =>[ "book_cd =? and book_nm = ? and docu_typ = ? and company_id =? and trans_flag = ?",'GUMD','doc_number','DOCNUM',1,'A'])
      if (max_doc_code.to_i) == doc_code.to_i
        sequence = Setup::Sequence.find_by_book_cd_and_book_nm_and_docu_typ_and_company_id_and_trans_flag('GUMD','doc_number','DOCNUM',1,'A')
        sequence.update_attributes!(:book_lno => (max_doc_code.to_i + 1))
      end
      sales_order_line = Sales::SalesOrderLine.find_by_id(id)
      return  if !sales_order_line
      #      order.update_attributes!(:order_status => 'IMPOSITION COMPLETE')
      sales_order_line.update_attributes!(:doc_code => doc_code)
      #      activity = order.create_sales_order_transaction_activity('IMPOSITION COMPLETE')
      #      activity.save!
    rescue Exception => ex
      return ex
    end
    return 'success'
  end

  def self.list_gum_imposition_sheets(doc_code)
    indigo_imposition = Production::IndigoImposition.find_by_doc_code(doc_code)
    indigo_imposition
  end

  def self.create_gum_imposition_sheets(doc)
    begin
      orders = []; order_lines = []; text = '';  message = ''
      doc_code  = parse_xml(doc/:params/'doc_code')
      imposition_file_name  = parse_xml(doc/:params/'imposition_file_name')
      imposition_file_type  = parse_xml(doc/:params/'imposition_file_type')
      print_ready_flag  = parse_xml(doc/:params/'print_ready_flag')
      comments  = parse_xml(doc/:params/'comments')
      indigo_imposition = Production::IndigoImposition.find_by_doc_code(doc_code)
      return 'error' if !indigo_imposition
      indigo_imposition.update_attributes!(:imposition_file_name => imposition_file_name,:imposition_file_type => imposition_file_type,:comments => comments,:print_ready_flag => print_ready_flag)
      if print_ready_flag == 'Y'
        sales_order_lines = Sales::SalesOrderLine.find_all_by_doc_code(doc_code)
        sales_order_lines.each{|sales_order_line|
          order = Sales::SalesOrder.find_by_trans_no(sales_order_line.trans_no)
          if sales_order_line.reject_from_imposition_flag == 'Y'
            message = "Order #{order.trans_no} modified. Please refresh screen"
            text = 'error'
            break
          else
            order.order_status = IMPOSITION_COMPLETE
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
            order_lines << sales_order_line
          end
        }
      end
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
    rescue Exception => ex
      return ex
    end
    return 'success'
  end


  ## Working fine just code refinement done on 10 aug 2012
  #  def self.create_gum_imposition_sheets(doc)
  #    begin
  #      doc_code  = parse_xml(doc/:params/'doc_code')
  #      imposition_file_name  = parse_xml(doc/:params/'imposition_file_name')
  #      imposition_file_type  = parse_xml(doc/:params/'imposition_file_type')
  #      print_ready_flag  = parse_xml(doc/:params/'print_ready_flag')
  #      comments  = parse_xml(doc/:params/'comments')
  #      indigo_imposition = Production::IndigoImposition.find_by_doc_code(doc_code)
  #      return 'error' if !indigo_imposition
  #      indigo_imposition.update_attributes!(:imposition_file_name => imposition_file_name,:imposition_file_type => imposition_file_type,:comments => comments,:print_ready_flag => print_ready_flag)
  #      if print_ready_flag == 'Y'
  #        sales_order_lines = Sales::SalesOrderLine.find_all_by_doc_code(doc_code)
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



  ## Tekweld Production Inboxes Services
  def self.gum_imposition_inbox(doc)
    condition = "so.trans_flag = 'A' AND so.artworkreviewed_flag = 'Y'
                     AND (so.orderentrycomplete_flag = 'Y' AND (so.qc_off_flag = 'Y' or so.orderqcstatus_flag = 'Y'))
                     AND ((so.paper_proof_flag = 'Y' AND so.artworkapprovedbycust_flag = 'A') or (so.paper_proof_flag = 'N'))
                     AND sol.blank_good_flag <> 'Y' AND so.blank_order_flag <> 'Y' AND sol.item_type = 'I' and sol.trans_flag = 'A' and sol.imposition_flag = 'N'
                     AND (soav.catalog_attribute_code = '#{CATALOG_ATTRIBUTE_CODE}' AND soav.catalog_attribute_value_code = '#{ATTRIBUTE_VALUE_DOCUCOLOR}' and catalog_items.workflow = '#{WORKFLOW_DOCUCOLOR}')
                     AND so.trans_type in ('S','E') AND (soa.final_artwork_flag = 'Y') AND so.ordercancelstatus_flag = 'N' and soav.trans_flag = 'A' and soa.trans_flag = 'A'"
    spec_order_condition = " so.trans_flag = 'A' AND so.artworkreviewed_flag = 'Y'
                     AND (so.orderentrycomplete_flag = 'Y' AND (so.qc_off_flag = 'Y' or so.orderqcstatus_flag = 'Y'))
                     AND ((so.paper_proof_flag = 'Y' AND so.artworkapprovedbycust_flag = 'A') or (so.paper_proof_flag = 'N'))
                     AND sol.blank_good_flag <> 'Y' AND so.blank_order_flag <> 'Y' AND sol.item_type = 'I' and sol.trans_flag = 'A' and sol.imposition_flag = 'N'
                     AND (soav.catalog_attribute_code = '#{CATALOG_ATTRIBUTE_CODE}' AND soav.catalog_attribute_value_code = '#{ATTRIBUTE_VALUE_DOCUCOLOR}' and catalog_items.workflow = '#{WORKFLOW_DOCUCOLOR}')
                     AND so.trans_type in ('F') AND ((sales_order_shippings.pre_prod_flag='Y' and sales_order_shippings.shipping_flag='N') or (so.approve_spec_order_flag = 'Y' and sales_order_shippings.pre_prod_flag='N'))
                     AND (soa.final_artwork_flag = 'Y') AND so.ordercancelstatus_flag = 'N' and soav.trans_flag = 'A' and soa.trans_flag = 'A'"
    condition = convert_sql_to_db_specific(condition)
    Sales::SalesOrder.find_by_sql ["select CAST(( select (
                                  select * from (select distinct '' as vs, '' as user_name,soa.artwork_version,so.ext_ref_no,types.description as order_type,so.trans_type,so.trans_date,customers.name,customers.code as customer_code,
                                         so.multi_description,so.payment_status,so.rushorder_flag,so.artwork_status,so.order_status,so.trans_no,sol.serial_no,so.logo_name,sol.catalog_item_code,sol.id,
                                         101  as shipping_serial_no,sol.reason,sol.doc_code,sol.item_description,sol.item_qty,so.ship_date,so.order_flagged from sales_orders so
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
                                         sales_order_shippings.serial_no as shipping_serial_no,sol.reason,sol.doc_code,sol.item_description,sales_order_shippings.ship_qty as item_qty,so.ship_date,so.order_flagged from sales_orders so
                                  inner join sales_order_lines sol on sol.sales_order_id = so.id
                                  inner join catalog_items on catalog_items.id = sol.catalog_item_id
                                  inner join customers on customers.id = so.customer_id
                                  inner join users on users.id = so.updated_by
                                  inner join sales_order_shippings ON sales_order_shippings.sales_order_id = so.id
                                  inner join sales_order_artworks soa on soa.sales_order_id = so.id
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

  def self.gum_print_inbox(doc)
    condition = "so.trans_flag = 'A' AND so.artworkreviewed_flag = 'Y'
                     AND (so.orderentrycomplete_flag = 'Y' AND (so.qc_off_flag = 'Y' or so.orderqcstatus_flag = 'Y'))
                     AND ((so.paper_proof_flag = 'Y' AND so.artworkapprovedbycust_flag = 'A') or (so.paper_proof_flag = 'N'))
                     AND sol.blank_good_flag <> 'Y' AND sol.item_type = 'I' AND sol.trans_flag = 'A' and sol.print_flag = 'N'
                     AND sol.imposition_flag = 'Y'
                     AND (soav.catalog_attribute_code = '#{CATALOG_ATTRIBUTE_CODE}' AND soav.catalog_attribute_value_code = '#{ATTRIBUTE_VALUE_DOCUCOLOR}' and catalog_items.workflow = '#{WORKFLOW_DOCUCOLOR}')
                     AND so.trans_type in ('S','E') AND (soa.final_artwork_flag = 'Y') AND so.ordercancelstatus_flag = 'N' and soav.trans_flag = 'A' and soa.trans_flag = 'A'"
    spec_order_condition = "so.trans_flag = 'A' AND so.artworkreviewed_flag = 'Y'
                     AND (so.orderentrycomplete_flag = 'Y' AND (so.qc_off_flag = 'Y' or so.orderqcstatus_flag = 'Y'))
                     AND ((so.paper_proof_flag = 'Y' AND so.artworkapprovedbycust_flag = 'A') or (so.paper_proof_flag = 'N'))
                     AND sol.blank_good_flag <> 'Y' AND sol.item_type = 'I' AND sol.trans_flag = 'A' and sol.print_flag = 'N'
                     AND sol.imposition_flag = 'Y'
                     AND (soav.catalog_attribute_code = '#{CATALOG_ATTRIBUTE_CODE}' AND soav.catalog_attribute_value_code = '#{ATTRIBUTE_VALUE_DOCUCOLOR}' and catalog_items.workflow = '#{WORKFLOW_DOCUCOLOR}')
                     AND so.trans_type in ('F') AND ((sales_order_shippings.pre_prod_flag='Y' and sales_order_shippings.shipping_flag='N') or (so.approve_spec_order_flag = 'Y' and sales_order_shippings.pre_prod_flag='N'))
                     AND (soa.final_artwork_flag = 'Y') AND so.ordercancelstatus_flag = 'N' and soav.trans_flag = 'A' and soa.trans_flag = 'A'"
    condition = convert_sql_to_db_specific(condition)
    Sales::SalesOrder.find_by_sql ["select CAST(( select (
                                  select * from (select distinct '' as vs, '' as user_name,soa.artwork_version,so.ext_ref_no,types.description as order_type,so.trans_type,so.trans_date,customers.name,customers.code as customer_code,
                                         so.multi_description,so.payment_status,so.rushorder_flag,so.artwork_status,so.order_status,so.trans_no,sol.serial_no,so.logo_name,sol.catalog_item_code,sol.id,
                                         indigo_impositions.imposition_file_name,indigo_impositions.imposition_file_type,101  as shipping_serial_no,sol.reason,sol.doc_code,sol.item_description,sol.item_qty,so.ship_date,so.order_flagged,soa.artwork_file_name
                                  from sales_orders so
                                  inner join sales_order_lines sol on sol.sales_order_id = so.id
                                  inner join catalog_items on catalog_items.id = sol.catalog_item_id
                                  inner join customers on customers.id = so.customer_id
                                  inner join users on users.id = so.updated_by
                                  inner join sales_order_artworks soa on soa.sales_order_id = so.id
                                  inner join sales_order_attributes_values soav on soav.sales_order_id = so.id
                                  inner join indigo_impositions on indigo_impositions.doc_code = sol.doc_code
                                  left outer join types on (
                                          types.type_cd = 'trans_type'
                                          and types.subtype_cd = 'so'
                                          and so.trans_type = types.value
                                          )
                                  where #{condition}
UNION
                                  select distinct '' as vs, '' as user_name,soa.artwork_version,so.ext_ref_no,types.description as order_type,so.trans_type,so.trans_date,customers.name,customers.code as customer_code,
                                         so.multi_description,so.payment_status,so.rushorder_flag,so.artwork_status,so.order_status,so.trans_no,sol.serial_no,so.logo_name,sol.catalog_item_code,sol.id,
                                         indigo_impositions.imposition_file_name,indigo_impositions.imposition_file_type,sales_order_shippings.serial_no as shipping_serial_no,sol.reason,sol.doc_code,sol.item_description,
                                         sales_order_shippings.ship_qty as item_qty,so.ship_date,so.order_flagged,soa.artwork_file_name from sales_orders so
                                  inner join sales_order_lines sol on sol.sales_order_id = so.id
                                  inner join catalog_items on catalog_items.id = sol.catalog_item_id
                                  inner join customers on customers.id = so.customer_id
                                  inner join users on users.id = so.updated_by
                                  inner join sales_order_artworks soa on soa.sales_order_id = so.id
                                  inner join sales_order_shippings ON sales_order_shippings.sales_order_id = so.id
                                  inner join sales_order_attributes_values soav on soav.sales_order_id = so.id
                                  inner join indigo_impositions on indigo_impositions.doc_code = sol.doc_code
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
  
  def self.cut_inbox(doc)
    condition = "((so.paper_proof_flag = 'Y' AND so.artworkapprovedbycust_flag = 'A') or (so.paper_proof_flag = 'N'))
                     AND so.trans_flag = 'A' AND so.artworkreviewed_flag = 'Y'
                     AND (so.orderentrycomplete_flag = 'Y' AND (so.qc_off_flag = 'Y' or so.orderqcstatus_flag = 'Y'))
                     AND sol.blank_good_flag <> 'Y' AND sol.item_type = 'I' AND sol.trans_flag = 'A' AND sol.cut_flag = 'N' AND sol.print_flag = 'Y'
                     AND (soav.catalog_attribute_code = '#{CATALOG_ATTRIBUTE_CODE}' AND ((soav.catalog_attribute_value_code = '#{ATTRIBUTE_VALUE_DOCUCOLOR}' and catalog_items.workflow = '#{WORKFLOW_DOCUCOLOR}') or (soav.catalog_attribute_value_code = '#{ATTRIBUTE_VALUE_DECAL}' and (catalog_items.workflow = '#{WORKFLOW_DIRECT_DECAL_DIGITEK}' or catalog_items.workflow = '#{WORKFLOW_WATER}'))))
                     AND so.trans_type in ('S','E') AND (soa.final_artwork_flag = 'Y') AND so.ordercancelstatus_flag = 'N' and soav.trans_flag = 'A' and soa.trans_flag = 'A'"
    spec_order_condition = "((so.paper_proof_flag = 'Y' AND so.artworkapprovedbycust_flag = 'A') or (so.paper_proof_flag = 'N'))
                     AND so.trans_flag = 'A' AND so.artworkreviewed_flag = 'Y'
                     AND (so.orderentrycomplete_flag = 'Y' AND (so.qc_off_flag = 'Y' or so.orderqcstatus_flag = 'Y'))
                     AND sol.blank_good_flag <> 'Y' AND sol.item_type = 'I' AND sol.trans_flag = 'A' AND sol.cut_flag = 'N' AND sol.print_flag = 'Y'
                     AND (soav.catalog_attribute_code = '#{CATALOG_ATTRIBUTE_CODE}' AND ((soav.catalog_attribute_value_code = '#{ATTRIBUTE_VALUE_DOCUCOLOR}' and catalog_items.workflow = '#{WORKFLOW_DOCUCOLOR}') or (soav.catalog_attribute_value_code = '#{ATTRIBUTE_VALUE_DECAL}' and (catalog_items.workflow = '#{WORKFLOW_DIRECT_DECAL_DIGITEK}' or catalog_items.workflow = '#{WORKFLOW_WATER}'))))
                     AND so.trans_type in ('F') AND ((sales_order_shippings.pre_prod_flag='Y' and sales_order_shippings.shipping_flag='N') or (so.approve_spec_order_flag = 'Y' and sales_order_shippings.pre_prod_flag='N'))
                     AND (soa.final_artwork_flag = 'Y') AND so.ordercancelstatus_flag = 'N' and soav.trans_flag = 'A' and soa.trans_flag = 'A'"
    condition = convert_sql_to_db_specific(condition)
    Sales::SalesOrder.find_by_sql ["select CAST(( select (
                                  select * from (select distinct '' as vs, '' as user_name,soa.artwork_version,so.ext_ref_no,types.description as order_type,so.trans_type,so.trans_date,customers.name,customers.code as customer_code,
                                         so.multi_description,so.payment_status,so.rushorder_flag,
                                         soav.catalog_attribute_value_code,
                                         so.artwork_status,so.order_status,so.trans_no,sol.serial_no,so.logo_name,sol.catalog_item_code,sol.id,
                                         101  as shipping_serial_no,sol.doc_code,sol.indigo_code,sol.item_description,sol.item_qty,so.ship_date,so.order_flagged from sales_orders so
                                  inner join sales_order_lines sol on sol.sales_order_id = so.id
                                  inner join catalog_items on catalog_items.id = sol.catalog_item_id
                                  inner join customers on customers.id = so.customer_id
                                  inner join sales_order_attributes_values soav on soav.sales_order_id = so.id
                                  inner join users on users.id = so.updated_by
                                  inner join sales_order_artworks soa on soa.sales_order_id = so.id
                                  left outer join types on (
                                          types.type_cd = 'trans_type'
                                          and types.subtype_cd = 'so'
                                          and so.trans_type = types.value
                                          )
                                  where #{condition}
UNION
                                  select distinct '' as vs, '' as user_name,soa.artwork_version,so.ext_ref_no,types.description as order_type,so.trans_type,so.trans_date,customers.name,customers.code as customer_code,
                                         so.multi_description,so.payment_status,so.rushorder_flag,
                                         soav.catalog_attribute_value_code,
                                         so.artwork_status,so.order_status,so.trans_no,sol.serial_no,so.logo_name,sol.catalog_item_code,sol.id,
                                         sales_order_shippings.serial_no as shipping_serial_no,sol.doc_code,sol.indigo_code,sol.item_description,sales_order_shippings.ship_qty as item_qty,so.ship_date,so.order_flagged from sales_orders so
                                  inner join sales_order_lines sol on sol.sales_order_id = so.id
                                  inner join catalog_items on catalog_items.id = sol.catalog_item_id
                                  inner join customers on customers.id = so.customer_id
                                  inner join sales_order_attributes_values soav on soav.sales_order_id = so.id
                                  inner join users on users.id = so.updated_by
                                  inner join sales_order_artworks soa on soa.sales_order_id = so.id
                                  inner join sales_order_shippings ON sales_order_shippings.sales_order_id = so.id
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
end
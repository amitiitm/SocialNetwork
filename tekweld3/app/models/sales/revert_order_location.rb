class Sales::RevertOrderLocation
  include General



  def self.create_revert_order_stages(doc)
    workflow = ''
    stage_code =  parse_xml(doc/'stage_code') if (doc/'stage_code').first
    order_status =  parse_xml(doc/'order_status') if (doc/'order_status').first
    trans_no =  parse_xml(doc/'trans_no') if (doc/'trans_no').first
    order = Sales::SalesOrder.find_by_sql("Select * from sales_orders where trans_flag = 'A' and trans_no = #{trans_no}")
    if stage_code.upcase == order_status.upcase
      order[0].errors[:base] << "Your Order is Already On #{order_status} Location"
      return order
    end
    query = Sales::Query.find_by_sales_order_id_and_answer_flag(order[0].id,'N')
    if query
      order[0].errors[:base] << "This order contains some queries once they answered then you can revert this order."
      return order
    end
    sales_order_attributes_values = Sales::SalesOrderAttributesValue.find_by_trans_flag_and_sales_order_id_and_catalog_attribute_code('A',order[0].id,CATALOG_ATTRIBUTE_CODE)
    workflow = sales_order_attributes_values.catalog_attribute_value_code if sales_order_attributes_values
    trans_type = order[0].trans_type
    reorder_type = order[0].reorder_type
    reorder_flag = 'N'
    if(trans_type == TRANS_TYPE_REORDER and (reorder_type == REORDER_TYPE1 || reorder_type == REORDER_TYPE2))
      reorder_flag = 'Y'
    end
    case stage_code
    when NEW_ORDER
      order[0].orderentrycomplete_flag = 'N';order[0].orderqcstatus_flag = 'N';order[0].orderpickstatus_flag = 'N';
      order[0].orderacksent_flag = 'N';order[0].order_status = NEW_ORDER ;order[0].artwork_status = ARTWORK_RECEIVED;
      order[0].acknowledgment_status = NOT_SENT;
      order[0].customer_checked_flag = 'N'; order[0].contact_checked_flag = 'N';
      order[0].item_checked_flag = 'N'; order[0].quantity_checked_flag = 'N'; order[0].imprint_checked_flag = 'N';
      order[0].shipping_checked_flag = 'N'; order[0].billing_checked_flag = 'N'; order[0].email_checked_flag = 'N';
      order[0].distributed_by_flag = 'N'; order[0].distributed_by_text = ''; order[0].salt = '';order[0].recommendation = '';
      order[0].orderreassigned_flag = 'N'; order[0].inventory_status = ''
      revert_reorder_flags(order[0])
      revert_order_line_flags(order[0])
      if(reorder_flag == 'N' and order[0].paper_proof_flag == 'Y')
        order[0].sales_order_artworks.each{|artwork|
          artwork.final_artwork_flag = 'N'
        }
      end
      order[0].create_sales_order_transaction_activity("ORDER STAGE REVERTED FROM #{order_status} TO #{stage_code}")
    when ENTRY_COMPLETED
      if order[0].qc_off_flag == 'N'
        order[0].orderqcstatus_flag = 'N';order[0].orderacksent_flag = 'N'; order[0].acknowledgment_status = NOT_SENT;;
        order[0].inventory_status = '';
        order[0].customer_checked_flag = 'N'; order[0].contact_checked_flag = 'N';
        order[0].item_checked_flag = 'N'; order[0].quantity_checked_flag = 'N'; order[0].imprint_checked_flag = 'N';
        order[0].shipping_checked_flag = 'N'; order[0].billing_checked_flag = 'N'; order[0].email_checked_flag = 'N';
        order[0].inventory_status = '';order[0].recommendation = ''
      end
      order[0].order_status = ENTRY_COMPLETED; order[0].artwork_status = ARTWORK_RECEIVED;
      order[0].artworkassigned_flag = 'N'; order[0].artworkcompleted_flag = 'N'; order[0].artworkreviewed_flag = 'N';
      order[0].artworksenttocust_flag = 'N'; order[0].artworkapprovedbycust_flag = ''
      order[0].distributed_by_flag = 'N'; order[0].distributed_by_text = ''; order[0].salt = ''
      order[0].orderreassigned_flag = 'N'
      revert_reorder_flags(order[0])
      revert_order_line_flags(order[0])
      if(reorder_flag == 'N' and order[0].paper_proof_flag == 'Y')
        order[0].sales_order_artworks.each{|artwork|
          artwork.final_artwork_flag = 'N'
        }
      end
      order[0].create_sales_order_transaction_activity("ORDER STAGE REVERTED FROM #{order_status} TO #{stage_code}")
    when ORDER_REASSIGNED_FOR_ENTRY
      order[0].orderentrycomplete_flag = 'N';order[0].orderqcstatus_flag = 'N';order[0].orderpickstatus_flag = 'N';
      order[0].orderacksent_flag = 'N';order[0].order_status = ORDER_REASSIGNED_FOR_ENTRY ;order[0].artwork_status = ARTWORK_RECEIVED;
      order[0].acknowledgment_status = NOT_SENT;
      order[0].customer_checked_flag = 'N'; order[0].contact_checked_flag = 'N';
      order[0].item_checked_flag = 'N'; order[0].quantity_checked_flag = 'N'; order[0].imprint_checked_flag = 'N';
      order[0].shipping_checked_flag = 'N'; order[0].billing_checked_flag = 'N'; order[0].email_checked_flag = 'N';
      order[0].distributed_by_flag = 'N'; order[0].distributed_by_text = ''; order[0].salt = '';order[0].recommendation = '';
      order[0].inventory_status = '';
      revert_reorder_flags(order[0])
      revert_order_line_flags(order[0])
      if(reorder_flag == 'N' and order[0].paper_proof_flag == 'Y')
        order[0].sales_order_artworks.each{|artwork|
          artwork.final_artwork_flag = 'N'
        }
      end
      order[0].create_sales_order_transaction_activity("ORDER STAGE REVERTED FROM #{order_status} TO #{stage_code}")
    when QC_COMPLETE
      if(order[0].qc_off_flag == 'N')
        order[0].order_status = QC_COMPLETE;
        order[0].artwork_status = ARTWORK_RECEIVED
        order[0].distributed_by_flag = 'N'; order[0].distributed_by_text = ''; order[0].salt = ''
        revert_reorder_flags(order[0])
        revert_order_line_flags(order[0])
        if(reorder_flag == 'N' and order[0].paper_proof_flag == 'Y')
          order[0].sales_order_artworks.each{|artwork|
            artwork.final_artwork_flag = 'N'
          }
        end
        order[0].create_sales_order_transaction_activity("ORDER STAGE REVERTED FROM #{order_status} TO #{stage_code}")
      else
        order[0].errors[:base] << 'QC Is Not Required By This Order'
        return order
      end
    when READY_FOR_INTERNAL_PROOFING
      if(order[0].trans_type != TRANS_TYPE_SAMPLE_ORDER and order[0].blank_order_flag == 'N' and reorder_flag == 'N')
        order[0].artwork_status = READY_FOR_INTERNAL_PROOFING; order[0].artworkreviewed_flag = 'N'; order[0].artworksenttocust_flag = 'N';
        order[0].artworkapprovedbycust_flag = ''
        if order[0].qc_off_flag == 'Y'
          order[0].order_status = ENTRY_COMPLETED
        else
          order[0].order_status = QC_COMPLETE
        end
        if order[0].paper_proof_flag == 'Y'
          order[0].paper_proof_status = 'PAPER PROOF REQUIRED'
        else
          order[0].paper_proof_status = 'NO PROOF REQUIRED'
        end
        revert_order_line_flags(order[0])
        order[0].sales_order_artworks.each{|artwork|
          artwork.final_artwork_flag = 'N'
        }
        order[0].distributed_by_flag = 'N'; order[0].distributed_by_text = ''; order[0].salt = ''
        order[0].create_sales_order_transaction_activity("ORDER STAGE REVERTED FROM #{order_status} TO #{stage_code}")
      else
        order[0].errors[:base] << 'Order cannot be reverted to the selected stage'
        return order
      end
    when ARTWORK_QC
      if(order[0].trans_type != TRANS_TYPE_SAMPLE_ORDER and order[0].blank_order_flag == 'N'and reorder_flag == 'N')
        if(order[0].paper_proof_flag == 'Y')
          order[0].artworksenttocust_flag = 'N'; order[0].artworkapprovedbycust_flag = '';
          order[0].paper_proof_status = 'PAPER PROOF REQUIRED'
        else
          order[0].paper_proof_status = 'NO PROOF REQUIRED'
        end
        if order[0].qc_off_flag == 'Y'
          order[0].order_status = ENTRY_COMPLETED
        else
          order[0].order_status = QC_COMPLETE
        end
        order[0].artwork_status = ARTWORK_QC
        order[0].distributed_by_flag = 'N'; order[0].distributed_by_text = ''; order[0].salt = ''
        revert_order_line_flags(order[0])
        order[0].create_sales_order_transaction_activity("ORDER STAGE REVERTED FROM #{order_status} TO #{stage_code}")
      else
        order[0].errors[:base] << 'Order cannot be reverted to the selected stage'
        return order
      end
    when SENT_TO_CUSTOMER
      if(order[0].trans_type != TRANS_TYPE_SAMPLE_ORDER and order[0].blank_order_flag == 'N' and reorder_flag == 'N')
        if(order[0].paper_proof_flag == 'Y')
          order[0].artworkapprovedbycust_flag = ''; order[0].paper_proof_status = 'PAPER PROOF REQUIRED'
          order[0].sales_order_artworks.each{|artwork|
            artwork.final_artwork_flag = 'N'
          }
          if order[0].qc_off_flag == 'Y'
            order[0].order_status = ENTRY_COMPLETED
          else
            order[0].order_status = QC_COMPLETE
          end
        else
          order[0].errors[:base] << 'Paper Proof Is Not Required By The Order'
          return order
        end
        order[0].artwork_status = SENT_TO_CUSTOMER
        revert_order_line_flags(order[0])
        order[0].distributed_by_flag = 'N'; order[0].distributed_by_text = ''
        order[0].create_sales_order_transaction_activity("ORDER STAGE REVERTED FROM #{order_status} TO #{stage_code}")
      else
        order[0].errors[:base] << 'Order cannot be reverted to the selected stage'
        return order
      end
    when PROOF_APPROVED
      if(order[0].trans_type != TRANS_TYPE_SAMPLE_ORDER and  order[0].blank_order_flag == 'N' and reorder_flag == 'N')
        if(order[0].paper_proof_flag == 'Y')
          order[0].artwork_status = PROOF_APPROVED
          if order[0].qc_off_flag == 'Y'
            order[0].order_status = ENTRY_COMPLETED
          else
            order[0].order_status = QC_COMPLETE
          end
          revert_order_line_flags(order[0])
          order[0].create_sales_order_transaction_activity("ORDER STAGE REVERTED FROM #{order_status} TO #{stage_code}")
        else
          order[0].errors[:base] << 'Paper Proof Is Not Required By The Order'
          return order
        end
      else
        order[0].errors[:base] << 'Order cannot be reverted to the selected stage'
        return order
      end
    when IMPOSITION_COMPLETE
      if(workflow == ATTRIBUTE_VALUE_DOCUCOLOR || workflow == ATTRIBUTE_VALUE_DECAL)
        if(order[0].trans_type != TRANS_TYPE_SAMPLE_ORDER and order[0].trans_type != TRANS_TYPE_VIRTUAL_ORDER and order[0].blank_order_flag == 'N' and workflow)
          order[0].order_status = IMPOSITION_COMPLETE
          order[0].sales_order_lines.each{|line|
            if(line.trans_flag == 'A' and line.item_type == 'I')
              line.print_flag = 'N'; line.cut_flag = 'N'; line.direct_production_flag = 'N'; line.print_ready_flag = 'N'
            end
          }
          order[0].create_sales_order_transaction_activity("ORDER STAGE REVERTED FROM #{order_status} TO #{stage_code}")
        else
          order[0].errors[:base] << 'Order cannot be reverted to the selected stage'
          return order
        end
      else
        order[0].errors[:base] << 'Order cannot be reverted to the selected stage'
        return order
      end
    when PRINT_COMPLETE
      if(workflow == ATTRIBUTE_VALUE_DOCUCOLOR || workflow == ATTRIBUTE_VALUE_DECAL || workflow == ATTRIBUTE_VALUE_DIRECT || workflow == ATTRIBUTE_VALUE_DIGITEK)
        if(order[0].trans_type != TRANS_TYPE_SAMPLE_ORDER and order[0].trans_type != TRANS_TYPE_VIRTUAL_ORDER and order[0].blank_order_flag == 'N')
          order[0].order_status = PRINT_COMPLETE
          order[0].sales_order_lines.each{|line|
            if(line.trans_flag == 'A' and line.item_type == 'I')
              line.cut_flag = 'N'; line.print_ready_flag = 'Y'; line.direct_production_flag = 'N'
            end
          }
          order[0].create_sales_order_transaction_activity("ORDER STAGE REVERTED FROM #{order_status} TO #{stage_code}")
        else
          order[0].errors[:base] << 'Order cannot be reverted to the selected stage'
          return order
        end
      else
        order[0].errors[:base] << 'Order cannot be reverted to the selected stage'
        return order
      end
    when CUTTING_COMPLETE
      if(workflow == ATTRIBUTE_VALUE_DOCUCOLOR || workflow == ATTRIBUTE_VALUE_DECAL)
        if(order[0].trans_type != TRANS_TYPE_SAMPLE_ORDER and order[0].trans_type != TRANS_TYPE_VIRTUAL_ORDER and  order[0].blank_order_flag == 'N')
          order[0].order_status = CUTTING_COMPLETE
          order[0].sales_order_lines.each{|line|
            if(line.trans_flag == 'A' and line.item_type == 'I')
              line.direct_production_flag = 'N'

            end
          }
          order[0].create_sales_order_transaction_activity("ORDER STAGE REVERTED FROM #{order_status} TO #{stage_code}")
        else
          order[0].errors[:base] << 'Order cannot be reverted to the selected stage'
          return order
        end
      else
        order[0].errors[:base] << 'Order cannot be reverted to the selected stage'
        return order
      end
    when SENT_DIGITIZING
      if(workflow == ATTRIBUTE_VALUE_EMBROIDERY)
        if(order[0].trans_type != TRANS_TYPE_SAMPLE_ORDER and order[0].trans_type != TRANS_TYPE_VIRTUAL_ORDER and order[0].blank_order_flag == 'N')
          order[0].order_status = SENT_DIGITIZING
          order[0].sales_order_lines.each{|line|
            if(line.trans_flag == 'A' and line.item_type == 'I')
              line.send_digitization_flag = 'Y'
              line.stitch_flag = 'N'; line.receive_digitization_flag = 'N'; line.direct_production_flag = 'N'

            end
          }
          order[0].create_sales_order_transaction_activity("ORDER STAGE REVERTED FROM #{order_status} TO #{stage_code}")
        else
          order[0].errors[:base] << 'Order cannot be reverted to the selected stage'
          return order
        end
      else
        order[0].errors[:base] << 'Order cannot be reverted to the selected stage'
        return order
      end
    when DIGITIZED_FILE_RECEIVED
      if (workflow == ATTRIBUTE_VALUE_EMBROIDERY)
        if(order[0].trans_type != TRANS_TYPE_SAMPLE_ORDER and order[0].trans_type != TRANS_TYPE_VIRTUAL_ORDER and  order[0].blank_order_flag == 'N')
          order[0].order_status = DIGITIZED_FILE_RECEIVED
          order[0].sales_order_lines.each{|line|
            if(line.trans_flag == 'A' and line.item_type == 'I')
              line.stitch_flag = 'N'; line.direct_production_flag = 'N'
            end
          }
          order[0].create_sales_order_transaction_activity("ORDER STAGE REVERTED FROM #{order_status} TO #{stage_code}")
        else
          order[0].errors[:base] << 'Order cannot be reverted to the selected stage'
          return order
        end
      else
        order[0].errors[:base] <<  'Order cannot be reverted to the selected stage'
        return order
      end
    when FILM_COMPLETE
      if(workflow == ATTRIBUTE_VALUE_DIRECT)
        if(order[0].trans_type != TRANS_TYPE_SAMPLE_ORDER and order[0].trans_type != TRANS_TYPE_VIRTUAL_ORDER and  order[0].blank_order_flag == 'N')
          order[0].order_status = FILM_COMPLETE
          order[0].sales_order_lines.each{|line|
            if(line.trans_flag == 'A' and line.item_type == 'I')
              line.print_flag = 'N'; line.stitch_flag = 'N'; line.direct_production_flag = 'N'; line.print_ready_flag = 'N'
            end

          }
          order[0].create_sales_order_transaction_activity("ORDER STAGE REVERTED FROM #{order_status} TO #{stage_code}")
        else
          order[0].errors[:base] << 'Order cannot be reverted to the selected stage'
          return order
        end
      else
        order[0].errors[:base] << 'Order cannot be reverted to the selected stage'
        return order
      end
    when STITCH_DONE
      if (workflow == ATTRIBUTE_VALUE_EMBROIDERY)
        if(order[0].trans_type != TRANS_TYPE_SAMPLE_ORDER and order[0].trans_type != TRANS_TYPE_VIRTUAL_ORDER and order[0].blank_order_flag == 'N')
          order[0].order_status = STITCH_DONE
          order[0].sales_order_lines.each{|line|
            if(line.trans_flag == 'A' and line.item_type == 'I')
              line.direct_production_flag = 'N'
            end

          }
          order[0].create_sales_order_transaction_activity("ORDER STAGE REVERTED FROM #{order_status} TO #{stage_code}")
        else
          order[0].errors[:base] << 'Order cannot be reverted to the selected stage'
          return order
        end
      else
        order[0].errors[:base] << 'Order cannot be reverted'
        return order
      end
    when PRODUCTION_DONE
      if(order[0].trans_type != TRANS_TYPE_SAMPLE_ORDER and order[0].trans_type != TRANS_TYPE_VIRTUAL_ORDER and  order[0].blank_order_flag == 'N')
        order[0].order_status = PRODUCTION_DONE
      end
    when PACKAGING_COMPLETED
      order[0].errors[:base] <<  'Order cannot be reverted to the current order stage'
      return order
    when SHIPPED
      order[0].errors[:base] << 'Order cannot be reverted to the current order stage'
      return order
    else
      order[0].errors[:base] << 'Order cannot be reverted to the current order stage'
      return order
    end
    workflow_location = Sales::CurrentLocationLogic.find_order_location(order[0],order[0].order_status,order[0].artwork_status)
    order[0].workflow_location = workflow_location
    save_proc = Proc.new{
      order[0].save!
      order[0].sales_order_lines.each{|line| line.save!}
      order[0].sales_order_artworks.each{|artwork| artwork.save!}
    }
    order[0].save_transaction(&save_proc)
    return order
  end

  def self.revert_reorder_flags(order)
    if(order.trans_type == TRANS_TYPE_REORDER and (order.reorder_type == REORDER_TYPE1 || order.reorder_type == REORDER_TYPE2))
      order.artworkassigned_flag = 'Y';order.artworkcompleted_flag = 'Y';order.artworkreviewed_flag = 'Y';
      order.artworkapprovedbycust_flag = ''
      order.artworksenttocust_flag = 'N' if order.paper_proof_flag == 'Y'
    else
      order.artworkassigned_flag = 'N'; order.artworkcompleted_flag = 'N'; order.artworkreviewed_flag = 'N';
      order.artworksenttocust_flag = 'N'; order.artworkapprovedbycust_flag = ''
    end
    if order.paper_proof_flag == 'Y'
      order.paper_proof_status = 'PAPER PROOF REQUIRED'
    else
      order.paper_proof_status = 'NO PROOF REQUIRED'
    end
  end

  def self.revert_order_line_flags(order)
    order.sales_order_lines.each{|line|
      if(line.trans_flag == 'A' and line.item_type == 'I')
        line.print_flag = 'N';line.cut_flag = 'N';line.film_flag = 'N';line.stitch_flag = 'N';
        line.imposition_flag = 'N';line.send_digitization_flag = 'N';line.receive_digitization_flag = 'N';
        line.send_for_estimation_flag = 'N';line.receive_stitch_estimation_flag = 'N';line.customer_stitch_approval_flag = 'N';
        line.direct_production_flag = 'N';line.imposition_reject_reason = '';line.reject_from_imposition_flag = 'N';
        line.print_ready_flag = 'N'; line.indigo_code = '';line.doc_code = '' ; line.reason = ''
      end
    }
  end
end
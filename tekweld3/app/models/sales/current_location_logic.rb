class Sales::CurrentLocationLogic
  include General

  def self.find_order_status(trans_no)
    order = Sales::SalesOrder.find_by_trans_no(trans_no)
    order_status = order.order_status
    artwork_status = order.artwork_status
    find_order_location(order,order_status,artwork_status)
  end

  def self.find_order_location(order,order_status,artwork_status)
    case order.trans_type
    when TRANS_TYPE_SAMPLE_ORDER
      case order_status
      when NEW_ORDER
        'OI-PICK'
      when ORDER_ANSWERED
        'OI-PICK'
      when ORDER_PICKED
        'OI-INCOMPLETE'
      when ORDER_REASSIGNED_FOR_ENTRY
        'OI-INCOMPLETE'
      when ORDER_QUERIED
        'OI-QUERIES'
      when ENTRY_COMPLETED
        if order.qc_off_flag == 'Y' || order.orderqcstatus_flag == 'Y'
          order.accountreviewed_flag == 'Y' ? 'SHIPPING INBOX' : 'OI-ACCOUNTING APPROVED'
        else
          'OI-QC'
        end
      when QC_COMPLETE
        order.accountreviewed_flag == 'Y' ? 'SHIPPING INBOX' : 'OI-ACCOUNTING APPROVED'
      when SHIPPED
        'INVOICE INBOX'
      when INVOICED
        'ORDER CLOSED'
      end
    when TRANS_TYPE_REGULAR_ORDER
      if order.blank_order_flag == 'Y'
        case order_status
        when NEW_ORDER
          'OI-PICK'
        when ORDER_ANSWERED
          'OI-PICK'
        when ORDER_PICKED
          'OI-INCOMPLETE'
        when ORDER_REASSIGNED_FOR_ENTRY
          'OI-INCOMPLETE'
        when ORDER_QUERIED
          'OI-QUERIES'
        when ENTRY_COMPLETED
          if order.qc_off_flag == 'Y' || order.orderqcstatus_flag == 'Y'
            #            order.accountreviewed_flag == 'Y' ? 'PRODUCTION INBOX' : 'OI-ACCOUNTING APPROVED'
            'PRODUCTION INBOX'
          else
            'OI-QC'
          end
        when QC_COMPLETE
          #          order.accountreviewed_flag == 'Y' ? 'PRODUCTION INBOX' : 'OI-ACCOUNTING APPROVED'
          'PRODUCTION INBOX'
        when PRODUCTION_DONE
          'PACKAGE JOB'
        when PARTIAL_PACKAGING
          'PACKAGE JOB AND SHIPPING INBOX'
        when PACKAGING_COMPLETED
          'SHIPPING INBOX'
        when PARTIAL_SHIPPED
          'PACKAGE JOB/SHIPPING/INVOICE'
        when SHIPPED
          'SHIPPING/INVOICE INBOX'
        when PARTIAL_INVOICED
          'PACKAGE JOB/SHIPPING/INVOICE'
        when INVOICED
          'ORDER CLOSED'
        end
      else
        find_location(order,order_status,artwork_status)
      end
    else
      find_location(order,order_status,artwork_status)
    end
  end

  def self.find_location(order,order_status,artwork_status)
    case order_status
    when NEW_ORDER
      artwork_status == WAITING_ARTWORK ? 'AI-WAITING ART' : artwork_status == ARTWORK_RECEIVED ? 'OI-PICK' : 'NOT FOUND'
    when ORDER_ANSWERED
      artwork_status == ARTWORK_RECEIVED ? 'OI-PICK' : 'NOT FOUND'
    when ORDER_PICKED
      artwork_status == ARTWORK_RECEIVED ? 'OI-INCOMPLETE' : 'NOT FOUND'
    when ORDER_REASSIGNED_FOR_ENTRY
      artwork_status == ARTWORK_RECEIVED ? 'OI-INCOMPLETE' : 'NOT FOUND'
    when ORDER_QUERIED
      artwork_status == ARTWORK_RECEIVED ? 'OI-QUERIES' : 'NOT FOUND'
    when ENTRY_COMPLETED
      find_location_based_on_artwork_status(order,order_status,artwork_status)
    when QC_COMPLETE
      find_location_based_on_artwork_status(order,order_status,artwork_status)
    when STITCHES_REJECTED_REDESIGN_ARTWORK
      find_location_based_on_artwork_status(order,order_status,artwork_status)
    when STITCHES_REJECTED_CHANGE_LAYOUT
      find_location_based_on_artwork_status(order,order_status,artwork_status)
    when REJECTED_FROM_PRINT
      find_location_based_on_artwork_status(order,order_status,artwork_status)
    when PARTIAL_PACKAGING
      'PACKAGE JOB AND SHIPPING INBOX'
    when PACKAGING_COMPLETED
      'SHIPPING INBOX'
    when PARTIAL_SHIPPED
      'PACKAGE JOB/SHIPPING/INVOICE'
    when SHIPPED
      'SHIPPING/INVOICE INBOX'
    when SHIPPED_TO_VENDOR
      'VENDOR INBOX/PACKAGE JOB'
    when PARTIAL_INVOICED
      'PACKAGE JOB/SHIPPING/INVOICE'
    when INVOICED
      'ORDER CLOSED'
    when ORDER_COMPLETED
      find_virtual_order_location(order,order_status,artwork_status)
    else
      if order.ordercancelstatus_flag == 'Y' || order.invoiced_flag == 'Y'
        return 'ORDER CLOSED'
      else
        find_production_location(order,order_status,artwork_status)
      end
    end
  end

  def self.find_virtual_order_location(order,order_status,artwork_status)
    case artwork_status
    when PROOF_APPROVED
      'ORDER CLOSED'
    when PROOF_REJECTED
      'AI-QC'
    when ARTWORK_QC
      find_virtual_order_location_based_on_paperproof(order,order_status,artwork_status)
    when SENT_TO_CUSTOMER
      find_virtual_order_location_based_on_paperproof(order,order_status,artwork_status)
    end
  end

  def self.find_virtual_order_location_based_on_paperproof(order,order_status,artwork_status)
    if order.paper_proof_flag == 'Y' and order.artworksenttocust_flag == 'N'
      'AI-SEND PROOF'
    elsif order.paper_proof_flag == 'Y' and order.artworksenttocust_flag == 'Y' and order.artworkapprovedbycust_flag == ''
      'AI-CUST RESPONSE and CUST PORTAL'
    else
      'ORDER CLOSED'
    end
  end

  def self.find_location_based_on_artwork_status(order,order_status,artwork_status)
    case artwork_status
    when ARTWORK_RECEIVED
      if order.trans_type == TRANS_TYPE_REORDER and order.reorder_type != REORDER_TYPE3
        if order.qc_off_flag == 'Y' || order.orderqcstatus_flag == 'Y'
          find_location_based_on_paperproof(order,order_status,artwork_status)
        else
          'OI-QC'
        end
      else
        if order.qc_off_flag == 'Y' || order.orderqcstatus_flag == 'Y'
          'AI-PICK'
        else
          'OI-QC'
        end
      end
    when ARTWORK_ANSWERED
      then 'AI-PICK'
    when PROOF_IN_PROGRESS
      then 'AI-INCOMPLETE'
    when ARTWORK_QUERIED
      then 'AI-QUERIES'
    when READY_FOR_INTERNAL_PROOFING
      'AI-QC'
    when REJECTED_FROM_IMPOSITION
      'AI-QC'
    when REJECTED_FROM_FILM
      'AI-QC'
    when ARTWORK_QC
      find_location_based_on_paperproof(order,order_status,artwork_status)
    when SENT_TO_CUSTOMER
      find_location_based_on_paperproof(order,order_status,artwork_status)
    when PROOF_APPROVED
      find_location_based_on_paperproof(order,order_status,artwork_status)
    when PROOF_REJECTED
      'AI-QC'
    end
  end


  def self.find_location_based_on_paperproof(order,order_status,artwork_status)
    if order.paper_proof_flag == 'Y' and order.artworksenttocust_flag == 'N'
      'AI-SEND PROOF'
    elsif order.paper_proof_flag == 'Y' and order.artworksenttocust_flag == 'Y' and order.artworkapprovedbycust_flag == ''
      'AI-CUST RESPONSE and CUST PORTAL'
    else
      find_production_location(order,order_status,artwork_status)
    end
  end

  def self.find_production_location(order,order_status,artwork_status)
    ## this line is working fine but for reorder with normal the item is not saved so
    ## we are getting order_line as nil thats why we are getting line from loop ## AmitPandey 6-July-2012
    #    order_line = Sales::SalesOrderLine.find_by_sales_order_id_and_trans_flag_and_item_type(order.id,'A','I')
    order_line = ''
    order.sales_order_lines.each{|sales_order_line|
      if sales_order_line.trans_flag == 'A' and sales_order_line.item_type == 'I'
        order_line = sales_order_line
        break
      end
    }
    return 'ITEM LINE NOT FOUND' if order_line == ''
    workflow = order_line.catalog_item.workflow
    if order_line.catalog_item.workflow == WORKFLOW_DOCUCOLOR
      docucolor_location(order_line)
    elsif(workflow == WORKFLOW_DIRECT_DECAL_DIGITEK || workflow == WORKFLOW_PAD || workflow == WORKFLOW_WATER)
      #      attributes_values = Sales::SalesOrderAttributesValue.active.find_by_sales_order_id_and_catalog_attribute_code(order.id,CATALOG_ATTRIBUTE_CODE)
      attributes_values = ''
      order.sales_order_attributes_values.each{|attribute_value|
        if attribute_value.trans_flag == 'A' and attribute_value.catalog_attribute_code == CATALOG_ATTRIBUTE_CODE
          attributes_values = attribute_value
          break
        end
      }
      return 'ATTRIBUTE NOT FOUND' if attributes_values == ''
      direct_decal_digitek_water_location(attributes_values,order_line,workflow,order_status,artwork_status)
    elsif order_line.catalog_item.workflow == WORKFLOW_EMBROIDERY
      embroidery_location(order_line)
    end
  end

  def self.direct_decal_digitek_water_location(attributes_values,order_line,workflow,order_status,artwork_status)
    if (attributes_values.catalog_attribute_value_code == ATTRIBUTE_VALUE_DIRECT || attributes_values.catalog_attribute_value_code == ATTRIBUTE_VALUE_PAD)
      if order_line.film_flag == 'N'
        return 'DIRECT FILM INBOX'
      elsif artwork_status == 'REJECTED FROM FILM'
        return 'AI-QC'
      elsif (order_line.film_flag == 'Y' and order_line.print_flag == 'N')
        return 'DIRECT PLATE/SCREEN INBOX'
      elsif (order_line.print_flag == 'Y' and order_line.direct_production_flag == 'N')
        return 'PRODUCTION INBOX'
      elsif (order_line.direct_production_flag == 'Y')
        return 'PACKAGE JOB INBOX'
      end
    elsif(attributes_values.catalog_attribute_value_code == ATTRIBUTE_VALUE_DECAL)
      if order_line.imposition_flag == 'N'
        return 'INDIGO IMPOSITION INBOX'
      elsif artwork_status == 'REJECTED FROM IMPOSITION'
        return 'AI-QC'
      elsif (order_line.imposition_flag == 'Y' and order_line.print_flag == 'N')
        return 'INDIGO PRINT INBOX'
      elsif (order_line.print_flag == 'Y' and order_line.cut_flag == 'N')
        return 'ABG DIECUT INBOX'
      elsif (order_line.cut_flag == 'Y' and order_line.direct_production_flag == 'N')
        return 'PRODUCTION INBOX'
      elsif (order_line.direct_production_flag == 'Y')
        if workflow == 'WATER'
          return 'SHIP TO VENDOR'
        else
          return 'PACKAGE JOB INBOX'
        end
      end
    elsif(attributes_values.catalog_attribute_value_code == ATTRIBUTE_VALUE_DIGITEK)
      if (order_line.print_flag == 'N')
        return 'DIGITEK PRINT INBOX'
      elsif (order_line.print_flag == 'Y' and order_line.direct_production_flag == 'N')
        return 'PRODUCTION INBOX'
      elsif (order_line.direct_production_flag == 'Y')
        return 'PACKAGE JOB INBOX'
      end
    end
  end

  def self.embroidery_location(order_line)
    if order_line.send_for_estimation_flag == 'N'
      return 'DIGI-SEND FOR EST'
    elsif order_line.send_for_estimation_flag == 'Y' and order_line.receive_stitch_estimation_flag == 'N'
      return 'DIGI-STITCH EST'
    elsif order_line.receive_stitch_estimation_flag == 'Y' and order_line.customer_stitch_approval_flag == 'N'
      return 'DIGI-CUST RESPONSE'
    elsif order_line.customer_stitch_approval_flag == 'Y' and order_line.send_digitization_flag == 'N'
      return 'Send For Digitization'
    elsif order_line.send_digitization_flag == 'Y' and order_line.receive_digitization_flag == 'N'
      return 'Digitization Inbox'
    elsif order_line.receive_digitization_flag == 'Y' and order_line.stitch_flag == 'N'
      return 'Stitch Inbox'
    elsif order_line.stitch_flag == 'Y' and order_line.direct_production_flag == 'N'
      return 'PRODUCTION INBOX'
    elsif order_line.direct_production_flag == 'Y'
      return 'PACKAGE JOB INBOX'
    end
  end

  def self.docucolor_location(order_line)
    if order_line.imposition_flag == 'N'
      return 'DOCUCOLOR IMPOSITION INBOX'
    elsif (order_line.imposition_flag == 'Y' and order_line.print_flag == 'N')
      return 'DOCUCOLOR PRINT INBOX'
    elsif (order_line.print_flag == 'Y' and order_line.cut_flag == 'N')
      return 'HEIDELBERG DIECUT INBOX'
    elsif (order_line.cut_flag == 'Y' and order_line.direct_production_flag == 'N')
      return 'PRODUCTION INBOX'
    elsif (order_line.direct_production_flag == 'Y')
      return 'PACKAGE JOB INBOX'
    end
  end
end
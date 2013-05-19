class Purchase::PurchaseLib
  include General
  
  def self.generate_po_xml(doc1)
    puts doc1
    doc1.root.name='purchase_orders'
    (doc1/:purchase_orders/:production_request).each{|ele|
      ele.name = "purchase_order"
      ele.at('ref_trans_no').name="Ignore1"
      ele.at('trans_no').name="ref_trans_no"
      ele.at('trans_date').name="ref_trans_date"
      ele.at('clear_qty').name="Ignore2"
      ele.at('ref_trans_bk').name="Ignore3"
      ele.at('trans_bk').name="ref_trans_bk"
      ele.at('po_vendor_id').name="vendor_id"
      ele.at('po_trans_date').name="trans_date"
      ele.at('company_store_id').name="store_id"
      ele.at('account_period_code').inner_html=(Setup::AccountPeriod.period_from_date((ele.at('trans_date').inner_html).to_s)).code
      ele.at('trans_type').inner_html="S"
      ele.at('trans_flag').inner_html="A"
      ele.at('id').inner_html=""
      ele.at('id').before do
        tag!'purchase_order_lines' do
          tag!'purchase_order_line' do
            tag!'id', ''   
            tag!'trans_date', (ele/:trans_date).inner_text
            tag!'catalog_item_id', (ele/:catalog_item_id).inner_text 
            #          tag!'catalog_item_code', (ele/:catalog_item_code).inner_text 
            tag!'catalog_item_code', Item::CatalogItem.find((ele/:catalog_item_id).inner_text).store_code
            tag!'item_qty', (ele/:item_qty).inner_text 
            tag!'item_description', (ele/:item_description).inner_text 
            tag!'item_price', (ele/:item_price).inner_text
            tag!'item_amt', (ele/:item_amt).inner_text
            tag!'item_type', (ele/:item_type).inner_text
            tag!'net_amt', (ele/:item_amt).inner_text     #Need to set the net amt in production request 
            tag!'discount_amt', (ele/:discount_amt).inner_text
            tag!'store_id', (ele/:store_id).inner_text
            tag!'ref_trans_bk', (ele/:ref_trans_bk).inner_text
            tag!'ref_trans_no', (ele/:ref_trans_no).inner_text
            tag!'ref_trans_date', (ele/:ref_trans_date).inner_text
            tag!'ref_serial_no', (ele/:ref_serial_no).inner_text
            tag!'ref_qty', (ele/:item_qty).inner_text 
          end       
        end
      end
      #     ele.at('id').name="IgnoreID"
    }
    puts doc1 
    doc1
  end
  
  
  def self.generate_po_xml_from_workbag(wb) 
    res = wb.group_by { |f| [f.vendor_id, f.cancel_date,f.ship_date] }.values
    xml_string = "<purchase_orders>"
    res.each{|order|
      xml_string = xml_string+"<purchase_order>"
      xml_string = xml_string +"<ship_date>#{order[0].ship_date}</ship_date>"
      xml_string = xml_string +"<shipping_code>UPS</shipping_code>"
      xml_string = xml_string +"<cancel_date>#{order[0].cancel_date}</cancel_date>"
      xml_string = xml_string +"<vendor_id>#{order[0].vendor_id}</vendor_id>"
      xml_string = xml_string +"<company_id>#{order[0].company_id}</company_id>"
      xml_string = xml_string +"<store_id>#{order[0].store_id}</store_id>"
      xml_string = xml_string +"<trans_date>#{Time.now.to_date}</trans_date>"
      xml_string = xml_string +"<purchase_date>#{Time.now.to_date}</purchase_date>"
      xml_string = xml_string +"<trans_type>W</trans_type>"
      xml_string = xml_string +"<account_period_code>#{Setup::AccountPeriod.period_from_date(Time.now).code}</account_period_code>"
      xml_string = xml_string+"<purchase_order_lines>"
      order.each{|line|
        xml_string = xml_string+"<purchase_order_line>"
        xml_string = xml_string +"<ref_trans_no>#{line.trans_no}</ref_trans_no>"
        xml_string = xml_string +"<ref_trans_bk>#{line.trans_bk}</ref_trans_bk>"
        xml_string = xml_string +"<ref_trans_date>#{line.trans_date}</ref_trans_date>"
        xml_string = xml_string +"<item_price>#{line.item_price}</item_price>"
        xml_string = xml_string +"<item_type>#{line.item_type}</item_type>"
        xml_string = xml_string +"<store_id>#{line.store_id}</store_id>"
        xml_string = xml_string +"<catalog_item_id>#{line.catalog_item_id}</catalog_item_id>"
        xml_string = xml_string +"<catalog_item_code>#{line.catalog_item_code}</catalog_item_code>"
        xml_string = xml_string +"<catalog_item_packet_id>#{line.catalog_item_packet_id}</catalog_item_packet_id>"
        xml_string = xml_string +"<catalog_item_packet_code>#{line.catalog_item_packet_code}</catalog_item_packet_code>"
        xml_string = xml_string +"<item_description>#{line.catalog_item_description}</item_description>"
        xml_string = xml_string +"<item_qty>#{line.wb_qty}</item_qty>"
        xml_string = xml_string +"<item_amt>#{line.wb_qty * line.item_price}</item_amt>"
        xml_string = xml_string +"<net_amt>#{line.wb_qty * line.item_price}</net_amt>"
        xml_string = xml_string +"<ref_type>W</ref_type>"
        xml_string = xml_string+"</purchase_order_line>"
      }
      xml_string = xml_string+"</purchase_order_lines>"
      xml_string = xml_string+"</purchase_order>"
    }
    xml_string = xml_string+"</purchase_orders>"
    xml = %{#{xml_string}}
    doc = Hpricot::XML(xml)
    puts doc
    return doc 
  end
  
  def self.create_orders(doc)
    orders = [] 
    (doc/:purchase_orders/:purchase_order).each{|order_doc|
      order = create_order(order_doc)
      orders <<  order if order
    }
    orders
  end

  def self.create_order(doc)
    order = add_or_modify_order(doc) 
    order.generate_trans_no('PAOIOD') if order.new_record?
    order.apply_header_fields_to_lines  
    order.apply_line_fields_to_header  
    order.apply_line_amt_fields_to_header() 
    return  if !order
    save_proc = Proc.new{
      if order.new_record?
        order.save!  
      else
        order.save! 
        order.purchase_order_lines.save_line
      end
      update_workbag_po_fields(order)
    }
    if(order.errors.empty?)
      order.save_transaction(&save_proc)
    end
    return order
  end

  def self.add_or_modify_order(doc)  
    id =  parse_xml(doc/'id') if (doc/'id').first  
    order = Purchase::PurchaseOrder.find_or_create(id)    
    return if !order
    if !order.new_record? and order.update_flag == 'V'
      order.errors.add('','This Order is View Only. Cannot update.') 
      return order
    end
    order.apply_attributes(doc) 
    set_vendor_info(order)
    set_company_info(order)
    order.due_date = Setup::Term.fill_terms(order.term_code,order.trans_date).pay1_date    
    order.company_id =1
    order.fill_default_header_values() if order.new_record? 
    order.ref_type = order.trans_type
    order.max_serial_no = order.purchase_order_lines.maximum_serial_no
    order.build_lines(doc/:purchase_order_lines/:purchase_order_line)   
    return order 
  end
  
  def self.set_vendor_info(order)
    vendor = Vendor::Vendor.find_by_id(order.vendor_id)
    if vendor
      order.term_code = vendor.invoice_term_code
      order.shipping_code = vendor.shipping_code
      order.bill_address1 = vendor.address1
      order.bill_address2 = vendor.address2
      order.bill_city = vendor.city
      order.bill_state = vendor.state
      order.bill_country = vendor.country
      order.bill_phone = vendor.phone
      order.bill_fax = vendor.fax
      order.bill_name = vendor.name
    end
  end
  
  def self.set_company_info(order)
    company = Setup::Company.find_by_id(order.company_id)
    if company
      order.ship_address1 = company.address1
      order.ship_address2 = company.address2
      order.ship_city = company.city
      order.ship_state = company.state
      order.ship_country = company.country
      order.ship_phone = company.phone
      order.ship_fax = company.fax
      order.ship_name = company.name
    end
  end

  
  def self.update_workbag_po_fields(order)
    order.purchase_order_lines.each{|line|
      workbag = Workbag::Workbag.find_by_trans_no(line.ref_trans_no)
      workbag.update_attributes(:vendor_po_bk => line.trans_bk,:vendor_po_no => line.trans_no,:vendor_po_date => line.trans_date,:po_vendor_id => order.vendor_id,:vendor_po_id => line.id,:vendor_po_qty => line.item_qty) if workbag  
      transfer_doc = Production::ContractorMemoLib.generate_xml_for_workbag_transfer(workbag.id,'PO') 
      Production::WorkbagTransferCrud.create_workbag_stage_transfers(transfer_doc)
    }
  end
  
  
  private_class_method :create_order, :add_or_modify_order
  
end

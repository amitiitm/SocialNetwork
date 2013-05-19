class Sales::SalesInvoiceCrud
  include General

  #Sales Invoice services  
  def self.list_invoices(doc)
    criteria = Setup::Criteria.fill_criteria(doc/:criteria) 
    Sales::SalesInvoice.find_by_sql ["select CAST( (select(select sales_invoices.id,sales_invoices.trans_bk,sales_invoices.trans_no,sales_invoices.trans_date,
                                    sales_invoices.trans_type,sales_invoices.shipping_code,sales_invoices.account_period_code,
                                    sales_invoices.tracking_no,sales_invoices.ship_date,sales_invoices.item_amt,sales_invoices.net_amt,
                                    customers.code as customer_code from sales_invoices
                                    inner join customers on customers.id = sales_invoices.customer_id where
                                    (sales_invoices.trans_flag = 'A') AND
                                    (sales_invoices.company_id = #{criteria.company_id}) AND
                                    (customers.code between '#{criteria.str1}' and '#{criteria.str2}' AND (0 =#{criteria.multiselect1.length} or customers.code in ('#{criteria.multiselect1.length}'))) AND
                                    (trans_no between '#{criteria.str3}' and '#{criteria.str4}' AND (0 =#{criteria.multiselect2.length} or trans_no in ('#{criteria.multiselect2}'))) AND
                                    (trans_date between '#{criteria.dt1}' and '#{criteria.dt2}' ) AND
                                    (account_period_code between '#{criteria.str5[0,8]}' and '#{criteria.str6[0,8]}' AND (0 =#{criteria.multiselect3.length} or account_period_code in ('#{criteria.multiselect3.length}'))) AND
                                    (ref_trans_no between '#{criteria.str7}' and '#{criteria.str8}' AND (0 =#{criteria.multiselect4.length} or ref_trans_no in ('#{criteria.multiselect4}')))
                                    order by trans_date, trans_no
                                    FOR XML PATH('sales_invoice'),type,elements xsinil)FOR XML PATH('sales_invoices')) AS xml) as xmlcol "
    ]
  end

  def self.sales_invoice_inbox(doc)
    #    criteria = Setup::Criteria.fill_criteria_for_query(doc/:criteria)
    condition = "so.trans_flag = 'A' AND sos.trans_flag = 'A'
                     AND sol.blank_good_flag <> 'Y' AND so.hold_order_flag <> 'Y' AND sol.item_type = 'I' and sol.trans_flag = 'A'
                     AND so.trans_type in ('S','E','F')
                     AND sos.shipping_flag = 'Y' AND sos.invoiced_flag = 'N' AND (sos.clear_qty >= sos.ship_qty)"
    sample_order_condition = "so.trans_flag = 'A' AND sos.trans_flag = 'A'
                     AND sol.blank_good_flag <> 'Y' AND so.hold_order_flag <> 'Y' AND sol.item_type = 'I' and sol.trans_flag = 'A'
                     AND so.trans_type = 'P'
                     AND sos.shipping_flag = 'Y' AND sos.invoiced_flag = 'N' AND (sos.clear_qty >= sos.ship_qty)"
    Sales::SalesInvoice.find_by_sql ["select CAST((
                                  select (
                                  select * from (select distinct so.ext_ref_no,types.description as order_type,so.trans_type,so.trans_date,customers.name,customers.code as customer_code,
                                         so.rushorder_flag,so.artwork_status,so.order_status,so.trans_no,so.logo_name,sol.catalog_item_code,so.id,sos.id as shipping_id,
                                         sol.item_description,sol.item_qty,sos.ship_name,sos.ship_address1,sos.ship_address2,sos.internal_ship_date as ship_date,
                                  sos.ship_city,sos.ship_state,sos.ship_zip,sos.ship_country,sos.ship_phone,sos.ship_fax,sos.ship_qty,sos.ship_method,sos.shipping_code,sos.estimated_ship_date
                                  from sales_orders so
                                  inner join sales_order_lines sol on sol.sales_order_id = so.id
                                  inner join catalog_items on catalog_items.id = sol.catalog_item_id
                                  inner join customers on customers.id = so.customer_id
                                  inner join sales_order_shippings sos on sos.sales_order_id = so.id
                                  left outer join types on (
                                          types.type_cd = 'trans_type'
                                          and types.subtype_cd = 'so'
                                          and so.trans_type = types.value
                                          )
                                  where #{condition}
UNION
                                  select distinct so.ext_ref_no,types.description as order_type,so.trans_type,so.trans_date,customers.name,customers.code as customer_code,
                                         so.rushorder_flag,so.artwork_status,so.order_status,so.trans_no,so.logo_name,'' as catalog_item_code,so.id,sos.id as shipping_id,
                                         '' as item_description, 0 as item_qty,sos.ship_name,sos.ship_address1,sos.ship_address2,sos.internal_ship_date as ship_date,
                                  sos.ship_city,sos.ship_state,sos.ship_zip,sos.ship_country,sos.ship_phone,sos.ship_fax,sos.ship_qty,sos.ship_method,sos.shipping_code,sos.estimated_ship_date
                                  from sales_orders so
                                  inner join sales_order_lines sol on sol.sales_order_id = so.id
                                  inner join catalog_items on catalog_items.id = sol.catalog_item_id
                                  inner join customers on customers.id = so.customer_id
                                  inner join sales_order_shippings sos on sos.sales_order_id = so.id
                                  left outer join types on (
                                          types.type_cd = 'trans_type'
                                          and types.subtype_cd = 'so'
                                          and so.trans_type = types.value
                                          )
                                  where #{sample_order_condition}) as result order by result.ship_date
                                  FOR XML PATH('sales_invoice'), TYPE,ELEMENTS XSINIL
                                  )FOR XML PATH('sales_invoices')) AS varchar(MAX)) as xmlcol"
    ]
  end

  def self.show_invoice(invoice_id)
    Sales::SalesInvoice.find_all_by_id(invoice_id)
  end
  ## used to call from invoice inbox
  def self.create_invoice_from_inbox(schema_name,sales_order_shipping,order,ship_qty)
    begin
      save_proc = Proc.new{
        sales_order,invoice,inv_text,receipt,rec_text,emails,payment_transaction,payment_text= Shipping::ShippingCrud.generate_invoice_and_receipt(sales_order_shipping,order,ship_qty,sales_order_shipping.multi_description,sales_order_shipping.tracking_no)
        if(inv_text == 'error' || rec_text =='error' || payment_text =='error'||!sales_order.errors[:base].empty?)
          order.errors[:base] <<  invoice.errors[:base][0] if(inv_text == 'error')
          order.errors[:base] <<  receipt.errors[:base][0] if(rec_text =='error')
          order.errors[:base] <<  payment_transaction.errors[:base][0] if(payment_text =='error')
          order.errors[:base] <<  sales_order.errors[:base][0] if !sales_order.errors[:base].empty?
          raise ActiveRecord::Rollback
        else
          workflow_location = Sales::CurrentLocationLogic.find_order_location(sales_order,sales_order.order_status,sales_order.artwork_status)
          sales_order.workflow_location = workflow_location
          sales_order.save!
          sales_order_shipping.invoiced_flag =  'Y'
          sales_order_shipping.save!
          emails.each{|email| email.save!}
          payment_transaction.save! if payment_transaction
        end
      }
      if(order.errors[:base].empty?)
        order.save_transaction(&save_proc)
      end
    rescue Exception => ex
      order.errors[:base] << ex
      return order
    end
    return order
  end

  def self.create_sales_invoice_xml(sales_order_shipping,order,ship_qty,multi_description,tracking_number)
    shipping = sales_order_shipping
    customer = Customer::Customer.find_by_id(order.customer_id)
    term = Setup::Term.fill_terms(customer.invoice_term_code,Time.now.to_date)
    xml_string = "<sales_invoices>"
    xml_string = xml_string+"<sales_invoice>"
    xml_string = xml_string +"<bill_name>#{order.bill_name}</bill_name>"
    xml_string = xml_string +"<customer_id>#{order.customer_id}</customer_id>"
    xml_string = xml_string +"<customer_code>#{order.customer_code}</customer_code>"
    xml_string = xml_string +"<term_code>#{order.term_code}</term_code>"
    xml_string = xml_string +"<due_date>#{term.pay1_date}</due_date>"
    xml_string = xml_string +"<ext_ref_no>#{order.ext_ref_no}</ext_ref_no>"
    xml_string = xml_string +"<ship_date>#{shipping.shipping_date}</ship_date>"
    xml_string = xml_string +"<trans_type>O</trans_type>"
    xml_string = xml_string +"<ref_trans_no>#{order.trans_no}</ref_trans_no>"
    xml_string = xml_string +"<ref_trans_bk>#{order.trans_bk}</ref_trans_bk>"
    xml_string = xml_string +"<shipping_code>#{shipping.shipping_code}</shipping_code>"
    xml_string = xml_string +"<customer_shipping_id>#{shipping.id}</customer_shipping_id>"
    xml_string = xml_string +"<ext_ref_date>#{order.ext_ref_date}</ext_ref_date>"
    xml_string = xml_string +"<trans_date>#{Time.now.to_date}</trans_date>"
    xml_string = xml_string +"<account_period_code>#{Setup::AccountPeriod.period_from_date(Time.now).code}</account_period_code>"
    xml_string = xml_string +"<trans_flag>A</trans_flag>"
    xml_string = xml_string +"<bill_address1>#{order.bill_address1}</bill_address1>"
    xml_string = xml_string +"<bill_address2>#{order.bill_address2}</bill_address2>"
    xml_string = xml_string +"<bill_city>#{order.bill_city}</bill_city>"
    xml_string = xml_string +"<bill_state>#{order.bill_state}</bill_state>"
    xml_string = xml_string +"<bill_zip>#{order.bill_zip}</bill_zip>"
    xml_string = xml_string +"<bill_fax>#{order.bill_fax}</bill_fax>"
    xml_string = xml_string +"<bill_phone>#{order.bill_phone}</bill_phone>"
    xml_string = xml_string +"<ship_name>#{shipping.ship_name}</ship_name>"
    xml_string = xml_string +"<ship_address1>#{shipping.ship_address1}</ship_address1>"
    xml_string = xml_string +"<ship_address2>#{shipping.ship_address2}</ship_address2>"
    xml_string = xml_string +"<ship_city>#{shipping.ship_city}</ship_city>"
    xml_string = xml_string +"<ship_state>#{shipping.ship_state}</ship_state>"
    xml_string = xml_string +"<ship_zip>#{shipping.ship_zip}</ship_zip>"
    xml_string = xml_string +"<ship_country>#{shipping.ship_country}</ship_country>"
    xml_string = xml_string +"<ship_phone>#{shipping.ship_phone}</ship_phone>"
    xml_string = xml_string +"<ship_fax>#{shipping.ship_fax}</ship_fax>"
    xml_string = xml_string +"<remarks>#{order.remarks}#{tracking_number}</remarks>"
    xml_string = xml_string +"<ship_per>0</ship_per>"
    if order.ordercancelstatus_flag == 'Y'
      xml_string = xml_string +"<ship_amt>#{order.ship_amt}</ship_amt>"
    else
      xml_string = xml_string +"<ship_amt>#{shipping.current_ship_amt}</ship_amt>"
    end
    #        xml_string = xml_string +"<insurance_per>0</insurance_per>"
    #        xml_string = xml_string +"<insurance_amt>0</insurance_amt>"
    xml_string = xml_string +"<item_amt>0</item_amt>"
    xml_string = xml_string +"<discount_per>#{order.discount_per}</discount_per>"
    xml_string = xml_string +"<discount_amt>#{order.discount_amt}</discount_amt>"
    xml_string = xml_string +"<tax_per>#{order.tax_per}</tax_per>"
    xml_string = xml_string +"<tax_amt>#{order.tax_amt}</tax_amt>"
    xml_string = xml_string +"<other_amt>#{order.other_amt}</other_amt>"
    xml_string = xml_string +"<net_amt>0</net_amt>"
    xml_string = xml_string +"<post_flag>P</post_flag>"
    xml_string = xml_string +"<sales_date>#{order.trans_date.to_date}</sales_date>"
    xml_string = xml_string +"<billed_flag>Y</billed_flag>"
    xml_string = xml_string +"<company_id>#{order.company_id}</company_id>"
    xml_string = xml_string +"<id></id>"

    xml_string = xml_string+"<sales_invoice_lines>"
    invoice = Sales::SalesInvoice.find_by_ref_trans_no(order.trans_no)
    if invoice
      xml_string = create_sales_invoice_singleline_xml(xml_string,order,multi_description,ship_qty)
    else
      xml_string = create_sales_invoice_multiline_xml(xml_string,order,multi_description,ship_qty)
    end
    xml_string = xml_string+"</sales_invoice_lines>"

    xml_string = xml_string+"</sales_invoice>"
    xml_string = xml_string+"</sales_invoices>"
    xml = %{#{xml_string}}
    doc = Hpricot::XML(xml)
    invoices =  create_invoices(doc,true)
    return invoices
  end

  def self.create_sales_invoice_multiline_xml(xml_string,order,multi_description,ship_qty)
    order.sales_order_lines.each{|order_line|
      if order_line.trans_flag == 'A'
        xml_string = xml_string+"<sales_invoice_line>"
        xml_string = xml_string +"<id></id>"
        if order_line.item_type == 'I'
          #          order_qty = nulltozero(shipping.clear_qty) + nulltozero(shipping.damaged_qty)
          ## there are multiple inventory items in sample also sample order must be shipped completely
          if order.trans_type == TRANS_TYPE_SAMPLE_ORDER
            order_qty = order_line.item_qty.to_i
          else
            order_qty = ship_qty.to_i
          end
          calculated_item_amount = (order_qty * order_line.item_price)
          calculated_net_amt = calculated_item_amount - order_line.discount_amt
          xml_string = xml_string +"<item_qty>#{order_qty}</item_qty>"
          xml_string = xml_string +"<multi_description>#{multi_description}</multi_description>"
          xml_string = xml_string +"<ref_qty>#{order_qty}</ref_qty>"
          xml_string = xml_string +"<item_amt>#{calculated_item_amount}</item_amt>"
          xml_string = xml_string +"<net_amt>#{calculated_net_amt}</net_amt>"
        else
          calculated_item_amount = order_line.item_amt
          calculated_net_amt = calculated_item_amount - order_line.discount_amt
          xml_string = xml_string +"<item_qty>#{order_line.item_qty}</item_qty>"
          xml_string = xml_string +"<ref_qty>#{order_line.item_qty}</ref_qty>"
          xml_string = xml_string +"<item_amt>#{calculated_item_amount}</item_amt>"
          xml_string = xml_string +"<net_amt>#{calculated_net_amt}</net_amt>"
        end
        xml_string = xml_string +"<ref_serial_no>#{order_line.serial_no}</ref_serial_no>"
        xml_string = xml_string +"<item_price>#{order_line.item_price}</item_price>"

        xml_string = xml_string +"<discount_amt>#{order_line.discount_amt}</discount_amt>"
        xml_string = xml_string +"<discount_per>#{order_line.discount_per}</discount_per>"
        xml_string = xml_string +"<remarks>#{order.remarks}</remarks>"
        xml_string = xml_string +"<ref_trans_bk>#{order_line.trans_bk}</ref_trans_bk>"
        xml_string = xml_string +"<update_flag>Y</update_flag>"
        xml_string = xml_string +"<trans_flag>A</trans_flag>"
        
        xml_string = xml_string +"<ref_trans_no>#{order_line.trans_no}</ref_trans_no>"
        xml_string = xml_string +"<item_description>#{order_line.item_description}</item_description>"
        xml_string = xml_string +"<catalog_item_id>#{order_line.catalog_item_id}</catalog_item_id>"
        xml_string = xml_string +"<company_id>#{order_line.company_id}</company_id>"
        xml_string = xml_string +"<account_period_code>#{Setup::AccountPeriod.period_from_date(Time.now).code}</account_period_code>"
        xml_string = xml_string +"<catalog_item_code>#{order_line.catalog_item_code}</catalog_item_code>"
        xml_string = xml_string +"<trans_date>#{Time.now.to_date}</trans_date>"
        xml_string = xml_string +"<item_type>#{order_line.item_type}</item_type>"
        #        xml_string = xml_string +"<trans_date>#{Time.now.to_date}</trans_date>"
        xml_string = xml_string +"<ref_trans_date>#{order.trans_date.to_date}</ref_trans_date>"
        xml_string = xml_string +"<taxable>Y</taxable>"
        xml_string = xml_string +"<packet_require_yn>N</packet_require_yn>"
        xml_string = xml_string +"<image_thumnail></image_thumnail>"
        xml_string = xml_string+"</sales_invoice_line>"
      end
    }
    return xml_string
  end

  def self.create_sales_invoice_singleline_xml(xml_string,order,multi_description,ship_qty)
    order.sales_order_lines.each{|order_line|
      if (order_line.item_type == 'I' and order_line.trans_flag == 'A')
        xml_string = xml_string+"<sales_invoice_line>"
        xml_string = xml_string +"<id></id>"
        #        order_qty = nulltozero(shipping.clear_qty) + nulltozero(shipping.damaged_qty) ## 5 july 2012 removed as suggested by vijay sir
        ## there are multiple inventory items in sample also sample order must be shipped completely
        if order.trans_type == TRANS_TYPE_SAMPLE_ORDER
          order_qty = order_line.item_qty.to_i
        else
          order_qty = ship_qty.to_i
        end
        calculated_item_amount = (order_qty * order_line.item_price)
        calculated_net_amt = calculated_item_amount - order_line.discount_amt
        xml_string = xml_string +"<multi_description>#{multi_description}</multi_description>"
        xml_string = xml_string +"<item_qty>#{order_qty}</item_qty>"
        xml_string = xml_string +"<item_amt>#{calculated_item_amount}</item_amt>"
        xml_string = xml_string +"<net_amt>#{calculated_net_amt}</net_amt>"
        xml_string = xml_string +"<ref_serial_no>#{order_line.serial_no}</ref_serial_no>"
        xml_string = xml_string +"<item_price>#{order_line.item_price}</item_price>"
        xml_string = xml_string +"<discount_amt>#{order_line.discount_amt}</discount_amt>"
        xml_string = xml_string +"<discount_per>#{order_line.discount_per}</discount_per>"
        xml_string = xml_string +"<remarks>#{order.remarks}</remarks>"
        xml_string = xml_string +"<ref_trans_bk>#{order_line.trans_bk}</ref_trans_bk>"
        xml_string = xml_string +"<update_flag>Y</update_flag>"
        xml_string = xml_string +"<trans_flag>A</trans_flag>"
        xml_string = xml_string +"<ref_qty>#{order_qty}</ref_qty>"
        xml_string = xml_string +"<ref_trans_no>#{order_line.trans_no}</ref_trans_no>"
        xml_string = xml_string +"<item_description>#{order_line.item_description}</item_description>"
        xml_string = xml_string +"<catalog_item_id>#{order_line.catalog_item_id}</catalog_item_id>"
        xml_string = xml_string +"<company_id>#{order_line.company_id}</company_id>"
        xml_string = xml_string +"<account_period_code>#{Setup::AccountPeriod.period_from_date(Time.now).code}</account_period_code>"
        xml_string = xml_string +"<catalog_item_code>#{order_line.catalog_item_code}</catalog_item_code>"
        xml_string = xml_string +"<trans_date>#{Time.now.to_date}</trans_date>"
        xml_string = xml_string +"<item_type>#{order_line.item_type}</item_type>"
        #        xml_string = xml_string +"<trans_date>#{Time.now.to_date}</trans_date>"
        xml_string = xml_string +"<ref_trans_date>#{order.trans_date.to_date}</ref_trans_date>"
        xml_string = xml_string +"<taxable>Y</taxable>"
        xml_string = xml_string +"<packet_require_yn>N</packet_require_yn>"
        xml_string = xml_string +"<image_thumnail></image_thumnail>"
        xml_string = xml_string+"</sales_invoice_line>"
      end
    }
    return xml_string
  end

  def self.create_invoices(doc,update_order_flag)
    invoices = [] 
    (doc/:sales_invoices/:sales_invoice).each{|invoice_doc|
      invoice = create_invoice(invoice_doc,update_order_flag)
      invoices <<  invoice if invoice
    }
    invoices
  end

  def self.create_invoice(doc,update_order_flag)
    invoice = add_or_modify_invoice(doc) 
    return  if !invoice
    order = Sales::SalesOrder.find_by_trans_no(invoice.ref_trans_no)
    invoice.generate_trans_no('SAOIIN') if invoice.new_record?
    invoice.apply_header_fields_to_lines  
    invoice.apply_line_fields_to_header 
    ref_hdrs, ref_lines = invoice.run_sales_posting() if(order.ordercancelstatus_flag != 'Y')
    gl_sale = Sales::SalesGlPosting::Posting.new
    gl_postings = gl_sale.create_gl_postings(invoice)
    save_proc = Proc.new{
      if invoice.new_record?
        invoice.save!         
      else
        invoice.save! 
        invoice.sales_invoice_lines.save_line
      end
      #save reference transactions
      if(order.ordercancelstatus_flag != 'Y')
        ref_lines.each{|ref_line|
          ref_line.save!
        } if ref_lines
        ref_hdrs.each{|ref_hdr|
          ref_hdr.update_attributes(:update_flag=>'V')
        } if ref_hdrs
        inventory = Inventory::InventorySales::Posting.new
        inventory_postings = inventory.create_inventory_postings(invoice)
        Inventory::InventoryPosting.post_inventory_transactions(inventory_postings) if inventory_postings
      end
      account_posting = Sales::SalesAccountsPosting::Posting.new
      account_posting.post_customerinvoice(invoice)
      GeneralLedger::GlPosting.post_gl_transactions(gl_postings)   if gl_postings
      #      check_order_invoiced(doc,invoice) if (invoice.trans_type == 'O' and invoice.ref_type == 'O' and update_order_flag == true)
      ##    we are sending email with attachment from function check_order_invoiced so this is commented
      #      email = Email::Email.send_email('SALESINVOICE',invoice)
      #      email.save!
    }
    if(invoice.errors.empty?)
      invoice.save_transaction(&save_proc)
    end
    return invoice
  end

  def self.add_or_modify_invoice(doc)
    id =  parse_xml(doc/'id') if (doc/'id').first  
    invoice = Sales::SalesInvoice.find_or_create(id) 
    return if !invoice
    if !invoice.new_record? and invoice.update_flag == 'V'
      invoice.errors.add('','This Invoice is View Only. Cannot update.') 
      return invoice
    end
    invoice.apply_attributes(doc) 
    invoice.fill_default_header_values() if invoice.new_record?
    invoice.ref_type = invoice.trans_type
    invoice.max_serial_no = invoice.sales_invoice_lines.maximum_serial_no
    invoice.build_lines(doc/:sales_invoice_lines/:sales_invoice_line)   
    return invoice 
  end

  def self.check_order_invoiced(order,invoice,sales_order_shipping)
    shipping_id  = sales_order_shipping.id
    if order.ordercancelstatus_flag == 'Y'
      order.sales_order_shippings.each{|shipping|
        if(shipping.trans_flag == 'A')
          shipping.invoiced_flag = 'Y'
        end
      }
      order.order_status = INVOICED; order.invoiced_flag = 'Y'; order.ordercompletestatus_flag = 'Y'
      order.update_flag = 'V'
    else
      order.sales_order_shippings.each{|shipping|
        if(shipping.trans_flag == 'A' and shipping.id == shipping_id.to_i)
          shipping.invoiced_flag = 'Y'
        end
      }
      shipping_clear_qty = 0
      order.sales_order_shippings.each{ |shipping|
        if (shipping.trans_flag == 'A' and shipping.invoiced_flag == 'Y')
          shipping_clear_qty = shipping_clear_qty + shipping.clear_qty
        end
      }
      if shipping_clear_qty.to_i - order.item_qty >= 0
        order.order_status = INVOICED; order.invoiced_flag = 'Y'; order.ordercompletestatus_flag = 'Y'
        activity_message = Artwork::ArtworkCrud.create_activity_message(order,"INVOICE NO: #{invoice.trans_no} GENERATED")
        order.create_sales_order_transaction_activity(activity_message)
      else
        order.order_status = PARTIAL_INVOICED
        activity_message = Artwork::ArtworkCrud.create_activity_message(order,"PARTIAL INVOICE NO: #{invoice.trans_no} GENERATED ")
        order.create_sales_order_transaction_activity(activity_message)
      end
      clear_qty = order.clear_qty + invoice.item_qty
      order.clear_qty = clear_qty; order.update_flag = 'V'
    end
    return order
    #    workflow_location = Sales::CurrentLocationLogic.find_order_location(order,order.order_status,order.artwork_status)
    #    order.workflow_location = workflow_location
  end
  ### to send invoice acknowledgment to customer via mail also used for resend acknowledgment.
  def self.generate_sales_invoice_pdf(sales_invoice,schema_name)
    begin
      pdf = Prawn::Document.new(:page_size=>"A4",:left_margin=>15)
      #      pdf.repeat :all do
      Sales::PrawnPdfCrud.generate_header_for_sales_invoice_pdf(pdf, schema_name,sales_invoice)
      #      end
      Sales::PrawnPdfCrud.fetch_lines_for_sales_invoice_pdf(pdf,sales_invoice)
      Sales::PrawnPdfCrud.footer_for_sales_invoice_pdf(pdf)
      path = Setup::Type.find(:first, :conditions=>['type_cd = ? and subtype_cd = ?','UPLOAD_FOLDER','REPORT_PRINT'])
      if path
        directory =  "#{Dir.getwd}" + path.value + schema_name
      end
      filename = "#{Time.now().strftime('%Y%m%d%H%M%S')}"
      absolute_filename = File.join(directory, filename)+ "." + "pdf"
      pdf.render_file "#{absolute_filename}"
      return true,absolute_filename
    rescue Exception => ex
      return false,ex
    end
  end

  def self.resend_invoice_acknowledgment(invoice_id,schema_name)
    begin
      invoice = Sales::SalesInvoice.find_by_id(invoice_id)
      result,pdf_file_name_path = generate_sales_invoice_pdf(invoice,schema_name)
      if result == true
        email = Email::Email.send_email('INVOICEACKNOWLEDGMENT',invoice)
        email.file_name_path = pdf_file_name_path
        email.save!
        return 'Invoice Sent Successfully','success'
      else
        return pdf_file_name_path,'error'
      end
    rescue Exception => ex
      return ex,'error'
    end
  end


  def self.create_customer_receipts_xml(invoice,order)
    begin
      #      order_first_invoice = Sales::SalesInvoice.find_by_ref_trans_no(order.trans_no)
      #      customer_receipt_line = Customer::CustomerReceiptLine.find_by_ref_no(order_first_invoice.trans_no) if order_first_invoice
      #      customer_receipt = Customer::CustomerReceipt.find_by_id(customer_receipt_line.customer_receipt_id) if customer_receipt_line
      gl_accounts = GeneralLedger::GlSetup.find_by_sql ["select TOP 1 * from gl_setups"]
      xml_string = "<customer_receipts> "
      xml_string = xml_string+"<customer_receipt>"
      xml_string = xml_string +"<trans_type>P</trans_type>"
      xml_string = xml_string +"<customer_id>#{invoice.customer_id}</customer_id>"
      xml_string = xml_string +"<customer_code>#{invoice.customer_code}</customer_code>"
      xml_string = xml_string +"<parent_id>#{invoice.customer_id}</parent_id>"
      xml_string = xml_string +"<parent_code>#{invoice.customer_code}</parent_code>"
      xml_string = xml_string +"<salesperson_code/>"
      xml_string = xml_string +"<description></description>"
      xml_string = xml_string +"<receipt_type>CASH</receipt_type>"
      xml_string = xml_string +"<check_no>#{invoice.trans_no}</check_no>"
      xml_string = xml_string +"<check_date/>"
      xml_string = xml_string +"<received_amt>#{invoice.net_amt}</received_amt>"
      xml_string = xml_string +"<bank_id>#{gl_accounts[0].faar_bank_id}</bank_id>"
      xml_string = xml_string +"<bank_code>#{gl_accounts[0].faar_bank_code}</bank_code>"
      xml_string = xml_string +"<deposit_no></deposit_no>"
      xml_string = xml_string +"<trans_flag>A</trans_flag>"
      xml_string = xml_string +"<trans_bk>RE01</trans_bk>"
      xml_string = xml_string +"<trans_date>#{invoice.trans_date}</trans_date>"
      xml_string = xml_string +"<account_period_code>#{invoice.account_period_code}</account_period_code>"
      xml_string = xml_string +"<action_flag>C</action_flag>"
      xml_string = xml_string +"<term_code/>"
      xml_string = xml_string +"<due_date/>"
      xml_string = xml_string +"<post_flag>P</post_flag>"
      xml_string = xml_string +"<updated_by/>"
      xml_string = xml_string +"<created_by>#{invoice.created_by}</created_by>"
      xml_string = xml_string +"<company_id>#{invoice.company_id}</company_id>"
      xml_string = xml_string +"<updated_by_code>#{invoice.updated_by_code}</updated_by_code>"

      #      if customer_receipt
      #        xml_string = xml_string +"<id>#{customer_receipt.id}</id>"
      #        xml_string = xml_string +"<trans_no>#{customer_receipt.trans_no}</trans_no>"
      #        xml_string = xml_string +"<applied_amt>#{nulltozero(customer_receipt.applied_amt) + nulltozero(invoice.net_amt)}</applied_amt>"
      #        xml_string = xml_string +"<balance_amt>#{nulltozero(customer_receipt.applied_amt) + nulltozero(invoice.net_amt)}</balance_amt>"
      #      else
      xml_string = xml_string +"<id></id>"
      xml_string = xml_string +"<trans_no/>"
      xml_string = xml_string +"<applied_amt>#{invoice.net_amt}</applied_amt>"
      xml_string = xml_string +"<balance_amt>0.00</balance_amt>"
      #      end

      xml_string = xml_string+"<customer_receipt_lines>"
      xml_string = xml_string+"<customer_receipt_line>"
      xml_string = xml_string +"<id></id>"
      xml_string = xml_string +"<company_id>#{invoice.company_id}</company_id>"
      xml_string = xml_string +"<created_by/>"
      xml_string = xml_string +"<updated_by/>"
      xml_string = xml_string +"<created_at/>"
      xml_string = xml_string +"<updated_at/>"
      xml_string = xml_string +"<update_flag>Y</update_flag>"
      xml_string = xml_string +"<trans_flag>A</trans_flag>"
      xml_string = xml_string +"<trans_bk>#{invoice.trans_bk}</trans_bk>"
      xml_string = xml_string +"<trans_no/>"
      xml_string = xml_string +"<voucher_no>#{invoice.trans_bk}#{invoice.trans_no}</voucher_no>"
      xml_string = xml_string +"<trans_date>#{invoice.trans_date}</trans_date>"
      xml_string = xml_string +"<voucher_date>#{invoice.trans_date}</voucher_date>"
      xml_string = xml_string +"<due_date/>"
      xml_string = xml_string +"<serial_no/>"
      xml_string = xml_string +"<voucher_flag/>"
      xml_string = xml_string +"<apply_flag>Y</apply_flag>"
      xml_string = xml_string +"<customer_receipt_id/>"
      xml_string = xml_string +"<gl_account_id/>"
      xml_string = xml_string +"<original_amt>#{invoice.net_amt}</original_amt>"
      xml_string = xml_string +"<apply_amt>#{invoice.net_amt}</apply_amt>"
      xml_string = xml_string +"<balance_amt>#{invoice.net_amt}</balance_amt>"
      xml_string = xml_string +"<disctaken_amt>0</disctaken_amt>"
      xml_string = xml_string +"<apply_to/>"
      xml_string = xml_string +"<ref_no>#{invoice.trans_no}</ref_no>"
      xml_string = xml_string +"<gl_account_code/>"
      xml_string = xml_string +"<gl_account_name/>"
      xml_string = xml_string +"<updated_by_code/>"
      xml_string = xml_string +"<remaining_amt>0.00</remaining_amt>"
      xml_string = xml_string +"<period_close_flag/>"
      xml_string = xml_string +"<description/>"
      xml_string = xml_string+"</customer_receipt_line>"
      xml_string = xml_string+"</customer_receipt_lines>"

      xml_string = xml_string+"</customer_receipt>"
      xml_string = xml_string+"</customer_receipts>"
      xml = %{#{xml_string}}
      doc = Hpricot::XML(xml)
      receipts =  Customer::CustomerReceiptCrud.create_receipts(doc,'R')
      receipt =  receipts.first if !receipts.empty?
      if receipt.errors.empty?
        return receipt,'success'
      else
        return receipt.errors,'error'
      end
    rescue Exception => ex
      return ex,'error'
    end
  end


  def self.list_open_invoices(doc)
    criteria = Setup::Criteria.fill_criteria_for_query(doc/:criteria) 
    Sales::SalesInvoice.find_by_sql ["select CAST( (select(select b.*, (b.item_qty - b.clear_qty) as open_qty,
                                    catalog_items.taxable as taxable,catalog_items.image_thumnail as image_thumnail, catalog_items.packet_require_yn as packet_require_yn,
                                    sales_invoices.discount_per as hdr_discount_per,
                                    sales_invoices.discount_amt as hdr_discount_amt,
                                    sales_invoices.tax_per as hdr_tax_per,
                                    sales_invoices.tax_amt as hdr_tax_amt,
                                    customers.code as customer_code from sales_invoices
                                    inner join customers on customers.id = sales_invoices.customer_id
                                    join sales_invoice_lines b on b.sales_invoice_id = sales_invoices.id
                                    join catalog_items on catalog_items.id = b.catalog_item_id
                                    where (sales_invoices.trans_flag = 'A') AND b.sales_invoice_id = sales_invoices.id and
                                    b.item_qty > b.clear_qty and
                                    b.trans_flag='A' and
                                    ( sales_invoices.company_id = #{criteria.company_id}) and
                                    sales_invoices.customer_id between #{criteria.int1} and #{criteria.int1}
                                    order by sales_invoices.trans_date, sales_invoices.trans_no, b.serial_no
                                    FOR XML PATH('sales_invoice'),type,elements xsinil)FOR XML PATH('sales_invoices')) AS xml) as xmlcol"
    ]
  end

  def self.list_open_invoices_hdr(doc)
    criteria = Setup::Criteria.fill_criteria_for_query(doc/:criteria)
    Sales::SalesInvoice.find_by_sql ["select CAST( (select(select distinct sales_invoices.id, sales_invoices.trans_no, sales_invoices.trans_date, sales_invoices.ext_ref_no as customer_order_no,
                                    customers.code as customer_code from sales_invoices
                                    inner join customers on customers.id = sales_invoices.customer_id
                                    join sales_invoice_lines b on b.sales_invoice_id = sales_invoices.id
                                    join catalog_items on catalog_items.id = b.catalog_item_id
                                    where (sales_invoices.trans_flag = 'A') AND b.sales_invoice_id = sales_invoices.id and
                                    b.item_qty > b.clear_qty and
                                    b.trans_flag='A' and
                                    ( sales_invoices.company_id = #{criteria.company_id}) and
                                    sales_invoices.customer_id between #{criteria.int1} and #{criteria.int2}
                                    order by sales_invoices.trans_no
                                    FOR XML PATH('sales_invoice'),type,elements xsinil)FOR XML PATH('sales_invoices')) AS xml) as xmlcol"
    ]

  end


  def self.list_open_invoice_lines(doc)
    criteria = Setup::Criteria.fill_criteria_for_query(doc/:criteria)
    Sales::SalesInvoice.find_by_sql ["select CAST( (select(select b.*, (b.item_qty - b.clear_qty) as open_qty,
                                    catalog_items.taxable as taxable,catalog_items.image_thumnail as image_thumnail, catalog_items.packet_require_yn as packet_require_yn,
                                    sales_invoices.discount_per as hdr_discount_per,
                                    sales_invoices.discount_amt as hdr_discount_amt,
                                    sales_invoices.tax_per as hdr_tax_per,
                                    sales_invoices.tax_amt as hdr_tax_amt,
                                    customers.code as customer_code from sales_invoices
                                    inner join customers on customers.id = sales_invoices.customer_id
                                    join sales_invoice_lines b on b.sales_invoice_id = sales_invoices.id
                                    join catalog_items on catalog_items.id = b.catalog_item_id
                                    where (sales_invoices.trans_flag = 'A') AND b.sales_invoice_id = sales_invoices.id and
                                    b.item_qty > b.clear_qty and
                                    b.trans_flag='A' and
                                    ( sales_invoices.company_id = #{criteria.company_id}) and
                                    sales_invoices.id between #{criteria.int1} and #{criteria.int2}
                                    order by sales_invoices.trans_date, sales_invoices.trans_no, b.serial_no
                                    FOR XML PATH('sales_invoice'),type,elements xsinil)FOR XML PATH('sales_invoices')) AS xml) as xmlcol"
    ]
  end

  private_class_method :create_invoice, :add_or_modify_invoice

end

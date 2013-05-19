class Shipping::ShippingCrud
  include General
  @config = YAML::load(File.open("#{Rails.root}/config/production_settings.yml"))
  #  Trans Type Codes
  #  S	Regular Order
  #  E	Re-Order
  #  P	Sample Order
  #  V	Virtual Order
  #  F	Spec Order

  ############################# Tekweld Services ###################################
  def self.list_shipping_inbox(doc)
    criteria = Setup::Criteria.fill_criteria_for_query(doc/:criteria)
    user = Admin::User.find_by_id(criteria.user_id)
    if user and user.login_type == 'V'
      ship_to_vendor_join = "inner join users on users.type_id = sos.vendor_id"
      ship_to_vendor_condition = "catalog_items.workflow = '#{WORKFLOW_WATER}' AND sos.vendor_id = #{user.type_id} AND (sos.ship_to_vendor_flag = 'Y') AND"
    end
    condition = "#{ship_to_vendor_condition}
								  (so.trans_type !='P' AND so.trans_flag = 'A' AND sos.trans_flag = 'A' AND so.sub_ref_type <> 'S' AND
									 sol.blank_good_flag <> 'Y' AND so.hold_order_flag <> 'Y' AND sol.item_type = 'I' and sol.trans_flag = 'A'
									 AND so.trans_type in ('S','E','F') AND (soa.final_artwork_flag = 'Y') AND so.ordercancelstatus_flag <> 'Y'
									 AND sos.packaging_flag = 'Y' AND sos.trans_flag = 'A'  AND (sos.ship_qty - sos.clear_qty > 0))"
    condition = convert_sql_to_db_specific(condition)
    Sales::SalesOrder.find_by_sql ["select CAST((
                                  select(select distinct '' as vs, '' as user_name,soa.artwork_version,so.ext_ref_no,types.description as order_type,so.trans_type,so.trans_date,customers.name,customers.code as customer_code,
                                         so.multi_description as order_multi_description,so.rushorder_flag,so.order_flagged,so.artwork_status,so.order_status,so.trans_no,sol.serial_no,so.logo_name,sol.catalog_item_code,sos.id,
                                         catalog_items.workflow,sol.indigo_code,sol.item_description,sol.item_qty,sos.internal_ship_date as ship_date,sos.internal_ship_date,sos.ship_name,sos.ship_address1,sos.ship_address2,
                                  sos.ship_city,sos.ship_state,sos.ship_zip,sos.ship_country,sos.ship_phone,sos.ship_fax,sos.clear_qty,(sos.ship_qty-sos.clear_qty) as ship_qty,sos.ship_method,sos.shipping_code,sos.estimated_ship_date
                                  from sales_orders so
                                  inner join sales_order_lines sol on sol.sales_order_id = so.id
                                  inner join catalog_items on catalog_items.id = sol.catalog_item_id
                                  inner join customers on customers.id = so.customer_id
                                  inner join sales_order_artworks soa on soa.sales_order_id = so.id
                                  inner join sales_order_shippings sos on sos.sales_order_id = so.id
                                  #{ship_to_vendor_join}
                                  left outer join types on (
                                          types.type_cd = 'trans_type'
                                          and types.subtype_cd = 'so'
                                          and so.trans_type = types.value
                                          )
                                  where #{condition}
                                  order by so.order_flagged desc,so.rushorder_flag desc, sos.internal_ship_date
                                  FOR XML PATH('sales_order'), TYPE,ELEMENTS XSINIL
                                  )FOR XML PATH('sales_orders')) AS varchar(MAX)) as xmlcol"
    ]
  end

  def self.create_shipping_inboxes(doc)
    message = ""
    text = ""
    (doc/:sales_orders/:sales_order).each{|order_doc|
      message,text = create_shipping_inbox(order_doc)
      break if text == 'error'
    }
    return message,text
  end
  def self.create_shipping_inbox(order_doc)
    begin
      message = ''
      multiple_attribute_values = []
      id =  parse_xml(order_doc/'id') if (order_doc/'id').first
      trans_no =  parse_xml(order_doc/'trans_no') if (order_doc/'trans_no').first
      damaged_ship_qty =  parse_xml(order_doc/'damaged_qty') if (order_doc/'damaged_qty').first
      ship_qty =  parse_xml(order_doc/'ship_qty') if (order_doc/'ship_qty').first
      multi_description =  parse_xml(order_doc/'multi_description') if (order_doc/'multi_description').first
      damaged_qty_description =  parse_xml(order_doc/'damaged_qty_description') if (order_doc/'damaged_qty_description').first
      order = Sales::SalesOrder.find_by_trans_no(trans_no)
      sales_order_shipping = Sales::SalesOrderShipping.find_by_id(id)
      return  if !sales_order_shipping
      return 'Sample Order Must be Shipped Completely','error' if (order.trans_type == TRANS_TYPE_SAMPLE_ORDER and sales_order_shipping.ship_qty.to_i != ship_qty.to_i)
      if sales_order_shipping.shipping_code.to_s != 'TRUCKING'
        packages = Sales::SalesOrderShippingPackage.find_by_sql ["select * from sales_order_shipping_packages where trans_flag = 'A' and isnull(tracking_no,'') = '' and sales_order_shipping_id = #{sales_order_shipping.id}"]
        if packages[0] || sales_order_shipping.generate_new_label_flag == 'Y'
          return 'Please Print Shipping Labels for all packages before shipment.','error'
        end
      end
      shipping_packages = []
      total_package_qty = 0
      tracking_number = ""
      sales_order_shipping.sales_order_shipping_packages.each{|sales_order_shipping_package|
        if sales_order_shipping_package.trans_flag == 'A' and sales_order_shipping_package.update_flag == 'Y'
          total_package_qty = total_package_qty + sales_order_shipping_package.pcs_per_carton
          tracking_number = tracking_number +  "," + sales_order_shipping_package.tracking_no if sales_order_shipping.shipping_code.to_s != 'TRUCKING'
          shipping_packages << sales_order_shipping_package
        end
      }
      tracking_number = tracking_number[1..-1] if tracking_number != ''
      return 'Ship Qty Doesnot Match the Total Packages Qty. Please Verify The Packages.','error' if total_package_qty.to_i != ship_qty.to_i
      if order.accountreviewed_flag != 'Y'
        result = Accounting::AccountingCrud.check_accounting(order)
        return result,'error' if result != 'success'
      end
      ### new changes which will update multi options qty through text input
      if !multi_description.blank?
        qty = []
        attribute_values = []
        damaged_qty = []
        damaged_attribute_values = []
        multi_description.split(/;/).each do |i|
          qty << i.split(/=/).last
          attribute_values << i.split(/=/).first
        end
        if !damaged_qty_description.blank?
          damaged_qty_description.split(/;/).each do |i|
            damaged_qty << i.split(/=/).last
            damaged_attribute_values << i.split(/=/).first
          end
        end
        multi_values =  Sales::SalesOrderAttributesMultipleValue.find_by_sql ["select soamv.id,soamv.value,soamv.qty, soamv.ship_qty, soamv.damaged_qty from sales_orders so
           inner join sales_order_attributes_values soav on soav.sales_order_id = so.id
           inner join sales_order_attributes_multiple_values soamv on soamv.sales_order_attributes_value_id = soav.id
           where soav.trans_flag = 'A' and soamv.trans_flag = 'A' and soamv.qty != 0 and soamv.qty > soamv.ship_qty
           and so.trans_no = #{trans_no}"]
        qty_count = 0
        attribute_values.each{|attribute_value|
          multi_values.each{|multi_value|
            if multi_value.value == attribute_value
              sales_order_attributes_multiple_value = Sales::SalesOrderAttributesMultipleValue.find_by_id(multi_value.id)
              multi_ship_qty = multi_value.ship_qty + qty[qty_count].to_i
              if damaged_qty[0]
                multi_damaged_qty = multi_value.damaged_qty + damaged_qty[qty_count].to_i
              else
                multi_damaged_qty = 0
              end
              sales_order_attributes_multiple_value.ship_qty = multi_ship_qty
              sales_order_attributes_multiple_value.damaged_qty = multi_damaged_qty
              multiple_attribute_values << sales_order_attributes_multiple_value
            end
          }
          qty_count = qty_count + 1
        }
      end
      sales_order_shipping.transaction do
        clear_qty = sales_order_shipping.clear_qty.to_i + ship_qty.to_i
        full_multi_description = sales_order_shipping.multi_description.to_s + multi_description.to_s
        #      return 'Ship qty is greater than remaining item qty','error' if (clear_qty > sales_order_shipping.ship_qty)
        sales_order_shipping.shipping_flag = 'Y' ; sales_order_shipping.shipping_date = Time.now
        sales_order_shipping.damaged_qty = damaged_ship_qty ; sales_order_shipping.clear_qty = clear_qty
        sales_order_shipping.multi_description = full_multi_description
        if sales_order_shipping.ship_qty.to_i == ship_qty.to_i
          sales_order_shipping.clear_ship_amt = sales_order_shipping.ship_amt
          sales_order_shipping.current_ship_amt = sales_order_shipping.ship_amt
        else
          sales_order_shipping.clear_ship_amt = sales_order_shipping.current_ship_amt + sales_order_shipping.clear_ship_amt
        end
        sales_order_shipping.save!
        shipping_packages.each{|shipping_package|
          shipping_package.update_attributes!(:update_flag => 'V')
        }
        clear_qty = 0
        order.sales_order_shippings.each{ |shipping|
          if (shipping.trans_flag == 'A' and shipping.shipping_flag == 'Y')
            clear_qty = clear_qty + shipping.clear_qty
          end
        }
        if clear_qty.to_i - order.item_qty >= 0
          order.order_status = SHIPPED ; order.shipping_status = 'ORDER SHIPPED' ; order.shipped_flag = 'Y'
          order.create_sales_order_transaction_activity('SHIPPED COMPLETELY')
        else
          order.order_status = PARTIAL_SHIPPED ; order.shipping_status = 'PARTIAL SHIPPED'
          activity_message = Artwork::ArtworkCrud.create_activity_message(order,"PARTIAL SHIPPING OF QTY: #{ship_qty} DONE")
          order.create_sales_order_transaction_activity(activity_message)
        end
        workflow_location = Sales::CurrentLocationLogic.find_order_location(order,order.order_status,order.artwork_status)
        order.workflow_location = workflow_location
        email = Email::Email.send_email('ORDERSHIPPEDCOMPLETLY',sales_order_shipping)
        email.save!
        order.save!
        multiple_attribute_values.each{|multiple_attribute_value| multiple_attribute_value.save!}
        invoice_flag = Setup::Type.find_by_type_cd_and_subtype_cd('saoi','auto_invoiced')
        if invoice_flag.value == 'Y'
          sales_order,invoice,inv_text,receipt,rec_text,emails,payment_transactions,payment_text= generate_invoice_and_receipt(sales_order_shipping,order,ship_qty,multi_description,tracking_number)
          if(inv_text == 'error' || rec_text =='error' || payment_text =='error'||!sales_order.errors[:base].empty?)
            message = invoice.errors[:base][0] if(inv_text == 'error')
            message = receipt.errors[:base][0] if(rec_text =='error')
            if(payment_text == 'error')#change
              message = ''
              payment_transactions.each{|transaction|
                message = message + transaction.errors[:base][0]
              }
            end
            message = sales_order.errors[:base][0] if !sales_order.errors[:base].empty?
            puts "#{message}"
            raise ActiveRecord::Rollback
          else
            workflow_location = Sales::CurrentLocationLogic.find_order_location(sales_order,sales_order.order_status,sales_order.artwork_status)
            sales_order.workflow_location = workflow_location
            sales_order.save!
            emails.each{|email| email.save!}
            payment_transactions.each{|transaction| transaction.save!} if payment_transactions[0] # change
            return 'order shipped successfully','success'
          end
        end
      end
    rescue Exception => ex
      return ex,'error'
    end
    return message,'error' if message != ''
  end

  def self.generate_invoice_and_receipt(sales_order_shipping,order,ship_qty,multi_description,tracking_number)
    payment_transactions = []
    emails = []
    inv_text = ''
    rec_text = ''
    payment_text = ''
    invoices = Sales::SalesInvoiceCrud.create_sales_invoice_xml(sales_order_shipping,order,ship_qty,multi_description,tracking_number)
    invoice =  invoices.first if !invoices.empty?
    if invoice.errors[:base].empty?
      inv_text = 'success'
    else
      inv_text = 'error'
      return order,invoice,inv_text,nil,'',emails,nil,''
    end
    sales_order = Sales::SalesOrder.find_by_id(order.id)
    sales_order = Sales::SalesInvoiceCrud.check_order_invoiced(sales_order,invoice,sales_order_shipping)
    result,pdf_file_name_path = Sales::SalesInvoiceCrud.generate_sales_invoice_pdf(invoice,'TEKW1122')
    if result == true
      email = Email::Email.send_email('INVOICEACKNOWLEDGMENT',invoice)
      email.file_name_path = pdf_file_name_path
      emails << email
      sales_order.create_sales_order_transaction_activity("INVOICE SENT FOR INVOICE# #{invoice.trans_no}")
    else
      sales_order.create_sales_order_transaction_activity("SOME ERROR OCCURRED WHILE SENDING INVOICE")
      sales_order.errors[:base] << "SOME ERROR OCCURRED WHILE SENDING INVOICE"
      return sales_order,invoice,inv_text,nil,rec_text,emails,nil,''
    end
    if(sales_order.term_code == 'CC')
      receipt,rec_text = Sales::SalesInvoiceCrud.create_customer_receipts_xml(invoice,sales_order)
      if receipt.errors[:base].empty?
        activity_message = Artwork::ArtworkCrud.create_activity_message(order,"CUSTOMER RECEIPT# #{receipt.trans_no} GENERATED AGAINST INVOICE# #{invoice.trans_no} FOR  $#{invoice.net_amt}")
        sales_order.create_sales_order_transaction_activity(activity_message)
        inv_text = 'success'
      else
        activity_message = Artwork::ArtworkCrud.create_activity_message(order,"ERROR #{receipt.errors[:base][0]}OCCURRED WHILE RECEIPT GENERATION")
        sales_order.create_sales_order_transaction_activity(activity_message)
        rec_text = 'error'
        return sales_order,invoice,inv_text,receipt,rec_text,emails,nil,''
      end
      payment_transactions, email, msg = Payment::PaymentCrud.capture_payment(sales_order,invoice)
      emails << email if email
      sales_order.payment_result = msg
      payment_transactions.each{|transaction| #change
        if(transaction.errors[:base].empty?)
          payment_text = 'success'
        else
          payment_text = 'error'
          return sales_order,invoice,inv_text,receipt,rec_text,emails,payment_transactions,payment_text
        end
      }
    end
    return sales_order,invoice,inv_text,receipt,rec_text,emails,payment_transactions,payment_text
  end
  ### SAMPLE ORDER SHIPPING INBOX ###
  def self.list_sample_order_shipping_inbox (doc)
    criteria = Setup::Criteria.fill_criteria_for_query(doc/:criteria)
    user = Admin::User.find_by_id(criteria.user_id)
    if user and user.login_type == 'V'
      ship_to_vendor_join = "inner join users on users.type_id = sos.vendor_id"
      ship_to_vendor_condition = "catalog_items.workflow = '#{WORKFLOW_WATER}' AND sos.vendor_id = #{user.type_id} AND (sos.ship_to_vendor_flag = 'Y') AND"
    end
    sample_order_condition = "#{ship_to_vendor_condition}
                  (so.trans_type='P' AND so.trans_flag = 'A' AND sos.trans_flag = 'A' AND
                    so.hold_order_flag <> 'Y' AND so.ordercancelstatus_flag <> 'Y' AND
									 sol.item_type = 'I' and sol.trans_flag = 'A' AND sos.trans_flag = 'A'
									 AND so.accountreviewed_flag = 'Y' AND (sos.ship_qty - sos.clear_qty > 0))"
    Sales::SalesOrder.find_by_sql ["select CAST((
                                  select(
                                  select distinct so.ext_ref_no,types.description as order_type,so.trans_type,so.trans_date,customers.name,customers.code as customer_code,
                                         so.rushorder_flag,so.order_flagged ,so.artwork_status,so.order_status,so.trans_no,so.logo_name,sos.id,
                                         sos.internal_ship_date as ship_date,sos.internal_ship_date,sos.ship_name,sos.ship_address1,sos.ship_address2,
                                  sos.ship_city,sos.ship_state,sos.ship_zip,sos.ship_country,sos.ship_phone,sos.ship_fax,sos.clear_qty,(sos.ship_qty-sos.clear_qty) as ship_qty,sos.ship_method,sos.shipping_code,sos.estimated_ship_date
                                  from sales_orders so
                                  inner join sales_order_lines sol on sol.sales_order_id = so.id
                                  inner join catalog_items on catalog_items.id = sol.catalog_item_id
                                  inner join customers on customers.id = so.customer_id
                                  inner join sales_order_artworks soa on soa.sales_order_id = so.id
                                  inner join sales_order_shippings sos on sos.sales_order_id = so.id
                                  #{ship_to_vendor_join}
                                  left outer join types on (
                                          types.type_cd = 'trans_type'
                                          and types.subtype_cd = 'so'
                                          and so.trans_type = types.value
                                          )
                                  where #{sample_order_condition}
                                  order by so.order_flagged desc,so.rushorder_flag desc, sos.internal_ship_date
                                  FOR XML PATH('sales_order'), TYPE,ELEMENTS XSINIL
                                  )FOR XML PATH('sales_orders')) AS varchar(MAX)) as xmlcol"
    ]
  end

  ## this function will automatically generate invoice based on flag in application settings.
  def self.generate_invoice_automatically(sales_order_shipping,order,ship_qty,multi_description,tracking_number)
    invoice_flag = Setup::Type.find_by_type_cd_and_subtype_cd('saoi','auto_invoiced')
    if invoice_flag.value == 'Y'
      xml = %{<sales_invoices>
              <sales_invoice>
                <id>#{order.id}</id>
                <shipping_id>#{sales_order_shipping.id}</shipping_id>
                <ship_qty>#{ship_qty}</ship_qty>
                <multi_description>#{multi_description}</multi_description>
                <tracking_number>#{tracking_number}</tracking_number>
              </sales_invoice>
            </sales_invoices>}
      doc = Hpricot::XML(xml)
      invoices = Sales::SalesInvoiceCrud.create_sales_invoice_xml(doc)
      invoice =  invoices.first if !invoices.empty?
      if invoice.errors.empty?
        return invoice,'success'
      else
        return invoice,'error'
      end
    else
      workflow_location = Sales::CurrentLocationLogic.find_order_status(order.trans_no)
      order.update_attributes!(:workflow_location => workflow_location)
    end
  end

  #Sales Standard/Regular AND ReOrder Order services
  def self.list_order_shipping_and_packages(doc)
    criteria = Setup::Criteria.fill_criteria_for_query(doc/:criteria)
    condition = "(so.company_id = #{criteria.company_id}) AND
                     (customers.code between '#{criteria.str1}' and '#{criteria.str2}' AND (0 =#{criteria.multiselect1.length} or customers.code in ('#{criteria.multiselect1}'))) AND
                     (so.trans_no between '#{criteria.str3}' and '#{criteria.str4}' AND (0 =#{criteria.multiselect2.length} or so.trans_no in ('#{criteria.multiselect2}'))) AND
                     (so.trans_date between '#{criteria.dt1}' and '#{criteria.dt2}' ) AND
                     (so.account_period_code between '#{criteria.str5[0,8]}' and '#{criteria.str6[0,8]}' AND (0 =#{criteria.multiselect3.length} or so.account_period_code in ('#{criteria.multiselect3}')))
                     AND (so.logo_name between '#{criteria.str7}' and '#{criteria.str8}' AND (0 =#{criteria.multiselect4.length} or so.logo_name in ('#{criteria.multiselect4}')))
                     AND (so.ext_ref_no between '#{criteria.str9}' and '#{criteria.str10}' AND (0 =#{criteria.multiselect5.length} or so.ext_ref_no in ('#{criteria.multiselect5}')))
                     AND (LTRIM(RTRIM(sos.ship_address1)) between '#{criteria.str11}' and '#{criteria.str12}' AND (0 =#{criteria.multiselect6.length} or LTRIM(RTRIM(sos.ship_address1)) in ('#{criteria.multiselect6}')))
                     AND (sos.internal_ship_date between '#{criteria.dt3}' and '#{criteria.dt4}' )
                     AND ((so.trans_type='P' AND so.trans_flag = 'A' AND
									 so.orderqcstatus_flag = 'Y'AND sol.blank_good_flag <> 'Y' AND so.hold_order_flag <> 'Y' AND
									 sol.item_type = 'I' and sol.trans_flag = 'A' AND sos.trans_flag = 'A'
									 AND so.accountreviewed_flag = 'Y')
								OR
								  (so.trans_type !='P' AND so.trans_flag = 'A' AND
									 sol.blank_good_flag <> 'Y' AND so.hold_order_flag <> 'Y' AND sol.item_type = 'I' and sol.trans_flag = 'A'
									 AND so.trans_type in ('S','E','F') AND (soa.final_artwork_flag = 'Y')
									 AND sos.trans_flag = 'A')) AND (sos.ship_qty - sos.clear_qty > 0)"
    condition = convert_sql_to_db_specific(condition)
    Sales::SalesOrder.find_by_sql ["select CAST((
                                  select(select distinct '' as vs, '' as user_name,soa.artwork_version,so.ext_ref_no,types.description as order_type,so.trans_type,so.trans_date,customers.name,customers.code as customer_code,
                                         so.rushorder_flag,so.artwork_status,so.order_status,so.trans_no,sol.serial_no,so.logo_name,sol.catalog_item_code,sos.id,
                                         catalog_items.workflow,sol.indigo_code,sol.item_description,sol.item_qty,sos.internal_ship_date as ship_date,sos.internal_ship_date,sos.ship_name,sos.ship_address1,sos.ship_address2,
                                  sos.ship_city,sos.ship_state,sos.ship_zip,sos.ship_country,sos.ship_phone,sos.ship_fax,sos.ship_qty,sos.ship_method,sos.shipping_code,sos.estimated_ship_date
                                  from sales_orders so
                                  inner join sales_order_lines sol on sol.sales_order_id = so.id
                                  inner join catalog_items on catalog_items.id = sol.catalog_item_id
                                  inner join customers on customers.id = so.customer_id
                                  inner join users on users.id = so.updated_by
                                  inner join sales_order_artworks soa on soa.sales_order_id = so.id
                                  inner join sales_order_shippings sos on sos.sales_order_id = so.id

                                  left outer join types on (
                                          types.type_cd = 'trans_type'
                                          and types.subtype_cd = 'so'
                                          and so.trans_type = types.value
                                          )
                                  where #{condition}
                                  order by sos.internal_ship_date
                                  FOR XML PATH('sales_order'), TYPE,ELEMENTS XSINIL
                                  )FOR XML PATH('sales_orders')) AS varchar(MAX)) as xmlcol"
    ]
  end
  def self.show_order_shipping_and_package(shipping_id)
    Sales::SalesOrderShipping.where(:id => shipping_id)
  end

  def self.create_order_shipping_and_packages(doc)
    orders = []
    (doc/:sales_order_shippings/:sales_order_shipping).each{|shipping_doc|
      order = create_order_shipping_and_package(shipping_doc)
      orders <<  order if order
    }
    orders
  end

  def self.create_order_shipping_and_package(doc)
    shipping = add_or_modify_order_shipping_and_package(doc)
    return  if !shipping
    save_proc = Proc.new{
      shipping.save_lines
    }
    shipping.save_transaction(&save_proc)
    return shipping
  end

  def self.add_or_modify_order_shipping_and_package(doc)
    id =  parse_xml(doc/'id') if (doc/'id').first
    shipping = Sales::SalesOrderShipping.find_or_create(id)
    return if !shipping
    shipping = update_shipping_amount(doc,shipping)
    shipping.run_block do
      shipping.max_serial_no = shipping.sales_order_shipping_packages.maximum_serial_no
      shipping.build_lines(doc/:sales_order_shipping_packages/:sales_order_shipping_package)
      shipping.max_serial_no = shipping.sales_order_shipping_truck_packages.maximum_serial_no
      shipping.build_lines(doc/:sales_order_shipping_truck_packages/:sales_order_shipping_truck_package)
    end
    return shipping
  end

  def self.update_shipping_amount(doc,shipping)
    ship_amt =  parse_xml(doc/'ship_amt') if (doc/'ship_amt').first
    #    clear_ship_amt = shipping.clear_ship_amt + ship_amt.to_f
    #    order = Sales::SalesOrder.find_by_id(shipping.sales_order_id)
    #    order_ship_amt = (order.ship_amt - shipping.ship_amt) + ship_amt.to_f
    #    order_net_amt = (order.net_amt - shipping.ship_amt) + ship_amt.to_f
    #    order.update_attributes!(:ship_amt=>order_ship_amt,:net_amt=>order_net_amt)
    shipping.update_attributes!(:current_ship_amt => ship_amt.to_f,:generate_new_label_flag => 'Y')
    return shipping
  end

  def self.list_vendor_shipping_inbox(doc)
    criteria = Setup::Criteria.fill_criteria_for_query(doc/:criteria)
    #    user = Admin::User.find_by_id(criteria.user_id)
    condition = "(so.company_id = #{criteria.company_id}) AND
                     (customers.code between '#{criteria.str1}' and '#{criteria.str2}' AND (0 =#{criteria.multiselect1.length} or customers.code in ('#{criteria.multiselect1}'))) AND
                     (so.trans_no between '#{criteria.str3}' and '#{criteria.str4}' AND (0 =#{criteria.multiselect2.length} or so.trans_no in ('#{criteria.multiselect2}'))) AND
                     (so.trans_date between '#{criteria.dt1}' and '#{criteria.dt2}' ) AND
                     (so.account_period_code between '#{criteria.str5[0,8]}' and '#{criteria.str6[0,8]}' AND (0 =#{criteria.multiselect3.length} or so.account_period_code in ('#{criteria.multiselect3}')))
                     AND (so.logo_name between '#{criteria.str7}' and '#{criteria.str8}' AND (0 =#{criteria.multiselect4.length} or so.logo_name in ('#{criteria.multiselect4}')))
                     AND (so.ext_ref_no between '#{criteria.str9}' and '#{criteria.str10}' AND (0 =#{criteria.multiselect5.length} or so.ext_ref_no in ('#{criteria.multiselect5}')))
                     AND (so.trans_flag = 'A' AND so.ordercancelstatus_flag <> 'Y' AND
									 sol.blank_good_flag <> 'Y' AND so.hold_order_flag <> 'Y' AND sol.item_type = 'I' and sol.trans_flag = 'A' AND sol.cut_flag = 'Y' and sol.direct_production_flag = 'Y'
									 AND so.trans_type in ('S','E','F') AND (soa.final_artwork_flag = 'Y')
									 AND sos.trans_flag = 'A'  AND sos.ship_to_vendor_flag = 'N' AND catalog_items.workflow = '#{WORKFLOW_WATER}')"
    condition = convert_sql_to_db_specific(condition)
    Sales::SalesOrder.find_by_sql ["select CAST((
                                  select(select distinct po.trans_no as ref_po_no,so.company_id,soa.artwork_version,so.ext_ref_no,types.description as order_type,so.trans_type,so.trans_date,customers.name,customers.code as customer_code,
                                         so.rushorder_flag,so.order_flagged,so.artwork_status,so.order_status,so.trans_no,sol.serial_no,so.logo_name,sol.catalog_item_code,sos.id,
                                         sol.item_description,sol.item_qty,sos.internal_ship_date as ship_date,sos.internal_ship_date,sos.ship_name,sos.ship_address1,sos.ship_address2,
                                  sos.vendor_id,sos.vendor_code,sos.ship_city,sos.ship_state,sos.ship_zip,sos.ship_country,sos.ship_phone,sos.ship_fax,sos.clear_qty,(sos.ship_qty-sos.clear_qty) as ship_qty,sos.ship_method,sos.shipping_code,sos.estimated_ship_date
                                  from sales_orders so
                                  inner join sales_order_lines sol on sol.sales_order_id = so.id
                                  inner join sales_order_attributes_values soav on soav.sales_order_id = so.id
                                  inner join customers on customers.id = so.customer_id
                                  inner join sales_order_artworks soa on soa.sales_order_id = so.id
                                  inner join sales_order_shippings sos on sos.sales_order_id = so.id
                                  inner join catalog_items on catalog_items.id = sol.catalog_item_id
                                  left outer join purchase_orders po on po.ref_trans_no = so.trans_no
                                  left outer join types on (
                                          types.type_cd = 'trans_type'
                                          and types.subtype_cd = 'so'
                                          and so.trans_type = types.value
                                          )
                                  where #{condition}
                                  order by so.order_flagged desc,so.rushorder_flag desc, sos.internal_ship_date
                                  FOR XML PATH('sales_order_shipping'), TYPE,ELEMENTS XSINIL
                                  )FOR XML PATH('sales_order_shippings')) AS varchar(MAX)) as xmlcol"
    ]
  end

  def self.create_vendor_shipping_inboxes(doc)
    message = ""
    text = ""
    (doc/:sales_order_shippings/:sales_order_shipping).each{|order_doc|
      message,text = create_vendor_shipping_inbox(order_doc)
      break if text == 'error'
    }
    return message,text
  end
  def self.create_vendor_shipping_inbox(order_doc)
    begin
      id =  parse_xml(order_doc/'id') if (order_doc/'id').first
      trans_no =  parse_xml(order_doc/'trans_no') if (order_doc/'trans_no').first
      vendor_id =  parse_xml(order_doc/'vendor_id') if (order_doc/'vendor_id').first
      vendor_code =  parse_xml(order_doc/'vendor_code') if (order_doc/'vendor_code').first
      purchase_order = Purchase::PurchaseOrder.find_by_ref_trans_no_and_trans_type(trans_no,'O')
      return  'Please Generate Purchase Order Before Shipping To Vendor','error' if !purchase_order
      order = Sales::SalesOrder.find_by_trans_no(trans_no)
      sales_order_shipping = Sales::SalesOrderShipping.find_by_id(id)
      return  'shipping not found','error' if !sales_order_shipping
      sales_order_transaction_activities = Sales::SalesOrderTransactionActivity.find_by_sql ["select * from sales_order_transaction_activities where sales_order_id = ? and sales_order_stage_code like ?",order.id,'SHIPPING LABEL PRINTED FOR VENDOR SHIPMENT TRACKING'+'%']
      return 'Please generate Shipping Labels for all packages before shipment.','error' if !sales_order_transaction_activities[0]
      #      return 'Please generate Shipping Labels for all packages before shipment.','error' if !sales_order_shipping.tracking_no || sales_order_shipping.tracking_no == ''
      sales_order_shipping.ship_to_vendor_flag = 'Y'
      sales_order_shipping.vendor_id = vendor_id
      sales_order_shipping.vendor_code = vendor_code
      order.order_status = SHIPPED_TO_VENDOR
      order.shipping_status = 'ORDER SHIPPED TO VENDOR'
      workflow_location = Sales::CurrentLocationLogic.find_order_location(order,order.order_status,order.artwork_status)
      order.workflow_location = workflow_location
      order.create_sales_order_transaction_activity('ORDER SHIPPED TO VENDOR')
      email = Email::Email.send_email('ORDERSHIPPEDTOVENDOR',order)
      save_proc = Proc.new{
        order.save!
        sales_order_shipping.save!
        email.save!
      }
      order.save_transaction(&save_proc)
      return 'Order Shipped Successfully','success'
    rescue Exception => ex
      return ex,'error'
    end
  end

  def self.print_ups_label_for_vendor_shipping(order_doc,schema_name)
    begin
      #      shipping_id = parse_xml(doc/:params/'id')
      company_id = parse_xml(order_doc/:params/'company_id')
      carton_length = parse_xml(order_doc/:params/'carton_length')
      carton_width = parse_xml(order_doc/:params/'carton_width')
      carton_height = parse_xml(order_doc/:params/'carton_height')
      carton_wt = parse_xml(order_doc/:params/'carton_weight')
      vendor_id = parse_xml(order_doc/:params/'vendor_id')
      #      shipping = Sales::SalesOrderShipping.find_by_id(shipping_id)
      #      order = Sales::SalesOrder.find_by_id(shipping.sales_order_id)
      company = Setup::Company.find_by_id(company_id)
      vendor = Vendor::Vendor.find_by_id(vendor_id)
      @config = YAML::load(File.open("#{Rails.root}/config/settings.yml"))
      ups_license_number = @config["ups_license_number"]
      ups_user_id = @config["ups_user_id"]
      ups_password = @config["ups_password"]
      ups_shipper_number = @config["ups_shipper_number"]
      url = 'https://wwwcie.ups.com/ups.app/xml/ShipConfirm'
      ##url = 'https://onlinetools.ups.com/ups.app/xml/ShipConfirm'
      uri = URI.parse url
      http = Net::HTTP.new uri.host, uri.port
      if uri.port == 443
        http.use_ssl	= true
        http.verify_mode = OpenSSL::SSL::VERIFY_NONE
      end
      xml_req = "<?xml version='1.0'?>
                  <AccessRequest xml:lang='en-US'>
                    <AccessLicenseNumber>#{ups_license_number}</AccessLicenseNumber>
                    <UserId>#{ups_user_id}</UserId>
                    <Password>#{ups_password}</Password>
                  </AccessRequest>

                  <?xml version='1.0'?>
                  <ShipmentConfirmRequest xml:lang='en-US'>
                    <Request>
                      <TransactionReference>
                        <CustomerContext>Customer Comment</CustomerContext>
                        <XpciVersion/>
                      </TransactionReference>
                      <RequestAction>ShipConfirm</RequestAction>
                      <RequestOption>validate</RequestOption>
                    </Request>
                    <LabelSpecification>
                      <LabelPrintMethod>
                        <Code>GIF</Code>
                        <Description>gif file</Description>
                      </LabelPrintMethod>
                      <HTTPUserAgent>Mozilla/4.5</HTTPUserAgent>
                      <LabelImageFormat>
                        <Code>GIF</Code>
                        <Description>gif</Description>
                      </LabelImageFormat>
                    </LabelSpecification>
                    <Shipment>
                     <RateInformation>
                        <NegotiatedRatesIndicator/>
                      </RateInformation>
                    <Description/>
                      <Shipper>
                        <Name>#{company.name}</Name>
                        <PhoneNumber>#{company.phone}</PhoneNumber>
                        <ShipperNumber>#{ups_shipper_number}</ShipperNumber>
                        <Address>
                        <AddressLine1>#{company.address1},#{company.address2}</AddressLine1>
                        <City>#{company.city}</City>
                        <StateProvinceCode>#{company.state}</StateProvinceCode>
                        <PostalCode>#{company.zip}</PostalCode>
                        <PostcodeExtendedLow></PostcodeExtendedLow>
                        <CountryCode>#{company.country}</CountryCode>
                       </Address>
                      </Shipper>
                    <ShipTo>
                        <CompanyName>#{vendor.first_name}</CompanyName>
                        <AttentionName>#{vendor.name}</AttentionName>
                        <PhoneNumber>#{vendor.phone}</PhoneNumber>
                        <Address>
                          <AddressLine1>#{vendor.address1}</AddressLine1>
                          <City>#{vendor.city}</City>
                          <StateProvinceCode>#{vendor.state}</StateProvinceCode>
                          <PostalCode>#{vendor.zip}</PostalCode>
                          <CountryCode>#{vendor.country}</CountryCode>
                        </Address>
                      </ShipTo>
                      <ShipFrom>
                        <CompanyName>#{company.name}</CompanyName>
                        <AttentionName>#{company.name}</AttentionName>
                        <PhoneNumber>#{company.phone}</PhoneNumber>
                      <TaxIdentificationNumber></TaxIdentificationNumber>
                        <Address>
                          <AddressLine1>#{company.address1},#{company.address2}</AddressLine1>
                          <City>#{company.city}</City>
                        <StateProvinceCode>#{company.state}</StateProvinceCode>
                        <PostalCode>#{company.zip}</PostalCode>
                        <CountryCode>#{company.country}</CountryCode>
                        </Address>
                      </ShipFrom>
                       <PaymentInformation>
                        <Prepaid>
                          <BillShipper>
                            <AccountNumber>#{ups_shipper_number}</AccountNumber>
                          </BillShipper>
                        </Prepaid>
                      </PaymentInformation>
                      <Service>
                        <Code>03</Code>
                        <Description></Description>
                      </Service>

            <Package>
                <ReferenceNumber>
                  <Code>02</Code>
                  <Value></Value>
                </ReferenceNumber>
                <ReferenceNumber>
                  <Code>02</Code>
                  <Value></Value>
                </ReferenceNumber>

                <PackageServiceOptions>
                  <InsuredValue>
                    <CurrencyCode>USD</CurrencyCode>
                    <MonetaryValue>1000</MonetaryValue>
                  </InsuredValue>
                </PackageServiceOptions>
                <PackagingType>
                  <Code>00</Code>
                  <Description></Description>
                </PackagingType>
                  <Description>Rate</Description>
                <PackageWeight>
                  <UnitOfMeasurement>
                    <Code>LBS</Code>
                  </UnitOfMeasurement>
                  <Weight>#{carton_wt}</Weight>
                </PackageWeight>
                <Dimensions>
                  <UnitOfMeasurement>
                    <Code>IN</Code>
                  </UnitOfMeasurement>
                  <Length>#{carton_length}</Length>
                  <Width>#{carton_width}</Width>
                  <Height>#{carton_height}</Height>
                </Dimensions>
              </Package>

                    </Shipment>
                  </ShipmentConfirmRequest>"
      @response_plain = http.post(uri.path, xml_req).body
      doc = Hpricot::XML(@response_plain)
      error_code = parse_xml(doc/:ShipmentConfirmResponse/:Response/'ResponseStatusCode')
      error_description = parse_xml(doc/:ShipmentConfirmResponse/:Response/'ErrorDescription')
      return error_description,'error' if error_code.to_i == 0
      digest = (doc/:ShipmentConfirmResponse/:ShipmentDigest).first.innerHTML
      #    url = 'https://onlinetools.ups.com/ups.app/xml/ShipAccept'
      url = 'https://wwwcie.ups.com/ups.app/xml/ShipAccept'
      uri = URI.parse url
      http = Net::HTTP.new uri.host, uri.port
      if uri.port == 443
        http.use_ssl	= true
        http.verify_mode = OpenSSL::SSL::VERIFY_NONE
      end

      @data = %{<?xml version='1.0'?>
                <AccessRequest xml:lang='en-US'>
                  <AccessLicenseNumber>#{ups_license_number}</AccessLicenseNumber>
                  <UserId>#{ups_user_id}</UserId>
                  <Password>#{ups_password}</Password>
                </AccessRequest>
                <?xml version='1.0'?>
                <ShipmentAcceptRequest>
                <Request>
                <TransactionReference>
                <CustomerContext>guidlikesubstance</CustomerContext>
                <XpciVersion>1.0001</XpciVersion>
                </TransactionReference>
                <RequestAction>ShipAccept</RequestAction>
                </Request>
                <ShipmentDigest>#{digest}</ShipmentDigest>
                </ShipmentAcceptRequest>}
      path = Setup::Type.find(:first, :conditions=>['type_cd = ? and subtype_cd = ?','UPLOAD_FOLDER','UPS_LABEL'])
      if path
        directory =  "#{Dir.getwd}" + '/'+ path.value + schema_name
      end
      FileUtils.mkdir_p(File.dirname(directory+'/'+'testfile'))
      @response_plain = http.post(uri.path, @data).body
      doc = Hpricot::XML(@response_plain)
      tracking_no_array = []
      (doc/:ShipmentAcceptResponse/:ShipmentResults/:PackageResults/:TrackingNumber).each{|tracking_no|
        tracking_no_array << tracking_no.innerHTML
      }
      tracking_count = 0
      (doc/:ShipmentAcceptResponse/:ShipmentResults/:PackageResults/:LabelImage).each{|label|
        graphic_image = (label/:GraphicImage).first.innerHTML
        html_code = (label/:HTMLImage).first.innerHTML
        File.open("#{directory}/label"+tracking_no_array[tracking_count]+".gif", 'wb') do|f|
          f.write(Base64.decode64(graphic_image))
        end
        File.open("#{directory}/#{tracking_no_array[tracking_count]}.html", 'wb') do|f|
          f.write(Base64.decode64(html_code))
        end
        tracking_count = tracking_count + 1
      }
      #      shipping.update_attributes!(:tracking_no => tracking_no_array[0]) removed on 6 july by amit pandey as taylor said
      (order_doc/:params/:sales_orders/:sales_order).each{|sales_order|
        trans_no = parse_xml(sales_order/'trans_no')
        order = Sales::SalesOrder.find_by_trans_no(trans_no)
        activity_message = Artwork::ArtworkCrud.create_activity_message(order,"SHIPPING LABEL PRINTED FOR VENDOR SHIPMENT TRACKING - #{tracking_no_array[0]}")
        activity = order.create_sales_order_transaction_activity(activity_message)
        activity.save!
      }
      return "#{tracking_no_array[0]}.html",'success'
    rescue Exception => ex
      return ex,'error'
    end
  end

  ## called from link button on sales_orders screen
  def self.send_package_tracking_info(order_id)
    begin
      sales_order = Sales::SalesOrder.find_by_id(order_id)
      sales_order.sales_order_shippings.each{|sales_order_shipping|
        email = Email::Email.send_email('ORDERSHIPPEDCOMPLETLY',sales_order_shipping)
        email.save!
      }
      return 'Tracking Information Sent Successfully'
    rescue Exception => ex
      return ex
    end
  end

  def self.get_ship_from_address(catalog_item_id,company_id)
    catalog_item = Item::CatalogItem.find_by_id(catalog_item_id) if catalog_item_id != ''
    if catalog_item
      if catalog_item.default_shipper == SHIP_FROM_COMPANY
        company = Setup::Company.find_by_id(catalog_item.default_shipper_id)
        return company.name,company.address1,company.address2,company.city,company.state,company.zip,company.phone,company.country
      else
        vendor = Vendor::Vendor.find_by_id(catalog_item.default_shipper_id)
        return vendor.name,vendor.address1,vendor.address2,vendor.city,vendor.state,vendor.zip,vendor.phone,vendor.country
      end
    else
      company = Setup::Company.find_by_id(company_id)
      return company.name,company.address1,company.address2,company.city,company.state,company.zip,company.phone,company.country
    end
  end

  def self.fetch_multioptions(trans_no)
    Sales::SalesOrder.find_by_sql ["select CAST((select(
           select soamv.value,soamv.qty, soamv.ship_qty as clear_qty,soamv.qty - soamv.ship_qty as ship_qty,soamv.damaged_qty
           from sales_orders so
           inner join sales_order_attributes_values soav on soav.sales_order_id = so.id
           inner join sales_order_attributes_multiple_values soamv on soamv.sales_order_attributes_value_id = soav.id
           where soav.trans_flag = 'A' and soamv.trans_flag = 'A' and soamv.qty != 0 and soamv.qty > soamv.ship_qty
           and so.trans_no = #{trans_no}
           FOR XML PATH('sales_order'), TYPE,ELEMENTS XSINIL
           )FOR XML PATH('sales_orders')) AS varchar(MAX)) as xmlcol"
    ]
  end
end
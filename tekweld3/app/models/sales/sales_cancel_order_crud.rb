class Sales::SalesCancelOrderCrud
  include General
  #  Trans Type Codes
  #  S	Regular Order
  #  E	Re-Order
  #  P	Sample Order
  #  V	Virtual Order
  #  F	Spec Order

  ## Tekweld PickOrder Services ##
  def self.list_orders_to_cancel(doc)
    criteria = Setup::Criteria.fill_criteria(doc/:criteria)
    condition = "( sales_orders.company_id = #{criteria.company_id}) AND
                     (sales_orders.customer_code between '#{criteria.str1}' and '#{criteria.str2}' AND (0 =#{criteria.multiselect1.length} or sales_orders.customer_code in ('#{criteria.multiselect1}'))) AND
                     (trans_no between '#{criteria.str3}' and '#{criteria.str4}' AND (0 =#{criteria.multiselect2.length} or trans_no in ('#{criteria.multiselect2}'))) AND
                     (trans_date between '#{criteria.dt1}' and '#{criteria.dt2}' ) AND
                     (account_period_code between '#{criteria.str5[0,8]}' and '#{criteria.str6[0,8]}' AND (0 =#{criteria.multiselect3.length} or account_period_code in ('#{criteria.multiselect3}')))  AND
                     (logo_name between '#{criteria.str7}' and '#{criteria.str8}' AND (0 =#{criteria.multiselect4.length} or logo_name in ('#{criteria.multiselect4}')))  AND
                     (ext_ref_no between '#{criteria.str9}' and '#{criteria.str10}' AND (0 =#{criteria.multiselect5.length} or ext_ref_no in ('#{criteria.multiselect5}')))
                     AND sales_orders.trans_flag = 'A' AND sales_orders.ordercancelstatus_flag = 'N' AND (sales_orders.invoiced_flag = 'N' or sales_orders.payment_capture_flag = 'N')
                     AND sales_orders.trans_type in ('S','E','P','V') and  sos.trans_flag = 'A' and sos.shipping_flag = 'N'"
    Sales::SalesOrder.find_by_sql ["select CAST((
                                  select(select distinct sales_orders.id,
                                                sales_orders.ext_ref_no,
                                                sales_orders.trans_no,
                                                sales_orders.trans_date,
                                                sales_orders.ship_date,
                                                sales_orders.customer_code,
                                                sales_orders.customer_contact,
                                                sales_orders.customer_phone,
                                                sales_orders.salesperson_code,
                                                sales_orders.externalsalesperson_code,
                                                sales_orders.logo_name,
                                                sales_orders.order_status,
                                                sales_orders.shipping_status,
                                                sales_orders.artwork_status,
                                                sales_orders.paper_proof_status,
                                                sales_orders.acknowledgment_status,
                                                sales_orders.accounting_status,
                                                sales_orders.rushorder_flag,
                                                sales_orders.cancel_order_reason,
                                                types.description as order_type
                                  from sales_orders
                                  inner join sales_order_shippings sos on sos.sales_order_id = sales_orders.id
                                  left outer join types on (
                                        types.type_cd = 'trans_type'
                                        and types.subtype_cd = 'so'
                                        and sales_orders.trans_type = types.value
                                       )
                                  where #{condition}
                                  FOR XML PATH('sales_order'), TYPE,ELEMENTS XSINIL
                                  )FOR XML PATH('sales_orders')) AS varchar(MAX)) as xmlcol"
    ]
  end
  
  def self.create_cancel_orders(doc)
    sales_orders = [] 
    (doc/:sales_orders/:sales_order).each{|order_doc|
      sales_order = create_cancel_order(order_doc)
      sales_orders <<  sales_order if sales_order
    }
    sales_orders
  end
  
  def self.create_cancel_order(order_doc)
    begin
      shippings = []
      trans_no =  parse_xml(order_doc/'trans_no') if (order_doc/'trans_no').first
      cancel_order_reason =  parse_xml(order_doc/'cancel_order_reason') if (order_doc/'cancel_order_reason').first
      order = Sales::SalesOrder.find_by_trans_no(trans_no)
      return  if !order
      if order.artworkapprovedbycust_flag == 'A'
        if(order.accountreviewed_flag == 'N' and order.term_code == 'CC')
          order.errors[:base] << 'Payment For The Order Is Not Authorized. Please Authorize Payment And Then Proceed To Cancel Order'
          return order
        elsif(order.accountreviewed_flag == 'N' and order.term_code != 'CC')
          order.errors[:base] << 'Accounting For The Order Is Not Approved . Please Approve Accounts And Then Proceed To Cancel Order'
          return order
        end
        order.tax_amt = (order.tax_amt)/2 ; order.discount_amt = (order.discount_amt)/2
        order.other_amt = (order.other_amt)/2 ; order.ship_amt = (order.ship_amt)/2
        order.insurance_amt = (order.insurance_amt)/2 ; order.salt = ''
        item_amt = 0.00
        order.sales_order_lines.each{|line|
          if(line.trans_flag == 'A')
            line.item_price = (line.item_price)/2 ; line.item_amt = (line.item_amt)/2
            line.net_amt = (line.net_amt)/2 ; line.discount_amt = (line.discount_amt)/2
            item_amt = item_amt + line.item_amt
          end
        }
        order.item_amt = item_amt ; order.net_amt = order.item_amt + order.ship_amt
        order.sales_order_shippings.each{|shipping|
          if(shipping.trans_flag == 'A')
            shipping.ship_amt = (shipping.ship_amt)/2 ; shipping.clear_ship_amt = (shipping.clear_ship_amt)/2 ; shipping.current_ship_amt = (shipping.current_ship_amt)/2
            shippings << shipping
          end
        }
      end
      save_proc = Proc.new{
        order.ordercancelstatus_flag = 'Y'
        order.sales_order_lines.each{|line| line.save!}
        order.sales_order_shippings.each{|shipping| shipping.save! }
        order.save!
        if order.artworkapprovedbycust_flag == 'A'
          sales_order,invoice,inv_text,receipt,rec_text,emails,payment_transaction,payment_text = Shipping::ShippingCrud.generate_invoice_and_receipt(shippings[0],order,order.item_qty,order.multi_description,'')
          if(inv_text == 'error' || rec_text =='error' || payment_text =='error'||!sales_order.errors[:base].empty?)
            order.errors[:base] <<  invoice.errors[:base][0] if(inv_text == 'error')
            order.errors[:base] <<  receipt.errors[:base][0] if(rec_text =='error')
            order.errors[:base] <<  payment_transaction.errors[:base][0] if(payment_text =='error')
            order.errors[:base] <<  sales_order.errors[:base][0] if !sales_order.errors[:base].empty?
            raise ActiveRecord::Rollback
          else
            sales_order.cancel_date = Time.now; sales_order.order_status = ORDER_CANCELLED;
            sales_order.update_flag = 'V'
            sales_order.workflow_location = 'ORDER CLOSED'; sales_order.cancel_order_reason = cancel_order_reason;
            sales_order.create_sales_order_transaction_activity(ORDER_CANCELLED)
            workflow_location = Sales::CurrentLocationLogic.find_order_location(sales_order,sales_order.order_status,sales_order.artwork_status)
            sales_order.workflow_location = workflow_location
            sales_order.save!
            emails.each{|email| email.save!}
            payment_transaction.save! if payment_transaction
          end
        else
          order.cancel_date = Time.now; order.order_status = ORDER_CANCELLED;
          order.update_flag = 'V'
          order.workflow_location = 'ORDER CLOSED'; order.cancel_order_reason = cancel_order_reason;
          order.create_sales_order_transaction_activity(ORDER_CANCELLED)
          workflow_location = Sales::CurrentLocationLogic.find_order_location(order,order.order_status,order.artwork_status)
          order.workflow_location = workflow_location
          order.save!
        end
      }
      if(order.errors.empty?)
        order.save_transaction(&save_proc)
      end
    rescue Exception => ex
      order.errors[:base] << ex
      return order
    end
    return order
  end
  
  ## Tekweld PickOrder Services ##
  def self.list_cancelled_orders(doc)
    criteria = Setup::Criteria.fill_criteria(doc/:criteria)
    condition = "( sales_orders.company_id = ?) AND
                     (customers.code between ? and ? AND (0 =? or customers.code in (?))) AND
                     (trans_no between ? and ? AND (0 =? or trans_no in (?))) AND
                     (trans_date between ? and ? ) AND
                     (account_period_code between ? and ? AND (0 =? or account_period_code in (?)))
                     AND (logo_name between ? and ? AND (0 =? or logo_name in (?)))
                     AND (ext_ref_no between ? and ? AND (0 =? or ext_ref_no in (?)))
                     AND sales_orders.trans_flag = 'A' AND sales_orders.ordercancelstatus_flag = 'Y'
                     AND sales_orders.trans_type in ('S','E','P','V')"
    Sales::SalesOrder.find_by_sql ["select CAST((
                                  select(select sales_orders.*,types.description as order_type,customers.code as customer_code
                                  from sales_orders
                                  inner join customers on customers.id = sales_orders.customer_id
                                  left outer join types on (
                                        types.type_cd = 'trans_type'
                                        and types.subtype_cd = 'so'
                                        and sales_orders.trans_type = types.value 
                                       )
                                  where #{condition}
                                  order by sales_orders.ship_date 
                                   FOR XML PATH('sales_order'), TYPE,ELEMENTS XSINIL
                                  )FOR XML PATH('sales_orders')) AS varchar(MAX)) as xmlcol",
      criteria.company_id,
      criteria.str1,criteria.str2,criteria.multiselect1.length,criteria.multiselect1,
      criteria.str3,criteria.str4,criteria.multiselect2.length,criteria.multiselect2,
      criteria.dt1,criteria.dt2,
      criteria.str5[0,8],criteria.str6[0,8],criteria.multiselect3.length,criteria.multiselect3,
      criteria.str7,criteria.str8,criteria.multiselect4.length,criteria.multiselect4,
      criteria.str9,criteria.str10,criteria.multiselect5.length,criteria.multiselect5
    ]
  end
end
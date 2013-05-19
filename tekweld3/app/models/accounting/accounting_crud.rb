class Accounting::AccountingCrud
  include General
  #  Trans Type Codes
  #  S	Regular Order
  #  E	Re-Order
  #  P	Sample Order
  #  V	Virtual Order
  #  F	Spec Order
  #  customers class_name is set as accounting status in orders screen.for new customer class_name is always CREDIT CARD   
  #  when accounts are reviewed then status is set as CLEAR and accountreviewed_flag = Y.
  ############################# Tekweld Services ###################################
  #AND((sales_orders.term_code = 'CC' AND sales_orders.id <> customer_payment_transactions.sales_order_id)
  #     OR(sales_orders.term_code <> 'CC' AND customers.credit_limit < sales_orders.net_amt) )
  #List Uncleared Accounts of customers in sales_order
  def self.list_uncleared_accounts_inbox(doc)
    criteria = Setup::Criteria.fill_criteria_for_query(doc/:criteria)
    condition = "( sales_orders.company_id = #{criteria.company_id}) AND
                     (customers.code between '#{criteria.str1}' and '#{criteria.str2}' AND (0 =#{criteria.multiselect1.length} or customers.code in ('#{criteria.multiselect1}'))) AND
                     (trans_no between '#{criteria.str3}' and '#{criteria.str4}' AND (0 =#{criteria.multiselect2.length} or trans_no in ('#{criteria.multiselect2}'))) AND
                     (trans_date between '#{criteria.dt1}' and '#{criteria.dt2}' ) AND
                     (account_period_code between '#{criteria.str5[0,8]}' and '#{criteria.str6[0,8]}' AND (0 =#{criteria.multiselect3.length} or account_period_code in ('#{criteria.multiselect3}'))) AND
                     (logo_name between '#{criteria.str7}' and '#{criteria.str8}' AND (0 =#{criteria.multiselect4.length} or logo_name in ('#{criteria.multiselect4}'))) AND
                     (ext_ref_no between '#{criteria.str9}' and '#{criteria.str10}' AND (0 =#{criteria.multiselect5.length} or ext_ref_no in ('#{criteria.multiselect5}')))
                     AND sales_orders.trans_flag = 'A' AND ((sales_orders.orderqcstatus_flag = 'Y' AND sales_orders.qc_off_flag = 'N')
                     OR (sales_orders.orderqcstatus_flag = 'N' AND sales_orders.qc_off_flag = 'Y'))
                     AND sales_orders.orderentrycomplete_flag = 'Y'
                     AND (sales_orders.accountreviewed_flag = 'N' AND sales_orders.accounting_status <> 'CLEAR' )
                     AND sales_orders.trans_type in ('S','E','P','F') AND sales_orders.sub_ref_type <> 'S'"
    Sales::SalesOrder.find_by_sql ["select CAST((
                                  select(select distinct sales_orders.*,types.description as order_type,
                                  (select (SUM(inv_amt)- SUM(paid_amt)) from customer_invoices where sales_orders.customer_id = customer_invoices.customer_id) as current_balance ,
                                  (select SUM(inv_amt) from customer_invoices where sales_orders.customer_id = customer_invoices.customer_id) as total_sales
                                  from sales_orders
                                  inner join customers on customers.id = sales_orders.customer_id
                                  left outer join customer_payment_transactions on customer_payment_transactions.sales_order_id = sales_orders.id
                                  left outer join types on (
                                        types.type_cd = 'trans_type'
                                        and types.subtype_cd = 'so'
                                        and sales_orders.trans_type = types.value
                                       )
                                  where #{condition}
                                  order by sales_orders.ship_date desc
                                   FOR XML PATH('sales_order'), TYPE,ELEMENTS XSINIL
                                  )FOR XML PATH('sales_orders')) AS varchar(MAX)) as xmlcol"
    ]
  end

  def self.create_accounts_inboxes(doc)
    orders = []
    (doc/:sales_orders/:sales_order).each{|order_doc|
      order = create_accounts_inbox(order_doc)
      orders <<  order if order
    }
    orders
  end

  def self.create_accounts_inbox(doc)
    id =  parse_xml(doc/'id') if (doc/'id').first
    #    accountreviewed_flag =  parse_xml(doc/'accountreviewed_flag') if (doc/'accountreviewed_flag').first    
    order = Sales::SalesOrder.find_by_id(id)
    return if !order
    save_proc = Proc.new{
      if order.term_code != 'CC'
        order.accounting_status = 'CLEAR'; order.accountreviewed_flag = 'Y' ; order.payment_status = 'CREDIT AUTHORIZED'
      else
        order.accounting_status = 'CLEAR'; order.accountreviewed_flag = 'Y' ; order.payment_status = 'CC AUTHORIZED'
      end
      order.workflow_location = 'SHIPPING INBOX' if order.trans_type == TRANS_TYPE_SAMPLE_ORDER
      order.create_sales_order_transaction_activity('CLEARED FROM ACCOUNTS DEPT')
      order.save!
    }
    if order.term_code == 'CC'
      #      payment = Payment::CustomerPaymentTransaction.find_by_sales_order_id_and_customer_id_and_response_code_and_payment_release_flag(order.id,order.customer_id,1,'N')
      if order.payment_authorize_flag == 'N'
        #        return order.errors[:base] << "Customer Payment Not Authorized"
        return order.add_error('Customer Payment Not Authorized')
      else
        order.save_transaction(&save_proc)
      end
    else
      customer = Customer::Customer.find_by_id(order.customer_id)
      pending_amount = Sales::SalesOrderCrud.get_orders_pending_amount(order.customer_id)
      credit_limit = fetch_customer_daily_credit_limit(customer)
      if (credit_limit < pending_amount)
        #        return order.errors[:base] << "Order Amount is above Customers Credit Limit"
        return order.add_error('Pending Amount is above Customers Credit Limit')
      else
        order.save_transaction(&save_proc)
      end
    end   
    return order
  end

  def self.fetch_customer_daily_credit_limit(customer)
    daily_credit_limit = Customer::CustomerDailyCreditLimit.find_by_sql ["select * from customer_daily_credit_limits where trans_flag = 'A' and customer_id = #{customer.id} and DATEDIFF(day,credit_limit_date,GETDATE()) = 0"]
    if daily_credit_limit[0]
      credit_limit = nulltozero(daily_credit_limit[0].credit_limit)
      return credit_limit
    else
      credit_limit = nulltozero(customer.credit_limit)
      return credit_limit
    end
  end

  def self.check_accounting(order)
    if order.term_code == 'CC'
      #      payment = Payment::CustomerPaymentTransaction.find_by_sales_order_id_and_customer_id_and_response_code(order.id,order.customer_id,1)
      if order.payment_authorize_flag != 'Y'
        return 'Customer Payment Not Authorized'
      else
        return 'success'
      end
    else
      customer = Customer::Customer.find_by_id(order.customer_id)
      pending_amount = Sales::SalesOrderCrud.get_orders_pending_amount(order.customer_id)
      credit_limit = Accounting::AccountingCrud.fetch_customer_daily_credit_limit(customer)
      if (credit_limit < pending_amount)
        return 'Pending Amount is above Customers Credit Limit'
      else
        return 'success'
      end
    end
  end
end

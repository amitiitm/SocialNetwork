class PromoCustomer::PromoCustomerCrud
  include General
  #  Trans Type Codes
  #  S	Regular Order
  #  E	Re-Order
  #  P	Sample Order
  #  V	Virtual Order
  #  F	Spec Order

  ## This service will work for both open and history order based on order_type = O/H
  def self.list_open_and_history_orders(doc)
    customer_id = parse_xml(doc/'customer_id')
    order_type = parse_xml(doc/'order_type')
    if order_type == 'H'
      condition = "so.trans_flag = 'A' and so.shipped_flag = 'Y' and so.trans_type in ('S','E','F') and so.ordercancelstatus_flag <> 'Y'and users.id = #{customer_id}"
    else
      condition = "so.trans_flag = 'A' and so.shipped_flag = 'N' and so.trans_type in ('S','E','F') and so.ordercancelstatus_flag <> 'Y' and users.id = #{customer_id}"
    end
    Sales::SalesOrder.find_by_sql ["select CAST((
                                  select(select so.id,so.ext_ref_no,CONVERT(VARCHAR(10),so.ext_ref_date,110) as ext_ref_date,so.trans_no,
                                  CONVERT(VARCHAR(10),so.trans_date,110) as trans_date,so.order_status,so.artwork_status,
                                  so.acknowledgment_status,so.payment_status,so.accounting_status,so.paper_proof_status,so.shipping_status,
                                  so.net_amt
                                  from sales_orders so
                                  inner join customers on customers.id = so.customer_id
                                  INNER JOIN users ON users.type_id = customers.id
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

  def self.show_order(order_id)
    Sales::SalesOrder.where(:id => order_id)
  end

  def self.update_shipping_info(doc)
    id =  parse_xml(doc/'id') if (doc/'id').first
    sales_order_shippings = []
    sales_order_shipping = Sales::SalesOrderShipping.find(id)
    if !sales_order_shipping
      sales_order_shipping.errors[:base] << 'Shipping No More Exists'
    end
    sales_order_shipping.apply_attributes(doc/:sales_order_shippings/:sales_order_shipping)
    #    sales_order_shipping.internal_inhand_date = parse_xml(doc/'estimated_arrival_date') if (doc/'estimated_arrival_date').first if sales_order_shipping.ship_date.blank?
    save_proc = Proc.new{
      sales_order_shipping.save!
    }
    if(sales_order_shipping.errors.empty?)
      sales_order_shipping.save_transaction(&save_proc)
    end
    sales_order_shippings << sales_order_shipping
    sales_order_shippings
  end
end
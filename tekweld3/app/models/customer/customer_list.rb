class Customer::CustomerList
  #  include ContentModelMethods
  #  include ClassMethods
  include General
  
  def self.list(doc)
    criteria = Setup::Criteria.fill_criteria(doc/:criteria)
    condition = "customers.code between ? and ? AND
                                      customers.name between ? and ? AND
                                      (nvl(billto_id,customers.id) in (select id from customers
                                                    where code between ? and ?) or billto_id = 0) AND
                                      customer_categories.code between ? and ? AND
                                      nvl(price_level,'') between ? and ? AND
                                      (nvl(salespeople.code,'') between ? and ?  or salesperson_id = 0) AND
                                      customers.trans_flag between  ? and ?                
    "
    condition = convert_sql_to_db_specific(condition)
    customer = Customer::Customer.find(:all, :joins => " inner join customer_categories on (customers.customer_category_id = customer_categories.id)
                                           left outer join salespeople on (customers.salesperson_id = salespeople.id )
                                           left outer join shippings on (customers.shipping_id = shippings.id)
      ",
      :conditions =>  [condition ,criteria.str1,criteria.str2, 
        criteria.str3,criteria.str4,
        criteria.str5,criteria.str6,
        criteria.str7,criteria.str8 ,
        criteria.str9[0,1], criteria.str10[0,1],
        criteria.str11,criteria.str12,
        criteria.str13[0,1], criteria.str14[0,1] ],
      :select => "customers.*,customer_categories.code as customer_category_code, shippings.code as shipping_code,
                                 salespeople.code as salesperson_code"              )

  
    customer
  end
  
  def self.list_customer_shippings(customer_id)
    customer = Customer::Customer.find(customer_id) 
    customer.customer_shippings if customer
  end
  
  def self.list_customer_notes(customer_id)
    customer = Customer::Customer.find(customer_id)
    customer.customer_notes if customer
  end
  
  def self.list_customer_jbtrankings(customer_id)
    customer = Customer::Customer.find(customer_id) 
    customer.customer_jbtrankings if customer 
  end

  def self.show_customer_shipping(shipping_id)
    shippings = Customer::CustomerShipping.find_all_by_id(shipping_id) 
    shippings
  end
  def self.list_customer_specific_shipping(customer_id)
    shippings = Customer::CustomerShipping.find_by_sql ["select * from customer_shippings where customer_id = #{customer_id}"]
    shippings
  end
end

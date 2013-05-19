class Customer::CustomerDailyCreditLimitCrud
  include General

  def self.list_customer_daily_credit_limits(doc)
    criteria = Setup::Criteria.fill_criteria_for_query(doc/:criteria)
    condition = "trans_flag = 'A' 
             AND (credit_limit_date between '#{criteria.dt1}' and '#{criteria.dt2}')
             AND (credit_limit between #{criteria.dec1} and #{criteria.dec2})"
    condition = convert_sql_to_db_specific(condition)
    Customer::CustomerDailyCreditLimit.find_by_sql ["select CAST((
                                  select(select *
                                  from customer_daily_credit_limits
                                  where #{condition}
                                  FOR XML PATH('customer'), TYPE,ELEMENTS XSINIL
                                  )FOR XML PATH('customers')) AS varchar(MAX)) as xmlcol "
    ]
  end

  def self.show_customer_daily_credit_limit (customer_id)
    Customer::CustomerDailyCreditLimit.find_all_by_id(customer_id)
  end

  def self.create_customer_daily_credit_limits(doc)
    customer_daily_credit_limits = []
    (doc/:customer_daily_credit_limits/:customer_daily_credit_limit).each{|credit_doc|
      customer_daily_credit_limit = create_customer_daily_credit_limit(credit_doc)
      customer_daily_credit_limits <<  customer_daily_credit_limit if customer_daily_credit_limit
    }
    customer_daily_credit_limits
  end

  def self.create_customer_daily_credit_limit(credit_doc)
    credit_limit = add_or_modify_customer_daily_credit_limit(credit_doc)
    return  if !credit_limit
    save_proc = Proc.new{
      credit_limit.save!
    }
    credit_limit.save_transaction(&save_proc)
    return credit_limit
  end

  def self.add_or_modify_customer_daily_credit_limit(credit_doc)
    id =  parse_xml(credit_doc/'id') if (credit_doc/'id').first
    credit_limit = Customer::CustomerDailyCreditLimit.find_or_create(id)
    return if !credit_limit
    credit_limit.apply_attributes(credit_doc)
    return credit_limit
  end
end
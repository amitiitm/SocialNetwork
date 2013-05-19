
class Customer::CustomerCrud
  include General
  
  def self.list_customers(doc)
    criteria = Setup::Criteria.fill_criteria_for_query(doc/:criteria)
    var1 = Customer::Customer.find_by_sql ["select value from types where type_cd = 'master_access' and subtype_cd = 'customer'"]
    condition = "(customers.company_id in (select company_id from user_companies where user_id = #{criteria.user_id}) OR ascii('All') = ascii('#{var1.first.value}')) AND
                (customers.code between '#{criteria.str1}' and '#{criteria.str2}' AND (0 =#{criteria.multiselect1.length} or customers.code in ('#{criteria.multiselect1}'))) AND
                (customers.name between '#{criteria.str3}' and '#{criteria.str4}' AND (0 =#{criteria.multiselect2.length} or customers.name in ('#{criteria.multiselect2}'))) AND
                (customers.customer_category_code between '#{criteria.str5}' and '#{criteria.str6}' AND (0 =#{criteria.multiselect3.length} or customers.customer_category_code in ('#{criteria.multiselect3}'))) AND
                (nvl(customers.price_level,'') between '#{criteria.str7}' and '#{criteria.str8}' AND (0 =#{criteria.multiselect4.length} or nvl(customers.price_level,'') in ('#{criteria.multiselect4}'))) AND
                (nvl(customers.salesperson_code,'') between '#{criteria.str9}' and '#{criteria.str10}'  AND (0 =#{criteria.multiselect5.length} or nvl(customers.salesperson_code,'') in ('#{criteria.multiselect5}')))
    "
    condition = convert_sql_to_db_specific(condition)
    Customer::Customer.find_by_sql ["select CAST(( 
                                  select(select customers.*,b.code as parent_code
                                  from customers
                                  inner join customers b on (customers.billto_id = b.id) 
                                  where #{condition}
                                  FOR XML PATH('customer'), TYPE,ELEMENTS XSINIL
                                  )FOR XML PATH('customers')) AS varchar(MAX)) as customers "
    ]
  end

  ## newly added on 29 july 2011 by amit
  def self.show_customer_by_code(customer_code)
    Customer::Customer.find_all_by_code(customer_code)
  end

  def self.show_customer(customer_id)
    customer=Customer::Customer.find_all_by_id(customer_id)  #.activecustomer removed by minal on 8jun
    return customer
  end


  def self.create_customers(doc)
    customers = []
    (doc/:customers/:customer).each{|customer_doc|
      customer = create_customer(customer_doc)
      customers <<  customer if customer
    }
    customers
  end

  def self.create_customer(doc)
    customer = add_or_modify(doc)
    customer.code = generate_customer_code(doc) if customer.new_record?
    type = Setup::Type.find_by_type_cd_and_subtype_cd('saoi','customer_profile')
    if (customer.new_record? and type.value == 'Y')
      begin
        customer_profile_code = create_cim_customer_profile(customer)
        customer.customer_profile_code = customer_profile_code
        customer.payment_gateway_code = 'AUTHORISE.NET'
      rescue Exception => ex
        return ex
      end
    end
    return  if !customer
    save_proc = Proc.new{
      if customer.new_record?
        customer.save!
      else
        customer.save!
        customer.save_lines
      end
    }
    customer.save_transaction(&save_proc)
    return customer
  end

  def self.add_or_modify(doc)
    id =  parse_xml(doc/'id') if (doc/'id').first
    customer = Customer::Customer.find_or_create(id)
    return if !customer
    customer.apply_attributes(doc)
    #  Add a block to set terms, shippings etc. from code
    customer.run_block do
      build_lines(doc/:customer_asirankings/:customer_asiranking)
      build_lines(doc/:notes/:note)
      build_lines(doc/:shippings/:shipping)
      build_lines(doc/:customer_salespeople/:customer_salesperson)
      build_lines(doc/:customer_relationships/:customer_relationship)
      build_lines(doc/:customer_wishlists/:customer_wishlist)
      build_lines(doc/:customer_item_pricings/:customer_item_pricing)
      build_lines(doc/:customer_contacts/:customer_contact)
      build_lines(doc/:customer_item_production_days/:customer_item_production_day)
    end
    return customer
  end

  def self.create_customer_profile(doc)
    customer_id =  parse_xml(doc/:params/'customer_id') if (doc/:params/'customer_id').first
    customer = Customer::Customer.find_by_id(customer_id)
    if (!customer.customer_profile_code || customer.customer_profile_code == '')
      begin
        customer_profile_code = create_cim_customer_profile(customer)
        customer.update_attributes!(:customer_profile_code => customer_profile_code,:payment_gateway_code => 'AUTHORISE.NET')
        return "Profile Created Successfully for #{customer.name}"
      rescue Exception => ex
        return ex
      end
    else
      return "Profile Already Exists for #{customer.name}"
    end
  end

  def self.create_cim_customer_profile(customer)
    @config = YAML::load(File.open("#{Rails.root}/config/settings.yml"))
    api_transaction_key = @config["api_transaction_key"]
    api_login_id = @config["api_login_id"]
    transaction = AuthorizeNet::CIM::Transaction.new(api_login_id,api_transaction_key,{:gateway => :test})
    profile = AuthorizeNet::CIM::CustomerProfile.new(
      :email => "#{customer.email}",
      :id => "#{customer.code}"
    )
    response = transaction.create_profile(profile)
    customer_profile_code = response.instance_variable_get(:@customer_profile_id)
    return customer_profile_code
  end

  def self.generate_customer_code(doc)
    company_id =  parse_xml(doc/'company_id') if (doc/'company_id').first
    name =  parse_xml(doc/'name') if (doc/'name').first
    last_name = name.split(" ")[1]
    code =  name.split(" ")[1] ? name.split(" ").first.first + last_name.slice(0,1) + last_name.slice(1,1) : name.slice(0,1) + name.slice(1,1) + name.slice(2,1)
    sequence_no = generate_docu_no('CU01','CUSTID',company_id)
    account_number = code.upcase + sequence_no if sequence_no
    Setup::Sequence.upd_book_code('CU01','CUSTID',sequence_no,company_id)
    return account_number
  end
  
  def self.generate_docu_no(book_code,docu_typ,company_id)
    begin
      if lno = Setup::Sequence.maximum(:book_lno, :conditions =>[ "book_cd =? and docu_typ = ? and company_id =? and trans_flag = 'A'",book_code, docu_typ,company_id])     
        lno =lno.to_i + 1
      end 
    rescue ActiveRecord::RecordNotFound  
      lno = nil
    end      
    lno.to_s
  end
  #customer category services
  def self.list_customer_categories(doc)
    criteria = Setup::Criteria.fill_criteria(doc/:criteria)
    Customer::CustomerCategory.find(:all)
  end

  def self.show_customer_category(customer_category_id)
    Customer::CustomerCategory.find_all_by_id(customer_category_id)
  end


  def self.create_customer_categories(doc)
    customer_categories = []
    (doc/:customer_categories/:customer_category).each{|customer_doc|
      customer_category = create_customer_category(customer_doc)
      customer_categories <<  customer_category if customer_category
    }
    customer_categories
  end

  def self.create_customer_category(doc)
    customer_category = add_or_modify_category(doc)
    return  if !customer_category
    save_proc = Proc.new{
      if customer_category.new_record?
        customer_category.save!
      else
        customer_category.save!
      end
    }
    customer_category.save_transaction(&save_proc)
    return customer_category
  end

  def self.add_or_modify_category(doc)
    id =  parse_xml(doc/'id') if (doc/'id').first
    customer_category = Customer::CustomerCategory.find_or_create(id)
    return if !customer_category
    customer_category.apply_attributes(doc)
    return customer_category
  end

  def self.create_customer_payment_profile(doc) ## not in use
    puts doc
    credit_card_no =  parse_xml(doc/:params/'credit_card_no') if (doc/:params/'credit_card_no').first
    card_type =  parse_xml(doc/:params/'card_type') if (doc/:params/'card_type').first
    expiration_month =  parse_xml(doc/:params/'expiration_month') if (doc/:params/'expiration_month').first
    expiration_year =  parse_xml(doc/:params/'expiration_year') if (doc/:params/'expiration_year').first
    customer_id =  parse_xml(doc/:params/'customer_id') if (doc/:params/'customer_id').first
    @config = YAML::load(File.open("#{Rails.root}/config/settings.yml"))
    api_transaction_key = @config["api_transaction_key"]
    api_login_id = @config["api_login_id"]
    customer = Customer::Customer.find_by_id(customer_id)
    if !customer
      return "Customer Does't Exists."
    end
    result = credit_card_no.creditcard?"#{card_type.downcase}" if (credit_card_no and card_type)
    if (customer.customer_profile_code and customer.customer_profile_code != '')
      check_duplicate_card = Payment::CustomerPaymentProfile.find_by_trans_flag_and_customer_id_and_card_number('A',customer.id,credit_card_no.to_s[-4..-1])
      if check_duplicate_card
        return "Payment Profile Already exists for Card No: #{credit_card_no}"
      end
      if result == true
        begin
          credit_card = AuthorizeNet::CreditCard.new("#{credit_card_no}", "#{expiration_month}#{expiration_year}")
          transaction = AuthorizeNet::CIM::Transaction.new(api_login_id,api_transaction_key,{:gateway => :test})
          payment_profile = AuthorizeNet::CIM::PaymentProfile.new(:payment_method => credit_card)
          response = transaction.create_payment_profile(payment_profile,"#{customer.customer_profile_code}")
          if response.success?
            customer_payment_profile_code = response.payment_profile_id
            #            payment_profile_response = transaction.get_payment_profile(customer_payment_profile_code.to_s,"#{customer.customer_profile_code}")
            #            if payment_profile_response.success?
            #              payment_profile = payment_profile_response.payment_profile
            #              payment_method =  payment_profile.instance_variable_get(:@payment_method)
            #              card_number = payment_method.instance_variable_get(:@card_number)
            #              expiration = payment_method.instance_variable_get(:@expiration)
            #            ,:payment_method => payment_method,:card_number => card_number,:expiration => expiration
            customer_profile_code = customer.customer_profile_code
            customer_payment = Payment::CustomerPaymentProfile.new
            customer_payment.update_attributes!(:trans_flag => 'A',:company_id => customer.company_id,:customer_id => customer.id,:customer_profile_code => customer_profile_code,:customer_payment_profile_code => customer_payment_profile_code,:card_number => credit_card_no.to_s[-4..-1],:payment_method => card_type)
            return "Payment Profile Created Successfully For #{customer.name}"
            #            else
            #              return "Internal Error While Fetching Payment Profile Credentials. Please Contact System Administrator"
            #            end
          else
            return "Internal Error While Creating Payment Profile. Please Contact System Administrator"
          end
        rescue Exception => ex
          return ex
        end
      else
        return "#{card_type} Card No: #{credit_card_no} is not valid"
      end
    else
      return "Authorise.net Profile does not exists for Customer: #{customer.name}"
    end
  end

  def self.delete_customer_payment_profile(doc)
    customer_id =  parse_xml(doc/:params/'customer_id') if (doc/:params/'customer_id').first
    customer_payment_profile_code =  parse_xml(doc/:params/'customer_payment_profile_code') if (doc/:params/'customer_payment_profile_code').first
    @config = YAML::load(File.open("#{Rails.root}/config/settings.yml"))
    api_transaction_key = @config["api_transaction_key"]
    api_login_id = @config["api_login_id"]
    customer = Customer::Customer.find_by_id(customer_id)
    payment_profile = Payment::CustomerPaymentProfile.find_by_trans_flag_and_customer_id_and_customer_payment_profile_code('A',customer.id,customer_payment_profile_code)
    if !customer
      return "Customer Does't Exists."
    end
    if (customer.customer_profile_code and customer.customer_profile_code != '')
      if !payment_profile
        return "Customer Payment Profile Does't Exists."
      end
      begin
        transaction = AuthorizeNet::CIM::Transaction.new(api_login_id,api_transaction_key,{:gateway => :test})
        response = transaction.delete_payment_profile("#{customer_payment_profile_code}",customer.customer_profile_code)
        if response.success?
          payment_profile.update_attributes!(:trans_flag => 'D')
          return "Customer Payment Profile Deleted Successfully."
        else
          return "Internal Error While Deleting Payment Profile. Please Contact System Administrator"
        end
      rescue Exception => ex
        return ex
      end
    else
      return "Authorise.net Profile does not exists for Customer: #{customer.name}"
    end
  end

  def self.create_customer_shippings(doc,order)
    begin
      id =  parse_xml(doc/'id') if (doc/'id').first
      address1 =  parse_xml(doc/'ship_address1') if (doc/'ship_address1').first
      address2 =  parse_xml(doc/'ship_address2') if (doc/'ship_address2').first
      city =  parse_xml(doc/'ship_city') if (doc/'ship_city').first
      state =  parse_xml(doc/'ship_state') if (doc/'ship_state').first
      zip =  parse_xml(doc/'ship_zip') if (doc/'ship_zip').first
      country =  parse_xml(doc/'ship_country') if (doc/'ship_country').first
      phone1 =  parse_xml(doc/'ship_phone') if (doc/'ship_phone').first
      fax1 =  parse_xml(doc/'ship_fax') if (doc/'ship_fax').first
      name =  parse_xml(doc/'ship_name') if (doc/'ship_name').first
      code = address1.gsub(/ +/,'').upcase
      #      customer_shipping = Customer::CustomerShipping.find_or_create_by_code_and_customer_id(:code => code,:customer_id => order.customer_id)
      customer_shipping = Customer::CustomerShipping.find_by_code_and_customer_id(code,order.customer_id)
      customer_shipping =  Customer::CustomerShipping.new if !customer_shipping
      customer = Customer::Customer.find_by_id(order.customer_id)
      max_serial_no = customer.customer_shippings.maximum_serial_no
      if !id || id == ''
        serial_no = max_serial_no + 1
      else
        serial_no = customer_shipping.serial_no
      end
      #customer_shipping.update_attributes!(:company_id=>order.company_id,:customer_id=>order.customer_id,:code => code,:name=>name,:serial_no=>serial_no,:address1 => address1,:address2=>address2,:city=>city,:state=>state,:zip=>zip,:country=>country,:phone1=>phone1,:fax1=>fax1)
      customer_shipping.company_id = order.company_id;  customer_shipping.customer_id=order.customer_id
      customer_shipping.code = code ; customer_shipping.name = name
      customer_shipping.serial_no = serial_no ; customer_shipping.address1 = address1
      customer_shipping.address2 = address2 ; customer_shipping.city = city
      customer_shipping.state = state ; customer_shipping.zip = zip
      customer_shipping.country = country ; customer_shipping.phone1 = phone1
      customer_shipping.fax1 = fax1
      return customer_shipping,'success'
    rescue Exception => ex
      return ex,'error'
    end
  end

  def self.export_cutomer_pricing_xls(customer_id,schema_name)
    begin
      path = Setup::Type.find(:first, :conditions=>['type_cd = ? and subtype_cd = ?','UPLOAD_FOLDER','REPORT_PRINT'])
      if path
        directory =  "#{Dir.getwd}" + path.value + schema_name
      end
      filename = "#{Time.now().strftime('%Y%m%d%H%M%S')}"
      absolute_filename = File.join(directory, filename)+ "." + "xls"
      customer_specific_price=Customer::CustomerItemPricing.find_by_sql("select  * from customer_item_pricings where customer_id=#{customer_id } and trans_flag='A'")
      if customer_specific_price
        excel= WIN32OLE.new('Excel.Application')
        workbook=excel.Workbooks.add
        excel.Sheets("Sheet1").Name = "Sheet1"
        worksheet = workbook.worksheets("Sheet1")
        worksheet.Activate
        worksheet.Cells(1,1).Value ='Item #'
        worksheet.Cells(1,2).Value ='Discount Code'
        row=1
        for col in 3..17
          worksheet.Cells(1,col).Value ="Tier #{row}"
          row+=1
        end
        row=2
        customer_specific_price.each do |cust_price|
          worksheet.Cells(row,1).Value =cust_price.catalog_item_code
          worksheet.Cells(row,2).Value = cust_price.charge_code if cust_price.charge_code
          colrow=1
          for col in 3..17
            worksheet.Cells(row,col).Value = cust_price["column#{colrow}"].to_s if cust_price["column#{colrow}"]
            colrow+=1
          end
          row+=1
        end
        absolute_filename = absolute_filename.to_s.gsub("/","\\")
        excel.ActiveWorkbook.SaveAs("#{absolute_filename}",-4143)
        workbook.close
        excel.quit
        filename = filename + "." + "xls"
      end
    end
  rescue =>exc
    workbook.close if workbook
    excel.quit if excel
  ensure
  end
end

class Payment::PaymentCrud
  include General

  def self.authorize_payment(doc)
    amount =  parse_xml(doc/:params/'amount') if (doc/:params/'amount').first
    sales_order_id =  parse_xml(doc/:params/'sales_order_id') if (doc/:params/'sales_order_id').first
    customer_payment_profile_code =  parse_xml(doc/:params/'customer_payment_profile_code') if (doc/:params/'customer_payment_profile_code').first
    customer_profile_code =  parse_xml(doc/:params/'customer_profile_code') if (doc/:params/'customer_profile_code').first
    order = Sales::SalesOrder.find_by_id(sales_order_id)
    #    amount = order.net_amt
    return "Payment Already Authorized" if order.payment_authorize_flag == 'Y'
    if (amount.to_f > 0.00 and customer_payment_profile_code and sales_order_id and customer_profile_code)
      begin
        @config = YAML::load(File.open("#{Rails.root}/config/settings.yml"))
        api_transaction_key = @config["api_transaction_key"]
        api_login_id = @config["api_login_id"]
        transaction = AuthorizeNet::CIM::Transaction.new(api_login_id,api_transaction_key,{:gateway => :test})
        response = transaction.create_transaction_auth_only(amount,customer_profile_code,customer_payment_profile_code, nil)
        payment_transaction = Payment::CustomerPaymentTransaction.new
        message_code = response.instance_variable_get(:@message_code)
        message_text = response.instance_variable_get(:@message_text)
        if response.success?
          direct_response =  response.direct_response
          puts response_hash = direct_response.instance_variable_get(:@fields)
          response_code = response_hash[:response_code]
          response_subcode = response_hash[:response_subcode]
          response_reason_code = response_hash[:response_reason_code]
          response_reason_text = response_hash[:response_reason_text]
          authorization_code = response_hash[:authorization_code]
          transaction_code = response_hash[:transaction_id]
          method = response_hash[:method]
          account_number = response_hash[:account_number]
          authorized_amount = response_hash[:amount]
          #          customer_id = response_hash[:customer_id]
          payment_transaction.amount = authorized_amount.to_f ; payment_transaction.trans_flag = 'A' ; payment_transaction.company_id = 1
          payment_transaction.customer_id = order.customer_id ; payment_transaction.sales_order_id = sales_order_id ; payment_transaction.customer_profile_code = customer_profile_code
          payment_transaction.customer_payment_profile_code = customer_payment_profile_code ; payment_transaction.transaction_code = transaction_code
          payment_transaction.response_code = response_code ; payment_transaction.response_subcode = response_subcode
          payment_transaction.response_reason_code = response_reason_code ; payment_transaction.response_reason_text = response_reason_text
          payment_transaction.authorization_code = authorization_code ; payment_transaction.method = method ; payment_transaction.account_number = account_number
          payment_transaction.message_code = message_code ; payment_transaction.message_text = message_text
          ## updating sales order
          order.payment_status = CC_AUTHORIZED ; order.payment_authorize_flag = 'Y'
          order.accountreviewed_flag = 'Y' ; order.accounting_status = CLEAR ; order.payment_release_flag = 'N'
          if order.trans_type == TRANS_TYPE_SAMPLE_ORDER
            status = Sales::CurrentLocationLogic.find_order_location(order,order.order_status,order.artwork_status)
          else
            status = order.workflow_location
          end
          order.workflow_location = status
          order.customer_payment_transactions.push(payment_transaction)
          email = Email::Email.send_email('PAYMENTAUTHORIZED',order)
          order.create_sales_order_transaction_activity("CC AUTHORIZED FOR $#{amount}")
          message = "Payment of Amount: $#{amount} Authorized Successfully For Order No: #{order.trans_no}"
        else
          payment_transaction.trans_flag = 'A' ; payment_transaction.company_id = 1 ; payment_transaction.customer_id = order.customer_id
          payment_transaction.sales_order_id = sales_order_id ; payment_transaction.customer_profile_code = customer_profile_code
          payment_transaction.customer_payment_profile_code = customer_payment_profile_code ; payment_transaction.message_code = message_code
          payment_transaction.message_text = message_text
          order.customer_payment_transactions.push(payment_transaction)
          order.payment_status = PAYMENT_AUTHORIZATION_FAILED
          email = Email::Email.send_email('PAYMENTAUTHORIZATIONFAILED',order)
          order.create_sales_order_transaction_activity('PAYMENT AUTHORIZATION FAILED')
          message = "#{message_text} Internal Error While Authorizing Payment. Please Contact System Administrator"
        end
        save_proc = Proc.new{
          order.save!
          payment_transaction.save!
          email.save!
        }
        if order.errors.empty?
          order.save_transaction(&save_proc)
          return message
        else
          'Error Occurred While Saving Transaction'
        end
      rescue Exception => ex
        return ex
      end
    else
      return 'Insufficient Data, Please Check Net Amount.It should be greater than zero'
    end
  end

  def self.create_payment_profile_and_authorize(doc) ## not in use
    credit_card_no =  parse_xml(doc/:params/'credit_card_no') if (doc/:params/'credit_card_no').first
    card_type =  parse_xml(doc/:params/'card_type') if (doc/:params/'card_type').first
    expiration_month =  parse_xml(doc/:params/'expiration_month') if (doc/:params/'expiration_month').first
    expiration_year =  parse_xml(doc/:params/'expiration_year') if (doc/:params/'expiration_year').first
    customer_id =  parse_xml(doc/:params/'customer_id') if (doc/:params/'customer_id').first
    amount =  parse_xml(doc/:params/'amount') if (doc/:params/'amount').first
    #    amount = 12.00
    sales_order_id =  parse_xml(doc/:params/'sales_order_id') if (doc/:params/'sales_order_id').first
    @config = YAML::load(File.open("#{Rails.root}/config/settings.yml"))
    api_transaction_key = @config["api_transaction_key"]
    api_login_id = @config["api_login_id"]
    customer = Customer::Customer.find_by_id(customer_id)
    if !customer
      customer = Customer::Customer.new
      return "Customer Does't Exists.",customer
    end
    result = credit_card_no.creditcard?"#{card_type.downcase}" if (credit_card_no and card_type)
    if (customer.customer_profile_code and customer.customer_profile_code != '')
      order = Sales::SalesOrder.find_by_id(sales_order_id)
      return "Payment Already Authorized" if order.payment_authorize_flag == 'Y'
      check_duplicate_card = Payment::CustomerPaymentProfile.find_by_trans_flag_and_customer_id_and_card_number('A',customer.id,credit_card_no.to_s[-4..-1])
      if check_duplicate_card
        return "Payment Profile Already exists for Card No: #{credit_card_no}",customer
      end
      if result == true
        begin
          credit_card = AuthorizeNet::CreditCard.new("#{credit_card_no}", "#{expiration_month}#{expiration_year}")
          transaction = AuthorizeNet::CIM::Transaction.new(api_login_id,api_transaction_key,{:gateway => :test})
          payment_profile = AuthorizeNet::CIM::PaymentProfile.new(:payment_method => credit_card)
          response = transaction.create_payment_profile(payment_profile,"#{customer.customer_profile_code}")
          if response.success?
            customer_payment_profile_code = response.payment_profile_id
            #            customer_profile_code = response.instance_variable_get(:@customer_profile_id)
            customer_profile_code = customer.customer_profile_code
            customer_payment = Payment::CustomerPaymentProfile.new
            customer_payment.update_attributes!(:trans_flag => 'A',:company_id => customer.company_id,:customer_id => customer.id,:customer_profile_code => customer_profile_code,:customer_payment_profile_code => customer_payment_profile_code,:card_number => credit_card_no.to_s[-4..-1],:payment_method => card_type)
            result = create_transaction_from_authorize_auth_only(amount,customer_profile_code,customer_payment_profile_code,sales_order_id,customer.id)
            if result == 'success'
              order.update_attributes!(:payment_status => 'CC AUTHORIZED',:payment_authorize_flag => 'Y',:accountreviewed_flag => 'Y',:accounting_status => 'CLEAR')
              email = Email::Email.send_email('PAYMENTAUTHORIZED',order)
              email.save!
              activity = order.create_sales_order_transaction_activity('PAYMENT PROFILE CREATED AND CC AUTHORIZED')
              activity.save!
              return "Payment of Amount: $#{amount} Authorized Successfully For Order No: #{order.trans_no}",customer
            elsif result == 'error'
              order.update_attributes!(:payment_status => 'PAYMENT AUTHORIZATION FAILED')
              email = Email::Email.send_email('PAYMENTAUTHORIZATIONFAILED',order)
              email.save!
              activity = order.create_sales_order_transaction_activity('PAYMENT AUTHORIZATION FAILED')
              activity.save!
              return "Payment Authorization Failed. Please Check if Credit Card is valid."
            else
              return "#{result}--Internal Error While Authorizing Transaction. Please Contact System Administrator",customer
            end
          else
            return "Internal Error While Creating Payment Profile. Please Contact System Administrator",customer
          end
        rescue Exception => ex
          return ex,customer
        end
      else
        return "#{card_type} Card No: #{credit_card_no} is not valid",customer
      end
    else
      return "Authorise.net Profile does not exists for Customer: #{customer.name}",customer
    end
  end

  ## not in use
  def self.create_transaction_from_authorize_auth_only(amount,customer_profile_code,customer_payment_profile_code,sales_order_id,customer_id)
    begin
      @config = YAML::load(File.open("#{Rails.root}/config/settings.yml"))
      api_transaction_key = @config["api_transaction_key"]
      api_login_id = @config["api_login_id"]
      transaction = AuthorizeNet::CIM::Transaction.new(api_login_id,api_transaction_key,{:gateway => :test})
      response = transaction.create_transaction_auth_only(amount, "#{customer_profile_code}","#{customer_payment_profile_code}", nil)
      payment_transaction = Payment::CustomerPaymentTransaction.new
      message_code = response.instance_variable_get(:@message_code)
      message_text = response.instance_variable_get(:@message_text)
      if response.success?
        direct_response =  response.direct_response
        response_code = response_hash[:response_code]
        response_subcode = response_hash[:response_subcode]
        response_reason_code = response_hash[:response_reason_code]
        response_reason_text = response_hash[:response_reason_text]
        authorization_code = response_hash[:authorization_code]
        transaction_code = response_hash[:transaction_id]
        method = response_hash[:method]
        account_number = response_hash[:account_number]
        authorized_amount = response_hash[:amount]
        #      customer_id = response_hash[:customer_id]
        payment_transaction.update_attributes!(:amount =>authorized_amount.to_f,:trans_flag => 'A',:company_id => 1,:customer_id =>customer_id,:sales_order_id => sales_order_id,:customer_profile_code => customer_profile_code,:customer_payment_profile_code => customer_payment_profile_code,
          :transaction_code => transaction_code,:response_code => response_code,:response_subcode => response_subcode,:response_reason_code=> response_reason_code,
          :response_reason_text => response_reason_text,:authorization_code => authorization_code,:method => method,:account_number => account_number,:message_code => message_code, :message_text => message_text)
        return 'success'
      else
        payment_transaction.update_attributes!(:trans_flag => 'A',:company_id => 1,:customer_id =>customer_id,:sales_order_id => sales_order_id,:customer_profile_code => customer_profile_code,:customer_payment_profile_code => customer_payment_profile_code,
          :message_code => message_code, :message_text => message_text)
        return 'error'
      end
    rescue Exception => ex
      return ex
    end
  end

  def self.capture_payment(order,invoice)
    payment_transactions = [] # change
    payment_transaction = Payment::CustomerPaymentTransaction.find_by_sales_order_id_and_customer_id_and_payment_release_flag(order.id,order.customer_id,'N')
    return payment_transaction,nil,"Payment Not Authorized For this Order." if !payment_transaction
    msg = ''
    sales_invoice_flag = 'N'
    sales_invoices = Sales::SalesInvoice.find_all_by_ref_trans_no(order.trans_no)
    sales_invoices.each{|sales_invoice|
      if(sales_invoice.id != invoice.id)
        sales_invoice_flag = 'Y'
      end
    }
    if(sales_invoice_flag == 'N')# to find whether there is already an invoice associated with the order
      if (invoice.net_amt.to_f > payment_transaction.amount.to_f)
        final_amount = payment_transaction.amount.to_f
        remaining_amount = (invoice.net_amt.to_f - payment_transaction.amount.to_f)
        remaining_amount = (('%.2f'%remaining_amount).to_f)
        capture_transaction,msg = capture_full_payment(order,payment_transaction,final_amount)
        payment_transactions << capture_transaction # change
        ## if some error occurred while capturing the authorized payment the it will return with out continuing further.
        return payment_transactions ,nil,msg if !payment_transaction.errors[:base].empty?
        if remaining_amount != 0.00
          payment_transaction,email,msg = authorize_and_capture_payment(order,remaining_amount,payment_transaction.customer_profile_code,payment_transaction.customer_payment_profile_code,order.id)
          payment_transactions << payment_transaction # change
        end
      else
        final_amount = invoice.net_amt.to_f
        payment_transaction, msg = capture_full_payment(order,payment_transaction,final_amount)
        payment_transactions << payment_transaction # change
      end
    else
      payment_transaction,email,msg = authorize_and_capture_payment(order,invoice.net_amt,payment_transaction.customer_profile_code,payment_transaction.customer_payment_profile_code,order.id)
      payment_transactions << payment_transaction # change
    end
    return payment_transactions, email, msg
  end

  def self.capture_full_payment(order,payment_transactions,final_amount)
    # change----  begin rescue clause removed
    order.customer_payment_transactions.each{|payment_transaction| # change
      if(payment_transaction.payment_release_flag == 'N' and payment_transaction.payment_capture_flag == 'N') # change
        @config = YAML::load(File.open("#{Rails.root}/config/settings.yml"))
        api_transaction_key = @config["api_transaction_key"]
        api_login_id = @config["api_login_id"]
        transaction = AuthorizeNet::CIM::Transaction.new(api_login_id,api_transaction_key,{:gateway => :test})
        response = transaction.create_transaction_prior_auth_capture(payment_transaction.transaction_code,final_amount)
        message_code = response.instance_variable_get(:@message_code)
        message_text = response.instance_variable_get(:@message_text)
        if response.success?
          direct_response =  response.direct_response
          response_hash = direct_response.instance_variable_get(:@fields)
          response_code = response_hash[:response_code]
          response_subcode = response_hash[:response_subcode]
          captured_authorization_code = response_hash[:authorization_code]
          captured_transaction_code = response_hash[:transaction_id]
          captured_amount = response_hash[:amount]
          captured_response_reason_text = response_hash[:response_reason_text]
          payment_transaction.captured_amount =  captured_amount.to_f
          payment_transaction.captured_transaction_code = captured_transaction_code
          payment_transaction.captured_authorization_code = captured_authorization_code
          payment_transaction.captured_response_reason_text = captured_response_reason_text
          payment_transaction.message_code = message_code; payment_transaction.message_text = message_text
          payment_transaction.payment_capture_flag = 'Y'
          order.payment_status = PAYMENT_CAPTURED
          order.payment_capture_flag = 'Y'
          order.create_sales_order_transaction_activity("PAYMENT OF $#{payment_transaction.captured_amount}  CAPTURED")
          msg = "Payment of Amount: $#{payment_transaction.captured_amount} Captured Successfully For Order No: #{order.trans_no}"
        else
          order.create_sales_order_transaction_activity('PAYMENT CAPTURED FAILED')
          msg = "#{message_text} Internal Error While Capturing Payment. Please Contact System Administrator"
          payment_transaction.errors[:base] << msg
        end
        return payment_transaction , msg
      end
    }
  end

  ## working fine
  #  def self.capture_full_payment(order,payment_transaction,final_amount)
  #    begin
  #      @config = YAML::load(File.open("#{Rails.root}/config/settings.yml"))
  #      api_transaction_key = @config["api_transaction_key"]
  #      api_login_id = @config["api_login_id"]
  #      transaction = AuthorizeNet::CIM::Transaction.new(api_login_id,api_transaction_key,{:gateway => :test})
  #      response = transaction.create_transaction_prior_auth_capture(payment_transaction.transaction_code,final_amount)
  #      message_code = response.instance_variable_get(:@message_code)
  #      message_text = response.instance_variable_get(:@message_text)
  #      if response.success?
  #        direct_response =  response.direct_response
  #        response_hash = direct_response.instance_variable_get(:@fields)
  #        response_code = response_hash[:response_code]
  #        response_subcode = response_hash[:response_subcode]
  #        captured_authorization_code = response_hash[:authorization_code]
  #        captured_transaction_code = response_hash[:transaction_id]
  #        captured_amount = response_hash[:amount]
  #        captured_response_reason_text = response_hash[:response_reason_text]
  #        #          customer_id = response_hash[:customer_id]
  #        payment_transaction.captured_amount =  captured_amount.to_f ; payment_transaction.payment_capture_flag = 'Y'
  #        payment_transaction.captured_transaction_code = captured_transaction_code
  #        payment_transaction.captured_authorization_code = captured_authorization_code
  #        payment_transaction.captured_response_reason_text = captured_response_reason_text
  #        payment_transaction.message_code = message_code; payment_transaction.message_text = message_text
  #        order.payment_status = PAYMENT_CAPTURED
  #        order.payment_capture_flag = 'Y'
  #        order.create_sales_order_transaction_activity("PAYMENT OF $#{payment_transaction.captured_amount}  CAPTURED")
  #        msg = "Payment of Amount: $#{payment_transaction.captured_amount} Captured Successfully For Order No: #{order.trans_no}"
  #      else
  #        order.create_sales_order_transaction_activity('PAYMENT CAPTURED FAILED')
  #        msg = "#{message_text} Internal Error While Capturing Payment. Please Contact System Administrator"
  #        payment_transaction.errors[:base] << msg
  #      end
  #      return payment_transaction , msg
  #    rescue Exception => ex
  #      payment_transaction.errors[:base] << ex
  #      return payment_transaction ,msg
  #    end
  #  end

  def self.authorize_and_capture_payment(order,amount,customer_profile_code,customer_payment_profile_code,sales_order_id)
    begin
      @config = YAML::load(File.open("#{Rails.root}/config/settings.yml"))
      api_transaction_key = @config["api_transaction_key"]
      api_login_id = @config["api_login_id"]
      transaction = AuthorizeNet::CIM::Transaction.new(api_login_id,api_transaction_key,{:gateway => :test})
      response = transaction.create_transaction_auth_capture(amount, "#{customer_profile_code}","#{customer_payment_profile_code}", nil)
      payment_transaction = Payment::CustomerPaymentTransaction.new
      message_code = response.instance_variable_get(:@message_code)
      message_text = response.instance_variable_get(:@message_text)
      if response.success?
        direct_response =  response.direct_response
        response_hash = direct_response.instance_variable_get(:@fields)
        response_code = response_hash[:response_code]
        response_subcode = response_hash[:response_subcode]
        response_reason_code = response_hash[:response_reason_code]
        response_reason_text = response_hash[:response_reason_text]
        authorization_code = response_hash[:authorization_code]
        transaction_code = response_hash[:transaction_id]
        method = response_hash[:method]
        account_number = response_hash[:account_number]
        authorized_amount = response_hash[:amount]
        #        customer_id = response_hash[:customer_id]
        payment_transaction.amount =authorized_amount.to_f 
        payment_transaction.trans_flag = 'A'; payment_transaction.company_id = 1; payment_transaction.customer_id =order.customer_id
        payment_transaction.sales_order_id = sales_order_id; payment_transaction.customer_profile_code = customer_profile_code
        payment_transaction.customer_payment_profile_code = customer_payment_profile_code
        payment_transaction.transaction_code = transaction_code; payment_transaction.response_code = response_code
        payment_transaction.response_subcode = response_subcode
        payment_transaction.response_reason_code = response_reason_code
        payment_transaction.response_reason_text = response_reason_text;payment_transaction.authorization_code = authorization_code
        payment_transaction.method = method; payment_transaction.account_number = account_number
        payment_transaction.message_code = message_code, payment_transaction.message_text = message_text
        order.payment_status = CC_AUTHORIZED_AND_CAPTURED; order.payment_authorize_flag = 'Y'; order.payment_capture_flag = 'Y'
        order.customer_payment_transactions.push(payment_transaction)
        email = Email::Email.send_email('PAYMENTAUTHORIZED',order)
        order.create_sales_order_transaction_activity("PAYMENT OF $#{amount} AUTHORIZED AND CAPTURED")
        msg =  "Payment of Amount: $#{amount} Authorized and Captured Successfully For Order No: #{order.trans_no}"
        payment_transaction.payment_capture_flag = 'Y'
      else
        payment_transaction.trans_flag = 'A'; payment_transaction.company_id = 1; payment_transaction.customer_id = order.customer_id
        payment_transaction.sales_order_id = sales_order_id; payment_transaction.customer_profile_code = customer_profile_code
        payment_transaction.customer_payment_profile_code = customer_payment_profile_code; payment_transaction.message_code = message_code
        payment_transaction.message_text = message_text
        order.payment_status = PAYMENT_AUTHORIZATION_AND_CAPTURED_FAILED
        order.customer_payment_transactions.push(payment_transaction)
        order.create_sales_order_transaction_activity('PAYMENT AUTHORIZATION AND CAPTURED FAILED')
        msg =  "#{message_text} Internal Error While Authorizing and Capturing Transaction. Please Contact System Administrator"
        payment_transaction.errors[:base] << msg
      end
    rescue Exception => ex
      payment_transaction.errors[:base] << ex
      return payment_transaction, email, msg
    end
    return payment_transaction, email, msg
  end


  def self.cancel_authorized_transaction(doc)
    sales_order_id =  parse_xml(doc/:params/'sales_order_id') if (doc/:params/'sales_order_id').first
    order = Sales::SalesOrder.find_by_id(sales_order_id)
    return 'Order Not found' if !order
    authorized_transaction = Payment::CustomerPaymentTransaction.find_by_sales_order_id_and_customer_id_and_response_code_and_payment_release_flag(order.id,order.customer_id,1,'N')
    return "Please Authorize Payment Before Cancelling it." if order.payment_authorize_flag != 'Y'
    return "Transaction cannot be cancelled as payment is already captured." if order.payment_capture_flag == 'Y'
    if sales_order_id
      begin
        @config = YAML::load(File.open("#{Rails.root}/config/settings.yml"))
        api_transaction_key = @config["api_transaction_key"]
        api_login_id = @config["api_login_id"]
        transaction = AuthorizeNet::CIM::Transaction.new(api_login_id,api_transaction_key,{:gateway => :test})
        response = transaction.create_transaction_void(authorized_transaction.transaction_code)
        #        payment_transaction = Payment::CustomerPaymentTransaction.new
        message_code = response.instance_variable_get(:@message_code)
        message_text = response.instance_variable_get(:@message_text)
        if response.success?
          direct_response =  response.direct_response
          puts response_hash = direct_response.instance_variable_get(:@fields)
          response_code = response_hash[:response_code]
          response_subcode = response_hash[:response_subcode]
          response_reason_code = response_hash[:response_reason_code]
          response_reason_text = response_hash[:response_reason_text]
          authorization_code = response_hash[:authorization_code]
          transaction_code = response_hash[:transaction_id]
          method = response_hash[:method]
          account_number = response_hash[:account_number]
          authorized_amount = response_hash[:amount]
          #          authorized_transaction.update_attributes!(:amount =>authorized_amount.to_f,:trans_flag => 'A',:company_id => 1,:customer_id =>order.customer_id,:sales_order_id => sales_order_id,:customer_profile_code => authorized_transaction.customer_profile_code,:customer_payment_profile_code => authorized_transaction.customer_payment_profile_code,
          #            :transaction_code => transaction_code,:response_code => response_code,:response_subcode => response_subcode,:response_reason_code=> response_reason_code,
          #            :response_reason_text => response_reason_text,:authorization_code => authorization_code,:method => method,:account_number => account_number,:message_code => message_code, :message_text => message_text,:payment_release_flag=>'Y')
          authorized_transaction.update_attributes!(:amount =>authorized_amount.to_f,:payment_release_flag=>'Y')
          order.update_attributes!(:payment_status => CC_RELEASED,:payment_authorize_flag => 'N',:accountreviewed_flag => 'N',:payment_release_flag=>'Y',:accounting_status => CREDIT_CARD)
          #          email = Email::Email.send_email('PAYMENTAUTHORIZED',order)
          #          email.save!
          activity = order.create_sales_order_transaction_activity("CC RELEASED")
          activity.save!
          return "Authorized Payment Released Successfully For Order No: #{order.trans_no}"
        else
          #          authorized_transaction.update_attributes!(:trans_flag => 'A',:company_id => 1,:customer_id =>order.customer_id,:sales_order_id => sales_order_id,:customer_profile_code => authorized_transaction.customer_profile_code,:customer_payment_profile_code => authorized_transaction.customer_payment_profile_code,
          #            :message_code => message_code, :message_text => message_text)
          authorized_transaction.update_attributes!(:message_code => message_code, :message_text => message_text)
          order.update_attributes!(:payment_status => PAYMENT_RELEASE_FAILED)
          #          email = Email::Email.send_email('PAYMENTAUTHORIZATIONFAILED',order)
          #          email.save!
          activity = order.create_sales_order_transaction_activity('PAYMENT RELEASE FAILED')
          activity.save!
          return "#{message_text} Internal Error While Releasing Payment. Please Contact System Administrator"
        end
      rescue Exception => ex
        return ex
      end
    else
      return 'Insufficient Data, Please Check That Order is saved.'
    end
  end

  ##### OLD METHODS

  def self.validate_credit_card(doc)
    credit_card_no =  parse_xml(doc/:params/'credit_card_no') if (doc/:params/'credit_card_no').first
    card_type =  parse_xml(doc/:params/'card_type') if (doc/:params/'card_type').first
    result = credit_card_no.creditcard?"#{card_type.downcase}" if (credit_card_no and card_type)
    return result
  end
  
  def self.make_payment(doc)
    trans_no =  parse_xml(doc/:params/'trans_no') if (doc/:params/'trans_no').first
    order = Sales::SalesOrder.find_by_trans_no(trans_no)
    return order
  end
  
  def self.build_form(order)
    timestamp = Time.now.to_i
    sequence = rand(1000*1000)
    #    loginid = '25BpR2HjPPwX'
    #    transaction_key = '23cm844Uj56V3J7g'
    @config = YAML::load(File.open("#{Rails.root}/config/settings.yml"))
    transaction_key = @config["api_transaction_key"]
    loginid = @config["api_login_id"]
    amount = 187.65
    #        inputstring = loginid + "^" + sequence.to_s + "^" + timestamp.to_s + "^" + amount.to_s + "^" + 'INR'
    inputstring = loginid + "^" + sequence.to_s + "^" + timestamp.to_s + "^" + amount.to_s + "^"
    fingerprint = OpenSSL::HMAC.hexdigest(OpenSSL::Digest::Digest.new('md5'), transaction_key, inputstring)
    #    https://developer.authorize.net/tools/paramdump/index.php
    #    https://test.authorize.net/gateway/transact.dll
    frm = "<html><body><form name='form1' action='https://test.authorize.net/gateway/transact.dll' method='POST'>"
    frm += "<INPUT TYPE=HIDDEN NAME='x_Version' VALUE='3.1'>"
    frm += "<input type=hidden name='x_login'  value='#{loginid}'/>"
    frm += "<input type=hidden name='x_trans_id'  value='#{transaction_key}'/>"
    frm += "<input type=hidden name='x_amount'  value='#{amount}'/>"
    frm += "<input type=hidden name='x_description'  value='Tekweld Sample Transaction'/>"
    frm += "<input type=hidden name='x_invoice_num'  value='#{order.trans_no}'/>"
    frm += "<input type=hidden name='x_fp_sequence'  value='#{sequence}'/>"
    frm += "<input type=hidden name='x_fp_timestamp'  value='#{timestamp}'/>"
    frm += "<input type=hidden name='x_fp_hash'  value='#{fingerprint}'/>"
    frm += "<input type=hidden name='x_test_request'  value='FALSE'/>"
    frm += "<input type=hidden name='x_show_form'  value='PAYMENT_FORM'/>"
    frm += "<input type=hidden name='x_first_name'  value='#{order.bill_name}'/>"
    frm += "<input type=hidden name='x_company'  value='Diaspark'/>"
    frm += "<input type=hidden name='x_address'  value='#{order.bill_address1 + order.bill_address2}'/>"
    frm += "<input type=hidden name='x_city'  value='#{order.bill_city}'/>"
    frm += "<input type=hidden name='x_state'  value='#{order.bill_state}'/>"
    frm += "<input type=hidden name='x_zip'  value='#{order.bill_zip}'/>"
    frm += "<input type=hidden name='x_country'  value='#{order.bill_country}'/>"
    frm += "<input type=hidden name='x_phone'  value='#{order.bill_phone}'/>"
    frm += "<input type=hidden name='x_fax'  value='#{order.bill_fax}'/>"
    frm += "<input type=hidden name='x_cust_id'  value='#{order.customer.code}'/>"
    frm += "<input type=hidden name='x_email'  value='amit.pandey@diaspark.com'/>"
    frm += "<input type=hidden name='x_ship_to_first_name'  value='Titanic'/>"
    frm += "<input type=hidden name='x_ship_to_last_name'  value='Inc'/>"
    frm += "<input type=hidden name='x_ship_to_address'  value='Dock 101 South Pole'/>"
    frm += "<input type=hidden name='x_ship_to_city'  value='Los Angeles'/>"
    frm += build_order_lines(order)
    frm += "<input type=hidden name='x_logo_url'  value='http://tekweld.promo:3000/images/tekweld.jpg'/>"
    frm += "<input type=hidden name='x_cancel_url'  value='http://tekweld.promo.diasparkonline.com:4009/payment/payment/cancel_payment'/>"
    frm += "<input type=hidden name='x_header_html_payment_form'  value='TEKWELD PAYMENT GATEWAY'/>"
    frm += "<input type=hidden name='x_footer_html_payment_form'  value='TEKWELD PAYMENT GATEWAY'/>"
    #    frm += "<input type=hidden name='x_currency_code'  value='INR'/>"

    frm += "<input type=hidden name='x_receipt_link_method'  value='POST'/>"
    frm += "<input type=hidden name='x_receipt_link_text'  value='HOME'/>"
    frm += "<input type=hidden name='x_receipt_link_url'  value='http://tekweld.promo.diasparkonline.com:4009/payment/payment/process_response'/>"

    #                    frm += "<input type=hidden name='x_delim_data'  value='FALSE'/>"
    #                frm += "<input type=hidden name='x_relay_always'  value='TRUE'/>"
    #                    frm += "<input type=hidden name='x_relay_response'  value='TRUE'/>"
    #                    frm += "<input type=hidden name='x_relay_url'  value='http://tekweld.promo/payment/payment/process_response'/>"

    frm += "<input type=hidden name='label'  value='Submit Payment'/>"
    frm += "</form></body><br><br><br><br><br><br><br><br><center><h2>Please wait you are being redirected to the payment gateway...</h2><br>Do not Press Refresh or Back Button.</center></html>"
    frm += "<script language='JavaScript'>window.document.form1.submit();</script>"
    frm += "<br><br><br><br><center>Please wait you are redirected to the payment gateway.</center>"
    return frm
  end
    
  def self.build_order_lines(order)
    frm = ""
    order.sales_order_lines.each{|line|
      frm += "<input type=hidden name='x_line_item' value='#{line.catalog_item_code}<|>#{line.catalog_item_code}<|>Testing Description<|>2.00<|>#{line.item_amt}<|>Y'/>"
    }
    return frm
  end

  def self.process_response(response_hash)
    x_trans_id = response_hash["x_trans_id"]
    x_auth_code = response_hash["x_auth_code"]
    x_response_code = response_hash["x_response_code"]
    x_response_reason_code = response_hash["x_response_reason_code"]
    x_response_reason_text = response_hash["x_response_reason_text"]
    customer_code = response_hash["x_cust_id"]
    customer_company = response_hash["x_company"]
    customer_email = response_hash["x_email"]
    paid_amount = response_hash["x_amount"]
    credit_card_number = response_hash["x_account_number"]
    x_type = response_hash["x_type"]
    card_type = response_hash["x_card_type"]
    payment_method = response_hash["x_method"]
    cavv_response = response_hash["x_cavv_response"]
    avs_code = response_hash["x_avs_code"]
    trans_no = response_hash["x_invoice_num"]
    begin
      order = Sales::SalesOrder.find_by_trans_no(trans_no)
      payment = Payment::PaymentResponse.new
      payment.update_attributes!(:x_trans_id => x_trans_id,:x_auth_code => x_auth_code,:x_response_code => x_response_code,:x_response_reason_code => x_response_reason_code,:x_response_reason_text => x_response_reason_text,
        :customer_code => customer_code,:customer_company => customer_company,:customer_email => customer_email,:paid_amount => paid_amount,:credit_card_number => credit_card_number,:x_type => x_type,:card_type => card_type,
        :payment_method => payment_method,:cavv_response => cavv_response,:avs_code=> avs_code,:trans_no => trans_no,:sales_order_id => order.id)
      activity = order.create_sales_order_transaction_activity('PAYMENT DONE')
      activity.save!
    rescue Exception => ex
      return ex
    end
    return 'success'
  end

  
end
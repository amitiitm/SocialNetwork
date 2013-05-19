class Payment::PaymentProfileCrud
  include General

  include General

  def self.list_payment_profiles(doc)
    criteria = Setup::Criteria.fill_criteria(doc/:criteria)
    Customer::CustomerPaymentProfile.find_by_sql ["select CAST( (select(select * from customer_payment_profiles
                                            FOR XML PATH('customer_payment_profile'),type,elements xsinil)FOR XML PATH('customer_payment_profiles')) AS xml) as xmlcol "
    ]
  end


  def self.show_payment_profile(profile_id)
    Customer::CustomerPaymentProfile.find_all_by_id(profile_id)
  end

  def self.create_payment_profiles(doc)
    payment_profiles = []
    message = ""
    (doc/:customer_payment_profiles/:customer_payment_profile).each{|profile_doc|
      message,text = create_payment_profile(profile_doc)
      if text == 'error'
        break
      else
        payment_profiles << text
      end
    }
    return payment_profiles,message
  end

  def self.create_payment_profile(doc)
    credit_card_no =  parse_xml(doc/'card_number') if (doc/'card_number').first
    card_type =  parse_xml(doc/'card_type') if (doc/'card_type').first
    expiration_month =  parse_xml(doc/'expiration_month') if (doc/'expiration_month').first
    expiration_year =  parse_xml(doc/'expiration_year') if (doc/'expiration_year').first
    customer_id =  parse_xml(doc/'customer_id') if (doc/'customer_id').first
    customer_code =  parse_xml(doc/'customer_code') if (doc/'customer_code').first
    first_name =  parse_xml(doc/'first_name') if (doc/'first_name').first
    last_name =  parse_xml(doc/'last_name') if (doc/'last_name').first
    company =  parse_xml(doc/'company') if (doc/'company').first
    address =  parse_xml(doc/'address') if (doc/'address').first
    city =  parse_xml(doc/'city') if (doc/'city').first
    state =  parse_xml(doc/'state') if (doc/'state').first
    zip =  parse_xml(doc/'zip') if (doc/'zip').first
    country =  parse_xml(doc/'country') if (doc/'country').first
    phone =  parse_xml(doc/'phone') if (doc/'phone').first
    fax =  parse_xml(doc/'fax') if (doc/'fax').first
    @config = YAML::load(File.open("#{Rails.root}/config/settings.yml"))
    api_transaction_key = @config["api_transaction_key"]
    api_login_id = @config["api_login_id"]
    customer = Customer::Customer.find_by_id(customer_id)
    if !customer
      return "Customer Does't Exists.",'error'
    end
    result = credit_card_no.creditcard?"#{card_type.downcase}" if (credit_card_no and card_type)
    if (customer.customer_profile_code and customer.customer_profile_code != '')
      check_duplicate_card = Payment::CustomerPaymentProfile.find_by_trans_flag_and_customer_id_and_card_number('A',customer.id,credit_card_no.to_s[-4..-1])
      if check_duplicate_card
        return "Payment Profile Already exists for Card No: #{credit_card_no}",'error'
      end
      if result == true
        begin
          billing_address = {:first_name => "#{first_name}", :last_name => "#{last_name}", :company => "#{company}",
            :address => "#{address}", :city => "#{city}", :state => "#{state}", :zip => "#{zip}",
            :country => "#{country}",:phone => "#{phone}",:fax=>"#{fax}"}
          credit_card = AuthorizeNet::CreditCard.new("#{credit_card_no}", "#{expiration_month}#{expiration_year}")
          transaction = AuthorizeNet::CIM::Transaction.new(api_login_id,api_transaction_key,{:gateway => :test})
          payment_profile = AuthorizeNet::CIM::PaymentProfile.new(:payment_method => credit_card,:billing_address => billing_address)
          response = transaction.create_payment_profile(payment_profile,"#{customer.customer_profile_code}")
          if response.success?
            customer_payment_profile_code = response.payment_profile_id
            customer_profile_code = customer.customer_profile_code
            customer_payment = Payment::CustomerPaymentProfile.new
            customer_payment.update_attributes!(:trans_flag => 'A',:company_id => customer.company_id,:customer_id => customer.id,:customer_code=>customer_code,:customer_profile_code => customer_profile_code,:customer_payment_profile_code => customer_payment_profile_code,:card_number => credit_card_no.to_s[-4..-1],:payment_method => card_type,:update_flag => 'V',
                                                :first_name => first_name,:last_name=>last_name,:company=>company,:address=>address,:city=>city,:state=>state,:zip=>zip,:country=>country,:phone=>phone,:fax=>fax)
            return "Payment Profile Created Successfully For #{customer.name}",customer_payment
          else
            return "Internal Error While Creating Payment Profile. Please Contact System Administrator",'error'
          end
        rescue Exception => ex
          return ex
        end
      else
        return "#{card_type} Card No: #{credit_card_no} is not valid",'error'
      end
    else
      return "Authorise.net Profile does not exists for Customer: #{customer.name}",'error'
    end
  end
end
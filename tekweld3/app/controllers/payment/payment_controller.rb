class Payment::PaymentController < ApplicationController
  require 'hpricot'
  require 'creditcard'
  require "activemerchant"
  require 'authorize-net'
  require 'rexml/document'
  require 'hmac-md5'


  def cancel_authorized_transaction
    doc = Hpricot::XML(request.raw_post)
    result = Payment::PaymentCrud.cancel_authorized_transaction(doc)
    render :xml => "<result>#{result}</result>"
  end



  def create_payment_profile_and_authorize
    doc = Hpricot::XML(request.raw_post)
    #xml = %{<params><credit_card_no>4111111111111111</credit_card_no><card_type>VISA</card_type><expiration_month>12</expiration_month><expiration_year>15</expiration_year><customer_id>2</customer_id><amount>10.00</amount><sales_order_id>664</sales_order_id></params>}
    #    doc = Hpricot::XML(xml)
    @result,@customer = Payment::PaymentCrud.create_payment_profile_and_authorize(doc)
    #    render :text => result
  end

  #### Old methods not in use.
  def validate_credit_card
    doc = Hpricot::XML(request.raw_post)
    result = Payment::PaymentCrud.validate_credit_card(doc)
    render :text => "#{result}"
  end
  
  def make_payment
    #    doc = Hpricot::XML(request.raw_post)
    xml = %{<params><trans_no>1543</trans_no></params>}
    doc = Hpricot::XML(xml)
    order = Payment::PaymentCrud.make_payment(doc)
    #    params = Payment::PaymentCrud.build_order_params(order,order_lines)
    render :inline => Payment::PaymentCrud.build_form(order)
  end
  
  
  def process_response
    response_hash = request.parameters
    result = Payment::PaymentCrud.process_response(response_hash)
    if result == 'success'
      render
    end
  end

  def create_transaction_from_authorize_auth_only
    api_transaction_key = "2Br54s6hwfK2a4ZR"
    api_login_id = "765XetqRVSg5"
    transaction = AuthorizeNet::CIM::Transaction.new(api_login_id,api_transaction_key,{:gateway => :test})
    # 2167967193   order = {:invoice_num => '1006',:description => 'testing transaction',:line_items => {:id=>'HS103',:name=>'HS103 Blue Berry',:description=>'Hand Sanetizer',:quantity=>'2',:price=>'10.00'}}
    response = transaction.create_transaction_auth_only(10, '6898612', '5978569', nil)
    direct_response =  response.direct_response if response.success?
    puts response.instance_variable_get(:@message_code)
    puts response.instance_variable_get(:@message_text)
    puts response_hash = direct_response.instance_variable_get(:@fields)
    response_code = response_hash[:response_code]
    puts response_code
    response_sub_code = response_hash[:response_subcode]
    puts response_sub_code
    response_reason_code = response_hash[:response_reason_code]
    puts response_reason_code
    response_reason_text = response_hash[:response_reason_text]
    puts response_reason_text
    authorization_code = response_hash[:authorization_code]
    puts authorization_code
    avs_response = response_hash[:avs_response]
    puts avs_response
    transaction_id = response_hash[:transaction_id]
    puts transaction_id
    invoice_number = response_hash[:invoice_number]
    puts invoice_number
    amount = response_hash[:amount]
    puts amount
    description = response_hash[:description]
    puts description
    method = response_hash[:method]
    puts method
    trans_type = response_hash[:trans_type]
    puts trans_type
    customer_id = response_hash[:customer_id]
    puts customer_id
    email_address = response_hash[:email_address]
    puts email_address
    address = response_hash[:address]
    puts address
    zip_code = response_hash[:zip_code] ## other customer details are returned same as in update_cim_customer_profile_address_from_authorize
    puts zip_code
    md5_hash = response_hash[:md5_hash]
    puts md5_hash
    account_number = response_hash[:account_number]
    puts account_number
    card_type = response_hash[:card_type]
    puts card_type
  end
end

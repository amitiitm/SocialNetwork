require 'cgi'

class Response
  attr_reader :params, :message, :test, :authorization, :avs_result, :cvv_result, :external_error
  
  def success?
    @success
  end
  
  def external_error?
    @external_error
  end

  def test?
    @test
  end
  
  def fraud_review?
    @fraud_review
  end
  
  def initialize(data, error = nil)
    if data
      process_data(data)
      @external_error = false
    else
      @params = {"L_LONGMESSAGE0" => error.message}
      @success = false
      @external_error = true
      @message = error.message
    end
  end
  
  def process_data(data)
    resp = {}
    d = data.split("&")
    d.each do |f|
      k,v = f.split("=")
      k = CGI::unescape(k)
      v = CGI::unescape(v)
      resp[k] = v
      #puts "#{k}=#{v}"
    end
    @authorization = resp["TRANSACTIONID"]
    @params = resp
    if resp["ACK"] == "Success" or resp["ACK"] == "SuccessWithWarning"
      @success = true
      @message = "Success"
    else
      @success = false
      @message = resp["L_LONGMESSAGE0"]
    end
  end
end
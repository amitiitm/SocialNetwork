require 'net/http'
require 'net/https'
require 'cgi'

class Paypal
  attr_accessor :gw, :q
  def initialize(gw)
    self.gw = gw
    self.q = {
      'PWD'       => gw.password,
      'USER'      => gw.login,
      'SIGNATURE' => gw.signature
    }
  end
  
  def authorize(amount, card_or_reference, options)
    merge(:method, "DoDirectPayment")
    merge("PAYMENTACTION", "Authorization")
    merge(:amt, amount/100.0)
    merge(card_or_reference.to_hash)
    merge(options)
    send_request
  end
  
  def refund(transactionid)
    merge(:method => "RefundTransaction")
    merge("REFUNDTYPE", "Full")
    merge("TRANSACTIONID", transactionid)
    send_request
  end
  
  def purchase(amount, card_or_reference, options = {})
    if card_or_reference.class == String
      merge(:method, "DoReferenceTransaction")
      merge("REFERENCEID", card_or_reference)
    else
      merge(:method, "DoDirectPayment")
      merge(card_or_reference.to_hash)
    end
    merge("PAYMENTACTION", "Sale")
    merge(:amt, amount/100.0)
    merge(options)
    send_request
  end
  
  def send_request
    http = Net::HTTP.new(self.gw.endpoint, 443)
    http.use_ssl = true
    begin
      resp, data = http.post(self.gw.path, build_request)
      begin
        resp.value
        return Response.new(data)
      rescue Exception => e
        return Response.new(false, e)
      end
    rescue Exception => e
      return Response.new(false, e)
    end
  end
  
  def build_request()
    merge(:version, self.gw.version)
    params = []
    self.q.keys.each do |k|
      params << "#{k.to_s.upcase}=#{CGI::escape(self.q[k].to_s)}"
    end
    params.join("&")
  end
  
  def merge(*args)
    if args.size == 1
      merge_with_hash(args[0])
    else
      merge_with_ke_value(args[0], args[1])
    end
  end
  
  def merge_with_hash(hash)
    self.q = self.q.merge(hash)
  end
  
  def merge_with_ke_value(k,v)
    self.q[k] = v
  end    
end
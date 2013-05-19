class Alerts < ActionMailer::Base
  def cid_problem(did, sip_headers, sent_at = Time.now)
    subject    "CID Problem with: #{did.number}"
    recipients ['mnavid@openfo.com']
    from       ['alerts@openfo.com']
    sent_on    sent_at
    
    body       :did => did, :sip_headers => sip_headers
  end

end

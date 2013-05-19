class Email::Emailer < ActionMailer::Base

  def sent_order(order)
    @subject    = 'Order Confirmed'
    @recipients = 'vijay.jain@diaspark.com'
    @from       = 'orders@diaspark.com'
    @sent_on    = Time.now
    @header    = {}
    @body["order"] = order
  end
end

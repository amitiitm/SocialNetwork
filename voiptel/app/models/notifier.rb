require 'digest/sha1'

class Notifier < ActionMailer::Base
  #include Resque::Mailer
  
  def notification(frm, to, subjct, content)
		myid = Digest::SHA1.hexdigest((Time.now.to_f * rand(10)).to_s)
    subject         subjct
    recipients      to
    from            frm
    content_type    "text/html"
    body            :content => content
    sent_on         Time.now
		headers({'In-Reply-To' => "#{myid}+msg@openfo.com", 'X-Return-Path' => "#{myid}+msg@openfo.com"})
  end

  def tehran_promo_update(user, credit,sent_at = Time.now)
    puts          "sending email to: #{user.email}"
    subject       'Balance Update - Tehran 5.9 Cents Promotion'
    recipients    user.email
    from          'OpenFo Network<support@openfo.com>'
    sent_on       sent_at
    content_type  "text/html"    
    body          :user => user, :credit => credit
  end
  
  def monday_sorry(user, sent_at = Time.now)
    puts          "sending email to: #{user.email}"
    subject       '$2 Credit for Interruption of Service'
    recipients    user.email
    from          'OpenFo Network<support@openfo.com>'
    sent_on       sent_at
    content_type  "text/html"    
    body          :user => user, :credit => 2
  end
  
  def fix_rates(user, cdrs, credit, sent_at = Time.now)
    puts          "sending email to: #{user.email}"
    subject       'Tehran Rate Adjustment - Credit Posted to Your Account'
    recipients    user.email
    cc           "support@openfo.com"
    from          'OpenFo Network<support@openfo.com>'
    sent_on       sent_at
    content_type  "text/html"    
    body          :user => user, :cdrs => cdrs, :credit => credit
  end
  
  def new_access_numbers(user, sent_at = Time.now)
    puts          "sending email to: #{user.email}"
    subject       'Please Update Your Records [New Access Numbers]'
    recipients    user.email
    from          'OpenFo Network<support@openfo.com>'
    sent_on       sent_at
    content_type  "text/html"    
    body          :user => user
  end
  
  def admin_failed_credit_card()
    subject       'New Failed Credit Card added to table'
    recipients    'adam@openfo.com'
    from          'OpenFo Network<support@openfo.com>'
    content_type  "text/html"    
  end
  
  def user_failed_credit_card(user_email)
    subject       'Your credit card failed to add fund to your Openfo Account'
    recipients     user_email
    from          'OpenFo Network<support@openfo.com>'
    content_type  "text/html"
  end

end

class Email::Email < ActiveRecord::Base
  include UserStamp
  
  belongs_to :email_configs

  #validates_presence_of :email_to,  :message => "email address cannot be blank" 
  #validates_format_of :email_to, :with => %r{^(?:[_a-z0-9-]+)(\.[_a-z0-9-]+)*@([a-z0-9-]+)(\.[a-zA-Z0-9\-\.]+)*(\.[a-z]{2,4})$}i

  def set_values(email_config_id,subject,receipients,from,email_cc,message)
    self.email_config_id = email_config_id
    self.subject = subject
    self.email_to = receipients
    self.email_from  = from
    self.email_cc = email_cc
    self.sent_on    = Time.now
    self.header    = "Content-Type: text/html; charset=utf-8"
    self.body = message
    self.company_id = 1
    self
  end
  
  def self.send_email(type,contextobj)
    #get the details of type 'New company created' from email_config table.
    email_config = Email::EmailConfig.find_by_trigger_event("#{type}")
    email = self.new
    case type
      ## TEKWELD EMAILS ####
    when 'NEWORDER'
      assigns = {}
      viewer = ActionView::Base.new(Tekweld2::Application.config.paths["app/views"].first,assigns)
      viewer.assigns[:parameter]=contextobj
      subject = "Tekweld New Order Created PO\##{contextobj.ext_ref_no}/SO\##{contextobj.trans_no}"
      neworder = viewer.render :file => 'sale/sales/new_order', :content_type => 'text/html'
      email.set_values( 
        email_config.id,
        subject,
        #        email_config.subject,
        contextobj.corr_dept_email,                      
        email_config.email_from,                        
        email_config.email_cc,                       
        neworder
      ) if email_config
      
    when 'ORDERACKNOWLEDGMENT'
      assigns = {}
      viewer = ActionView::Base.new(Tekweld2::Application.config.paths["app/views"].first,assigns)
      viewer.assigns[:parameter]=contextobj
      subject = "Tekweld Order Acknowledgement PO\##{contextobj.ext_ref_no}/SO\##{contextobj.trans_no}"
      order_acknowledgment = viewer.render :file => 'sale/sales/order_acknowledgment', :content_type => 'text/html'
      email.set_values( 
        email_config.id,
        subject,
        #        email_config.subject,
        contextobj.corr_dept_email,
        email_config.email_from,                        
        email_config.email_cc,                       
        order_acknowledgment
      ) if email_config
    when 'SENDARTWORK'
      assigns = {}
      viewer = ActionView::Base.new(Tekweld2::Application.config.paths["app/views"].first,assigns)
      viewer.assigns[:parameter]=contextobj
      subject = "Tekweld Artwork Acknowledgement PO\##{contextobj.ext_ref_no}/SO\##{contextobj.trans_no}"
      send_artwork = viewer.render :file => 'artwork/artwork/artwork_acknowledgment', :content_type => 'text/html'
      email.set_values( 
        email_config.id,
        subject,
        #        email_config.subject,
        contextobj.artwork_dept_email,
        email_config.email_from,                        
        email_config.email_cc,                       
        send_artwork
      ) if email_config
      
    when 'SHIPDATEALERT'
      assigns = {}
      viewer = ActionView::Base.new(Tekweld2::Application.config.paths["app/views"].first,assigns)
      viewer.assigns[:parameter]=contextobj
      subject = "Tekweld Order ShipDate Alert PO\##{contextobj.ext_ref_no}/SO\##{contextobj.trans_no}"
      shipdate_alert = viewer.render :file => 'sale/sales/order_shipdate_alert', :content_type => 'text/html'
      email.set_values( 
        email_config.id,
        subject,
        #        email_config.subject,
        contextobj.corr_dept_email,
        email_config.email_from,                        
        email_config.email_cc,                       
        shipdate_alert
      ) if email_config
      
    when 'FIRSTPAPERPROOFREMINDER'
      assigns = {}
      viewer = ActionView::Base.new(Tekweld2::Application.config.paths["app/views"].first,assigns)
      viewer.assigns[:parameter]=contextobj
      subject = "Tekweld FirstPaperProof Alert PO\##{contextobj.ext_ref_no}/SO\##{contextobj.trans_no}"
      ppreminder1 = viewer.render :file => 'email/email_reminder/firstpaperproofreminder', :content_type => 'text/html'
      email.set_values( 
        email_config.id,
        subject,
        #        email_config.subject,
        contextobj.artwork_dept_email,
        email_config.email_from,                        
        email_config.email_cc,                       
        ppreminder1
      ) if email_config
      
    when 'SECONDPAPERPROOFREMINDER'
      assigns = {}
      viewer = ActionView::Base.new(Tekweld2::Application.config.paths["app/views"].first,assigns)
      viewer.assigns[:parameter]=contextobj
      subject = "Tekweld SecondPaperProof Alert PO\##{contextobj.ext_ref_no}/SO\##{contextobj.trans_no}"
      ppreminder2 = viewer.render :file => 'email/email_reminder/secondpaperproofreminder', :content_type => 'text/html'
      email.set_values( 
        email_config.id,
        subject,
        #        email_config.subject,
        contextobj.artwork_dept_email,
        email_config.email_from,                        
        email_config.email_cc,                       
        ppreminder2
      ) if email_config
      
    when 'DIGITIZATION FILE ACKNOWLEDGMENT'
      assigns = {}
      viewer = ActionView::Base.new(Tekweld2::Application.config.paths["app/views"].first,assigns)
      viewer.assigns[:parameter]=contextobj
      vendor_email = contextobj.vendor.email_to if contextobj.vendor
      subject = "Tekweld Digitization File Acknowledgment PO\##{contextobj.ext_ref_no}/SO\##{contextobj.trans_no}"
      digitization_file = viewer.render :file => 'production/production/digitization_file_acknowledgment', :content_type => 'text/html'
      email.set_values( 
        email_config.id,
        subject,
        #        email_config.subject,
        vendor_email,
        email_config.email_from,                        
        email_config.email_cc,                       
        digitization_file
      ) if email_config

    when 'ESTIMATION FILE ACKNOWLEDGMENT'
      assigns = {}
      viewer = ActionView::Base.new(Tekweld2::Application.config.paths["app/views"].first,assigns)
      viewer.assigns[:parameter]=contextobj
      vendor_email = contextobj.vendor.email_to if contextobj.vendor
      subject = "Tekweld Estimation File Acknowledgment PO\##{contextobj.ext_ref_no}/SO\##{contextobj.trans_no}"
      digitization_file = viewer.render :file => 'production/production/estimation_file_acknowledgment', :content_type => 'text/html'
      email.set_values(
        email_config.id,
        subject,
        #        email_config.subject,
        vendor_email,
        email_config.email_from,
        email_config.email_cc,
        digitization_file
      ) if email_config
    when 'UNAUTHORIZEDCREDITCARDREMINDER'
      assigns = {}
      viewer = ActionView::Base.new(Tekweld2::Application.config.paths["app/views"].first,assigns)
      viewer.assigns[:parameter]=contextobj
      subject = "Tekweld Unauthorized Credit Card Alert PO\##{contextobj.ext_ref_no}/SO\##{contextobj.trans_no}"
      creditcard = viewer.render :file => 'email/email_reminder/unauthorizedcreditcardreminder', :content_type => 'text/html'
      email.set_values(
        email_config.id,
        subject,
        #        email_config.subject,
        contextobj.account_dept_email,
        email_config.email_from,
        email_config.email_cc,
        creditcard
      ) if email_config
      
    when 'ORDERSHIPPEDCOMPLETLY'
      assigns = {}
      viewer = ActionView::Base.new(Tekweld2::Application.config.paths["app/views"].first,assigns)
      viewer.assigns[:parameter]=contextobj
      subject = "Tekweld Order PO\##{contextobj.sales_order.ext_ref_no}/SO\##{contextobj.sales_order.trans_no} is Shipped."
      order = viewer.render :file => 'shipping/shipping/complete_order_shipped', :content_type => 'text/html'
      email.set_values(
        email_config.id,
        subject,
        #        email_config.subject,
        contextobj.sales_order.shipping_dept_email,
        email_config.email_from,
        email_config.email_cc,
        order
      ) if email_config

    when 'SALESINVOICE'
      assigns = {}
      viewer = ActionView::Base.new(Tekweld2::Application.config.paths["app/views"].first,assigns)
      viewer.assigns[:parameter]=contextobj
      subject = "Tekweld Invoice PO\##{contextobj.ext_ref_no}/SO\##{contextobj.ref_trans_no}/Invoice\##{contextobj.trans_no}"
      invoice = viewer.render :file => 'sale/sales_invoice/sales_invoice', :content_type => 'text/html'
      email.set_values(
        email_config.id,
        subject,
        contextobj.corr_dept_email,
        email_config.email_from,
        email_config.email_cc,
        invoice
      ) if email_config

    when 'PAYMENTAUTHORIZED'
      assigns = {}
      viewer = ActionView::Base.new(Tekweld2::Application.config.paths["app/views"].first,assigns)
      viewer.assigns[:parameter]=contextobj
      subject = "Tekweld Payment Acknowledgment PO\##{contextobj.ext_ref_no}/SO\##{contextobj.trans_no}"
      payment = viewer.render :file => 'payment/payment/payment_authorized', :content_type => 'text/html'
      email.set_values(
        email_config.id,
        subject,
        contextobj.account_dept_email,
        email_config.email_from,
        email_config.email_cc,
        payment
      ) if email_config

    when 'PAYMENTAUTHORIZATIONFAILED'
      assigns = {}
      viewer = ActionView::Base.new(Tekweld2::Application.config.paths["app/views"].first,assigns)
      viewer.assigns[:parameter]=contextobj
      subject = "Tekweld Payment Failed Acknowledgment PO\##{contextobj.ext_ref_no}/SO\##{contextobj.trans_no}"
      payment = viewer.render :file => 'payment/payment/payment_authorization_failed', :content_type => 'text/html'
      email.set_values(
        email_config.id,
        subject,
        contextobj.account_dept_email,
        email_config.email_from,
        email_config.email_cc,
        payment
      ) if email_config
    when 'SENDMULTIPLEARTWORK'
      assigns = {}
      viewer = ActionView::Base.new(Tekweld2::Application.config.paths["app/views"].first,assigns)
      viewer.assigns[:parameter]=contextobj
      subject = "Tekweld Artwork Acknowledgement PO\##{contextobj.ext_ref_no}/SO\##{contextobj.trans_no}"
      send_artwork = viewer.render :file => 'artwork/artwork/multiple_artwork_acknowledgment', :content_type => 'text/html'
      email.set_values(
        email_config.id,
        subject,
        #        email_config.subject,
        contextobj.customer_email,
        email_config.email_from,
        email_config.email_cc,
        send_artwork
      ) if email_config
    when 'STITCH APPROVAL ACKNOWLEDGMENT'
      assigns = {}
      viewer = ActionView::Base.new(Tekweld2::Application.config.paths["app/views"].first,assigns)
      viewer.assigns[:parameter]=contextobj
      customer_email = contextobj.customer.email if contextobj.customer
      subject = "Tekweld Stitch Approval Acknowledgement PO\##{contextobj.ext_ref_no}/SO\##{contextobj.trans_no}"
      order_acknowledgment = viewer.render :file => 'sale/sales/stitch_approval_acknowledgment', :content_type => 'text/html'
      email.set_values(
        email_config.id,
        subject,
        #        email_config.subject,
        contextobj.corr_dept_email,
        email_config.email_from,
        email_config.email_cc,
        order_acknowledgment
      ) if email_config
    when 'VENDOR QUERY ACKNOWLEDGMENT'
      assigns = {}
      viewer = ActionView::Base.new(Tekweld2::Application.config.paths["app/views"].first,assigns)
      viewer.assigns[:parameter]=contextobj
      subject = "Tekweld Vendor Query Acknowledgement PO\##{contextobj.ext_ref_no}/SO\##{contextobj.trans_no}"
      query_acknowledgment = viewer.render :file => 'production/production/vendor_query_acknowledgment', :content_type => 'text/html'
      email.set_values(
        email_config.id,
        subject,
        #        email_config.subject,
        email_config.email_to,
        email_config.email_from,
        email_config.email_cc,
        query_acknowledgment
      ) if email_config
    when 'ORDERSHIPPEDTOVENDOR'
      assigns = {}
      viewer = ActionView::Base.new(Tekweld2::Application.config.paths["app/views"].first,assigns)
      viewer.assigns[:parameter]=contextobj
      subject = "Tekweld Order Shipped to Vendor Acknowledgement PO\##{contextobj.ext_ref_no}/SO\##{contextobj.trans_no}"
      query_acknowledgment = viewer.render :file => 'shipping/shipping/order_shipped_to_vendor_acknowledgment', :content_type => 'text/html'
      email.set_values(
        email_config.id,
        subject,
        #        email_config.subject,
        email_config.email_to,
        email_config.email_from,
        email_config.email_cc,
        query_acknowledgment
      ) if email_config

    when 'INVOICEACKNOWLEDGMENT'
      assigns = {}
      viewer = ActionView::Base.new(Tekweld2::Application.config.paths["app/views"].first,assigns)
      viewer.assigns[:parameter]=contextobj
      subject = "Tekweld Invoice Acknowledgement PO\##{contextobj.ext_ref_no}/SO\##{contextobj.ref_trans_no}"
      order_acknowledgment = viewer.render :file => 'sale/sales_invoice/invoice_acknowledgment', :content_type => 'text/html'
      email.set_values(
        email_config.id,
        subject,
        contextobj.customer.account_dept_email,## object of sales invoice
        email_config.email_from,
        email_config.email_cc,
        order_acknowledgment
      ) if email_config
    when 'PAYMENTNOTCAPTURED'
      assigns = {}
      viewer = ActionView::Base.new(Tekweld2::Application.config.paths["app/views"].first,assigns)
      viewer.assigns[:parameter]=contextobj
      #      customer_email = 'amit.pandey@diaspark.com'
      subject = "Tekweld Payment Captured Failed PO\##{contextobj.ext_ref_no}/SO\##{contextobj.trans_no}"
      payment = viewer.render :file => 'payment/payment/payment_not_captured', :content_type => 'text/html'
      email.set_values(
        email_config.id,
        subject,
        contextobj.account_dept_email,
        email_config.email_from,
        email_config.email_cc,
        payment
      ) if email_config

    when 'FIRSTRUSHORDERPROOFREMINDER'
      contextobj.hour_count = 18
      assigns = {}
      viewer = ActionView::Base.new(Tekweld2::Application.config.paths["app/views"].first,assigns)
      viewer.assigns[:parameter]=contextobj
      subject = "Tekweld First PaperProof Alert PO\##{contextobj.ext_ref_no}/SO\##{contextobj.trans_no}"
      ppreminder = viewer.render :file => 'email/email_reminder/hourlyproofreminderforrushorders', :content_type => 'text/html'
      email.set_values(
        email_config.id,
        subject,
        contextobj.artwork_dept_email,
        email_config.email_from,
        email_config.email_cc,
        ppreminder
      ) if email_config


    when 'SECONDRUSHORDERPROOFREMINDER'
      contextobj.hour_count = 12
      assigns = {}
      viewer = ActionView::Base.new(Tekweld2::Application.config.paths["app/views"].first,assigns)
      viewer.assigns[:parameter]=contextobj
      subject = "Tekweld Second PaperProof Alert PO\##{contextobj.ext_ref_no}/SO\##{contextobj.trans_no}"
      ppreminder = viewer.render :file => 'email/email_reminder/hourlyproofreminderforrushorders', :content_type => 'text/html'
      email.set_values(
        email_config.id,
        subject,
        contextobj.artwork_dept_email,
        email_config.email_from,
        email_config.email_cc,
        ppreminder
      ) if email_config


    when 'THIRDRUSHORDERPROOFREMINDER'
      contextobj.hour_count = 6
      assigns = {}
      viewer = ActionView::Base.new(Tekweld2::Application.config.paths["app/views"].first,assigns)
      viewer.assigns[:parameter]=contextobj
      subject = "Tekweld Third PaperProof Alert PO\##{contextobj.ext_ref_no}/SO\##{contextobj.trans_no}"
      ppreminder = viewer.render :file => 'email/email_reminder/hourlyproofreminderforrushorders', :content_type => 'text/html'
      email.set_values(
        email_config.id,
        subject,
        contextobj.artwork_dept_email,
        email_config.email_from,
        email_config.email_cc,
        ppreminder
      ) if email_config


    when 'FOURTHRUSHORDERPROOFREMINDER'
      contextobj.hour_count = 3
      assigns = {}
      viewer = ActionView::Base.new(Tekweld2::Application.config.paths["app/views"].first,assigns)
      viewer.assigns[:parameter]=contextobj
      subject = "Tekweld Fourth PaperProof Alert PO\##{contextobj.ext_ref_no}/SO\##{contextobj.trans_no}"
      ppreminder = viewer.render :file => 'email/email_reminder/hourlyproofreminderforrushorders', :content_type => 'text/html'
      email.set_values(
        email_config.id,
        subject,
        contextobj.artwork_dept_email,
        email_config.email_from,
        email_config.email_cc,
        ppreminder
      ) if email_config


    when 'FIFTHRUSHORDERPROOFREMINDER'
      contextobj.hour_count = 1
      assigns = {}
      viewer = ActionView::Base.new(Tekweld2::Application.config.paths["app/views"].first,assigns)
      viewer.assigns[:parameter]=contextobj
      subject = "Tekweld Fifth PaperProof Alert PO\##{contextobj.ext_ref_no}/SO\##{contextobj.trans_no}"
      ppreminder = viewer.render :file => 'email/email_reminder/hourlyproofreminderforrushorders', :content_type => 'text/html'
      email.set_values(
        email_config.id,
        subject,
        contextobj.artwork_dept_email,
        email_config.email_from,
        email_config.email_cc,
        ppreminder
      ) if email_config
      ## sales estimate
    when 'SENDESTIMATE'
      assigns = {}
      viewer = ActionView::Base.new(Tekweld2::Application.config.paths["app/views"].first,assigns)
      viewer.assigns[:parameter]=contextobj
      subject = "Tekweld Estimate \##{contextobj.trans_no}"
      invoice = viewer.render :file => 'sale/sales_quotation/sales_estimate', :content_type => 'text/html'
      email.set_values(
        email_config.id,
        subject,
        contextobj.corr_dept_email,
        #        contextobj.shipping_dept_email,
        email_config.email_from,
        email_config.email_cc,
        invoice
      ) if email_config

    when 'DISCOUNTCOUPONAPPROVED'
      assigns = {}
      viewer = ActionView::Base.new(Tekweld2::Application.config.paths["app/views"].first,assigns)
      viewer.assigns[:parameter]=contextobj
      subject = "Congratulations You Have Won! a Discount Coupon\##{contextobj.coupon_code}"
      coupon = viewer.render :file => 'setup/discount_coupon/approve_discount_coupon', :content_type => 'text/html'
      email.set_values(
        email_config.id,
        subject,
        contextobj.customer.corr_dept_email,
        email_config.email_from,
        email_config.email_cc,
        coupon
      ) if email_config

    when 'New User Create'   
      #get the email id for company new user creation
      email_id = contextobj.email
      email_id = email_config.email_to if [nil, ''].include?(email_id)
      #newly added
      assigns = {}
      viewer = ActionView::Base.new(Tekweld2::Application.config.paths["app/views"].first,assigns)
      viewer.assigns[:parameter]=contextobj
      company_html = viewer.render :file => 'main/new_company', :content_type => 'text/html'       
      puts company_html
      #create new email with the fetched values.
      email.set_values( email_config.id,
        email_config.subject,
        email_id,
        email_config.email_from,
        email_config.email_cc,
        company_html
        #                        "Dear #{contextobj.first_name} #{contextobj.last_name}, You can login to retail application using this url http://localhost:3000/bin/RetailNew.  Login:  #{contextobj.email} and password: #{contextobj.password}"
      ) if email_config
    when 'Forgot Password'   
      #get the email id for the user
      email_id = contextobj.email
      email_id = email_config.email_to if [nil, ''].include?(email_id)
      #create new email with the fetched values.
      email.set_values( email_config.id,
        email_config.subject,
        email_id,
        email_config.email_from,
        email_config.email_cc,
        "Dear #{contextobj.first_name} #{contextobj.last_name}, Your password has been reset. New Password is #{contextobj.password}"
      ) if email_config
    when 'Notes'
      config_id = email_config.id if email_config
      #contextobj.email_from ||= email_config.email_from if email_config
      contextobj.email_from = email_config.email_from if [nil, ''].include?(contextobj.email_from)
      email.set_values( config_id,
        contextobj.subject,
        contextobj.email_to,
        contextobj.email_from,
        contextobj.email_cc,
        contextobj.description
      ) 
    when 'New Catalog User Create'   
      #get the email id for company new user creation
      email_id = contextobj.email
      #email_id = email_config.email_to if [nil, ''].include?(email_id)
      #create new email with the fetched values.
      assigns = {}
      viewer = ActionView::Base.new(Tekweld2::Application.config.paths["app/views"].first,assigns)
      viewer.assigns[:parameter]=contextobj
      order_html = viewer.render :file => 'customer/new_catalog_user', :content_type => 'text/html' 
      email.set_values( email_config.id,
        "Welcome to Website",
        email_id,
        email_config.email_from,
        email_config.email_cc,
        #"Dear #{contextobj.name}, Thanks for registering at our website. Your user id is #{contextobj.code} and password is #{contextobj.password}"
        order_html
      ) if email_config
    when 'New Catalog Order'   
      #get the email id for company new user creation
      email_id = contextobj.customer.email
      #email_id = email_config.email_to if [nil, ''].include?(email_id)
      #create new email with the fetched values.
      assigns = {}
      viewer = ActionView::Base.new(Tekweld2::Application.config.paths["app/views"].first,assigns)
      viewer.assigns[:parameter]=contextobj
      order_html = viewer.render :file => 'customer/new_catalog_order', :content_type => 'text/html' 
      email.set_values( email_config.id,
        "New Store Transfer Issue #{contextobj.trans_no} created",
        email_id,
        email_config.email_from,
        email_config.email_cc,
        #                        "Dear #{contextobj.customer.name}, Thanks for placing order with us. Your new order no. #{contextobj.trans_no}"
        order_html
      ) if email_config
    when 'Store Transfer Issue'   
      #get the email id for transfered store.
      store_id = contextobj.trans_type_id
      companies = Setup::Company.find_by_id(store_id)
      email_id = companies.email_to
      assigns = {}
      viewer = ActionView::Base.new(Tekweld2::Application.config.paths["app/views"].first,assigns)
      viewer.assigns[:parameter]=contextobj
      store_transfer_html = viewer.render :file => 'inventory/store_transfer_issue', :content_type => 'text/html' 
      email.set_values( email_config.id,
        "New Store Transfer: Receipt #{contextobj.trans_no} created",
        email_id,
        email_config.email_from,
        email_config.email_cc,
        store_transfer_html
      ) if email_config
    when 'Store Transfer Receive'   
      #get the email id for transfered store.
      store_id = contextobj.trans_type_id
      companies = Setup::Company.find_by_id(store_id)
      email_id = companies.email_to
      assigns = {}
      viewer = ActionView::Base.new(Tekweld2::Application.config.paths["app/views"].first,assigns)
      viewer.assigns[:parameter]=contextobj
      store_transfer_html = viewer.render :file => 'inventory/store_transfer_receive', :content_type => 'text/html' 
      email.set_values( email_config.id,
        "New Order #{contextobj.trans_no} created",
        email_id,
        email_config.email_from,
        email_config.email_cc,
        store_transfer_html
      ) if email_config
      
    when 'Catalog User from Retail'   #added by Minal on 1aug
      #get the email id for company new user creation
      email_id = contextobj.email
      email_id = email_config.email_to if [nil, ''].include?(email_id)
      #newly added
      assigns = {}
      viewer = ActionView::Base.new(Tekweld2::Application.config.paths["app/views"].first,assigns)
      viewer.assigns[:parameter]=contextobj
      company_html = viewer.render :file => 'customer/new_customer_login', :content_type => 'text/html'       
      puts company_html
      #create new email with the fetched values.
      email.set_values( email_config.id,
        email_config.subject,
        email_id,
        email_config.email_from,
        email_config.email_cc,
        company_html
        #                        "Dear #{contextobj.first_name} #{contextobj.last_name}, You can login to retail application using this url http://localhost:3000/bin/RetailNew.  Login:  #{contextobj.email} and password: #{contextobj.password}"
      ) if email_config
    else
      email = nil
    end
    email
  end
  
  def save_this_mail
    self.save!
  end
end

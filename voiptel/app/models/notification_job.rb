module NotificationJob
  @queue = :notification
  
  def self.perform notification_id, user_id
    v = MY_VIEW
    user = User.find(user_id)
    faqs = Faq.all
    nt = NotificationTemplate.find(notification_id)
    template = nt.liquid_template
    
    content = template.render('user' => user, 'faqs' => faqs)
    content = v.render(:partial => "notification_templates/main_template", :locals => {:content => content, :subject => nt.subject})

    begin
      delivered = true
      if RAILS_ENV == "production"
        Notifier.deliver_notification("#{nt.from_name} <#{nt.from_address}>", user.email, nt.subject, content)
      end      
    rescue 
      delivered = false
    end        
    
    if user.class == User
      emailable = user.account
    else
      emailable = user
    end
    
    notification = Notification.new(
      :content                    => content,        
      :subject                    => nt.subject,     
      :from_name                  => nt.from_name,   
      :from_address               => nt.from_address,
      :to_name                    => user.full_name, 
      :to_address                 => user.email,
      :notification_template_id   => nt.id,
      :notification_category_id   => nt.category.id,
      :memo_update_id             => nil,
      :delivered                  => true
    )
    
    emailable.notifications     << notification
    nil    
  end
end
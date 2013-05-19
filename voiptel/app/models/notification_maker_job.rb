module NotificationMakerJob
  @queue = :notification_maker
  
  def self.perform notification_template_id
    for a in Account.find(:all, :conditions => {:status => 1})
      for u in a.users.find(:all, :select => "id, email")
        unless u.email.blank?
          Resque.enqueue(NotificationJob, notification_template_id, u.id)
        end
      end
    end
  end
end
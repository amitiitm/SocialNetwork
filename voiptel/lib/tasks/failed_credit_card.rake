task :failed_credit_card => :environment do
  
  @time_now= Time.now().strftime('%Y-%m-%d %H:%M:00')
  my_time = (Time.now() - 300).strftime('%Y-%m-%d %H:%M:00')
   
  @failed_credits = OrderTransaction.find(:all, :conditions => ["created_at  >= ? and created_at  <=? and success =? ", my_time,@time_now,0])
  
  if !@failed_credits.nil?
    @failed_credits.each do |failed_credit|
      Notifier.deliver_admin_failed_credit_card()
      @user_email = failed_credit.account.user.email
      if !@user_email.blank? and !@user_email.nil?
        Notifier.deliver_user_failed_credit_card(@user_email)
      end
    end
  end
end

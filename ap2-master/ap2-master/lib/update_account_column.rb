class UpdateRecord
  def update_account
    success = []
    failure = []
    Account.find(:all, :conditions => ["accounts.status=1"]).each do |account|
      pbx_cdr =PbxCdr.find(:first,
                           :conditions => {:contactable_type => "User", :contactable_id => account.users},
                           :order => "date DESC")
      ot = account.order_transactions.find(:first, :conditions => ["success=?", true], :order => "created_at DESC")
      answered_cdr = account.cdrs.answered.last
      unless pbx_cdr.blank?
        account.last_conversation_id = pbx_cdr.id
        account.last_conversation_date = pbx_cdr.date
      end
      unless ot.blank?
        account.last_deposit_amount = ot.full_amount
        account.last_deposit_date = ot.created_at
      end
      unless answered_cdr.blank?
        account.last_answered_cdr = answered_cdr.date
      end

      begin
        if account.save!
          success << User.find(account.account_holder_id).first_name
        end
      rescue Exception => e
        Rails.logger.info e
        failure << User.find(account.account_holder_id).first_name
      end
    end
    Rails.logger.info "*******************Success*****************************************"
    Rails.logger.info success.inspect
    Rails.logger.info "*******************Failure*****************************************"
    Rails.logger.info failure.inspect

    p "*******************Success*****************************************"
    p success.inspect
    p "*******************Failure*****************************************"
    p failure.inspect
  end
end

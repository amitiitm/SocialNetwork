class PbxCdr < ActiveRecord::Base
  belongs_to :admin_user
  belongs_to :contactable, :polymorphic => true
  belongs_to :memo

  after_save :update_account

  def update_account
    begin
      if self.contactable_type == "User"
        account = User.find(self.contactable_id).account
        account.last_conversation_id = self.id
        account.last_conversation_date = Date.today
        account.save
      end
    rescue
    end
  end

  def clear_missed_call_from_inbound
    inbound_calls = PbxCdr.find(:all, :order => "date DESC", :conditions => "disposition_status = 1 AND disposition='VOICEMAIL_in'", :group => 'cid')
    inbound_missed_calls = inbound_calls.select{|x| x.duration <= 5 }
    inbound_missed_calls.each do |pbx_cdr|
      formatted_date = pbx_cdr.date.utc.to_formatted_s(:db)
      outbound_latest_call = PbxCdr.find(:first, :order => "date DESC", :conditions => ["dst_number=? AND date > ? AND disposition='ANSWER'", pbx_cdr.cid, formatted_date])
      unless outbound_latest_call.blank?
        formatted_date = outbound_latest_call.date.utc.to_formatted_s(:db)
        PbxCdr.update_all("disposition_status = 0", ["date < ? AND disposition_status=1 AND duration < 5 AND disposition='VOICEMAIL_in' AND cid=?", formatted_date, pbx_cdr.cid])
      end
    end
    
  
    inbound_vm_calls = inbound_calls.select{|x| x.duration > 5 }
    inbound_vm_calls.each do |pbx_cdr|
      outbound_latest_call = PbxCdr.find(:first, :order => "date DESC", :conditions => ["dst_number=? AND date > ? AND disposition=?", pbx_cdr.cid, pbx_cdr.date, 'ANSWER'])
      unless outbound_latest_call.blank?
        formatted_date = outbound_latest_call.date.utc.to_formatted_s(:db)
        PbxCdr.update_all("disposition_status = 2", ["date < ? AND disposition_status = 1 AND duration > 5 AND disposition='VOICEMAIL_in' AND cid=?", formatted_date, pbx_cdr.cid])
      end
    end
  end
end

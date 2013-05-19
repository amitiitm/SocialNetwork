class Forwarding < ActiveRecord::Base
  belongs_to :did
  belongs_to :account
  belongs_to :forwardable, :polymorphic => true
  
  before_destroy :clear_did
  
  private
  
  def clear_did
    self.did.did_type = 0
    self.did.save
    
    self.account.acc_dids.find(:first, :conditions => {:account_id => self.account.id, :did_id => self.did.id}).delete
  end
end

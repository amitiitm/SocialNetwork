class AccountDid < ActiveRecord::Base
  belongs_to :account
  belongs_to :did
  has_many :account_dids
  
  named_scope :find_account_did, lambda { |account, did| {:conditions => ["account_id = ? and did_id = ?", account.id, did.id]} }
  named_scope :find_by_account_and_area_code, lambda {|account, area_code| {:conditions => ["account_id = ? and area_code = ?", account.id, area_code]}}
  
  
  def assigned_dids
    AssignedDid.find(:all, :conditions => {:account_id => account.id, :did_id => did.id})
  end
end

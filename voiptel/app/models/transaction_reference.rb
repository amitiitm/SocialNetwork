class TransactionReference < ActiveRecord::Base
  has_many :transactions
  has_many :order_transactions
  belongs_to :user
  belongs_to :address
  belongs_to :account
  default_scope :conditions=>{:is_deleted=>false}, :order => 'position ASC'

    def self.all_tr(tr_id)
      with_exclusive_scope{TransactionReference.find_by_id(tr_id)}
    end

end

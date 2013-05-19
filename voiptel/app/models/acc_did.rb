class AccDid < ActiveRecord::Base
  set_table_name "acc_did"
  belongs_to :account
  belongs_to :did
end

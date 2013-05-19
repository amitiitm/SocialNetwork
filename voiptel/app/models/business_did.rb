class BusinessDid < ActiveRecord::Base
  belongs_to :account
  belongs_to :did
end

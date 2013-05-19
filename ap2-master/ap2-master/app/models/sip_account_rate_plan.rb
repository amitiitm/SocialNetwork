class SipAccountRatePlan < ActiveRecord::Base
  belongs_to :rate_plan
  belongs_to :sip_account
end

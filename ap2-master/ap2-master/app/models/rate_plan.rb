class RatePlan < ActiveRecord::Base
  #has_many :rate_plans_promotions
  has_many :promotions, :dependent => :destroy
  has_many :sip_accounts #, :through => :sip_account_rate_plans
  
  accepts_nested_attributes_for :promotions, :allow_destroy => true
  
  validates_presence_of :name, :message => "Rate plan name can't be blank"
end

class AccountPromotion < ActiveRecord::Base
  attr_accessor :rate_in_cents
  
  belongs_to :account
  belongs_to :country, :class_name => "V2Country", :foreign_key => "country_id"
  
  validates_presence_of :name,  :message => "Promotion name can't be blank!"
  validates_presence_of :prefix,  :message => "Prefix can't be blank"
  validates_presence_of :days,  :message => "Days can't be blank"
  validates_presence_of :rate,  :message => "Rate can't be blank"
  validates_presence_of :account_id
  
  def rate_in_cents
    if self.rate.blank?
      ""
    else
      self.rate.to_f * 100
    end
  end
  
  def rate_in_cents=(in_cents)    
    if in_cents.blank?
      self.rate = nil
    else
      self.rate = in_cents.to_f / 100
    end    
  end
  
end

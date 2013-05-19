class Referral < ActiveRecord::Base
  attr_accessor :referred
  attr_accessor :match_user_id

  belongs_to :account
  before_update :update_referrer
  #belongs_to :account, :foreign_key => "referred_account_id"
  
  validates_presence_of :referrer_first_name, :if => :is_referred?, :message => "Please enter the first name of the person who reffered you"
  validates_presence_of :referrer_last_name, :if => :is_referred?, :message => "Please enter the last name of the person who reffered you"
  validates_presence_of :referred, :message => "Please indicate whether you were reffered to OpenFo by anyone"
  
  def is_referred?
    self.referred == "yes"
  end
  
  def referred_account
    Account.find(self.referred_account_id)
  end
  
  def phone
    p = self.referrer_phone_number.gsub(/[^0-9]/,"")
    if not p.blank?
      Phone.find(:first, :conditions => ["number like ?", "%#{p}%"])
    else
      nil
    end
  end
  
  def update_referrer
    if not self.match_user_id.blank?
      self.referrer_user_id = self.match_user_id
      u = User.find(self.match_user_id) 
      self.referrer_account_id = u.account.id
      self.match_date = Time.now
      self.mapped = true
    end
  end
end

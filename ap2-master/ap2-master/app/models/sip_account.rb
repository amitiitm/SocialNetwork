class SipAccount < ActiveRecord::Base
	#establish_connection DB_OPENSIPS
  set_table_name "subscriber"
  
  belongs_to :account
  belongs_to :rate_plan
  has_one :forwarding, :as => :forwardable, :dependent => :destroy
  has_one :vm_box, :class_name => "VMBox", :foreign_key => "subscriber_id", :dependent => :destroy
  has_many :sip_locations, :class_name => "SipLocation", :primary_key => "username", :foreign_key => "username"
    
  validates_presence_of :cid_number, :message => "Caller ID Number can't be blank"
  validates_presence_of :area_code, :message => "Area code can't be blank"
  validates_presence_of :did_id, :message => "Please select a DID Number", :on => :create
  
  attr_accessor :did_number, :plans, :vm_email, :did_id
  
  before_create :create_vm_box
  after_create :create_did
  
  CODECS = [
    ["PCMU", "PCMU"],
    ["G729", "G729"]
  ]
  
  TIMEOUT = [[20, 20], [30, 30], [45, 45], [60, 60]]
  
  def cid
    "#{self.cid_name} <#{self.cid_number}>"
  end    
  
  def vm_email
    if self.new_record?
      self.account.account_holder.email
    else
      self.vm_box.email
    end
  end
  
  def vm_email=(email)
    unless self.new_record?
      self.vm_box.email = email
      self.vm_box.save
    end
  end
  
  def has_rate_plan?(plan)
    (self.rate_plans.find(:first, :conditions => {:id => plan.id})) ? true : false
  end
  
  def self.random_text(size = 6, first_set = "num", slice = 2, seperate = "")
    chars = (('a'..'z').to_a - %w(i o l ))
    nums  = (2..9).to_a

    password = ""
    next_letter = first_set
    counter = 0

    size.times do
      if next_letter == "char"
        password += chars[rand(chars.size)]
      else
        password += nums[rand(nums.size)].to_s
      end
      counter += 1
      if counter == slice
        password += seperate
        counter = 0
        if next_letter == "char"
          next_letter = "num"
        else
          next_letter = "char"
        end
      end
    end
    if password[-1..-1] == "-"
      password[0..-2]
    else
      password
    end
  end
  
  private  

  def create_did
    did = Did.find(self.did_id)
    return unless did
    unless self.account.dids.find(:first, :conditions => {:id => did.id})
      self.account.dids << did
      did.did_type = 2
      did.save
    end
    unless self.forwarding
      self.forwarding = Forwarding.new(:rate => 0, :did_id => did.id, :account_id => self.account.id)
      self.forwarding.save
    end
  end
  
  def create_vm_box
    vm_box = VMBox.new
    vm_box.email = self.vm_email
    vm_box.mailbox = self.username
    vm_box.full_name = self.account.account_holder.name
    self.vm_box = vm_box
  end
end

class Phone < ActiveRecord::Base
  include ActionView::Helpers::NumberHelper
  # Associations
  belongs_to :user
  belongs_to :account
  belongs_to :area_code_info

  has_one :assigned_did, :dependent => :destroy
  has_many :cdrs
  
  # Callbacks
  before_validation :append_one_to_number
  before_validation :combine_number
  before_save :convert_number_to_old_fields
  
  before_save :set_area_code_info
  before_save :set_account
	before_save :check_area_code
  after_update :remove_assigned_did
  
  # Validations:
  validates_presence_of :number, :message => "Phone number can't be blank"
  validate :uniqueness_of_number
  validate :format_of_number, :if => :number_is_not_blank
  
  attr_accessor :remove, :dont_save
  attr_accessor :i_call_it_tmp_number_god_damn_it
  #attr_accessor :lat_long
  
  PHONE_TYPES = [
    ["Home", 1],
    ["Mobile", 2],
    ["Work", 3]
  ]
  
  PHONE_TYPE_NAMES = {
    1 => "Home",
    2 => "Mobile",
    3 => "Work"
  }
  
  TYPES = [
    ["Home", 1],
    ["Mobile", 2],
    ["Work", 3]
  ]
  
  HOME = 1
  MOBILE = 2
  WORK = 3
  
  liquid_methods :formatted_number, :formatted_did
  
  def formatted_number
    number_to_phone(self.number, :area_code => true)
  end
  
  def formatted_did
    did = "1(877) 810-3003 *Toll Free*"
    if self.assigned_did
      did = number_to_phone(self.assigned_did.did.number, :area_code => true)
    end
    did
  end
  
  def type_name
    PHONE_TYPE_NAMES[self.phone_type]
  end

  def type_name_short
    PHONE_TYPE_NAMES[self.phone_type][0..0]
  end
    
  
  def set_account
    unless self.account_id
      self.account_id = self.user.account_id
    end
  end
  
  def complete_phone_number
    "#{country_code}#{area_code}#{phone_number}"
  end
  
  def assign_did(did)    
    # create account_did if needed
    account_did = AccountDid.find_account_did(account, did).first

    unless account_did
      account_did = AccountDid.new(:account_id => account.id, :did_id => did.id,
                                  :area_code => did.area_code)
      account_did.save
    end
    AssignedDid.destroy_all(:phone_id=>self.id,:account_id=>account.id,:user_id=>user.id)
    assigned_did = AssignedDid.new(:did_id => did.id, :phone => self, :account => account,
                                  :user => user, :area_code => area_code,
                                  :account_did => account_did)
    assigned_did.save
    self.assigned_did = assigned_did
    self.save
  end
  
  def lat_long
    LatLong.new(area_code_info.lat, area_code_info.long)
  end
  
  def npanxx
    "#{self.area_code}#{self.phone_number[0..2]}"
  end
  
  
  private
  
  def combine_number
   if self.number.blank?
     self.number = "#{self.country_code}#{self.area_code}#{self.phone_number}"
   end
  end
  
  def format_of_number
    unless (self.number.match(/\A[1]?[2-9][0-8][0-9][2-9][0-9]{6}\z/))
      self.errors.add(:number, "Phone number #{self.number} is not a valid U.S. number.")
    end
  end
  
  def uniqueness_of_number
    if (phone = Phone.find_by_number(self.number) and new_record?)
      if (phone.account_id == self.account_id)
        if phone.deleted
          phone.deleted = false
          phone.save
          self.dont_save = true
        else
          self.errors.add(:number, "Phone number #{number} is already registered under your account.")
        end
      else
        self.errors.add(:number, "Phone number #{number} is already registered under another account.
                        Please contact customer support for assistance.")
      end
    end
  end
  
  def number_is_not_blank
    !self.number.blank?
  end
  
  def append_one_to_number
    unless self.number.blank?
      if (self.number.length == 10)
        self.number = "1#{self.number}"
      end
    end
  end
  
  def area_code_and_phone_number_are_empty
    self.country_code.blank? && self.area_code.blank? && self.phone_number.blank?
  end
    
  def remove_assigned_did
    if changes["number"]
      if assigned_did
        assigned_did.destroy
        self.account.assign_dids
      end
    end
  end
  
  def update_assigned_did
    if changed?
      Counter.inc
      assign_did
    end
  end
  
  def sorted_did_locations    
    did_locations = DidRateCenterLocation.find(:all, :conditions => {:npa => area_code})     
    did_locations = did_locations.sort_by {|location| location.distance_to(self.lat_long)}
  end
  
  def suggest_did_locations
    # first see if there are other dids associated w/ this account
    account_assigned_dids = AssignedDid.find(:all, :conditions => {:account_id => account.id})
    
  end

  def check_area_code
		area_code = AreaCode.find(:first, :conditions => {:area_code => self.area_code})
		unless area_code
			area_code = AreaCode.new
			area_code.area_code = self.area_code
			area_code.country_id = 1
			area_code.save
		end
	end
	
	def convert_number_to_old_fields
	 self.country_code = "1"
	 self.area_code = self.number[1..3]
	 self.phone_number = self.number[4..-1]
	end
	
  def set_area_code_info
    update_area_code_info = false    
    # if record was changed and changes was specificly make to the area_code_info do not set it again
    if changed?
      if changes["area_code_info"]
        update_area_code_info = true
      end
    end
    
    # if phone is a new record set area_code_info on it    
    if new_record?
      update_area_code_info = true
    end
    
    # just a simple flag to see if it has to set the area_code info or not    
    if update_area_code_info
      area_code_info = AreaCodeInfo.find(:first, :conditions => {:npanxx => npanxx.to_i})
      self.area_code_info = area_code_info
    end
  end
  
end

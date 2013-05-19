class Did < ActiveRecord::Base
  belongs_to :country
  #belongs_to :area_code
  belongs_to :vendor
  belongs_to :npanxx
  belongs_to :area_code_info
  #belongs_to :rate_center
  belongs_to :did_rate_center_location
  belongs_to :did_provider
  has_many :cid_problems  
  has_many :assigned_dids, :dependent => :destroy
  has_many :account_dids
  has_many :cdrs
  has_many :card_cdrs;
  has_many :tmp_phones
  
  has_many :acc_dids

  has_one :account, :through => :acc_did

  has_many :vms
  
  has_many :forwardings
  has_one :account, :through => :forwardings

    # callbakcs:  
  before_create :set_country, :set_area_code, :set_area_code_info, :set_did_rate_center_location
  # this should be handled in the after_destroy reassign call
#  before_destroy :inform_phones
  after_destroy :remove_did_rate_center_location
  after_destroy :reassign_did_to_phones
#  after_save :reassign_did_to_phones_if_not_active
  
  attr_accessor :numbers
  
  
  named_scope :available_dids, lambda { |args| {:conditions => ["area_code_id = ? and active = ? and did_type = ?", args.id, true, 1]} }
  
  TYPES = [
    ["Not Allocated", 0],
    ["AC / CC", 1],
    ["Forwarding", 2],
    ["Fax", 3],
    ["OpenFo Incomming", 4],
    ["Promo", 5]
  ]
  
  CALLING_CARD = 1
  B2B = 2
  FAX = 3
  
  def npanxx_number
    self.number[1..6]
  end
  
  def npa_number
    self.number[1..3]
  end
  
  def can_be_used_with?(phone)
    unless self.active
      puts "DID is not active dudes!"
      return false
    end
    unless phone.area_code_info and self.area_code_info
      puts "I don't have area_code_infos"
      return false
    end
    puts "PHONE RC: #{phone.area_code_info.ratecenter} DID RC: #{self.area_code_info.ratecenter}"
    if phone.area_code_info.ratecenter == self.area_code_info.ratecenter
      puts "MATCHING RATE CENTER I SHOULD USE THIS DID: #{self.number}"
      return true
    else
      distance = area_code_info.distance_to(phone.area_code_info)
      puts "D: #{distance}"
#      (distance <= 11.9) ? distance : false
	# requirement change, max distance can be 9
      (distance <= 7) ? distance.to_f : false
    end
  end
  
  def set_area_code
    self.area_code = self.number[1..3]
#    area_code_number = self.number[1..3]
#    area_code = AreaCode.find(:first, :conditions => {:area_code => area_code_number })
#    unless area_code
#      area_code = AreaCode.new
#      area_code.area_code = area_code_number
#      area_code.country_id = 1
#    end
#    area_code.save
#    self.area_code = area_code
#    self.area_code_id = area_code.id
  end
  
  def self.select_options_for_rate_centers
    Did.find(:all, :select => "DISTINCT rate_center, COUNT(rate_center) as count", :conditions =>["rate_center IS NOT NULL and rate_center != ''"], :group => "rate_center asc").map {|r| ["#{r.rate_center} (#{r.count})", r.rate_center]}
  end
  
  def self.select_options_for_area_code
    Did.find(:all, :select => "DISTINCT area_code, COUNT(area_code) as count", :conditions =>["area_code IS NOT NULL and area_code != ''"], :group => "area_code asc").map {|r| ["#{r.area_code} (#{r.count})", r.area_code]}
  end
  
  private
  def inform_phones
      if self.assigned_dids
          self.assigned_dids.each do |assigned_did|
              assigned_did.phone.notes=''
              assigned_did.phone.save
          end
      end
  end

  def remove_did_rate_center_location
    if did_rate_center_location
      if did_rate_center_location.dids.size == 0
        DidRateCenterLocation.delete(did_rate_center_location)      
      end
    end
  end
  
  def set_country
    self.country_id = 1
  end
=begin  
  def set_npanxx_and_rate_center  
      npa = self.number[1..3]
      nxx = self.number[4..6]
      npanxx = Npanxx.find(:first, :conditions=>{:npa => npa, :nxx => nxx})
      unless npanxx
        npanxx = RateCenterInfo::get_record(npa, nxx)
      end
      if npanxx
        self.npanxx = npanxx
        self.rate_center = npanxx.rate_center        
      end
  end
=end

  def set_area_code_info
    area_code_info = AreaCodeInfo.find(:first, :conditions => {:npanxx => self.npanxx_number.to_i})
    self.area_code_info = area_code_info
    if area_code_info
      self.lat = area_code_info.lat
      self.long = area_code_info.long
      self.rate_center = area_code_info.ratecenter
      self.lata = area_code_info.lata
    end
  end
  

  def set_did_rate_center_location
    if self.area_code_info
      rate_center_location = DidRateCenterLocation.find(:first, :conditions => {:area_code_info_id => self.area_code_info.id,
        :lat => self.area_code_info.lat.to_s, :long => self.area_code_info.long.to_s})
      unless rate_center_location
        rate_center_location = DidRateCenterLocation.new
        rate_center_location.npa = self.area_code_info.npa
        rate_center_location.lat = self.area_code_info.lat
        rate_center_location.long = self.area_code_info.long
       #rate_center_location.rate_center = self.npanxx.rate_center
        rate_center_location.area_code_info = self.area_code_info
        rate_center_location.save
      end
    end
    self.did_rate_center_location = rate_center_location
  end

  def reassign_did_to_phones
      puts "Reassigning dids to floating phones size is #{assigned_dids.count}"
      assigned_dids.each do |assigned_did|
          puts "Reassigning to #{assigned_did.phone.number}"
          PhoneDidHandler.process_new_phone Phone.find(assigned_did.phone.id)
      end
  end
public
  def reassign_did_to_phones_if_not_active
      self.assigned_dids.each{|assigned_did| assigned_did.destroy} if not active
      if active
          # find all phones belonging to this area code and this rate center
          puts "*************** did save complete #self.inspect}"
          if area_code
              PhoneDidHandler.reassign_phone_dids_for_area_code area_code
          end
          PhoneDidHandler.reassign_phone_dids_for_rate_center(rate_center) if rate_center
      end
  end 
end

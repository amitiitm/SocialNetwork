class Lead < ActiveRecord::Base
  include ActionView::Helpers::NumberHelper
  has_one :memo , :as => :memoable
  
  belongs_to :created_by, :class_name => "AdminUser", :foreign_key => "admin_user_id"
  
  has_many :notifications, :as => :emailable
  has_many :pbx_cdrs, :as => :contactable
  
  attr_accessor :file, :upload
  
  liquid_methods :first_name, :last_name, :email, :full_name
  
  ZONES = {
    "10"  => "Hawaii",
    "9"   => "Alaska",
    "8"   => "Pacific Time (US & Canada)",
    "7"   => "Mountain Time (US & Canada)",
    "6"   => "Central Time (US & Canada)", 
    "5"   => "Eastern Time (US & Canada)"
  }
  
  STATUS = [
    ["New", "0"],
    ["In Progress", "1"],
    ["Converted", "2"],
    ["Rejected", "3"],
    ["Problem", "4"]
  ]
  
  STATUS_STRINGS = ["New", "In Progress", "Converted", "Rejected", "Problem"]
  
  def select_options_for_contactable
    [["#{self.info}", 1]]
  end
  
  def select_options_for_contactable_number(contactable_id)
    [["#{number_to_phone(self.phone, :area_code => true)}", 1]]
  end
  
  def user_for_convert
    user = User.new
    user.first_name = self.first_name || ""
    user.last_name = self.last_name || ""
    user.email = self.email || ""
    user.phones << Phone.new(:number => self.phone.gsub(/(\D+)/, ""))
    user.auth_user = AuthUser.new(:email => (self.email || nil))
    user
  end
  
  def self.zip_codes
    Lead.find(:all, :select => "DISTINCT zip_code, COUNT(zip_code) as count", :conditions =>["zip_code IS NOT NULL and zip_code != ''"], :group => "zip_code asc").map {|l| ["#{l.zip_code} (#{l.count})", l.zip_code]}
  end
  
  def self.area_codes
    Lead.find(:all, :select => "DISTINCT area_code, COUNT(area_code) as count", :conditions =>["area_code IS NOT NULL and area_code != ''"], :group => "area_code asc").map {|l| ["#{l.area_code} (#{l.count})", l.area_code]}
  end
  
  def self.states
    Lead.find(:all, :select => "DISTINCT state, COUNT(state) as count", :conditions =>["state IS NOT NULL and state != ''"], :group => "state asc").map {|l| ["#{l.state} (#{l.count})", l.state]}
  end
  
  def self.time_zones
    Lead.find(:all, :select => "DISTINCT time_zone", :conditions =>["time_zone IS NOT NULL and time_zone != ''"]).map {|l| [l.time_zone, l.time_zone]}
  end
  
  def args_for_call_link(contactable_id, memo, admin_user)
    args = {}
    args['contactable_type'] = "Lead"
    args['contactable_id'] = contactable_id
    args['ext'] = admin_user.ext
    args['admin_user_id'] = admin_user.id
    args['cid'] = "19493257005"
    args['memo_id'] = memo.id
    args.to_param.gsub("&", "|")
  end
  
  def status_string
    STATUS_STRINGS[self.status]
  end

  def import
    f = File.new(self.file.path, "r")
    while line = f.gets
      l = Lead.new
      l.admin_user_id = 0
      line = line.gsub(/\D/, "")
      l.phone = line
      l.phone = "1#{l.phone}" if l.phone.length == 10        
      l.set_lead_info
      l.save
    end
  end
  
  def user
    self
  end
  
  def first_name=(name)
    self[:first_name] = name.strip
  end
  
  def last_name=(name)
    self[:last_name] = name.strip
  end
  
  def email=(email)
    self[:email] = email.strip
  end
  
  def full_name
    name = "#{first_name} #{last_name}"
    return nil if name.blank?
    name.strip
  end
  
  def info
    full_name || number_to_phone(self.phone, :area_code => true)
  end
  
  def self.find_without_memo(options = {})
    conditions = ""
    if options[:conditions]
      if not options[:conditions].blank?
        conditions = "AND #{options[:conditions]}"
      end      
      options.delete(:conditions)
    end
    find_memo_also = (options[:memo_type_id]) ? (" and m.memo_type_id = '#{memo_type}'") : ""
    join = "LEFT OUTER JOIN memos m ON #{table_name}.id = m.memoable_id and m.memoable_type = '#{self.to_s}'#{find_memo_also}"
    if not options[:count]
      options = options.merge(:select => "#{table_name}.*", :joins => join, :conditions => "m.id IS NULL #{conditions}")
      result = find(:all, options)
      #result = []
    else
      options.delete(:count)
      result = count(:all, :select => "#{table_name}.id", :joins => join, :conditions => "m.id IS NULL #{conditions}")
    end
    result
  end
  
  def set_lead_info
    l = self
    npanxx = l.phone[1..6]
    l.area_code = npanxx[0..2]
    area_code_info = AreaCodeInfo.find(:first, :conditions => {:npanxx => npanxx})
    if area_code_info
      l.city = area_code_info.city
      l.state = area_code_info.state
      l.zip_code = area_code_info.zipcode
      l.time_zone = ZONES[area_code_info.timezone]
      l.rate_center = area_code_info.ratecenter
    end
  end
end

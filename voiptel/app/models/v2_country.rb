class V2Country < ActiveRecord::Base
  has_many :dids
  has_many :area_codes
  has_many :cdrs
  has_many :old_zones
  has_many :numbering_plans, :class_name => "V2NumberingPlan", :foreign_key => "country_id"
  has_many :rates, :foreign_key => "country_id"
  has_many :phone_countries
  
  has_many :promotions, :foreign_key => "country_id"
  has_many :account_promotions, :foreign_key => "country_id"
  
  VALIDATION = [
    #["Restrict", 0],
    ["Min & Max Digits", 1],
    ["Min Digits", 2],
    ["No Validation", 3]
  ]
  
  VALIDATION_STRINGS = ["", "Min & Max", "Only Min", "No Validation"]
  
  def carriers
    distinct_carriers = rates.find(:all, :select => "distinct carrier_id")
    carriers = []
    for carrier in distinct_carriers
      carriers << Carrier.find(carrier.carrier_id, :select => "id, name")
    end
    carriers
  end  
  
  def rate_descs
    descs = []
    carriers.each do |c|
      descs += c.country_descs(self.id)
    end
    (descs.sort {|a,b,| a.count <=> b.count}).reverse
  end

  def self.select_options
    self.find(:all, :select => "id,name", :conditions => {:publish => true}, :order => "name asc").collect {|c| [c.name, c.id] }
  end
  
end

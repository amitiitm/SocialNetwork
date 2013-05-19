class Country < ActiveRecord::Base
  has_many :dids
  has_many :area_codes
  has_many :cdrs
  has_many :zones
  has_many :numbering_plans
  has_many :rates
  
  VALIDATION = [
    ["Restrict", 0],
    ["Min & Max Digits", 1],
    ["Min Digits", 2],
    ["No Validation", 3],
  ]
  
  def max_routes
    z = self.zones.find(:first, :order => "routes_count desc")
    if z
      z.routes_count
    else
      5
    end
  end
end

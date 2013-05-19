class RateCenter < ActiveRecord::Base
  has_many :npanxxes
  has_many :dids
  has_many :did_rate_center_locations
end

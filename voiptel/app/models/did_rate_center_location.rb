class DidRateCenterLocation < ActiveRecord::Base
  #belongs_to :rate_center
  belongs_to :area_code_info
  has_many :dids
  
  def distance_to(lat_long_obj)
    lat_long_obj.distance(LatLong.new(lat, long))
  end
  
end

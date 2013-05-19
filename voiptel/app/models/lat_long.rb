class LatLong
  
  attr_accessor :lat
  attr_accessor :long
  
  def initialize(lat, long)
    self.lat = lat
    self.long = long
  end
  
  def distance(lat_long_obj)
    calc_distance(self.lat, self.long, lat_long_obj.lat, lat_long_obj.long)
  end
  
  private
  def calc_distance(lat1, long1, lat2, long2)
    lat1 = lat1.to_f
    long1 = long1.to_f
    lat2 = lat2.to_f
    long2 = long2.to_f
    r = 6371 / 1.609344
    lat = to_rad((lat2 - lat1))
    long = to_rad((long2 - long1))
    a = (Math.sin(lat/2) * Math.sin(lat/2)) + Math.cos(to_rad(lat1)) * Math.cos(to_rad(lat2)) * Math.sin(long/2) * Math.sin(long/2)
    c = 2 * Math.atan2(Math.sqrt(a), Math.sqrt(1-a))
    d = r * c
    
  end
  
  def to_rad(degree)
    ((degree * Math::PI) / 180).to_f
  end
  
end

latlong = LatLong.new(1,2)
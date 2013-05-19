class PhoneInfo
  attr_accessor :npa
  attr_accessor :nxx
  attr_accessor :npanxx
  attr_accessor :lat
  attr_accessor :long
  
  def initialize(npanxx)
    self.npa = npanxx.npa
    self.nxx = npanxx.nxx
    self.npanxx = npanxx
    self.lat = npanxx.latitude
    self.long = npanxx.longitude
  end  
end
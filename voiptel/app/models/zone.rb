class Zone < ActiveRecord::Base
  has_many :routes, :dependent => :destroy
  has_many :carriers, :through => :routes
	has_many :cdrs
	has_many :card_cdrs
	
  belongs_to :country
  
  #after_create :create_routes
  before_save :check_rates
  before_save :set_prefix_length
  
  validates_presence_of :name
  validates_presence_of :prefix
  validates_presence_of :buy_rate
  validates_presence_of :sell_rate
  
  #validates_uniqueness_of :prefix
  
  attr_accessor :carrier, :margin, :rates_in_cents
  
  def markup
    (sell_rate - buy_rate).to_f / buy_rate * 100
  end

  def markup=(val)
    
  end
  
  def to_s
    "zone"
  end
  
  def selections
    selections = []
    (0..5).each do |i|
      selections[i] = nil
    end
    routes.each do |r|
      selections[r.priority] = r.carrier_id
    end
    return selections
  end
  
  def create_routes
    (1..5).each do |i|
      route = Route.new
      route.zone_id = self.id
      route.priority = i
      route.carrier_id = nil
      route.save
    end
  end
  
  def set_prefix_length
    self.prefix_length = self.prefix.length
  end
  
  def check_rates
    if self.rates_in_cents
      self.buy_rate /= 100
      self.sell_rate /= 100
    end
  end
    
end

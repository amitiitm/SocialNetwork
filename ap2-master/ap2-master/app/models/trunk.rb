class Trunk < ActiveRecord::Base
  has_many :trunk_endpoints, :dependent => :destroy
  has_many :endpoints, :through => :trunk_endpoints
  
  has_many :carrier_trunks, :dependent => :destroy
  has_one :carrier, :through => :carrier_trunks
  
  has_many :rate_sheets
  has_many :rates
  
  belongs_to :rate_sheet
  
  attr_accessor :use_endpoint
  
  before_save :check_endpoints
  has_many :rates
  
  def using_endpoint?(eid)
    if self.trunk_endpoints.find(:first, :conditions => {:endpoint_id => eid})
      true
    else
      false
    end
  end
  
  private
  
  def check_endpoints
    if self.use_endpoint.class == HashWithIndifferentAccess
      self.use_endpoint.keys.each do |eid|
        update_endpoint(eid.to_i, self.use_endpoint[eid])
      end
    end
  end
  
  def update_endpoint(eid, value)
    te = self.trunk_endpoints.find(:first, :conditions => {:endpoint_id => eid})
    if value == "0"
      if te 
        te.destroy        
      end
    else
      unless te
        self.endpoints << Endpoint.find(eid)
      end
    end
  end
  
end

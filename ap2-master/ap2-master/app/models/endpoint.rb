class Endpoint < ActiveRecord::Base
  has_many :carrier_endpoints, :dependent => :destroy
  has_one :carrier, :through => :carrier_endpoints
  
  has_many :trunk_endpoints, :dependent => :destroy
  has_one :trunk, :through => :trunk_endpoints
  
  has_many :account_endpoints, :dependent => :destroy
  has_one :account, :through => :account_endpoints
  
  has_one :trusted_endpoint, :dependent => :destroy
  
  validates_presence_of :name, :ip, :port, :settings
  validates_uniqueness_of :name, :message => "Duplicate endpoint name is not allowed!"
  
  DEFAULT_SETTING = "type=peer\ndisallow=all\n;allow=g729\n;allow=alaw\n;allow=ulaw"
  
  after_save :check_trusted
  
  private
  def check_trusted
    if self.in
      if self.account
        context_info = "handler=trunk;peer=#{self.account.short_name};account=#{self.account.id}"
      elsif self.carrier
        context_info = "handler=did;peer=#{self.carrier.short_name}"
      else
        logger.info { "------------- COULD NOT FIND ENDPOINT ASSOCIATIONS" }
      end
      self.trusted_endpoint ||= TrustedEndpoint.new
      self.trusted_endpoint.grp = 1
      self.trusted_endpoint.ip = self.ip
      self.trusted_endpoint.mask = 32
      self.trusted_endpoint.port = 0
      self.trusted_endpoint.proto = 'any'
      self.trusted_endpoint.context_info = context_info
      self.trusted_endpoint.save
    else
      if self.trusted_endpoint
        self.trusted_endpoint.destroy
      end
    end
  end        
end

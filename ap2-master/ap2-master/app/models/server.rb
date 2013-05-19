class Server < ActiveRecord::Base
  validates_presence_of :name, :message => "Name can't be blank"
  validates_presence_of :ip, :message => "IP can't be blank"
  validates_presence_of :hostname, :message => "Hostname can't be blank"
  validates_presence_of :server_type, :message => "Server Type can't be blank"
  
  has_many :server_settings
  has_one :load_balancer, :dependent => :destroy
  has_one :trusted_endpoint, :dependent => :destroy
  
  accepts_nested_attributes_for :load_balancer, :allow_destroy => true  
  
  after_create :set_trusted_endpoint
  
  SERVER_TYPES = [
    ["LB", 1],
    ["GW", 2],
    ["Media", 3],
    ["App", 4],
    ["DB", 5],
    ["VM", 6],
    ["Memcache", 7],
    ["Mail", 8],
    ["SCM", 9],
    ["Voicemail", 10]
  ]
  
  def set_trusted_endpoint
    if self.server_type == 3
      t = TrustedEndpoint.new
      t.ip = self.ip
      t.mask = 32
      t.port = 0
      t.proto = "any"
      t.grp = 2
      t.server_id = self.id
      t.save
    end
  end
end

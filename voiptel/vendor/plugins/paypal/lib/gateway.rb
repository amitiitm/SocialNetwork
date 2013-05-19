class Gateway < AbstractGateway
  attr_accessor :login, :password, :signature, :endpoint, :path, :version
  def initialize(options)
    self.login = options[:login]
    self.password = options[:password]
    self.signature = options[:signature]
    if $mode == :test
      self.endpoint = "api-3t.sandbox.paypal.com"
    else
      self.endpoint = "api-3t.paypal.com"
    end
    self.path = "/nvp"
    self.version = "65.0"
  end
  
  def self.mode=(mode)
    $mode = mode
  end
  
  def self.mode
    $mode
  end
  
  def self.gateway=(gw)
    $gateway = gw
  end
  
  def self.gateway
    $gateway
  end  
end
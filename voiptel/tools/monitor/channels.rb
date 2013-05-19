require 'rubygems'
require 'eventmachine'
require 'memcache'

class AMI < EM::Connection
  attr_accessor :server, :ip
  def initialize(*args)
		super
    self.server = args[0][:server]
		self.ip = args[0][:ip]
		puts "Server: #{self.server}:#{self.ip}"
  end
  
  def post_init
		puts "Post init"
    send_data "Action: Login\r\nUsername: moe\r\nSecret: baghali1234\r\nEvents: off\r\n\r\n"
  end

  def receive_data data
  end

  def unbind
    "Connection closed"
  end
  def resume
  end
end


begin
	EM::run do
	  EM::connect "10.0.0.4", 5038, AMI, :server => "media1", :ip => "10.0.0.4"
  end
rescue Exception => e
	puts e.class.name.to_s
	puts e.backtrace
end

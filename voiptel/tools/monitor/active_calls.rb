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
		@memcache = Memcache.new(:server => "127.0.0.1:11211")
    send_data "Action: Login\r\nUsername: cm\r\nSecret: sp110q\r\nEvents: off\r\n\r\n"
    @data = ""
		EventMachine::add_periodic_timer( 1 ) { send_data "Action: Command\r\nCommand: core show channels \r\n\r\n" }
  end

  def receive_data data
    if data.index("Permission denied")
      puts "Auth Again"
      send_data "Action: Login\r\nUsername: cm\r\nSecret: sp110q\r\nEvents: off\r\n\r\n"
    end
    
		matches = data.match(/([0-9]+) active call[s]?/)
		if matches
			active_calls = matches[1]
			@memcache.set("#{self.server}_calls", active_calls)
		end
		matches = data.match(/([0-9]+) active channel[s]?/)
		if matches
			active_channels = matches[1]
			@memcache.set("#{self.server}_channels", active_channels)
		end
  end

  def unbind
    @memcache.set("#{self.server}_calls", "-1")
    @memcache.set("#{self.server}_channels", "-1")
    puts "Connection terminated, try reconnect"
		reconnect self.ip, 5038
		sleep 1
  end
  def resume
    puts "Connection resumed"
  end
end


begin
	EM::run do
	  EM::connect "10.0.0.30", 5038, AMI, :server => "media1", :ip => "10.0.0.30"
	  EM::connect "10.0.0.31", 5038, AMI, :server => "media2", :ip => "10.0.0.31"
	  EM::connect "10.0.0.32", 5038, AMI, :server => "media3", :ip => "10.0.0.32"
  end
rescue Exception => e
	puts e.class.name.to_s
	puts e.backtrace
end

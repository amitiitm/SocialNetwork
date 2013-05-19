require 'rubygems'
require 'eventmachine'
require 'memcache'
require 'juggernaut'
require "json"

class AMI < EM::Connection
  attr_accessor :server, :ip, :channels, :calls, :status
  def initialize(*args)
		super
		@status = "down"
		@channels = "0"
		@calls = "0"

    @server = args[0][:server]
		@ip = args[0][:ip]
  end
  
  def post_init
		puts "init #{@server}:#{@ip}"
    send_data "Action: Login\r\nUsername: cm\r\nSecret: sp110q\r\nEvents: off\r\n\r\n"
    @data = ""
		EventMachine::add_periodic_timer( 1 ) { send_data "Action: Command\r\nCommand: core show channels \r\n\r\n" }
  end

  def receive_data data
    if @data.index("\r\n\r\n")
			data = @data
			@data = ""
      responses = data.split("\r\n\r\n")
      responses.each do |r|
        process r
      end
    else
      @data << data
    end
  end

  def process data
    if data.index("Permission denied")
      puts "Auth Again"
      send_data "Action: Login\r\nUsername: cm\r\nSecret: sp110q\r\nEvents: off\r\n\r\n"
      return
    end

		return unless data.index("active call") or data.index("active channel")
    
    status = "up"    
    
    match = data.match(/([0-9]+) active call[s]?/)
    calls = (match)? match[1].to_i : "error"
    
    match = data.match(/([0-9]+) active channel[s]?/)
    channels = (match)? match[1].to_i : "error"
    
    if calls == "error" or channels == "error"
			puts "----------------"
      puts "DEBUG:"
      puts data.inspect
      puts "----------------"
    end
    
    if ((channels != @channels) or (calls != @calls) or (status != @status))
      puts "server: #{@server} channels: #{channels} @channels: #{@channels} calls: #{calls} @calls: #{@calls} status: #{status} @status: #{@status}"
      @channels = channels
      @calls = calls
      @status = status
      publish
    end
  end


  def unbind
    @status = "down"
    puts "Connection terminated, try reconnect"
		reconnect @ip, 5038
		sleep 1
  end
  def resume
    puts "Connection resumed"
  end
  
  def publish
    Juggernaut.redis_options = {:host => "10.0.0.28"}
		Juggernaut.publish("cm", {"server" => @server, "status" => @status, "calls" => @calls, "channels" => @channels}.to_json)
  end
  
end

module Juggernaut
	def redis_options=(options)
		@redis_options = options
	end
end

begin
	EM::run do
	  EM::connect "10.0.0.4", 5038, AMI, :server => "media1", :ip => "10.0.0.4"
	  EM::connect "10.0.0.5", 5038, AMI, :server => "media2", :ip => "10.0.0.5"
	  EM::connect "10.0.0.6", 5038, AMI, :server => "media3", :ip => "10.0.0.6"
  end
rescue Exception => e
	unless e.class == Interrupt	
		puts e.class.name.to_s
		puts e.backtrace
	end
end

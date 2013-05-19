require "rubygems"
require "eventmachine"

class KhanGholiMoradClient < EventMachine::Connection
  attr_accessor :status, :kgm
  
  def initialize(*args)
    super
    self.kgm = args[0]
    self.status = "init"
  end
  
  def post_init
    puts "KhanGholiMorad client post init"
  end

  def receive_data data
    data = JSON.parse(data)
    puts "received: #{data.inspect}"
    send_data(self.kgm.args)
    close_connection(true)
  end

  def unbind
    if error?
      self.kgm.valid = false
      self.kgm.errors << "Could not connect to KhanGholiMorad Server"
    end
    EM::stop
  end 
end


class KhanGholiMorad  
  attr_accessor :args, :valid, :errors
  
  def initialize(args)
    self.valid = false
    self.errors = []
    self.args = args
    run
  end
  
  def valid?
    self.valid
  end
  
  def run    
    EventMachine::run {
      EventMachine::connect "localhost", 9090, KhanGholiMoradClient, self
    }                    
    puts "The event loop has ended"
  end  
end


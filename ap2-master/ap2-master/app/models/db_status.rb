class DBStatus
  attr_accessor :master, :slave

  def initialize
    get_master_status
    get_slave_status
  end
  
  def get_master_status
    client = Mysql2::Client.new(:host => "db1", :username => "root", :password => "sp110q")
    result = client.query("SHOW MASTER STATUS").each do |row|
    	self.master = row
		end
  end
  
  def get_slave_status
    client = Mysql2::Client.new(:host => "db3", :username => "root", :password => "sp110q")
    result = client.query("SHOW SLAVE STATUS").each do |row|
			self.slave = row
    end
  end  
end

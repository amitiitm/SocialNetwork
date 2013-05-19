#require "mysql"    # if needed
#
#@db_host  = "localhost"
#@db_user  = "root"
#@db_pass  = "root"
#@db_name = "your_db_name"
#
#client = Mysql::Client.new(:host => @db_host, :username => @db_user, :password => @db_pass, :database => @db_name)
#@cdr_result = client.query("SELECT * from your_db_table_name')
require 'mysql2'
require "active_record"

ActiveRecord::Base.establish_connection(
  :adapter  => 'mysql2',
  :database => 'test',
  :username => 'root',
  :password => 'hpes',
  :host     => '127.0.0.1')

class User < ActiveRecord::Base
  users = User.find(:all)
  puts users
end
User.new
class ServerSetting < ActiveRecord::Base
  belongs_to :server
  
  validates_presence_of :module, :message => "Module can't be blank"
  validates_presence_of :server_id, :message => "Server can't be blank"
  validates_presence_of :settings, :message => "Settings can't be blank"
end

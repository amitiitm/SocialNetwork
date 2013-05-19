class AddServerTypeToServers < ActiveRecord::Migration
  def self.up
    add_column :servers, :server_type, :integer
  end

  def self.down
    remove_column :servers, :server_type
  end
end

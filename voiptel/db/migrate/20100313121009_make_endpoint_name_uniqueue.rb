class MakeEndpointNameUniqueue < ActiveRecord::Migration
  def self.up
    add_index :endpoints, :name, :unique => true
  end

  def self.down
    remove_index :endpoints, :column => :name
  end
end

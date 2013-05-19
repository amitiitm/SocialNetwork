class DropForwardings < ActiveRecord::Migration
  def self.up
    drop_table :forwardings
  end

  def self.down
  end
end

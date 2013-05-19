class AddIpToCarriers < ActiveRecord::Migration
  def self.up
    add_column :carriers, :ip, :string, :limit => 15
  end

  def self.down
    remove_column :carriers, :ip
  end
end

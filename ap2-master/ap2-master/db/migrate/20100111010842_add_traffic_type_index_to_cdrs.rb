class AddTrafficTypeIndexToCdrs < ActiveRecord::Migration
  def self.up
    add_index :cdrs, :traffic_type
  end

  def self.down
    remove_index :cdrs, :traffic_type
  end
end

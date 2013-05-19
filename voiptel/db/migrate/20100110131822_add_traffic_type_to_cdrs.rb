class AddTrafficTypeToCdrs < ActiveRecord::Migration
  def self.up
    add_column :cdrs, :traffic_type, :integer, :default => 1
  end

  def self.down
    remove_column :cdrs, :traffic_type
  end
end

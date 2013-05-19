class AddRoutesCountToZones < ActiveRecord::Migration
  def self.up
    add_column :zones, :routes_count, :integer, :default => 0
  end

  def self.down
    remove_column :zones, :routes_count
  end
end

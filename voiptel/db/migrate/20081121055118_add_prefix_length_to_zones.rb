class AddPrefixLengthToZones < ActiveRecord::Migration
  def self.up
    add_column :zones, :prefix_length, :integer
  end

  def self.down
    remove_column :zones, :prefix_length
  end
end

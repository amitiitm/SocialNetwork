class AddPublishToZones < ActiveRecord::Migration
  def self.up
    add_column :zones, :publish, :boolean, :default => 1
  end

  def self.down
    remove_column :zones, :publish
  end
end

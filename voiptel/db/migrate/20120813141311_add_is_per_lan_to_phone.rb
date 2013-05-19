class AddIsPerLanToPhone < ActiveRecord::Migration
  def self.up
    add_column :phones, :is_per_lan, :boolean, :default => 0
  end

  def self.down
    remove_column :phones, :is_per_lan
  end
end

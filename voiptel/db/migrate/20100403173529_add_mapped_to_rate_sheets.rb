class AddMappedToRateSheets < ActiveRecord::Migration
  def self.up
    add_column :rate_sheets, :mapped, :boolean, :default => false
  end

  def self.down
    remove_column :rate_sheets, :mapped
  end
end

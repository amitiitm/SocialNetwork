class AddProcessedToRateSheets < ActiveRecord::Migration
  def self.up
    add_column :rate_sheets, :processed, :boolean, :default => false
  end

  def self.down
    remove_column :rate_sheets, :processed
  end
end

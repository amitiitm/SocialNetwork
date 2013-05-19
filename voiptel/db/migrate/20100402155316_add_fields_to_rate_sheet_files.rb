class AddFieldsToRateSheetFiles < ActiveRecord::Migration
  def self.up
    add_column :rate_sheet_files, :mapped, :boolean, :default => false
    add_column :rate_sheet_files, :processed, :boolean, :default => false
  end

  def self.down
    remove_column :rate_sheet_files, :processed
    remove_column :rate_sheet_files, :mapped
  end
end

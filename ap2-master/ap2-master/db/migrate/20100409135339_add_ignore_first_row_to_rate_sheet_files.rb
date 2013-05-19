class AddIgnoreFirstRowToRateSheetFiles < ActiveRecord::Migration
  def self.up
    add_column :rate_sheet_files, :include_first_row, :boolean, :default => false
  end

  def self.down
    remove_column :rate_sheet_files, :include_first_row
  end
end

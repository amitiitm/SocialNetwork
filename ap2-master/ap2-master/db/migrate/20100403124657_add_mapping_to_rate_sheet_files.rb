class AddMappingToRateSheetFiles < ActiveRecord::Migration
  def self.up
    add_column :rate_sheet_files, :col_desc, :integer
    add_column :rate_sheet_files, :col_prefix, :integer
    add_column :rate_sheet_files, :col_rate, :integer
  end

  def self.down
    remove_column :rate_sheet_files, :col_desc
    remove_column :rate_sheet_files, :col_rate
    remove_column :rate_sheet_files, :col_prefix
  end
end

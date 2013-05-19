class AddRemovePrefixToRateSheetFiles < ActiveRecord::Migration
  def self.up
    add_column :rate_sheet_files, :remove_prefix, :string, :limit => 20
    add_column :rate_sheet_files, :add_prefix, :string, :limit => 20
  end

  def self.down
    remove_column :rate_sheet_files, :add_prefix
    remove_column :rate_sheet_files, :remove_prefix
  end
end

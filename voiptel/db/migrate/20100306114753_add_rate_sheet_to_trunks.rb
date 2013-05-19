class AddRateSheetToTrunks < ActiveRecord::Migration
  def self.up
    add_column :trunks, :rate_sheet_id, :integer
  end

  def self.down
    remove_column :trunks, :rate_sheet_id
  end
end

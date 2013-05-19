class AddActiveToRateSheetRevesions < ActiveRecord::Migration
  def self.up
    add_column :rate_sheet_revesions, :active, :boolean, :default => false
  end

  def self.down
    remove_column :rate_sheet_revesions, :active
  end
end

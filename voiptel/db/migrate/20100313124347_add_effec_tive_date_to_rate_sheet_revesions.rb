class AddEffecTiveDateToRateSheetRevesions < ActiveRecord::Migration
  def self.up
    add_column :rate_sheet_revesions, :effective_date, :datetime
  end

  def self.down
    remove_column :rate_sheet_revesions, :effective_date
  end
end

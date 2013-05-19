class AddTrunkIdToRateSheets < ActiveRecord::Migration
  def self.up
    add_column :rate_sheets, :trunk_id, :integer
  end

  def self.down
    remove_column :rate_sheets, :trunk_id
  end
end

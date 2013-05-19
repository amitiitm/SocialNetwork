class AddIndexesToRates < ActiveRecord::Migration
  def self.up

    add_index :rates, :rate_group_id
    add_index :rates, :rate_sheet_id
    add_index :rates, :trunk_id
  end

  def self.down
    remove_index :rates, :trunk_id
    remove_index :rates, :rate_sheet_id
    remove_index :rates, :rate_group_id
  end
end

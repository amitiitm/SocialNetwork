class AlterDiamondInventoryLinesAddSellUnit < ActiveRecord::Migration
  def self.up
    add_column :diamond_inventory_lines, :sell_unit, :string, :limit=>4
  end

  def self.down
    remove_column :diamond_inventory_lines, :sell_unit
  end
end

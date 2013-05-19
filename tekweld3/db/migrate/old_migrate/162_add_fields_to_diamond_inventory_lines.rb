class AddFieldsToDiamondInventoryLines < ActiveRecord::Migration
  def self.up
    add_column :diamond_inventory_lines, :diamond_lot_no, :string, :limit=>25
    add_column :diamond_inventory_lines, :diamond_packet_no, :string, :limit=>25
  end

  def self.down
    remove_column :diamond_inventory_lines, :diamond_lot_no
    remove_column :diamond_inventory_lines, :diamond_packet_no
  end
end

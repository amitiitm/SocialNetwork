class AddItemDescriptionToInventoryTables < ActiveRecord::Migration
  def self.up
    add_column :inventory_transaction_lines, :item_description, :string, :limit=>100
    add_column :inventory_transfers, :item_description, :string, :limit=>100
    add_column :diamond_inventory_lines, :lot_description, :string, :limit=>50
    add_column :diamond_inventory_transfers, :lot_description, :string, :limit=>50
  end

  def self.down
    remove_column :inventory_transaction_lines, :item_description
    remove_column :inventory_transfers, :item_description
    remove_column :diamond_inventory_lines, :lot_description
    remove_column :diamond_inventory_transfers, :lot_description
  end
end

class AddCardsInventoryIdToDistributionInventories < ActiveRecord::Migration
  def self.up
    add_column :distribution_inventories, :cards_inventory_id, :integer
  end

  def self.down
    remove_column :distribution_inventories, :cards_inventory_id
  end
end

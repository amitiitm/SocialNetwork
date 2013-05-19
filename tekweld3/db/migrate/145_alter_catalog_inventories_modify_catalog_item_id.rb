class AlterCatalogInventoriesModifyCatalogItemId < ActiveRecord::Migration
  def self.up
    remove_column :catalog_inventories, :catalog_item_id
    add_column :catalog_inventories, :catalog_item_id ,:string ,:limit=>50

  end

  def self.down
    remove_column :catalog_inventories, :catalog_item_id
    add_column :catalog_inventories, :catalog_item_id ,:integer
  end
end

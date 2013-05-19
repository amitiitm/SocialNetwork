class CreateItemCatalogItemAccessories < ActiveRecord::Migration
  def self.up
    create_table :item_catalog_item_accessories do |t|

      t.timestamps
    end
  end

  def self.down
    drop_table :item_catalog_item_accessories
  end
end

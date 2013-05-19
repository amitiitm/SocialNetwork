class CreateItemCatalogItemPriceLevels < ActiveRecord::Migration
  def self.up
    create_table :item_catalog_item_price_levels do |t|

      t.timestamps
    end
  end

  def self.down
    drop_table :item_catalog_item_price_levels
  end
end

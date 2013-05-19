class AlterCatalogItemsPricesAddPriceLevels < ActiveRecord::Migration
  def self.up
    add_column :catalog_item_prices,:price_level, :string, :limit=>1
  end

  def self.down
    remove_column :catalog_item_prices,:price_level
  end
end

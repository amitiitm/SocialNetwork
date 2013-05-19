class AlterCatalogItemsAddImageFields < ActiveRecord::Migration
  def self.up
    add_column :catalog_items, :image_1200 ,:string ,:limit=>100
    add_column :catalog_item_images, :image_1200 ,:string ,:limit=>100
  end

  def self.down
    remove_column :catalog_items, :image_1200
    remove_column :catalog_item_images, :image_1200
  end
end

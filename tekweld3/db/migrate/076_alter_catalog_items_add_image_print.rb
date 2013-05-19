class AlterCatalogItemsAddImagePrint < ActiveRecord::Migration
  def self.up
    add_column :catalog_items, :image_print, :string, :limit=>100
  end

  def self.down
    remove_column :catalog_items, :image_print
  end
end

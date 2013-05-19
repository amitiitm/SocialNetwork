class  AddSketchToCatalogItems < ActiveRecord::Migration
  def self.up
    add_column :catalog_items, :sketch_image1, :string, :limit=>100
    add_column :catalog_items, :sketch_image2, :string, :limit=>100
    add_column :catalog_items, :sketch_image3, :string, :limit=>100
  end

  def self.down
    remove_column :catalog_items, :sketch_image1
    remove_column :catalog_items, :sketch_image2
    remove_column :catalog_items, :sketch_image3
  end
end

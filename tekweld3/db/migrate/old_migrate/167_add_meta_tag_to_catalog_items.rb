class AddMetaTagToCatalogItems < ActiveRecord::Migration
  def self.up
    add_column :catalog_items, :meta_tag, :string, :limit=>500
  end

  def self.down
    remove_column :catalog_items, :meta_tag
  end
end

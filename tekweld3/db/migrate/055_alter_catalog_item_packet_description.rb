class AlterCatalogItemPacketDescription < ActiveRecord::Migration
  def self.up
    remove_column :catalog_item_packets, :description
    add_column :catalog_item_packets, :description, :string, :limit=>100
  end

  def self.down
    remove_column :catalog_item_packets, :description
    add_column :catalog_item_packets, :description, :string, :limit=>100, :null=>false
  end
end

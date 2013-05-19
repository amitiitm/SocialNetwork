class  AddPriceToCatalogItemPacket < ActiveRecord::Migration
  def self.up
    add_column :catalog_item_packets, :price, :decimal, :precision=>12, :scale=>2, :default=>0
  end

  def self.down
    remove_column :catalog_item_packets, :price
  end
end

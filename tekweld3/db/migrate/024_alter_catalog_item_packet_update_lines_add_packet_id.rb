class AlterCatalogItemPacketUpdateLinesAddPacketId < ActiveRecord::Migration
  def self.up
    add_column :catalog_item_packet_update_lines,:catalog_item_packet_id, :integer,:null => false
  end

  def self.down
    remove_column :catalog_item_packet_update_lines,:catalog_item_packet_id
  end
end


class AddSequenceToCatalogStoreLocations < ActiveRecord::Migration
  def self.up
    add_column :catalog_store_locations, :sequence, :integer
  end

  def self.down
    remove_column :catalog_store_locations, :sequence
  end
end

class AlterCatalogItemsPacketsAddLines < ActiveRecord::Migration
  def self.up
    add_column :catalog_items,:tag_line1, :string, :limit=>100
    add_column :catalog_items,:tag_line2, :string, :limit=>100
    add_column :catalog_items,:tag_line3, :string, :limit=>100
    add_column :catalog_items,:tag_line4, :string, :limit=>100
    add_column :catalog_items,:tag_line5, :string, :limit=>100
    add_column :catalog_items,:tag_line6, :string, :limit=>100
    add_column :catalog_items,:tag_line7, :string, :limit=>100
    add_column :catalog_items,:tag_line8, :string, :limit=>100
    add_column :catalog_item_packets,:tag_line1, :string, :limit=>100
    add_column :catalog_item_packets,:tag_line2, :string, :limit=>100
    add_column :catalog_item_packets,:tag_line3, :string, :limit=>100
    add_column :catalog_item_packets,:tag_line4, :string, :limit=>100
    add_column :catalog_item_packets,:tag_line5, :string, :limit=>100
    add_column :catalog_item_packets,:tag_line6, :string, :limit=>100
    add_column :catalog_item_packets,:tag_line7, :string, :limit=>100
    add_column :catalog_item_packets,:tag_line8, :string, :limit=>100
    
  end

  def self.down
    remove_column :catalog_items,:tag_line1
    remove_column :catalog_items,:tag_line2
    remove_column :catalog_items,:tag_line3
    remove_column :catalog_items,:tag_line4
    remove_column :catalog_items,:tag_line5
    remove_column :catalog_items,:tag_line6
    remove_column :catalog_items,:tag_line7
    remove_column :catalog_items,:tag_line8
    remove_column :catalog_item_packets,:tag_line1
    remove_column :catalog_item_packets,:tag_line2
    remove_column :catalog_item_packets,:tag_line3
    remove_column :catalog_item_packets,:tag_line4
    remove_column :catalog_item_packets,:tag_line5
    remove_column :catalog_item_packets,:tag_line6
    remove_column :catalog_item_packets,:tag_line7
    remove_column :catalog_item_packets,:tag_line8
  end
  
end

class AddRiFlagToInventoryDetails < ActiveRecord::Migration
  def self.up
    add_column :diamond_inventory_details, :ri_flag, :string, :limit=>1
    add_column :inventory_details, :receipt_issue_flag, :string, :limit=>1
  end

  def self.down
    remove_column :diamond_inventory_details, :ri_flag
    remove_column :inventory_details, :receipt_issue_flag
  end
end

class AddExtRefToDiamondInventoryDetails < ActiveRecord::Migration
  def self.up
    add_column :diamond_inventory_details, :ext_ref_no, :string, :limit=>50
    add_column :diamond_inventory_details, :ext_ref_date, :datetime
  end

  def self.down
    remove_column :diamond_inventory_details, :ext_ref_no
    remove_column :diamond_inventory_details, :ext_ref_date
  end
end

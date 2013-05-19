class AddRemoveFieldsToDiamondInventories < ActiveRecord::Migration
  def self.up
    add_column :diamond_inventories, :trans_type, :string, :limit=>1
    add_column :diamond_inventories, :trans_type_id, :integer
    add_column :diamond_inventories, :ext_ref_no, :string, :limit=>50
    add_column :diamond_inventories, :ext_ref_date, :datetime
    remove_column :diamond_inventory_lines, :customer_id
    remove_column :diamond_inventory_lines, :vendor_id
  end

  def self.down
    remove_column :diamond_inventories, :column_precision
    remove_column :diamond_inventories, :trans_type
    remove_column :diamond_inventories, :trans_type_id
    remove_column :diamond_inventories, :ext_ref_no
    remove_column :diamond_inventories, :ext_ref_date
    add_column :diamond_inventory_lines, :customer_id, :integer
    add_column :diamond_inventory_lines, :vendor_id, :integer
  end
end

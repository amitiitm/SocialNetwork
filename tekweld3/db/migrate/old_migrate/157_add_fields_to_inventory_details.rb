class AddFieldsToInventoryDetails < ActiveRecord::Migration
  def self.up
    add_column :inventory_details, :trans_type, :string, :limit=>1
    add_column :inventory_details, :trans_type_id, :integer
    add_column :inventory_details, :ext_ref_no, :string, :limit=>50
    add_column :inventory_details, :ext_ref_date, :datetime
  end

  def self.down
    remove_column :inventory_details, :trans_type
    remove_column :inventory_details, :trans_type_id
    remove_column :inventory_details, :ext_ref_no
    remove_column :inventory_details, :ext_ref_date
  end
end

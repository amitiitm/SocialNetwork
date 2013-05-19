class AlterCatalogOrdersAndLines < ActiveRecord::Migration
  def self.up
    add_column :catalog_orders,:discount_per, :decimal, :precision => 6, :scale => 2
    add_column :catalog_orders,:discount_amt, :decimal, :precision => 12, :scale => 2
    add_column :catalog_orders,:remarks, :string, :limit=>255
    add_column :catalog_orders,:ext_ref_no, :string, :limit=>50
    add_column :catalog_orders,:ext_ref_date, :datetime
    add_column :catalog_order_lines,:spl_order_flag, :string, :limit=>1, :default=>'N'
    add_column :catalog_order_lines,:size, :string, :limit=>10
    add_column :catalog_order_lines,:metal_color, :string, :limit=>10
    add_column :catalog_order_lines,:diamond, :string, :limit=>10
    add_column :catalog_order_lines,:metal_type, :string, :limit=>10
    add_column :catalog_order_lines,:pearl_size, :string, :limit=>10
    add_column :catalog_order_lines,:pearl_color, :string, :limit=>10
    add_column :catalog_order_lines,:pearl_type, :string, :limit=>10
    add_column :catalog_order_lines,:remarks, :string, :limit=>255
  end

  def self.down
    remove_column :catalog_orders,:discount_per
    remove_column :catalog_orders,:discount_amt
    remove_column :catalog_orders,:remarks
    remove_column :catalog_orders,:ext_ref_no
    remove_column :catalog_orders,:ext_ref_date
    remove_column :catalog_order_lines,:spl_order_flag
    remove_column :catalog_order_lines,:size
    remove_column :catalog_order_lines,:metal_color
    remove_column :catalog_order_lines,:diamond
    remove_column :catalog_order_lines,:metal_type
    remove_column :catalog_order_lines,:pearl_size
    remove_column :catalog_order_lines,:pearl_color
    remove_column :catalog_order_lines,:pearl_type
    remove_column :catalog_order_lines,:remarks
  end
end

class AlterCatalogOrderLinesAddFields < ActiveRecord::Migration
  def self.up
    add_column :catalog_order_lines, :order_type ,:string,:limit=>1 ,:default=>'O'
    add_column :catalog_order_lines, :ship_to ,:string,:limit=>250
    add_column :catalog_order_lines,:item_amt ,:decimal ,:precision=>12, :scale=>2
    add_column :catalog_order_lines,:discount_per,:decimal, :precision=>6, :scale=>2
    add_column :catalog_order_lines, :item_description ,:string,:limit=>250
    add_column :catalog_order_lines,:account_period_code, :string,:limit => 8
    add_column :catalog_orders,:account_period_code, :string,:limit => 8
  end

  def self.down
    remove_column :catalog_order_lines, :order_type
    remove_column :catalog_order_lines, :ship_to
    remove_column :catalog_order_lines, :item_amt
    remove_column :catalog_order_lines, :discount_per
    remove_column :catalog_order_lines, :item_description
    remove_column :catalog_order_lines, :account_period_code
    remove_column :catalog_orders, :account_period_code
  end
end

                   
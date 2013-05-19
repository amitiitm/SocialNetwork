class AlterCatalogOrderLinesAddClearQty < ActiveRecord::Migration
  def self.up
    remove_column :catalog_order_lines,:qty
    add_column :catalog_order_lines,:qty, :decimal,:precision=>10 , :scale=>2
    add_column :catalog_order_lines,:clear_qty, :decimal,:precision=>10 , :scale=>2
  end

  def self.down
    remove_column :catalog_order_lines,:clear_qty
    remove_column :catalog_order_lines,:qty
    add_column :catalog_order_lines,:qty, :integer
  end
end

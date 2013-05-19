class AlterCatalogOrderAddAmtFields < ActiveRecord::Migration
  def self.up
    add_column :catalog_orders, :item_qty, :decimal, :precision => 10, :scale => 2
    add_column :catalog_orders, :item_amt, :decimal, :precision => 12, :scale => 2
    add_column :catalog_orders, :ship_amt, :decimal, :precision => 12, :scale => 2
    add_column :catalog_orders, :tax_amt, :decimal, :precision => 12, :scale => 2
    add_column :catalog_orders, :net_amt, :decimal, :precision => 12, :scale => 2
  end

  def self.down
    add_column :catalog_orders, :item_qty
    add_column :catalog_orders, :item_amt
    add_column :catalog_orders, :ship_amt
    add_column :catalog_orders, :tax_amt
    add_column :catalog_orders, :net_amt
  end
end

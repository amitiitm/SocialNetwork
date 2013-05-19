class AlterPosOrdersWorkbagAddItemPrice < ActiveRecord::Migration
  def self.up
    add_column :pos_orders, :item_price , :decimal, :precision=>10, :scale=>2 ,:default=>0.00
    add_column :workbags, :item_price , :decimal, :precision=>10, :scale=>2 ,:default=>0.00
    add_column :contractor_memos, :item_price , :decimal, :precision=>10, :scale=>2 ,:default=>0.00
  end

  def self.down
    remove_column :pos_orders, :item_price
    remove_column :workbags, :item_price
    remove_column :contractor_memos, :item_price
   
  end
end

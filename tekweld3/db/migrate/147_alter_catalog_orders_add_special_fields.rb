class AlterCatalogOrdersAddSpecialFields < ActiveRecord::Migration
  def self.up
    add_column :catalog_order_lines, :spo_flag ,:string ,:limit=>1, :default=>'N'  #'N' not special order, 'Y' it is special order
    add_column :catalog_order_lines, :spo_size ,:string ,:limit=>25
    add_column :catalog_order_lines, :spo_head_size ,:string ,:limit=>25
    add_column :catalog_order_lines, :spo_metal_type ,:string ,:limit=>25
    add_column :catalog_order_lines, :spo_diamond_qlty ,:string ,:limit=>25
    add_column :catalog_order_lines, :spo_metal_color ,:string ,:limit=>25
    add_column :carts, :spo_flag ,:string ,:limit=>1, :default=>'N'  #'N' not special order, 'Y' it is special order
    add_column :carts, :spo_size ,:string ,:limit=>25
    add_column :carts, :spo_head_size ,:string ,:limit=>25
    add_column :carts, :spo_metal_type ,:string ,:limit=>25
    add_column :carts, :spo_diamond_qlty ,:string ,:limit=>25
    add_column :carts, :spo_metal_color ,:string ,:limit=>25
    add_column :wishlists, :spo_flag ,:string ,:limit=>1, :default=>'N'  #'N' not special order, 'Y' it is special order
    add_column :wishlists, :spo_size ,:string ,:limit=>25
    add_column :wishlists, :spo_head_size ,:string ,:limit=>25
    add_column :wishlists, :spo_metal_type ,:string ,:limit=>25
    add_column :wishlists, :spo_diamond_qlty ,:string ,:limit=>25
    add_column :wishlists, :spo_metal_color ,:string ,:limit=>25
  end

  def self.down
    remove_column :catalog_order_lines, :spo_flag
    remove_column :catalog_order_lines, :spo_size
    remove_column :catalog_order_lines, :spo_head_size
    remove_column :catalog_order_lines, :spo_metal_type
    remove_column :catalog_order_lines, :spo_diamond_qlty
    remove_column :catalog_order_lines, :spo_metal_color
    remove_column :carts, :spo_flag
    remove_column :carts, :spo_size
    remove_column :carts, :spo_head_size
    remove_column :carts, :spo_metal_type
    remove_column :carts, :spo_diamond_qlty
    remove_column :carts, :spo_metal_color
    remove_column :wishlists, :spo_flag
    remove_column :wishlists, :spo_size
    remove_column :wishlists, :spo_head_size
    remove_column :wishlists, :spo_metal_type
    remove_column :wishlists, :spo_diamond_qlty
    remove_column :wishlists, :spo_metal_color
  end
end

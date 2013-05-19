class AddFieldsToDiamondSalesPurchaseTable < ActiveRecord::Migration
  def self.up
    add_column :diamond_sale_lines, :diamond_lot_number, :string, :limit=>25
    add_column :diamond_purchase_lines, :diamond_lot_number, :string, :limit=>25
    add_column :diamond_sale_lines, :diamond_packet_code, :string, :limit=>25
    add_column :diamond_purchase_lines, :diamond_packet_code, :string, :limit=>25
  end

  def self.down
    remove_column :diamond_sale_lines, :diamond_lot_number
    remove_column :diamond_purchase_lines, :diamond_lot_number
    remove_column :diamond_sale_lines, :diamond_packet_code
    remove_column :diamond_purchase_lines, :diamond_packet_code
  end
end

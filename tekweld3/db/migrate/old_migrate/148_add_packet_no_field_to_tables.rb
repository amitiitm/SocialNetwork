class AddPacketNoFieldToTables < ActiveRecord::Migration
  def self.up
    add_column :catalog_items, :packet_require_yn, :string, :limit=>1, :default=>'N'
    add_column :catalog_order_lines, :catalog_item_packet_id, :integer
    add_column :catalog_order_lines, :catalog_item_packet_code, :string, :limit=>25
    add_column :inventory_summaries, :catalog_item_packet_id, :integer
    add_column :inventory_details, :catalog_item_packet_id, :integer
    add_column :inventory_transfers, :catalog_item_packet_id, :integer
    add_column :inventory_transfers, :catalog_item_packet_code, :string, :limit=>25
    add_column :purchase_order_lines, :catalog_item_packet_id, :integer
    add_column :purchase_order_lines, :catalog_item_packet_code, :string, :limit=>25
    add_column :purchase_order_cancel_lines, :catalog_item_packet_id, :integer
    add_column :purchase_order_cancel_lines, :catalog_item_packet_code, :string, :limit=>25
    add_column :purchase_memo_lines, :catalog_item_packet_id, :integer
    add_column :purchase_memo_lines, :catalog_item_packet_code, :string, :limit=>25
    add_column :purchase_memo_return_lines, :catalog_item_packet_id, :integer
    add_column :purchase_memo_return_lines, :catalog_item_packet_code, :string, :limit=>25
    add_column :purchase_invoice_lines, :catalog_item_packet_id, :integer
    add_column :purchase_invoice_lines, :catalog_item_packet_code, :string, :limit=>25
    add_column :purchase_credit_invoice_lines, :catalog_item_packet_id, :integer
    add_column :purchase_credit_invoice_lines, :catalog_item_packet_code, :string, :limit=>25
    add_column :sales_order_lines, :catalog_item_packet_id, :integer
    add_column :sales_order_lines, :catalog_item_packet_code, :string, :limit=>25
    add_column :sales_order_cancel_lines, :catalog_item_packet_id, :integer
    add_column :sales_order_cancel_lines, :catalog_item_packet_code, :string, :limit=>25
    add_column :sales_memo_lines, :catalog_item_packet_id, :integer
    add_column :sales_memo_lines, :catalog_item_packet_code, :string, :limit=>25
    add_column :sales_memo_return_lines, :catalog_item_packet_id, :integer
    add_column :sales_memo_return_lines, :catalog_item_packet_code, :string, :limit=>25
    add_column :sales_invoice_lines, :catalog_item_packet_id, :integer
    add_column :sales_invoice_lines, :catalog_item_packet_code, :string, :limit=>25
    add_column :sales_credit_invoice_lines, :catalog_item_packet_id, :integer
    add_column :sales_credit_invoice_lines, :catalog_item_packet_code, :string, :limit=>25
  end

  def self.down
    remove_column :catalog_items, :packet_require_yn
    remove_column :catalog_order_lines, :catalog_item_packet_code
    remove_column :catalog_order_lines, :catalog_item_packet_id
    remove_column :inventory_summaries, :catalog_item_packet_id
    remove_column :inventory_details, :catalog_item_packet_id
    remove_column :inventory_transfers, :catalog_item_packet_code
    remove_column :inventory_transfers, :catalog_item_packet_id
    remove_column :purchase_order_lines, :catalog_item_packet_code
    remove_column :purchase_order_lines, :catalog_item_packet_id
    remove_column :purchase_order_cancel_lines, :catalog_item_packet_code
    remove_column :purchase_order_cancel_lines, :catalog_item_packet_id
    remove_column :purchase_memo_lines, :catalog_item_packet_code
    remove_column :purchase_memo_lines, :catalog_item_packet_id
    remove_column :purchase_memo_return_lines, :catalog_item_packet_code
    remove_column :purchase_memo_return_lines, :catalog_item_packet_id
    remove_column :purchase_invoice_lines, :catalog_item_packet_code
    remove_column :purchase_invoice_lines, :catalog_item_packet_id
    remove_column :purchase_credit_invoice_lines, :catalog_item_packet_code
    remove_column :purchase_credit_invoice_lines, :catalog_item_packet_id
    remove_column :sales_order_lines, :catalog_item_packet_code
    remove_column :sales_order_lines, :catalog_item_packet_id
    remove_column :sales_order_cancel_lines, :catalog_item_packet_code
    remove_column :sales_order_cancel_lines, :catalog_item_packet_id
    remove_column :sales_memo_lines, :catalog_item_packet_code
    remove_column :sales_memo_lines, :catalog_item_packet_id
    remove_column :sales_memo_return_lines, :catalog_item_packet_code
    remove_column :sales_memo_return_lines, :catalog_item_packet_id
    remove_column :sales_invoice_lines, :catalog_item_packet_code
    remove_column :sales_invoice_lines, :catalog_item_packet_id
    remove_column :sales_credit_invoice_lines, :catalog_item_packet_code
    remove_column :sales_credit_invoice_lines, :catalog_item_packet_id
  end
end

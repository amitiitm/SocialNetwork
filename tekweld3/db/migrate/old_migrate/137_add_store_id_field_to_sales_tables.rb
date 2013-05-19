class AddStoreIdFieldToSalesTables < ActiveRecord::Migration
  def self.up
    add_column :sales_orders, :store_id, :integer
    add_column :sales_order_lines, :store_id, :integer
    add_column :sales_invoices, :store_id, :integer
    add_column :sales_invoice_lines, :store_id, :integer
    add_column :sales_memos, :store_id, :integer
    add_column :sales_memo_lines, :store_id, :integer
    add_column :sales_credit_invoices, :store_id, :integer
    add_column :sales_credit_invoice_lines, :store_id, :integer
    add_column :sales_memo_returns, :store_id, :integer
    add_column :sales_memo_return_lines, :store_id, :integer
    add_column :sales_order_cancels, :store_id, :integer
    add_column :sales_order_cancel_lines, :store_id, :integer
  end

  def self.down
    remove_column :sales_orders, :store_id
    remove_column :sales_order_lines, :store_id
    remove_column :sales_invoices, :store_id
    remove_column :sales_invoice_lines, :store_id
    remove_column :sales_memos, :store_id
    remove_column :sales_memo_lines, :store_id
    remove_column :sales_credit_invoices, :store_id
    remove_column :sales_credit_invoice_lines, :store_id
    remove_column :sales_memo_returns, :store_id
    remove_column :sales_memo_return_lines, :store_id
    remove_column :sales_order_cancels, :store_id
    remove_column :sales_order_cancel_lines, :store_id
  end
end

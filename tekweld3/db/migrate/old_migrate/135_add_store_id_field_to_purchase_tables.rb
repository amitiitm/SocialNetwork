class AddStoreIdFieldToPurchaseTables < ActiveRecord::Migration
  def self.up
    add_column :purchase_orders, :store_id, :integer
    add_column :purchase_order_lines, :store_id, :integer
    add_column :purchase_invoices, :store_id, :integer
    add_column :purchase_invoice_lines, :store_id, :integer
    add_column :purchase_memos, :store_id, :integer
    add_column :purchase_memo_lines, :store_id, :integer
    add_column :purchase_credit_invoices, :store_id, :integer
    add_column :purchase_credit_invoice_lines, :store_id, :integer
    add_column :purchase_memo_returns, :store_id, :integer
    add_column :purchase_memo_return_lines, :store_id, :integer
    add_column :purchase_order_cancels, :store_id, :integer
    add_column :purchase_order_cancel_lines, :store_id, :integer
  end

  def self.down
    remove_column :purchase_orders, :store_id
    remove_column :purchase_order_lines, :store_id
    remove_column :purchase_invoices, :store_id
    remove_column :purchase_invoice_lines, :store_id
    remove_column :purchase_memos, :store_id
    remove_column :purchase_memo_lines, :store_id
    remove_column :purchase_credit_invoices, :store_id
    remove_column :purchase_credit_invoice_lines, :store_id
    remove_column :purchase_memo_returns, :store_id
    remove_column :purchase_memo_return_lines, :store_id
    remove_column :purchase_order_cancels, :store_id
    remove_column :purchase_order_cancel_lines, :store_id
  end
end

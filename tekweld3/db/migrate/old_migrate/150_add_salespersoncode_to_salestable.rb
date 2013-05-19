class AddSalespersoncodeToSalestable < ActiveRecord::Migration
  def self.up
    add_column :sales_orders, :salesperson_code, :string, :limit=>25
    add_column :sales_invoices, :salesperson_code, :string, :limit=>25
    add_column :sales_memos, :salesperson_code, :string, :limit=>25
    add_column :sales_credit_invoices, :salesperson_code, :string, :limit=>25
    add_column :sales_memo_returns, :salesperson_code, :string, :limit=>25
    add_column :sales_order_cancels, :salesperson_code, :string, :limit=>25
    remove_column :sales_orders, :salesperson_id
    remove_column :sales_invoices, :salesperson_id
    remove_column :sales_memos, :salesperson_id
    remove_column :sales_credit_invoices, :salesperson_id
    remove_column :sales_memo_returns, :salesperson_id
    remove_column :sales_order_cancels, :salesperson_id
  end

  def self.down
    remove_column :sales_orders, :salesperson_code
    remove_column :sales_invoices, :salesperson_code
    remove_column :sales_memos, :salesperson_code
    remove_column :sales_credit_invoices, :salesperson_code
    remove_column :sales_memo_returns, :salesperson_code
    remove_column :sales_order_cancels, :salesperson_code
    add_column :sales_orders, :salesperson_id, :integer
    add_column :sales_invoices, :salesperson_id, :integer
    add_column :sales_memos, :salesperson_id, :integer
    add_column :sales_credit_invoices, :salesperson_id, :integer
    add_column :sales_memo_returns, :salesperson_id, :integer
    add_column :sales_order_cancels, :salesperson_id, :integer
  end
end

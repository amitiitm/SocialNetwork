class RemoveCompanyStoreFieldFromSalesTables < ActiveRecord::Migration
  def self.up
    remove_column :sales_orders, :company_store_code
    remove_column :sales_order_lines, :company_store_code
    remove_column :sales_invoices, :company_store_code
    remove_column :sales_invoice_lines, :company_store_code
    remove_column :sales_memos, :company_store_code
    remove_column :sales_memo_lines, :company_store_code
    remove_column :sales_credit_invoices, :company_store_code
    remove_column :sales_credit_invoice_lines, :company_store_code
    remove_column :sales_memo_returns, :company_store_code
    remove_column :sales_memo_return_lines, :company_store_code
    remove_column :sales_order_cancels, :company_store_code
    remove_column :sales_order_cancel_lines, :company_store_code
  end

  def self.down
    add_column :sales_orders, :company_store_code, :string, :limit=>25
    add_column :sales_order_lines, :company_store_code, :string, :limit=>25
    add_column :sales_invoices, :company_store_code, :string, :limit=>25
    add_column :sales_invoice_lines, :company_store_code, :string, :limit=>25
    add_column :sales_memos, :company_store_code, :string, :limit=>25
    add_column :sales_memo_lines, :company_store_code, :string, :limit=>25
    add_column :sales_credit_invoices, :company_store_code, :string, :limit=>25
    add_column :sales_credit_invoice_lines, :company_store_code, :string, :limit=>25
    add_column :sales_memo_returns, :company_store_code, :string, :limit=>25
    add_column :sales_memo_return_lines, :company_store_code, :string, :limit=>25
    add_column :sales_order_cancels, :company_store_code, :string, :limit=>25
    add_column :sales_order_cancel_lines, :company_store_code, :string, :limit=>25
  end

end

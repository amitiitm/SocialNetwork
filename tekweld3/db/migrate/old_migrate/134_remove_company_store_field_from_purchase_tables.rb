class RemoveCompanyStoreFieldFromPurchaseTables < ActiveRecord::Migration
  def self.up
    remove_column :purchase_orders, :company_store_code
    remove_column :purchase_order_lines, :company_store_code
    remove_column :purchase_invoices, :company_store_code
    remove_column :purchase_invoice_lines, :company_store_code
    remove_column :purchase_memos, :company_store_code
    remove_column :purchase_memo_lines, :company_store_code
    remove_column :purchase_credit_invoices, :company_store_code
    remove_column :purchase_credit_invoice_lines, :company_store_code
    remove_column :purchase_memo_returns, :company_store_code
    remove_column :purchase_memo_return_lines, :company_store_code
    remove_column :purchase_order_cancels, :company_store_code
    remove_column :purchase_order_cancel_lines, :company_store_code
  end

  def self.down
    add_column :purchase_orders, :company_store_code, :string, :limit=>25
    add_column :purchase_order_lines, :company_store_code, :string, :limit=>25
    add_column :purchase_invoices, :company_store_code, :string, :limit=>25
    add_column :purchase_invoice_lines, :company_store_code, :string, :limit=>25
    add_column :purchase_memos, :company_store_code, :string, :limit=>25
    add_column :purchase_memo_lines, :company_store_code, :string, :limit=>25
    add_column :purchase_credit_invoices, :company_store_code, :string, :limit=>25
    add_column :purchase_credit_invoice_lines, :company_store_code, :string, :limit=>25
    add_column :purchase_memo_returns, :company_store_code, :string, :limit=>25
    add_column :purchase_memo_return_lines, :company_store_code, :string, :limit=>25
    add_column :purchase_order_cancels, :company_store_code, :string, :limit=>25
    add_column :purchase_order_cancel_lines, :company_store_code, :string, :limit=>25
  end

end

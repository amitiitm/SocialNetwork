class AddSkuToSalesPurchaseTables < ActiveRecord::Migration
  def self.up
    add_column :sales_order_lines, :customer_sku_no, :string, :limit=>25
    add_column :sales_invoice_lines, :customer_sku_no, :string, :limit=>25
    add_column :sales_credit_invoice_lines,  :customer_sku_no, :string, :limit=>25
    add_column :sales_memo_lines, :customer_sku_no, :string, :limit=>25
    add_column :sales_order_cancel_lines, :customer_sku_no, :string, :limit=>25
    add_column :sales_memo_return_lines, :customer_sku_no, :string, :limit=>25
    add_column :purchase_order_lines, :vendor_sku_no, :string, :limit=>25
    add_column :purchase_invoice_lines, :vendor_sku_no, :string, :limit=>25
    add_column :purchase_credit_invoice_lines,  :vendor_sku_no, :string, :limit=>25
    add_column :purchase_memo_lines, :vendor_sku_no, :string, :limit=>25
    add_column :purchase_order_cancel_lines, :vendor_sku_no, :string, :limit=>25
    add_column :purchase_memo_return_lines, :vendor_sku_no, :string, :limit=>25
  end

  def self.down
    remove_column :sales_order_lines, :customer_sku_no
    remove_column :sales_invoice_lines, :customer_sku_no
    remove_column :sales_credit_invoice_lines
    remove_column :sales_memo_lines, :customer_sku_no
    remove_column :sales_order_cancel_lines, :customer_sku_no
    remove_column :sales_memo_return_lines, :customer_sku_no
    remove_column :purchase_order_lines, :vendor_sku_no
    remove_column :purchase_invoice_lines, :vendor_sku_no
    remove_column :purchase_credit_invoice_lines,  :vendor_sku_no
    remove_column :purchase_memo_lines, :vendor_sku_no
    remove_column :purchase_order_cancel_lines, :vendor_sku_no
    remove_column :purchase_memo_return_lines, :vendor_sku_no
  end
end

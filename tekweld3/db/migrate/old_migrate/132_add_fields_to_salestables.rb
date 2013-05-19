class AddFieldsToSalestables < ActiveRecord::Migration
  def self.up
    add_column :sales_orders, :ext_ref_no, :string, :limit=>50
    add_column :sales_orders, :ext_ref_date, :datetime
    add_column :sales_orders, :other_amt, :decimal, :precision=>12, :scale=>2, :default=>0
    add_column :sales_orders, :ship_amt, :decimal, :precision=>12, :scale=>2, :default=>0
    add_column :sales_invoices, :ext_ref_no, :string, :limit=>50
    add_column :sales_invoices, :ext_ref_date, :datetime
    add_column :sales_invoices, :other_amt, :decimal, :precision=>12, :scale=>2, :default=>0
    add_column :sales_invoices, :ship_amt, :decimal, :precision=>12, :scale=>2, :default=>0
    add_column :sales_credit_invoices, :ext_ref_no, :string, :limit=>50
    add_column :sales_credit_invoices, :ext_ref_date, :datetime
    add_column :sales_credit_invoices, :other_amt, :decimal, :precision=>12, :scale=>2, :default=>0
    add_column :sales_credit_invoices, :ship_amt, :decimal, :precision=>12, :scale=>2, :default=>0
    add_column :sales_memos, :ext_ref_no, :string, :limit=>50
    add_column :sales_memos, :ext_ref_date, :datetime
    add_column :sales_memos, :other_amt, :decimal, :precision=>12, :scale=>2, :default=>0
    add_column :sales_memos, :ship_amt, :decimal, :precision=>12, :scale=>2, :default=>0
    add_column :sales_order_cancels, :ext_ref_no, :string, :limit=>50
    add_column :sales_order_cancels, :ext_ref_date, :datetime
    add_column :sales_order_cancels, :other_amt, :decimal, :precision=>12, :scale=>2, :default=>0
    add_column :sales_order_cancels, :ship_amt, :decimal, :precision=>12, :scale=>2, :default=>0
    add_column :sales_memo_returns, :ext_ref_no, :string, :limit=>50
    add_column :sales_memo_returns, :ext_ref_date, :datetime
    add_column :sales_memo_returns, :other_amt, :decimal, :precision=>12, :scale=>2, :default=>0
    add_column :sales_memo_returns, :ship_amt, :decimal, :precision=>12, :scale=>2, :default=>0
  end

  def self.down
    remove_column :sales_orders, :ext_ref_no
    remove_column :sales_orders, :ext_ref_date
    remove_column :sales_orders, :other_amt
    remove_column :sales_orders, :ship_amt
    remove_column :sales_invoices, :ext_ref_no
    remove_column :sales_invoices, :ext_ref_date
    remove_column :sales_invoices, :other_amt
    remove_column :sales_invoices, :ship_amt
    remove_column :sales_credit_invoices, :ext_ref_no
    remove_column :sales_credit_invoices, :ext_ref_date
    remove_column :sales_credit_invoices, :other_amt
    remove_column :sales_credit_invoices, :ship_amt
    remove_column :sales_memos, :ext_ref_date
    remove_column :sales_memos, :ext_ref_no
    remove_column :sales_memos, :other_amt
    remove_column :sales_memos, :ship_amt
    remove_column :sales_order_cancels, :ext_ref_date
    remove_column :sales_order_cancels, :ext_ref_no
    remove_column :sales_order_cancels, :other_amt
    remove_column :sales_order_cancels, :ship_amt
    remove_column :sales_memo_returns, :ext_ref_date
    remove_column :sales_memo_returns, :ext_ref_no
    remove_column :sales_memo_returns, :other_amt
    remove_column :sales_memo_returns, :ship_amt
  end
end

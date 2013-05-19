class AddFieldsToPurchasetables < ActiveRecord::Migration
  def self.up
    add_column :purchase_orders, :ext_ref_no, :string, :limit=>50
    add_column :purchase_orders, :ext_ref_date, :datetime
    add_column :purchase_orders, :other_amt, :ship_amt, :decimal, :precision=>12, :scale=>2, :default=>0
    add_column :purchase_invoices, :ext_ref_no, :string, :limit=>50
    add_column :purchase_invoices, :ext_ref_date, :datetime
    add_column :purchase_invoices, :ship_amt, :other_amt, :decimal, :precision=>12, :scale=>2, :default=>0
    add_column :purchase_credit_invoices, :ext_ref_no, :string, :limit=>50
    add_column :purchase_credit_invoices, :ext_ref_date, :datetime
    add_column :purchase_credit_invoices, :ship_amt, :other_amt, :decimal, :precision=>12, :scale=>2, :default=>0
    add_column :purchase_memos, :ext_ref_no, :string, :limit=>50
    add_column :purchase_memos, :ext_ref_date, :datetime
    add_column :purchase_memos, :other_amt, :ship_amt, :decimal, :precision=>12, :scale=>2, :default=>0
    add_column :purchase_order_cancels, :ext_ref_no, :string, :limit=>50
    add_column :purchase_order_cancels, :ext_ref_date, :datetime
    add_column :purchase_order_cancels, :other_amt, :ship_amt, :decimal, :precision=>12, :scale=>2, :default=>0
    add_column :purchase_memo_returns, :ext_ref_no, :string, :limit=>50
    add_column :purchase_memo_returns, :ext_ref_date, :datetime
    add_column :purchase_memo_returns, :other_amt, :ship_amt, :decimal, :precision=>12, :scale=>2, :default=>0
  end

  def self.down
    remove_column :purchase_orders, :ext_ref_no
    remove_column :purchase_orders, :ext_ref_date
    remove_column :purchase_orders, :other_amt
    remove_column :purchase_orders, :ship_amt
    remove_column :purchase_invoices, :ext_ref_no
    remove_column :purchase_invoices, :ext_ref_date
    remove_column :purchase_invoices, :other_amt
    remove_column :purchase_invoices, :ship_amt
    remove_column :purchase_credit_invoices, :ext_ref_no
    remove_column :purchase_credit_invoices, :ext_ref_date
    remove_column :purchase_credit_invoices, :other_amt
    remove_column :purchase_credit_invoices, :ship_amt
    remove_column :purchase_memos, :ext_ref_date
    remove_column :purchase_memos, :ext_ref_no
    remove_column :purchase_memos, :other_amt
    remove_column :purchase_memos, :ship_amt
    remove_column :purchase_order_cancels, :ext_ref_date
    remove_column :purchase_order_cancels, :ext_ref_no
    remove_column :purchase_order_cancels, :other_amt
    remove_column :purchase_order_cancels, :ship_amt
    remove_column :purchase_memo_returns, :ext_ref_date
    remove_column :purchase_memo_returns, :ext_ref_no
    remove_column :purchase_memo_returns, :other_amt
    remove_column :purchase_memo_returns, :ship_amt
  end
end

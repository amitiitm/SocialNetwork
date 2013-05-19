class AddFieldsToPosInvoices < ActiveRecord::Migration
  def self.up
    add_column :pos_invoices, :term_code, :string, :limit=>25
    add_column :pos_invoices, :sales_date, :datetime
    add_column :pos_invoices, :shipping_code, :string, :limit=>25
    add_column :pos_invoices, :due_date, :datetime
    add_column :pos_invoices, :ship_date, :datetime
    add_column :pos_invoices, :trans_type, :string, :limit=>1
    add_column :pos_invoices, :item_qty, :decimal,:precision=>10, :scale=>2, :default=>0
    add_column :pos_invoices, :ext_ref_no, :string, :limit=>25
    add_column :pos_invoices, :ext_ref_date, :datetime
    add_column :pos_invoices, :other_amt, :decimal,:precision=>12, :scale=>2, :default=>0
    add_column :pos_invoices, :salesperson_code, :string, :limit=>25
    remove_column :pos_invoices, :shipping_amt
    add_column :pos_invoices, :ship_amt, :decimal,:precision=>12, :scale=>2, :default=>0
    remove_column :pos_invoices, :comments
    add_column :pos_invoices, :remarks, :string, :limit=>255
  end

  def self.down
    remove_column :pos_invoices, :sales_date
    remove_column :pos_invoices, :term_code
    remove_column :pos_invoices, :shipping_code
    remove_column :pos_invoices, :due_date
    remove_column :pos_invoices, :ship_date
    remove_column :pos_invoices, :trans_type
    remove_column :pos_invoices, :item_qty
    remove_column :pos_invoices, :ext_ref_no
    remove_column :pos_invoices, :ext_ref_date
    remove_column :pos_invoices, :other_amt
    remove_column :pos_invoices, :salesperson_code
    remove_column :pos_invoices, :ship_amt
    add_column :pos_invoices,:shipping_amt, :decimal,:precision=>12, :scale=>2, :default=>0
    remove_column :pos_invoices, :remarks
    add_column :pos_invoices, :comments, :string, :limit=>50
  end
end

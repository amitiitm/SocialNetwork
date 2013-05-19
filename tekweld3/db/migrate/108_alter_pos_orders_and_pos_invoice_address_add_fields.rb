class AlterPosOrdersAndPosInvoiceAddressAddFields < ActiveRecord::Migration
  def self.up
    add_column :pos_orders, :bill_first_name, :string, :limit=>50
    add_column :pos_orders, :bill_last_name, :string, :limit=>50
    add_column :pos_orders, :ship_first_name, :string, :limit=>50
    add_column :pos_orders, :ship_last_name, :string, :limit=>50
    #pos invoice
    add_column :pos_invoice_addresses, :bill_first_name, :string, :limit=>50
    add_column :pos_invoice_addresses, :bill_last_name, :string, :limit=>50
    add_column :pos_invoice_addresses, :ship_first_name, :string, :limit=>50
    add_column :pos_invoice_addresses, :ship_last_name, :string, :limit=>50
    add_column :pos_invoice_addresses, :billing_email, :string, :limit=>200
    add_column :pos_invoice_addresses, :billing_cell_no, :string, :limit=>15
    add_column :pos_invoice_addresses, :shipping_cell_no, :string, :limit=>15
    add_column :pos_invoice_addresses, :shipping_email, :string, :limit=>200
  end

  def self.down
    remove_column :pos_orders, :bill_first_name
    remove_column :pos_orders, :bill_last_name
    remove_column :pos_orders, :ship_first_name
    remove_column :pos_orders, :ship_last_name
     #pos invoice
    remove_column :pos_invoice_addresses, :bill_first_name
    remove_column :pos_invoice_addresses, :bill_last_name
    remove_column :pos_invoice_addresses, :ship_first_name
    remove_column :pos_invoice_addresses, :ship_last_name
    remove_column :pos_invoice_addresses, :billing_cell_no
    remove_column :pos_invoice_addresses, :billing_email
    remove_column :pos_invoice_addresses, :shipping_cell_no
    remove_column :pos_invoice_addresses, :shipping_email
   
  end
end




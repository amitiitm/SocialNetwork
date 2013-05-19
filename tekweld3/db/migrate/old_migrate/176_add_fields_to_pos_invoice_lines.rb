class AddFieldsToPosInvoiceLines < ActiveRecord::Migration
  def self.up
#    add_column :pos_invoice_lines, :trans_date, :datetime
#    add_column :pos_invoice_lines, :trans_bk, :string, :limit=>4
#    add_column :pos_invoice_lines, :account_period_code, :string, :limit=>8
#    add_column :pos_invoice_lines, :item_type, :string, :limit=>1
#    add_column :pos_invoice_lines, :catalog_item_packet_id, :integer , :limit=>4
#    add_column :pos_invoice_lines, :catalog_item_code, :string, :limit=>25
#    add_column :pos_invoice_lines, :trans_no, :string, :limit=>18
#    add_column :pos_invoice_lines, :catalog_item_packet_code, :string, :limit=>25
#    add_column :pos_invoice_lines, :customer_sku_no, :string, :limit=>25
  end

  def self.down
    remove_column :pos_invoice_lines, :trans_date
    remove_column :pos_invoice_lines, :trans_bk
    remove_column :pos_invoice_lines, :account_period_code
    remove_column :pos_invoice_lines, :item_type
    remove_column :pos_invoice_lines, :catalog_item_packet_id
    remove_column :pos_invoice_lines, :catalog_item_code
    remove_column :pos_invoice_lines, :trans_no
    remove_column :pos_invoice_lines, :catalog_item_packet_code
    remove_column :pos_invoice_lines, :customer_sku_no
  end
end

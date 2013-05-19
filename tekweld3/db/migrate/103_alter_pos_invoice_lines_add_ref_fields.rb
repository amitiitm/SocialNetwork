class AlterPosInvoiceLinesAddRefFields < ActiveRecord::Migration
  def self.up
    add_column :pos_invoice_lines, :ref_trans_id, :integer
    add_column :pos_invoice_lines, :ref_type , :string ,:limit=>3
    add_column :pos_invoice_lines, :ref_trans_no , :string ,:limit=>18
    add_column :pos_invoice_lines, :ref_trans_bk  , :string ,:limit=>4
    add_column :pos_invoice_lines, :ref_serial_no , :string ,:limit=>6
    add_column :pos_invoice_lines, :ref_trans_date, :datetime
  end

  def self.down
    remove_column :pos_invoice_lines, :ref_trans_id
    remove_column :pos_invoice_lines, :ref_type
    remove_column :pos_invoice_lines, :ref_trans_no 
    remove_column :pos_invoice_lines, :ref_trans_bk  
    remove_column :pos_invoice_lines, :ref_serial_no 
    remove_column :pos_invoice_lines, :ref_trans_date
  end
end

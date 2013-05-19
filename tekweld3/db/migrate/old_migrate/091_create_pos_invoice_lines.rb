class CreatePosInvoiceLines < ActiveRecord::Migration
  def self.up
    create_table :pos_invoice_lines do |t|
      t.integer   :company_id, :null=>false
      t.integer   :created_by, :updated_by
      t.datetime  :created_at, :updated_at
      t.string    :update_flag, :limit=>1,:default=>'Y'
      t.string    :trans_flag, :limit=>1,:default=>'A'
      t.string    :trans_type, :limit=>1,:default=>'S'
      t.integer   :lock_version, :default=>0 
      t.integer   :pos_invoice_id, :ref_pos_invoice_id, :catalog_item_id
      t.string    :serial_no, :limit=>6
      t.string    :item_name, :limit=>50
      t.string    :item_description, :limit=>100
      t.decimal   :discount_per, :precision=>6, :scale=>2, :default=>0
      t.decimal   :tax_per, :precision=>6, :scale=>3, :default=>0
      t.decimal   :item_qty, :clear_qty, :precision=>10, :scale=>2, :default=>0
      t.decimal   :item_price, :item_amt, :net_amt, :discount_amt, :tax_amt, :precision=>12, :scale=>2, :default=>0
    end
  end

  def self.down
    drop_table :pos_invoice_lines
  end
end

class CreateVendorInvoiceLines < ActiveRecord::Migration
  def self.up
    create_table :vendor_invoice_lines do |t|
      t.integer   :company_id, :null=>false
      t.integer   :created_by, :updated_by
      t.datetime  :created_at, :updated_at
      t.string    :update_flag, :limit=>1,:default=>'Y'
      t.string    :trans_flag, :limit=>1,:default=>'A'
      t.integer   :lock_version, :default=>0 
      t.string    :trans_bk, :limit=>4
      t.string    :trans_no, :limit=>18
      t.datetime  :trans_date
      t.string    :serial_no, :limit=>6
      t.integer   :vendor_invoice_id, :gl_account_id
      t.decimal   :gl_amt , :precision=>12, :scale=>2
      t.string    :description, :limit=>50
    end
  end

  def self.down
    drop_table :vendor_invoice_lines 
  end
end

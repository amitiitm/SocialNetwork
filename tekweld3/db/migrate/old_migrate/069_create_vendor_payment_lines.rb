class CreateVendorPaymentLines < ActiveRecord::Migration
  def self.up
  create_table :vendor_payment_lines do |t|
      t.integer   :company_id, :null=>false
      t.integer   :created_by, :updated_by
      t.datetime  :created_at, :updated_at
      t.string    :update_flag, :limit=>1,:default=>'Y'
      t.string    :trans_flag, :limit=>1,:default=>'A'
      t.integer   :lock_version, :default=>0 
      t.string    :trans_bk, :limit=>4
      t.string    :trans_no, :limit=>18
      t.string    :voucher_no,:limit=>18
      t.datetime  :trans_date, :voucher_date, :due_date
      t.string    :serial_no, :limit=>6
      t.string    :voucher_flag, :apply_flag , :limit=>1
      t.integer   :vendor_payment_id,  :gl_account_id 
      t.decimal   :original_amt, :apply_amt ,:balance_amt, :disctaken_amt, :precision=>12, :scale=>2
      t.string    :apply_to, :limit=>10
      t.string    :ref_no, :limit=>20
    end
  end 

  def self.down
    drop_table :vendor_payment_lines
  end
end

class CreateGlDetails < ActiveRecord::Migration
  def self.up
    create_table :gl_details do |t|
      t.integer   :company_id, :null=>false
      t.integer   :created_by, :updated_by
      t.datetime  :created_at, :updated_at
      t.string    :update_flag, :limit=>1,:default=>'Y'
      t.string    :trans_flag, :limit=>1,:default=>'A'
      t.integer   :lock_version, :default=>0 
      t.string    :trans_bk, :ref_bk, :limit=>4
      t.string    :trans_no, :limit=>18
      t.datetime  :trans_date, :ref_date
      t.string    :account_period_code, :limit=>8
      t.string    :dtl_serial_no, :limit=>6
      t.integer   :gl_account_id
      t.decimal   :debit_amt, :credit_amt , :precision=>12, :scale=>2
      t.string    :description, :limit=>50
      t.string    :trans_type, :limit=>4
      t.string    :ref_no, :limit=>15
      t.string    :post_flag, :limit=>1
      t.string    :customer_vendor_flag, :limit=>1
      t.integer   :customer_vendor_id
      t.string    :hdr_serial_no, :module_code, :limit=>6
    end
  end

  def self.down
     drop_table :gl_details
  end
end

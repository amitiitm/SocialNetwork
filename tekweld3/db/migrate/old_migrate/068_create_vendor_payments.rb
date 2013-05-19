class CreateVendorPayments < ActiveRecord::Migration
  def self.up
   create_table :vendor_payments do |t|
      t.integer   :company_id, :null=>false
      t.integer   :created_by, :updated_by
      t.datetime  :created_at, :updated_at
      t.string    :update_flag, :limit=>1,:default=>'Y'
      t.string    :trans_flag, :limit=>1,:default=>'A'
      t.integer   :lock_version, :default=>0 
      t.string    :trans_bk, :limit=>4
      t.string    :trans_no, :limit=>18
      t.datetime  :trans_date, :check_date, :due_date
      t.string    :account_period_code, :limit=>8
      t.string    :post_flag, :action_flag, :limit=>1
      t.string    :trans_type, :limit=>1
      t.string    :payment_type, :limit=>4
      t.integer   :vendor_id,  :soldto_id, :bank_id
      t.string    :term_code, :purchaseperson_code,  :limit=>25
      t.decimal   :paid_amt, :applied_amt ,:balance_amt, :item_qty, :precision=>12, :scale=>2
      t.string    :check_no, :limit=>15
      t.string    :description, :limit=>50
      t.string    :deposit_no, :limit=>15
    end
  end
 
  def self.down
    drop_table :vendor_payments
  end
end

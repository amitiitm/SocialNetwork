class CreateBankTransactions < ActiveRecord::Migration
  def self.up
     create_table :bank_transactions do |t|
      t.integer   :company_id, :null=>false
      t.integer   :created_by, :updated_by
      t.datetime  :created_at, :updated_at
      t.string    :update_flag, :limit=>1,:default=>'Y'
      t.string    :trans_flag, :limit=>1,:default=>'A'
      t.integer   :lock_version, :default=>0 
      t.string    :trans_bk, :limit=>4
      t.string    :trans_no, :limit=>18
      t.datetime  :trans_date, :check_date, :clear_date
      t.string    :account_period_code, :limit=>8
      t.string    :post_flag, :clear_flag, :action_flag, :account_flag, :limit=>1
      t.string    :trans_type, :payment_type,:limit=>4
      t.integer   :account_id, :deposit_no, :bank_id
      t.decimal   :debit_amt, :credit_amt , :precision=>12, :scale=>2
      t.string    :check_no, :limit=>15
      t.string    :remarks, :ref_no, :payto_name, :limit=>50
      t.string    :comments, :limit=>300
      t.string    :serial_no, :limit=>6
    end
  end

  def self.down
    drop_table :bank_transactions
  end
end

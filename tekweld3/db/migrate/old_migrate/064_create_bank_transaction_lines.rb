class CreateBankTransactionLines < ActiveRecord::Migration
  def self.up
    create_table :bank_transaction_lines do |t|
      t.integer   :company_id, :null=>false
      t.integer   :created_by, :updated_by
      t.datetime  :created_at, :updated_at
      t.string    :update_flag, :limit=>1,:default=>'Y'
      t.string    :trans_flag, :limit=>1,:default=>'A'
      t.integer   :lock_version, :default=>0 
      t.string    :trans_bk, :limit=>4
      t.string    :trans_no, :limit=>18
      t.datetime  :trans_date
      t.integer   :gl_account_id, :bank_transaction_id
      t.decimal   :debit_amt, :credit_amt , :precision=>12, :scale=>2
      t.string    :description, :limit=>50
      t.string    :serial_no, :limit=>6
    end
  end

  def self.down
    drop_table :bank_transaction_lines
  end
end

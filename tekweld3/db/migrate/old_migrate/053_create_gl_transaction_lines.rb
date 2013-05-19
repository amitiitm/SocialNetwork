class CreateGlTransactionLines < ActiveRecord::Migration
  def self.up
    create_table :gl_transaction_lines do |t|
      t.integer   :company_id, :null=>false
      t.integer   :created_by, :updated_by
      t.datetime  :created_at, :updated_at
      t.string    :update_flag, :limit=>1,:default=>'Y'
      t.string    :trans_flag, :limit=>1,:default=>'A'
      t.integer   :lock_version, :default=>0 
      t.string    :trans_bk, :limit=>4
      t.string    :trans_no,:ref_no, :limit=>18
      t.datetime  :trans_date, :ref_date
      t.string    :serial_no, :limit=>6
      t.integer   :gl_account_id,:gl_transaction_id
      t.decimal   :debit_amt, :credit_amt , :precision=>12, :scale=>2
      t.string    :description, :limit=>50
      t.string    :post_flag, :limit=>1
    
    end
  end

  def self.down
    drop_table :gl_transaction_lines
  end
end

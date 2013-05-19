class CreateGlTransactions < ActiveRecord::Migration
  def self.up
    create_table :gl_transactions do |t|
      t.integer   :company_id, :null=>false
      t.integer   :created_by, :updated_by
      t.datetime  :created_at, :updated_at
      t.string    :update_flag, :limit=>1,:default=>'Y'
      t.string    :trans_flag, :limit=>1,:default=>'A'
      t.integer   :lock_version, :default=>0 
      t.string    :trans_bk, :limit=>4
      t.string    :trans_no, :limit=>18
      t.datetime  :trans_date
      t.string    :account_period_code, :limit=>8
      t.string    :trans_type, :limit=>4
      t.string    :post_flag, :limit=>1
    end
  end

  def self.down
    drop_table :gl_transactions
  end
end

class CreateInventoryTransactions < ActiveRecord::Migration
  def self.up
    create_table :inventory_transactions do |t|
      t.integer   :company_id, :null=>false
      t.integer   :created_by, :updated_by
      t.datetime  :created_at, :updated_at
      t.string    :update_flag, :limit=>1,:default=>'Y'
      t.string    :trans_flag, :limit=>1,:default=>'A'
      t.integer   :lock_version, :default=>0            
      t.string    :trans_bk, :limit=>4	
      t.string    :trans_no,:limit=>18	
      t.datetime  :trans_date
      t.string    :account_period_code, :limit=>8
      t.string    :receipt_issue_flag, :limit=>1
      t.string    :trans_type, :limit=>1
      t.integer   :trans_type_id
      t.string    :ext_ref_no, :limit=>50
      t.datetime  :ext_ref_date
      t.string    :remarks, :limit=>50
    end
  end

  def self.down
    drop_table :inventory_transactions
  end
end

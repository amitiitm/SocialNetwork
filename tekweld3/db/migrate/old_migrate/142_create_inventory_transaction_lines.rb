class CreateInventoryTransactionLines < ActiveRecord::Migration
  def self.up
    create_table :inventory_transaction_lines do |t|
      t.integer   :company_id, :null=>false
      t.integer   :created_by, :updated_by
      t.datetime  :created_at, :updated_at
      t.string    :update_flag, :limit=>1,:default=>'Y'
      t.string    :trans_flag, :limit=>1,:default=>'A'
      t.integer   :lock_version, :default=>0            
      t.integer   :inventory_transaction_id, :null=>false
      t.string    :trans_bk, :limit=>4	
      t.string    :trans_no, :limit=>18	
      t.datetime  :trans_date
      t.string    :serial_no, :limit=>6
      t.string    :account_period_code, :limit=>8
      t.string    :receipt_issue_flag, :limit=>1
      t.string    :item_type, :limit=>1	
      t.integer   :catalog_item_id, :null=>false
      t.string    :catalog_item_code, :limit=>25, :null=>false
      t.decimal   :rec_qty, :iss_qty, :precision=>10, :scale=>2, :default=>0
      t.decimal   :rec_price, :rec_amt, :iss_price, :iss_amt, :precision=>12, :scale=>2, :default=>0
    end
  end

  def self.down
    drop_table :inventory_transaction_lines
  end
end


class CreateInventoryDetails < ActiveRecord::Migration
  def self.up
    create_table :inventory_details do |t|
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
      t.string    :account_period_code, :limit=>8
      t.string    :company_store_code, :limit=>25, :null=>false
      t.integer   :catalog_item_id, :null=>false
      t.decimal   :stock_rec_qty,:stock_iss_qty, :memo_rec_qty, :memo_iss_qty, :precision=>10, :scale=>2, :default=>0
      t.decimal   :stock_rec_price, :stock_iss_price, :memo_rec_price, :memo_iss_price, :precision=>12, :scale=>2, :default=>0
      t.decimal   :stock_rec_amt, :stock_iss_amt, :memo_rec_amt, :memo_iss_amt, :precision=>12, :scale=>2, :default=>0
    end
  end

  def self.down
    drop_table :inventory_details
  end
end

class CreateInventorySummaries < ActiveRecord::Migration
  def self.up
    create_table :inventory_summaries do |t|
      t.integer   :company_id, :null=>false
      t.integer   :created_by, :updated_by
      t.datetime  :created_at, :updated_at
      t.string    :update_flag, :limit=>1,:default=>'Y'
      t.string    :trans_flag, :limit=>1,:default=>'A'
      t.integer   :lock_version, :default=>0 
      t.string    :account_period_code, :limit=>8
      t.string    :company_store_code, :limit=>25, :null=>false
      t.integer   :catalog_item_id, :null=>false
      t.decimal   :stock_rec_qty,:stock_iss_qty, :memo_rec_qty, :memo_iss_qty, :precision=>10, :scale=>2
      t.decimal   :stock_rec_amt, :stock_iss_amt, :memo_rec_amt, :memo_iss_amt, :precision=>12, :scale=>2
    end
  end

  def self.down
    drop_table :inventory_summaries
  end
end

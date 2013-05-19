class CreateDiamondInventoryDetails < ActiveRecord::Migration
  def self.up
    create_table :diamond_inventory_details do |t|
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
      t.string    :trans_type, :limit=>4	
      t.integer   :diamond_lot_id, :diamond_packet_id, :customer_vendor_id
      t.string    :location_code, :limit=>25
      t.string    :stone_type, :shape, :color, :clarity, :quality, :limit=>18
      t.decimal   :stock_rec_pcs, :stock_iss_pcs, :memo_rec_pcs, :memo_iss_pcs, :precision=>10, :scale=>2, :default=>0
      t.decimal   :stock_rec_wt, :stock_iss_wt, :memo_rec_wt, :memo_iss_wt, :precision=>12, :scale=>3, :default=>0
      t.decimal   :stock_rec_amt, :stock_iss_amt, :memo_rec_amt, :memo_iss_amt, :precision=>12, :scale=>2, :default=>0
      t.decimal   :stock_rec_price, :stock_iss_price, :memo_rec_price, :memo_iss_price, :cost, :precision=>10, :scale=>2, :default=>0
      t.string    :sell_unit, :limit=>4	
      t.string    :type, :limit=>50
      t.string    :account_period_code, :limit=>8
      t.string    :remarks, :limit=>255
      t.string    :customer_vendor_flag, :limit=>1
    end
  end

  def self.down
    drop_table :diamond_inventory_details
  end
end

class CreateDiamondInventoryLines < ActiveRecord::Migration
  def self.up
    create_table :diamond_inventory_lines do |t|
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
      t.integer   :diamond_lot_id, :diamond_packet_id, :customer_id
      t.integer   :vendor_id, :diamond_inventory_id
      t.string    :remarks, :limit=>255	
      t.string    :ri_flag, :memo_flag, :limit=>1	
      t.string    :account_period_code, :limit=>8
      t.string    :location_code, :stone_type, :shape, :color, :clarity, :quality, :limit=>25
      t.decimal   :size, :precision=>7, :scale=>2
      t.decimal   :iss_pcs, :rec_pcs, :iss_price, :rec_price, :precision=>12, :scale=>2
      t.decimal   :iss_wt, :rec_wt, :precision=>12, :scale=>3
      t.decimal   :iss_amt, :rec_amt, :wtd_cost, :precision=>12, :scale=>2
    end
  end

  def self.down
    drop_table :diamond_inventory_lines
  end
end

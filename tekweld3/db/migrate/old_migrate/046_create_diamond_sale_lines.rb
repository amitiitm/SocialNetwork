class CreateDiamondSaleLines < ActiveRecord::Migration
  def self.up
    create_table :diamond_sale_lines do |t|
      t.integer   :company_id, :null=>false
      t.integer   :created_by, :updated_by
      t.datetime  :created_at, :updated_at
      t.string    :update_flag, :limit=>1,:default=>'Y'
      t.string    :trans_flag, :limit=>1,:default=>'A'
      t.integer   :lock_version, :default=>0 
      t.string    :trans_bk, :ref_trans_bk, :limit=>4	
      t.string    :trans_no, :ref_trans_no, :limit=>18	
      t.datetime  :trans_date, :ref_trans_date
      t.string    :serial_no, :ref_serial_no, :limit=>6
      t.string    :ref_type, :limit=>1	
      t.integer   :diamond_lot_id, :diamond_packet_id, :diamond_sale_id
      t.string    :location_code, :limit=>25
      t.string    :stone_type, :shape, :color, :clarity, :quality, :limit=>18
      t.decimal   :commission_per,:discount_per, :size, :precision=>6, :scale=>2
      t.decimal   :pcs, :ref_pcs, :clear_pcs, :precision=>10, :scale=>2
      t.decimal   :wt, :ref_wt, :clear_wt, :precision=>12, :scale=>3
      t.decimal   :net_amt, :discount_amt, :line_amt, :commission_amt, :precision=>12, :scale=>2
      t.decimal   :price, :cost, :precision=>10, :scale=>2
      t.string    :sell_unit, :limit=>4	
      t.string    :type, :limit=>50
      t.string    :account_period_code, :limit=>8
    end
  end

  def self.down
    drop_table :diamond_sale_lines
  end
end

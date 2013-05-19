class CreateContractorMemos < ActiveRecord::Migration
  def self.up
    create_table :contractor_memos do |t|
      t.integer   :company_id,  :null => false
      t.integer   :created_by
      t.integer   :updated_by
      t.timestamp :created_at
      t.timestamp :updated_at
      t.string    :update_flag,  :limit => 1,    :default => "Y"
      t.string    :trans_flag,   :limit => 1,    :default => "A"
      t.integer   :lock_version,                 :default => 0
      t.string    :trans_bk,      :limit => 4  , :null => false
      t.string    :trans_no,      :limit => 18 , :null => false
      t.timestamp :trans_date
      t.string    :trans_type,   :limit => 1
      t.string    :account_period_code,    :limit => 8 , :null => false
      t.string    :ref_trans_id,      :limit => 4 
      t.string    :ref_trans_bk,      :limit => 4 
      t.string    :ref_trans_no,      :limit => 18 
      t.timestamp :ref_trans_date
      t.string    :ref_type,   :limit => 1
      t.integer   :contractor_id
      t.string    :bill_name ,:limit =>50
      t.string    :bill_address1 ,:limit =>50
      t.string    :bill_address2 ,:limit =>50
      t.string    :bill_city ,:limit =>25
      t.string    :bill_state ,:limit =>25
      t.string    :bill_zip,:limit =>15
      t.string    :bill_country,:limit =>20
      t.string    :bill_phone,:limit =>50
      t.string    :bill_fax,:limit =>50
      t.integer   :store_id
      t.string    :ship_name,:limit =>50
      t.string    :ship_address1,:limit =>50
      t.string    :ship_address2,:limit =>50
      t.string    :ship_city,:limit =>25
      t.string    :ship_state,:limit =>25
      t.string    :ship_zip,:limit =>15
      t.string    :ship_country,:limit =>20
      t.string    :ship_phone,:limit =>50
      t.string    :ship_fax,:limit =>50
      t.string    :ext_ref_no,:limit =>50
      t.timestamp :ext_ref_date 
      t.timestamp :memo_date 
      t.string    :term_code,:limit =>25
      t.timestamp :cancel_date 
      t.timestamp :due_date 
      t.timestamp :ship_date 
      t.string    :shipping_code,:limit =>25
      t.string    :tracking_no,:limit =>50
      t.string    :post_flag,:limit =>1
      t.decimal   :memo_qty, :precision=>6, :scale=>2     ,:default=>0.00
      t.decimal   :clear_qty, :precision=>6, :scale=>2 ,:default=>0.00
      t.integer   :catalog_item_id
      t.string    :catalog_item_code,:limit =>255
      t.string    :catalog_item_description,:limit =>50
      t.integer   :catalog_item_packet_id
      t.string    :catalog_item_packet_code,:limit =>25
      t.string    :vendor_instruction,:limit =>255
      t.string    :metal_type,:limit =>25
      t.string    :metal_color,:limit =>25
      t.decimal   :metal_weight, :precision=>12, :scale=>4
      t.integer   :stone_lot_id
      t.string    :stone_lot_number,:limit =>25
      t.integer   :stone_packet_id
      t.string    :stone_packet_code,:limit =>25
      t.string    :stone_type,:limit =>4
      t.string    :stone_shape,:limit =>18
      t.decimal   :stone_size , :precision=>7, :scale=>2
      t.string    :stone_quality ,:limit=>18
      t.string    :stone_color ,:limit =>18
      t.string    :stone_clarity,:limit =>18
      t.string    :stone_setting,:limit =>18
      t.decimal   :stone_weight, :precision=>8, :scale=>4
      t.decimal   :stone_qty , :precision=>5, :scale=>0
      t.string    :length,:limit =>25
      t.string    :finish,:limit =>25
      t.string    :size,:limit =>25
      t.decimal   :discount_per, :precision=>6, :scale=>2
      t.decimal   :discount_amt, :precision=>12, :scale=>2
      t.decimal   :tax_per, :precision=>6, :scale=>3
      t.decimal   :tax_amt , :precision=>12, :scale=>2
      t.decimal   :other_amt, :precision=>12, :scale=>2
      t.decimal   :ship_amt , :precision=>12, :scale=>2
      t.decimal   :item_amt , :precision=>12, :scale=>2
      t.decimal   :net_amt , :precision=>12, :scale=>2
      t.string    :remarks,:limit =>255
       
    end
  end

  def self.down
    drop_table :contractor_memos
  end
end

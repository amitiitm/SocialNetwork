class CreatePosOrderTrackings < ActiveRecord::Migration
  def self.up
    create_table :pos_order_trackings do |t|
      t.integer   :company_id,  :null => false
      t.integer   :created_by
      t.integer   :updated_by
      t.timestamp :created_at
      t.timestamp :updated_at
      t.string    :update_flag,  :limit => 1,    :default => "Y"
      t.string    :trans_flag,   :limit => 1,    :default => "A"
      t.integer   :lock_version,                 :default => 0
      t.integer   :store_id
      t.string    :trans_bk,      :limit => 4  , :null => false
      t.string    :trans_no,      :limit => 18 , :null => false
      t.timestamp :trans_date
      t.string    :trans_type,   :limit => 1
      t.string    :account_period_code,    :limit => 8 , :null => false
      t.integer   :customer_id
      t.string    :bill_name,:limit =>50
      t.integer   :customer_shipping_id
      t.string    :ship_name,:limit =>50
      t.string    :ext_ref_no, :limit =>50
      t.timestamp :ext_ref_date
      t.string    :salesperson_code, :limit =>25
      t.timestamp :promised_date
      t.timestamp :estimated_date
      t.integer   :catalog_item_id
      t.string    :catalog_item_code,:limit =>255
      t.string    :catalog_item_description,:limit =>50
      t.integer   :catalog_item_packet_id
      t.string    :catalog_item_packet_code,:limit =>25
      t.decimal   :item_qty, :precision=>6, :scale=>2 
      t.decimal   :clear_qty, :precision=>6, :scale=>2 
      t.string    :stage1,:limit =>50
      t.string    :stage2,:limit =>50
      t.string    :stage3,:limit =>50
      t.string    :stage4,:limit =>50
      t.string    :stage5,:limit =>50
      t.string    :stage6,:limit =>50
      t.string    :stage7,:limit =>50
      t.string    :stage8,:limit =>50
      t.string    :stage9,:limit =>50
      t.string    :stage10,:limit =>50
    end
  end

  def self.down
    drop_table :pos_order_trackings
  end
end

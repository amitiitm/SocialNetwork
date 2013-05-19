class CreateWorkbags < ActiveRecord::Migration
  def self.up
    create_table :workbags do |t|
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
      t.integer   :ref_trans_id
      t.string    :ref_trans_bk ,      :limit => 4
      t.string    :ref_trans_no ,      :limit => 18
      t.timestamp :ref_trans_date
      t.string    :ref_type,:limit => 1
      t.decimal   :ref_qty , :precision=>6, :scale=>2
      t.integer   :customer_id 
      t.string    :customer_name,      :limit => 50
      t.string    :ext_ref_no,      :limit => 50
      t.timestamp :ext_ref_date
      t.string    :post_flag,      :limit => 1
      t.integer   :store_id 
      t.decimal   :wb_qty, :precision=>12, :scale=>2
      t.string    :open_flag,      :limit => 1
      t.string    :internal_description,      :limit => 255
      t.string    :remarks,      :limit => 255
      t.integer   :catalog_item_id 
      t.string    :catalog_item_code,      :limit => 25
      t.string    :catalog_item_description,      :limit => 50
      t.integer   :catalog_item_packet_id
      t.string    :catalog_item_packet_code,      :limit => 25
      t.integer   :po_vendor_id
      t.integer   :vendor_po_id
      t.string    :vendor_po_no,      :limit => 25
      t.timestamp :vendor_po_date                            
      t.decimal   :vendor_po_qty, :precision=>6, :scale=>2
      t.string    :current_stage,      :limit => 25
      t.string    :current_status,      :limit => 25
      t.timestamp :estimated_date 
      t.string    :vendor_instruction,      :limit => 255
      t.string    :metal_type,      :limit => 25
      t.string    :metal_color,      :limit => 25
      t.decimal   :metal_weight, :precision=>12, :scale=>4
      t.integer   :stone_lot_id
      t.string    :stone_lot_number,:limit =>25
      t.integer   :stone_packet_id
      t.string    :stone_packet_code,      :limit => 25
      t.string    :stone_type,      :limit => 4
      t.string    :stone_shape,      :limit => 18
      t.decimal   :stone_size, :precision=>7, :scale=>2
      t.string    :stone_quality,      :limit => 18
      t.string    :stone_color,      :limit => 18
      t.string    :stone_clarity,      :limit => 18
      t.string    :stone_setting,      :limit => 18
      t.decimal   :stone_weight, :precision=>8, :scale=>4
      t.decimal   :stone_qty, :precision=>5, :scale=>0
      t.string    :size,      :limit => 25
      t.string    :length,      :limit => 25
      t.string    :finish,      :limit => 25
    end
  end

  def self.down
    drop_table :workbags
  end
end

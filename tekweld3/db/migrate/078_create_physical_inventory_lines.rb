class CreatePhysicalInventoryLines < ActiveRecord::Migration
  def self.up
    create_table :physical_inventory_lines do |t|
      t.integer   :company_id,  :null => false
      t.integer   :created_by
      t.integer   :updated_by
      t.timestamp :created_at
      t.timestamp :updated_at
      t.string    :update_flag,  :limit => 1,    :default => "Y"
      t.string    :trans_flag,   :limit => 1,    :default => "A"
      t.integer   :lock_version,                 :default => 0
      t.integer   :physical_inventory_id, :null=>false
      t.string    :trans_bk,      :limit => 4  , :null => false
      t.string    :trans_no,      :limit => 18 , :null => false
      t.timestamp :trans_date
      t.string    :serial_no, :limit => 6
      t.integer   :catalog_item_id
      t.string    :catalog_item_code, :limit => 25
      t.integer   :catalog_item_packet_id
      t.string    :catalog_item_packet_code, :limit => 25
      t.string    :memo_flag, :limit => 1
      t.decimal   :item_qty, :precision => 10, :scale => 2
      t.decimal   :item_price, :precision => 12, :scale => 2
      t.decimal   :item_amount, :precision => 12, :scale => 2
    end
  end

  def self.down
    drop_table :physical_inventory_lines
  end
end

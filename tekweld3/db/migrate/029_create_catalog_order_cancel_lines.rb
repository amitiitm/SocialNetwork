class CreateCatalogOrderCancelLines < ActiveRecord::Migration
  def self.up
    create_table :catalog_order_cancel_lines do |t|
      t.integer   :company_id,:default => 1,   :null => false
      t.integer   :created_by
      t.integer   :updated_by
      t.timestamp :created_at
      t.timestamp :updated_at
      t.string    :update_flag, :limit => 1, :default => "Y"
      t.string    :trans_flag, :limit => 1,                                 :default => "A"
      t.integer   :lock_version, :default => 0
      t.integer   :user_id, :default => 0
      t.integer   :catalog_order_cancel_id, :null => false
      t.integer   :catalog_item_id, :null => false
      t.timestamp :ship_date
      t.timestamp :cancel_date
      t.integer   :qty, :null => false
      t.decimal   :item_price, :precision => 12, :scale => 2
      t.decimal   :discount, :precision => 12, :scale => 2
      t.decimal   :amount, :precision => 12, :scale => 2
      t.string    :trans_bk, :ref_trans_bk, :limit => 4
      t.string    :trans_no, :ref_trans_no, :limit => 18
      t.timestamp :trans_date, :ref_trans_date
      t.string    :serial_no, :limit => 6
      t.integer   :catalog_item_packet_id
      t.string    :catalog_item_packet_code, :limit => 25
      t.string    :spl_order_flag, :limit=>1, :default=>'N'
      t.string    :size, :limit=>10
      t.string    :metal_color, :limit=>10
      t.string    :diamond, :limit=>10
      t.string    :metal_type, :limit=>10
      t.string    :pearl_type, :limit=>10
      t.string    :pearl_color, :limit=>10
      t.string    :pearl_size, :limit=>10
      t.string    :remarks, :limit=>255
    end
  end

  def self.down
    drop_table :catalog_order_cancel_lines
  end
end

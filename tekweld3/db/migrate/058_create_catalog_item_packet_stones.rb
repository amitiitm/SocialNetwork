class CreateCatalogItemPacketStones < ActiveRecord::Migration
  def self.up
    create_table :catalog_item_packet_stones do |t|
      t.integer   :company_id,  :null => false
      t.integer   :created_by
      t.integer   :updated_by
      t.timestamp :created_at
      t.timestamp :updated_at
      t.string    :update_flag,  :limit => 1,    :default => "Y"
      t.string    :trans_flag,   :limit => 1,    :default => "A"
      t.integer   :lock_version, :default => 0
      t.integer   :catalog_item_packet_id, :default=>0
      t.string    :catalog_item_packet_code, :limit=>25
      t.integer   :serial_no
      t.string    :shade, :limit=>4
      t.string    :cut, :limit=>4
      t.string    :stone_type, :limit=>4
      t.string    :stone_quality, :limit=>25
      t.string    :stone_setting, :limit=>4
      t.string    :stone_shape, :limit=>25
      t.string    :stone_size, :limit=>25
      t.decimal   :sieve_size, :precision=>8, :scale=>4
      t.string    :stone_color, :limit=>25
      t.string    :stone_clarity, :limit=>25
      t.string    :stone_sizemm, :limit=>25
      t.string    :stone_width, :limit=>25
      t.string    :stone_sizegroup, :limit=>20
      t.decimal   :stone_loss_amt, :precision=>12, :scale=>2
      t.decimal   :qty, :precision=>5, :scale=>1
      t.decimal   :wt, :precision=>8, :scale=>4
      t.decimal   :total_wt, :precision=>10, :scale=>4
      t.decimal   :cost, :precision=>10, :scale=>2
      t.decimal   :price_per_pcs, :precision=>10, :scale=>2
      t.decimal   :total_cost, :precision=>10, :scale=>2
      t.decimal   :labor, :precision=>8, :scale=>2
      t.decimal   :setting_cost, :precision=>10, :scale=>2
      t.decimal   :cert_cost, :precision=>10, :scale=>2
      t.string    :make, :limit=>4
      t.string    :setter, :limit=>1
      t.string    :supplier, :limit=>1
      t.string    :cert_flag, :limit=>1
      t.string    :cert_lab_code, :limit=>18
      t.string    :flag1, :limit=>1
      t.decimal   :markup_per, :precision=>12, :scale=>2
      t.decimal   :price, :precision=>12, :scale=>2
      t.string    :remarks, :limit=>250
    end
  end

  def self.down
    drop_table :catalog_item_packet_stones
  end
end

class CreateCatalogItemPacketExtensions < ActiveRecord::Migration
  def self.up
    create_table :catalog_item_packet_extensions do |t|
      t.integer   :company_id,  :null => false
      t.integer   :created_by
      t.integer   :updated_by
      t.timestamp :created_at
      t.timestamp :updated_at
      t.string    :update_flag,  :limit => 1,    :default => "Y"
      t.string    :trans_flag,   :limit => 1,    :default => "A"
      t.integer   :lock_version, :default => 0
      t.integer   :catalog_item_packet_id, :default=>0
      t.string    :metal_type, :limit=>25
      t.string    :metal_color, :limit=>25
      t.decimal   :total_diamond_amt, :precision=>12, :scale=>2
      t.decimal   :metal_base_rate, :precision=>12, :scale=>2
      t.decimal   :metal_surcharge, :precision=>12, :scale=>2
      t.decimal   :metal_total_rate, :precision=>12, :scale=>2
      t.decimal   :metal_increment, :precision=>8, :scale=>6
      t.string    :casting_unit, :limit=>25
      t.decimal   :casting_wt, :precision=>10, :scale=>4
      t.decimal   :casting_cost, :precision=>12, :scale=>2
      t.decimal   :casting_amt, :precision=>12, :scale=>2
      t.string    :finding_unit, :limit=>25
      t.decimal   :finding_wt, :precision=>10, :scale=>4
      t.decimal   :finding_cost, :precision=>12, :scale=>2
      t.decimal   :finding_amt, :precision=>12, :scale=>2
      t.decimal   :setting_amt, :precision=>12, :scale=>2
      t.decimal   :handling_amt, :precision=>12, :scale=>2
      t.decimal   :labor_amt, :precision=>12, :scale=>2
      t.decimal   :tag_price, :precision=>12, :scale=>2
      t.integer   :diamond_qty, :default=>0
      t.decimal   :diamond_wt, :precision=>10, :scale=>4
      t.integer   :color_stone_qty, :default=>0
      t.decimal   :color_stone_wt, :precision=>10, :scale=>4
      t.string    :certificate, :limit=>1, :default=>'N'
    end
  end

  def self.down
    drop_table :catalog_item_packet_extensions
  end
end

class CreateCatalogInventories < ActiveRecord::Migration
  def self.up
    create_table :catalog_inventories do |t|
      t.integer   :company_id,  :null => false
      t.integer   :created_by
      t.integer   :updated_by
      t.timestamp :created_at
      t.timestamp :updated_at
      t.string    :update_flag,  :limit => 1,    :default => "Y"
      t.string    :trans_flag,   :limit => 1,    :default => "A"
      t.integer   :lock_version,                 :default => 0
      t.string    :item_type ,:limit=>1
      t.string    :catalog_item_category, :limit => 250
      t.integer   :catalog_item_id
      t.string    :open_sales_order ,:limit =>18
      t.string    :edii_pending_order ,:limit =>18
      t.decimal   :rts_qty, :precision => 10, :scale => 2
      t.decimal   :pl_qty, :precision => 10, :scale => 2
    end
  end

  def self.down
    drop_table :catalog_inventories
  end
end


    
 



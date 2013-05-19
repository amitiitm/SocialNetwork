class CreateCatalogItemPackages < ActiveRecord::Migration
 def self.up
    create_table :catalog_item_packages do |t|
      t.integer   :company_id,  :null => false
      t.integer   :created_by
      t.integer   :updated_by
      t.timestamp :created_at
      t.timestamp :updated_at
      t.string    :update_flag,  :limit => 1,    :default => "Y"
      t.string    :trans_flag,   :limit => 1,    :default => "A"
      t.integer   :lock_version,                 :default => 0
      t.integer   :catalog_item_id
      t.string    :carton_size, :limit=>50	
      t.decimal   :pcs_per_carton, :precision=>12, :scale=>2
      t.decimal   :carton_wt, :precision => 12, :scale => 4, :default => 0.00
    end
  end

  def self.down
    drop_table :catalog_item_packages
  end
end

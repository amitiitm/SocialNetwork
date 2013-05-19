class CreateCatalogItemSetups < ActiveRecord::Migration
  def self.up
    create_table :catalog_item_setups do |t|
      t.integer   :company_id,  :null => false
      t.integer   :created_by
      t.integer   :updated_by
      t.timestamp :created_at
      t.timestamp :updated_at
      t.string    :update_flag,  :limit => 1,    :default => "Y"
      t.string    :trans_flag,   :limit => 1,    :default => "A"
      t.integer   :lock_version,                 :default => 0
      t.integer   :catalog_item_id
      t.integer   :catalog_setup_item_id
      t.string    :catalog_setup_item_code, :limit=>25
      t.string    :catalog_setup_item_charges, :limit=>50
      t.decimal   :amount, :precision => 12, :scale => 2
    end
  end

  def self.down
    drop_table :catalog_item_setups
  end
end
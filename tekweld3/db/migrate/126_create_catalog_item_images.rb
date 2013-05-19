class CreateCatalogItemImages < ActiveRecord::Migration
  def self.up
    create_table  :catalog_item_images do |t|
      t.integer   :company_id,  :null => false
      t.integer   :created_by
      t.integer   :updated_by
      t.timestamp :created_at
      t.timestamp :updated_at
      t.string    :update_flag,  :limit => 1,    :default => "Y"
      t.string    :trans_flag,   :limit => 1,    :default => "A"
      t.integer   :lock_version,                 :default => 0
      t.string    :serial_no,   :limit => 6
      t.integer   :catalog_item_id
      t.string   :catalog_item_code, :limit => 25
      t.string    :image_thumnail, :string=>100
      t.string    :image_small, :string=>100
      t.string    :image_normal, :string=>100
      t.string    :image_enlarge, :string=>100
    end
  end

  def self.down
    drop_table :catalog_item_images
  end
end

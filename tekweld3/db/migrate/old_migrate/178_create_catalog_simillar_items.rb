class CreateCatalogSimillarItems < ActiveRecord::Migration
  def self.up
    create_table :catalog_item_similar_items do |t|
      t.integer   :company_id, :null=>false
      t.integer   :created_by, :updated_by
      t.datetime  :created_at, :updated_at
      t.string    :update_flag, :limit=>1,:default=>'Y'
      t.string    :trans_flag, :limit=>1,:default=>'A'
      t.integer   :lock_version, :default=>0            
      t.integer   :catalog_item_id, :limit=>1, :null=>false
      t.string    :serial_no, :limit=>6
      t.integer   :similar_item_id, :limit=>1, :null=>false
      t.string    :similar_item_code, :limit=>25, :null=>true
    end
  end

  def self.down
    drop_table :catalog_item_similar_items
  end
end

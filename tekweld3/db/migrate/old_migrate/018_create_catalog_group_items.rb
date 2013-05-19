class CreateCatalogGroupItems < ActiveRecord::Migration
  def self.up
    create_table :catalog_group_items do |t|
      t.integer   :company_id, :null=>false
      t.integer   :created_by, :updated_by
      t.datetime  :created_at, :updated_at
      t.string    :update_flag, :limit=>1,:default=>'Y'
      t.string    :trans_flag, :limit=>1,:default=>'A'
      t.integer   :lock_version, :default=>0            
      t.integer   :catalog_group_id, :null=>false
      t.integer   :catalog_item_id, :null=>false
    end
  end

  def self.down
    drop_table :catalog_group_items
  end
end

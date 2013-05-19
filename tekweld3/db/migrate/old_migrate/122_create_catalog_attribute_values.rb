class CreateCatalogAttributeValues < ActiveRecord::Migration
  def self.up
    create_table :catalog_attribute_values do |t|
      t.integer   :company_id, :null=>false
      t.integer   :created_by, :updated_by
      t.datetime  :created_at, :updated_at
      t.string    :update_flag, :limit=>1,:default=>'Y'
      t.string    :trans_flag, :limit=>1,:default=>'A'
      t.integer   :lock_version, :default=>0            
      t.integer   :catalog_attribute_id, :null=>false
      t.string    :code, :limit=> 25, :null=>false
      t.string    :name, :limit=>50, :null=>false
      t.string    :description, :limit=>100 
    end
  end

  def self.down
    drop_table :catalog_attribute_values
  end
end

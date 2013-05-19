class CreateCatalogAttributes < ActiveRecord::Migration
  def self.up
    create_table :catalog_attributes do |t|
      t.integer   :company_id, :null=>false
      t.integer   :created_by, :updated_by
      t.datetime  :created_at, :updated_at
      t.string    :update_flag, :limit=>1,:default=>'Y'
      t.string    :trans_flag, :limit=>1,:default=>'A'
      t.integer   :lock_version, :default=>0            
      t.string    :code, :limit=> 25, :null=>false
      t.string    :name, :limit=>50, :null=>false
      t.string    :description, :limit=>100 
      t.string    :is_boolean, :limit=>1, :default=>'N'
    end
  end

  def self.down
    drop_table :catalog_attributes
  end
end

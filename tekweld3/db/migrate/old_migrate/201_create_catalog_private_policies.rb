class CreateCatalogPrivatePolicies < ActiveRecord::Migration
  def self.up
    create_table :catalog_private_policies do |t|
      t.integer   :company_id, :null=>false
      t.integer   :created_by, :updated_by
      t.datetime  :created_at, :updated_at
      t.string    :update_flag, :limit=>1,:default=>'Y'
      t.string    :trans_flag, :limit=>1,:default=>'A'
      t.integer   :lock_version, :default=>0 
      t.string    :heading, :limit=>100
      t.string    :paragraph, :limit=>1500
      t.string    :link1_text, :limit=>100
      t.string    :link1_url, :limit=>100
      t.string    :link2_text, :limit=>100
      t.string    :link2_url, :limit=>100
      t.string    :link3_text, :limit=>100
      t.string    :link3_url, :limit=>100
      t.integer   :sequence
    end
  end

  def self.down
    drop_table :catalog_private_policies
  end
end

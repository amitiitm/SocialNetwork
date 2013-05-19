class CreateCatalogPromotions < ActiveRecord::Migration
  def self.up
  create_table :catalog_promotions do |t|
      t.integer   :company_id, :null=>false
      t.integer   :created_by, :updated_by
      t.datetime  :created_at, :updated_at
      t.string    :update_flag, :limit=>1,:default=>'Y'
      t.string    :trans_flag, :limit=>1,:default=>'A'
      t.integer   :lock_version, :default=>0            
      t.string    :image1,  :limit=>100 
      t.string    :image2,  :limit=>100 
      t.string    :image3,  :limit=>100 
      t.string    :image4,  :limit=>100 
      t.string    :image1_link,  :limit=>100 
      t.string    :image2_link,  :limit=>100 
      t.string    :image3_link,  :limit=>100 
      t.string    :image4_link,  :limit=>100 
      t.string    :template_type,  :limit=>25
  end
  end

  def self.down
    drop_table :catalog_promotions
  end
end

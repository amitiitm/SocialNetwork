class CreateCatalogItems < ActiveRecord::Migration
  def self.up
  create_table :catalog_items do |t|
      t.integer   :company_id, :null=>false
      t.integer   :created_by, :updated_by
      t.datetime  :created_at, :updated_at
      t.string    :update_flag, :limit=>1,:default=>'Y'
      t.string    :trans_flag, :limit=>1,:default=>'A'
      t.integer   :lock_version, :default=>0            
      t.string    :item_type, :limit=>1, :default=>'I'
      t.integer   :catalog_item_category_id
      t.string    :store_code,  :limit=>25, :null=>false
      t.string    :web_code,  :limit=>25, :null=>false
      t.string    :name,  :limit=>50
      t.string    :purchase_description,  :limit=>100
      t.string    :sale_description,  :limit=>100
      t.string    :barcode, :limit=>25
      t.decimal   :cost, :precision=>12, :scale=>2
      t.string    :unit, :limit=>10
      t.string    :taxable, :limit=>1, :default=>'Y'
      t.integer   :prefered_vendor_id
      t.integer   :vendor_item_name, :limit=>50
      t.string    :image_thumnail,  :limit=>100 
      t.string    :image_small,  :limit=>100 
      t.string    :image_normal,  :limit=>100 
      t.string    :image_enlarge,  :limit=>100 
      t.decimal   :reorder_qty,  :precision=>7, :scale=>0
      t.decimal   :reorder_level,  :precision=>5, :scale=>0
      t.decimal   :min_qty,  :precision=>12, :scale=>2
      t.decimal   :max_qty,  :precision=>12, :scale=>2
      t.datetime  :item_date
      t.integer   :priority, :default=>0
    end
  end


  def self.down
    drop_table :catalog_items
  end
end

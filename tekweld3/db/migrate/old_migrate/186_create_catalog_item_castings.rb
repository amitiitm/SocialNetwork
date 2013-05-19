class CreateCatalogItemCastings < ActiveRecord::Migration
  def self.up
    create_table :catalog_item_castings do |t|
      t.integer   :company_id, :null=>false
      t.integer   :created_by, :updated_by
      t.datetime  :created_at, :updated_at
      t.string    :update_flag, :limit=>1,:default=>'Y'
      t.string    :trans_flag, :limit=>1,:default=>'A'
      t.integer   :lock_version, :default=>0            
      t.integer   :catalog_item_id, :default=>0
      t.string    :catalog_item_code, :limit=>25
      t.integer   :serial_no
      t.string    :setter, :limit=>1
      t.string    :supplier, :limit=>1
      t.string    :billed_wt_flag, :limit=>1, :default=>'C'
      t.string    :unit, :limit=>4
      t.decimal   :qty, :precision=>5, :scale=>1
      t.string    :metal_type, :limit=>4
      t.string    :metal_color, :limit=>4
      t.decimal   :metal_size,  :precision=>7, :scale=>2
      t.decimal   :wt, :precision=>8, :limit=>4
      t.decimal   :finished_wt, :precision=>8, :limit=>4
      t.decimal   :total_wt, :precision=>10, :limit=>4
      t.decimal   :gold_surcharge, :precision=>12, :limit=>2
      t.decimal   :cost, :precision=>10, :limit=>2
      t.decimal   :labor, :precision=>8, :limit=>2
      t.decimal   :total_cost, :precision=>10, :scale=>2
      t.decimal   :labor_wt, :precision=>12, :limit=>2
      t.string    :vendor_id, :limit=>18
      t.string    :vendor_item_id, :limit=>18
      t.string    :cast_cd, :limit=>18
      t.string    :duty_flag, :limit=>1
    end
  end

  def self.down
    drop_table :catalog_item_castings
  end
end

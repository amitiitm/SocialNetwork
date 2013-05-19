class CreateCatalogItemOthers < ActiveRecord::Migration
  def self.up
    create_table :catalog_item_others do |t|
      t.integer   :company_id, :null=>false
      t.integer   :created_by, :updated_by
      t.datetime  :created_at, :updated_at
      t.string    :update_flag, :limit=>1,:default=>'Y'
      t.string    :trans_flag, :limit=>1,:default=>'A'
      t.integer   :lock_version, :default=>0            
      t.integer   :catalog_item_id, :default=>0
      t.string    :catalog_item_code, :limit=>25
      t.integer   :serial_no
      t.string    :other_type, :limit=>4
      t.string    :other_code, :limit=>25, :null=>false
      t.string    :supplier, :limit=>1
      t.string    :setter, :limit=>1
      t.string    :duty_flag, :limit=>1, :default=>'Y'
      t.decimal   :cost,  :precision=>10,  :scale=>2
      t.decimal   :qty,  :precision=>10,  :scale=>2
      t.decimal   :total_cost,  :precision=>12,  :scale=>2
      t.string    :remarks, :limit=>255
    end
  end

  def self.down
    drop_table :catalog_item_others
  end
end

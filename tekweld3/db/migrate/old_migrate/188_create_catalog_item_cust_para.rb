class CreateCatalogItemCustPara < ActiveRecord::Migration
  def self.up
    create_table :catalog_item_cust_parameters do |t|
      t.integer   :company_id, :null=>false
      t.integer   :created_by, :updated_by
      t.datetime  :created_at, :updated_at
      t.string    :update_flag, :limit=>1,:default=>'Y'
      t.string    :trans_flag, :limit=>1,:default=>'A'
      t.integer   :lock_version, :default=>0            
      t.integer   :catalog_item_id, :default=>0
      t.string    :catalog_item_code, :limit=>25
      t.integer   :serial_no
      t.integer   :customer_id, :null=>false
      t.string    :customer_sku_no, :limit=>25
      t.decimal   :price,  :precision=>10,  :scale=>2, :default=>1
    end
  end

  def self.down
    drop_table :catalog_item_cust_parameters
  end
end

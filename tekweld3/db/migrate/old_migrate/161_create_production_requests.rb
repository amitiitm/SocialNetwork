class CreateProductionRequests < ActiveRecord::Migration
  def self.up
    create_table :production_requests do |t|
      t.integer   :company_id, :null=>false
      t.integer   :created_by, :updated_by
      t.datetime  :created_at, :updated_at
      t.string    :update_flag, :limit=>1,:default=>'Y'
      t.string    :trans_flag, :limit=>1,:default=>'A'
      t.integer   :lock_version, :default=>0 
      t.string    :trans_bk, :ref_trans_bk, :po_trans_bk, :limit=>4, :null=>false
      t.string    :trans_no, :ref_trans_no, :po_trans_no, :limit=>18, :null=>false
      t.string    :account_period_code, :limit=>8, :null=>false
      t.datetime  :trans_date, :null=>false	
      t.datetime  :ref_trans_date, :null=>false	
      t.string    :status, :limit=>1 #O:Open, C:Close
      t.string    :trans_type, :limit=>1 #C:customer, V:vendor, S:store
      t.integer   :trans_type_id
      t.string    :po_serial_no, :ref_serial_no, :limit=>6
      t.integer   :company_store_id
      t.string    :company_store_code, :limit=>25, :null=>false
      t.string    :item_type, :ref_type, :limit=>1	
      t.integer   :catalog_item_id, :null=>false
      t.string    :catalog_item_code, :limit=>25, :null=>false
      t.string    :item_description, :limit=>100, :null=>false
      t.decimal   :discount_per, :precision=>6, :scale=>2, :default=>0
      t.decimal   :item_qty, :ref_qty, :clear_qty, :precision=>10, :scale=>2, :default=>0
      t.decimal   :item_price, :item_amt, :net_amt, :discount_amt, :precision=>12, :scale=>2, :default=>0
      t.string    :ext_ref_no, :limit=>50
      t.datetime  :ext_ref_date
      t.integer   :po_vendor_id
      
    end
  end

  def self.down
    drop_table :production_requests
  end
end

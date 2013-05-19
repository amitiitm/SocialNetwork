class CreateCatalogOpenOrders < ActiveRecord::Migration
  def self.up
    create_table :catalog_open_orders do |t|
      t.integer   :company_id,  :null => false
      t.integer   :created_by
      t.integer   :updated_by
      t.timestamp :created_at
      t.timestamp :updated_at
      t.string    :update_flag,  :limit => 1,    :default => "Y"
      t.string    :trans_flag,   :limit => 1,    :default => "A"
      t.integer   :lock_version,                 :default => 0
      t.string    :trans_bk, :limit => 4 ,:null => false
      t.string    :trans_no ,:limit =>18 ,:null => false
      t.timestamp :trans_date,:null => false
      t.string    :account_period_code, :limit => 8 ,:null => false
      t.integer   :customer_id
      t.string    :customer_code, :limit => 50
      t.string    :customer_name, :limit => 50
      t.string    :ship_to, :limit => 250
      t.timestamp :ship_date
      t.string    :serial_no, :limit => 6
      t.integer   :catalog_item_id, :null => false
      t.string    :catalog_item_code, :limit => 250
      t.string    :size, :limit=>10
      t.decimal   :item_qty, :precision => 10, :scale => 2
      t.decimal   :item_price, :precision => 12, :scale => 2
      t.string    :item_type ,:limit=>1
      t.string    :catalog_item_category, :limit => 250
      t.string    :catalog_item_description, :limit => 250
      t.decimal   :item_amt , :precision=>12, :scale=>2
      t.decimal   :clear_qty, :precision => 10, :scale => 2
      t.string    :ext_ref_no,                 :limit => 25 
      t.timestamp :ext_ref_date
      t.string    :ref_trans_no ,:limit =>18 
      t.timestamp :ref_trans_date
      t.timestamp :cancel_date
      t.decimal   :cancel_qty, :precision => 10, :scale => 2
    end
  end

  def self.down
    drop_table :catalog_open_orders
  end
end


    
 



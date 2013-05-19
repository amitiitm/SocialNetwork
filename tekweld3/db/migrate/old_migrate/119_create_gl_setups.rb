class CreateGlSetups < ActiveRecord::Migration
  def self.up
    create_table :gl_setups do |t|
      t.integer   :company_id, :null=>false
      t.integer   :created_by, :updated_by
      t.datetime  :created_at, :updated_at
      t.string    :update_flag, :limit=>1,:default=>'Y'
      t.string    :trans_flag, :limit=>1,:default=>'A'
      t.integer   :lock_version, :default=>0 
      t.integer   :ar_account_id, :null=>false
      t.integer   :ap_account_id, :null=>false
      t.integer   :shipping_purchase_account_id, :null=>false
      t.integer   :shipping_sales_account_id, :null=>false
      t.integer   :discount_purchase_account_id, :null=>false
      t.integer   :discount_sales_account_id, :null=>false
      t.integer   :salestax_purchase_account_id, :null=>false
      t.integer   :salestax_sales_account_id, :null=>false
      t.integer   :default_purchase_account_id, :null=>false
      t.integer   :default_sales_account_id, :null=>false
    end
  end

  def self.down
    drop_table :gl_setups
  end
end

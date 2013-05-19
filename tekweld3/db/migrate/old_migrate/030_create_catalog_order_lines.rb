class CreateCatalogOrderLines < ActiveRecord::Migration
  def self.up
    create_table :catalog_order_lines do |t|
      t.integer   :company_id, :null=>false
      t.integer   :created_by, :updated_by
      t.datetime  :created_at, :updated_at
      t.string    :update_flag, :limit=>1,:default=>'Y'
      t.string    :trans_flag, :limit=>1,:default=>'A'
      t.integer   :lock_version, :default=>0            
      t.integer   :user_id, :default=>0       
      t.integer   :order_id, :null=>false
      t.integer   :catalog_item_id, :null=>false
      t.datetime  :ship_date, :null=>false
      t.datetime  :cancel_date, :null=>false
      t.integer   :qty, :null=>false
      t.decimal   :item_price, :precision=>12, :scale=>2
      t.decimal   :discount, :precision=>12, :scale=>2
      t.decimal   :amount, :precision=>12, :scale=>2
    end
  end

  def self.down
    drop_table :catalog_order_lines
  end
end

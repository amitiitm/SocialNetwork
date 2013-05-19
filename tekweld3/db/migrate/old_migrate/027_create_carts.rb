class CreateCarts < ActiveRecord::Migration
  def self.up
    create_table :carts do |t|
      t.integer   :company_id, :null=>false
      t.integer   :created_by, :updated_by
      t.datetime  :created_at, :updated_at
      t.string    :update_flag, :limit=>1, :default=>'Y'
      t.string    :trans_flag, :limit=>1, :default=>'A'
      t.integer   :lock_version, :default=>0            
      t.integer   :user_id, :default=>0
      t.integer   :qty, :default=>0
      t.decimal   :item_price, :precision=>12, :scale=>2
      t.decimal   :amount, :precision=>12, :scale=>2
      t.decimal   :discount, :precision=>12, :scale=>2
      t.datetime  :cart_date
      t.string    :status, :limit=>1 ,:default=>'C'
      t.string    :comments, :limit=>200
      t.integer   :catalog_item_id, :null=>false 
      t.integer   :customer_id, :null=>false 
    end
  end

  def self.down
    drop_table :carts
  end
end

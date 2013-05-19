class CreateWishlists < ActiveRecord::Migration
  def self.up
    create_table :wishlists do |t|
      t.integer   :company_id, :null=>false
      t.integer   :created_by, :updated_by
      t.datetime  :created_at, :updated_at
      t.string    :update_flag, :limit=>1,:default=>'Y'
      t.string    :trans_flag, :limit=>1,:default=>'A'
      t.integer   :lock_version, :default=>0            
      t.integer   :user_id, :default=>0, :null=>false
      t.string    :comments,:limit=>200 
      t.datetime  :wish_date, :null=>false
      t.integer   :catalog_item_id, :null=>false 
      t.integer   :customer_id, :null=>false
    end
  end

  def self.down
    drop_table :wishlists
  end
end

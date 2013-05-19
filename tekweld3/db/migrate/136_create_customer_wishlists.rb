class CreateCustomerWishlists < ActiveRecord::Migration
  def self.up
    create_table  :customer_wishlists do |t|
      t.integer   :company_id,  :null => false
      t.integer   :created_by
      t.integer   :updated_by
      t.timestamp :created_at
      t.timestamp :updated_at
      t.string    :update_flag,  :limit => 1,    :default => "Y"
      t.string    :trans_flag,   :limit => 1,    :default => "A"
      t.integer   :lock_version,                 :default => 0
      t.integer   :customer_id
      t.timestamp :wish_date
      t.string    :salesperson_code,      :limit => 25
      t.string    :catalog_item_code,      :limit => 25
      t.string    :catalog_item_description,      :limit => 200
      t.string    :item_for_whom,      :limit => 100
      t.string    :catalog_item_price, :decimal, :precision=>12, :scale=>2
      t.string    :remarks,  :limit =>200
    end
  end

  def self.down
    drop_table :customer_wishlists
  end
end

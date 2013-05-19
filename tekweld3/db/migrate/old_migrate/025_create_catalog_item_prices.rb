class CreateCatalogItemPrices < ActiveRecord::Migration
  def self.up
    create_table :catalog_item_prices do |t|
      t.integer   :company_id, :null=>false
      t.integer   :created_by, :updated_by
      t.datetime  :created_at, :updated_at
      t.string    :update_flag, :limit=>1,:default=>'Y'
      t.string    :trans_flag, :limit=>1,:default=>'A'
      t.integer   :lock_version, :default=>0            
      t.integer   :catalog_item_id, :default=>0
      t.datetime  :from_date, :null=>false
      t.datetime  :to_date, :null=>false
      t.decimal   :price,:precision=>12, :scale=>2
      t.decimal   :discount_amt,:precision=>12, :scale=>2
      t.decimal   :discount_per,:precision=>5, :scale=>2
    end
  end

  def self.down
    drop_table :catalog_item_prices
  end
end

class AddPriceToRatePlans < ActiveRecord::Migration
  def self.up
    add_column :rate_plans, :price, :decimal, :precision => 4, :scale => 2
  end

  def self.down
    remove_column :rate_plans, :price
  end
end

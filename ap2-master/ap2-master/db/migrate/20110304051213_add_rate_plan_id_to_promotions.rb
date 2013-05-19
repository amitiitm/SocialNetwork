class AddRatePlanIdToPromotions < ActiveRecord::Migration
  def self.up
    add_column :promotions, :rate_plan_id, :integer
    add_index :promotions, :rate_plan_id
    add_index :promotions, :country_id
  end

  def self.down    
    remove_index :promotions, :country_id
    remove_index :promotions, :rate_plan_id
    remove_column :promotions, :rate_plan_id
  end
end
class CreateRatePlansPromotions < ActiveRecord::Migration
  def self.up
    create_table :rate_plans_promotions do |t|
      t.integer :rate_plan_id
      t.integer :promotion_id

      t.timestamps
    end
  end

  def self.down
    drop_table :rate_plans_promotions
  end
end

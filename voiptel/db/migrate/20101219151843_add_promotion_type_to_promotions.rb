class AddPromotionTypeToPromotions < ActiveRecord::Migration
  def self.up
    add_column :promotions, :promotion_type, :integer, :limit => 1, :default => 1
  end

  def self.down
    remove_column :promotions, :promotion_type
  end
end

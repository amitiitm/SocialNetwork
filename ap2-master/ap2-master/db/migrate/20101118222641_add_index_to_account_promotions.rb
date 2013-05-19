class AddIndexToAccountPromotions < ActiveRecord::Migration
  def self.up
    add_index :account_promotions, :account_id
    add_index :account_promotions, :country_id
  end

  def self.down
    remove_index :account_promotions, :country_id
    remove_index :account_promotions, :account_id
  end
end
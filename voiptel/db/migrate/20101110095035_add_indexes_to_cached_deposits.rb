class AddIndexesToCachedDeposits < ActiveRecord::Migration
  def self.up
    add_index :cached_deposits, :account_id
    add_index :cached_deposits, :month
  end

  def self.down
    remove_index :cached_deposits, :month
    remove_index :cached_deposits, :account_id
  end
end

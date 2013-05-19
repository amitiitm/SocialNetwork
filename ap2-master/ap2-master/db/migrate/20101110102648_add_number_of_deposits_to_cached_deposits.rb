class AddNumberOfDepositsToCachedDeposits < ActiveRecord::Migration
  def self.up
    add_column :cached_deposits, :number_of_deposits, :integer, :default => 0
  end

  def self.down
    remove_column :cached_deposits, :number_of_deposits
  end
end

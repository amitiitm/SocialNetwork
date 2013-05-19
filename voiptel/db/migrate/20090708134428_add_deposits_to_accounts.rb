class AddDepositsToAccounts < ActiveRecord::Migration
  def self.up
    add_column :accounts, :deposits, :decimal, :precision => 12, :scale => 4, :default => 0.0
  end

  def self.down
    remove_column :accounts, :deposits
  end
end

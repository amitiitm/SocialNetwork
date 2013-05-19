class AddCurrentDebtToAccounts < ActiveRecord::Migration
  def self.up
    add_column :accounts, :current_debt, :decimal, :precision => 12, :scale => 4, :default => 0.0
  end

  def self.down
    remove_column :accounts, :current_debt
  end
end

class AddCurrentDebtToOrderTransactions < ActiveRecord::Migration
  def self.up
    add_column :order_transactions, :current_debt, :decimal, :precision => 12, :scale => 4, :default => 0.0
  end

  def self.down
    remove_column :order_transactions, :current_debt
  end
end

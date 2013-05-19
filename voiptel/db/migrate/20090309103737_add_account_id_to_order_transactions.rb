class AddAccountIdToOrderTransactions < ActiveRecord::Migration
  def self.up
    add_column :order_transactions, :account_id, :integer
  end

  def self.down
    remove_column :order_transactions, :account_id
  end
end

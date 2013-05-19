class AddStatusToOrderTransactions < ActiveRecord::Migration
  def self.up
    add_column :order_transactions, :status, :integer, :limit => 1
  end

  def self.down
    remove_column :order_transactions, :status
  end
end

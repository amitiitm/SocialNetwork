class AddMessageToOrderTransactions < ActiveRecord::Migration
  def self.up
    add_column :order_transactions, :message, :string
  end

  def self.down
    remove_column :order_transactions, :message
  end
end

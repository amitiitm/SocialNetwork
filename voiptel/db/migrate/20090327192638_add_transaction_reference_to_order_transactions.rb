class AddTransactionReferenceToOrderTransactions < ActiveRecord::Migration
  def self.up
    add_column :order_transactions, :transaction_reference_id, :integer
  end

  def self.down
    remove_column :order_transactions, :transaction_reference_id
  end
end

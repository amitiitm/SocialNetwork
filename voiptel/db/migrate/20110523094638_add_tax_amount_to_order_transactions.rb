class AddTaxAmountToOrderTransactions < ActiveRecord::Migration
  def self.up
    add_column :order_transactions, :tax_amount, :decimal, :precision => 7, :scale => 4, :default => 0
    add_column :order_transactions, :full_amount, :decimal, :precision => 7, :scale => 4, :default => 0
  end

  def self.down
    remove_column :order_transactions, :full_amount
    remove_column :order_transactions, :tax_amount
  end
end
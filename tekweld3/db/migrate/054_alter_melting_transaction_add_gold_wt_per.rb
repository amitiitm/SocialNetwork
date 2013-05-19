class AlterMeltingTransactionAddGoldWtPer < ActiveRecord::Migration
  def self.up
    add_column :melting_transactions, :gold_weight, :decimal, :precision=>12, :scale=>5
    add_column :melting_transactions, :gold_per, :decimal, :precision=>6, :scale=>2
  end

  def self.down
    remove_column :melting_transactions, :gold_weight
    remove_column :melting_transactions, :gold_per
  end
end

class AlterMeltingTransactionAddAmtFields < ActiveRecord::Migration
  def self.up
    add_column :melting_transactions, :co_op_amt, :decimal, :precision=>10, :scale=>2
    add_column :melting_transactions, :total_paid, :decimal, :precision=>10, :scale=>2
   
  end

  def self.down
    remove_column  :melting_transactions, :co_op_amt
    remove_column  :melting_transactions, :total_paid
  
  end
end

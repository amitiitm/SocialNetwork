class AddAllowTransactionToAccounts < ActiveRecord::Migration
  def self.up
    add_column :accounts, :allow_transaction, :boolean, :default => false
  end

  def self.down
    remove_column :accounts, :allow_transaction
  end
end

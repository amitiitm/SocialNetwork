class AddUserAndAccountToTransactionReference < ActiveRecord::Migration
  def self.up
    add_column :transaction_references, :account_id, :integer
    add_column :transaction_references, :user_id, :integer
  end

  def self.down
    remove_column :transaction_references, :user_id
    remove_column :transaction_references, :account_id
  end
end

class AlterMeltingTransactionAddOpenEncashCheck < ActiveRecord::Migration
  def self.up
    add_column :melting_transactions, :open_check, :string, :limit=>1
    add_column :melting_transactions, :encashed_check, :string, :limit=>1
  end

  def self.down
    remove_column :melting_transactions, :open_check
    remove_column :melting_transactions, :encashed_check
  end
end

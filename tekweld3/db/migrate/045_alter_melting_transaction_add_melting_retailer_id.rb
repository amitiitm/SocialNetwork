class AlterMeltingTransactionAddMeltingRetailerId < ActiveRecord::Migration
  def self.up
    add_column :melting_transactions,:melting_retailer_id, :integer
    remove_column :melting_transactions,:vendor_id
  end

  def self.down
    remove_column :melting_transactions,:melting_retailer_id
    add_column :melting_transactions,:vendor_id, :integer
  end
end

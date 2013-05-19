class  AlterDepositNoDataType < ActiveRecord::Migration
  def self.up
    remove_column :bank_transactions, :deposit_no
    add_column :bank_transactions, :deposit_no, :string, :limit=>25
    remove_column :customer_receipts, :deposit_no
    add_column :customer_receipts, :deposit_no, :string, :limit=>25
  end

  def self.down
    remove_column :bank_transactions, :deposit_no
    add_column :bank_transactions, :deposit_no, :integer
    remove_column :customer_receipts, :deposit_no
    add_column :customer_receipts, :deposit_no, :integer
  end
end

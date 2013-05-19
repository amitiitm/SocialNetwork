class AddBusinessToAccounts < ActiveRecord::Migration
  def self.up
    add_column :accounts, :account_type, :integer, :default => 1
    add_column :accounts, :business_name, :string
  end

  def self.down
    remove_column :accounts, :business_name
    remove_column :accounts, :business
  end
end

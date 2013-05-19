class AddShortNameToAccounts < ActiveRecord::Migration
  def self.up
    add_column :accounts, :short_name, :string
    add_index :accounts, :short_name, :unique => true
  end

  def self.down
    remove_index :accounts, :column => :short_name
    remove_column :accounts, :short_name
  end
end

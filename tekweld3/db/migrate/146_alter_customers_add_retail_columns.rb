class AlterCustomersAddRetailColumns < ActiveRecord::Migration
  def self.up
    add_column :customers, :gender ,:string ,:limit=>25
    add_column :customers, :title ,:string ,:limit=>25
    add_column :customers, :suffix ,:string ,:limit=>25
    add_column :customers, :birth_date ,:string ,:limit=>6
    add_column :customers, :account_type ,:string ,:limit=>25
  end

  def self.down
    remove_column :customers
    remove_column :customers
    remove_column :customers
    remove_column :customers
    remove_column :customers
  end
end

class AddSetCidToAccounts < ActiveRecord::Migration
  def self.up
    add_column :accounts, :set_cid, :boolean, :default => true
  end

  def self.down
    remove_column :accounts, :set_cid
  end
end

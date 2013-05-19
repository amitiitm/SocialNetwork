class AddAnnounceCallLimitToAccounts < ActiveRecord::Migration
  def self.up
    add_column :accounts, :announce_call_limit, :boolean, :default => false
  end

  def self.down
    remove_column :accounts, :announce_call_limit
  end
end

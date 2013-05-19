class AddIndexesToSipAccounts < ActiveRecord::Migration
  def self.up
    add_index :sip_accounts, :domain
    add_index :sip_accounts, :account_id
    add_index :sip_accounts, :username
  end

  def self.down
    remove_index :sip_accounts, :username
    remove_index :sip_accounts, :account_id
    remove_index :sip_accounts, :domain
    mind
  end
end
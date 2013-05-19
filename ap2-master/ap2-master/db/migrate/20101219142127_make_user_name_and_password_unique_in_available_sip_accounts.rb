class MakeUserNameAndPasswordUniqueInAvailableSipAccounts < ActiveRecord::Migration
  def self.up
    add_index :available_sip_accounts, [:username, :password], :unique => true
  end

  def self.down
    remove_index :available_sip_accounts, [:username, :password]
  end
end
class ChangeSipAccountTableNameToSubscriber < ActiveRecord::Migration
  def self.up
    rename_table :sip_accounts, :subscriber
  end

  def self.down
    rename_table :subscriber, :sip_accounts
  end
end
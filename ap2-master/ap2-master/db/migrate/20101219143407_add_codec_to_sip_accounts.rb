class AddCodecToSipAccounts < ActiveRecord::Migration
  def self.up
    add_column :sip_accounts, :codec, :string, :limit => 20
  end

  def self.down
    remove_column :sip_accounts, :codec
  end
end
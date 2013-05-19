class AddExtraFieldsToSipAccounts < ActiveRecord::Migration
  def self.up
    add_column :sip_accounts, :cid_name, :string, :limit => 50
    add_column :sip_accounts, :cid_number, :string, :limit => 20
    add_column :sip_accounts, :set_cid, :boolean, :default => true
    add_column :sip_accounts, :area_code, :string, :limit => 10
  end

  def self.down
    remove_column :sip_accounts, :area_code
    remove_column :sip_accounts, :set_cid
    remove_column :sip_accounts, :cid_number
    remove_column :sip_accounts, :cid_name
  end
end

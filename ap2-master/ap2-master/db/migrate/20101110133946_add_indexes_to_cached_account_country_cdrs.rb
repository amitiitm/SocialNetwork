class AddIndexesToCachedAccountCountryCdrs < ActiveRecord::Migration
  def self.up
    add_index :cached_account_country_cdrs, :account_id
    add_index :cached_account_country_cdrs, :country_id
    add_index :cached_account_country_cdrs, :month
  end

  def self.down
    remove_index :cached_account_country_cdrs, :month
    remove_index :cached_account_country_cdrs, :country_id
    remove_index :cached_account_country_cdrs, :account_id
  end
end

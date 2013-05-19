class AddIndexesToCachedAccountCdrs < ActiveRecord::Migration
  def self.up
    add_index :cached_account_cdrs, :account_id
    add_index :cached_account_cdrs, :month
  end

  def self.down
    remove_index :cached_account_cdrs, :month
    remove_index :cached_account_cdrs, :account_id
  end
end

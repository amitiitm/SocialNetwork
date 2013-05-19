class AddOtherDispositionsToCachedAccountCdrs < ActiveRecord::Migration
  def self.up
    add_column :cached_account_cdrs, :other_dispositions, :integer, :default => 0
  end

  def self.down
    remove_column :cached_account_cdrs, :other_dispositions
  end
end

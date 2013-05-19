class AddInvalidStuffToCachedAccountCdrs < ActiveRecord::Migration
  def self.up
    add_column :cached_account_cdrs, :invalid_num, :integer, :default => 0
    add_column :cached_account_cdrs, :no_input, :integer, :default => 0
  end

  def self.down
    remove_column :cached_account_cdrs, :no_input
    remove_column :cached_account_cdrs, :invalid_num
  end
end

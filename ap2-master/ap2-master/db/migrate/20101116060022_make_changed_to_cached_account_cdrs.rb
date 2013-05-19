class MakeChangedToCachedAccountCdrs < ActiveRecord::Migration
  def self.up
    add_column :cached_account_country_cdrs, :buy_cost, :decimal, :precision => 10, :scale => 4, :default => 0
    add_column :cached_account_country_cdrs, :sell_cost, :decimal, :precision => 10, :scale => 4, :default => 0
    remove_column :cached_account_country_cdrs, :no_input
  end

  def self.down
    add_column :cached_account_country_cdrs, :no_input, :integer, :default => 0
    remove_column :cached_account_country_cdrs, :sell_cost
    remove_column :cached_account_country_cdrs, :buy_cost
  end
end

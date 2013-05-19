class ChangeCostLimitsOnCachedAccountCdrs < ActiveRecord::Migration
  def self.up
    change_column :cached_account_cdrs, :buy_cost, :decimal, :precision => 10, :scale => 4, :default => 0
    change_column :cached_account_cdrs, :sell_cost, :decimal, :precision => 10, :scale => 4, :default => 0
  end

  def self.down
  end
end

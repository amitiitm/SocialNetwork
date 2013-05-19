class ChangeCdrRateNames < ActiveRecord::Migration
  def self.up
    rename_column :card_cdrs, :sell_rate, :rate
    rename_column :card_cdrs, :sell_cost, :cost
  end

  def self.down
    rename_column :card_cdrs, :cost, :sell_cost
    rename_column :card_cdrs, :rate, :sell_rate
  end
end

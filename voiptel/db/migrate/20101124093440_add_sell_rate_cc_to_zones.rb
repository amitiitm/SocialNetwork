class AddSellRateCcToZones < ActiveRecord::Migration
  def self.up
    add_column :zones, :cc_sell_rate, :decimal, :precision => 6, :scale => 4
  end

  def self.down
    remove_column :zones, :cc_sell_rate
  end
end

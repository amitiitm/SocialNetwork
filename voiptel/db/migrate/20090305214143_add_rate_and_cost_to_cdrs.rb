class AddRateAndCostToCdrs < ActiveRecord::Migration
  def self.up
    add_column :cdrs, :rate, :decimal, :precision => 10, :scale => 8
    add_column :cdrs, :cost, :decimal, :precision => 10, :scale => 8
  end

  def self.down
    remove_column :cdrs, :cost
    remove_column :cdrs, :rate
  end
end

class FuckThisFuckingOpenFo < ActiveRecord::Migration
  def self.up
    change_column :tax_items, :percentage, :decimal, :precision => 6, :scale => 4
  end

  def self.down
    change_column :tax_items, :percentage, :string
  end
end
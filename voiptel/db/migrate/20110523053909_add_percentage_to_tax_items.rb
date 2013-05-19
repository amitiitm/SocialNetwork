class AddPercentageToTaxItems < ActiveRecord::Migration
  def self.up
    add_column :tax_items, :percentage, :double, :precision => 4, :scale => 2
  end

  def self.down
    remove_column :tax_items, :percentage
  end
end

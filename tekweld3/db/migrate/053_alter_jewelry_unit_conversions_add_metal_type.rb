class AlterJewelryUnitConversionsAddMetalType < ActiveRecord::Migration
  def self.up
    remove_column :jewelry_unit_conversions, :type
    add_column :jewelry_unit_conversions, :metal_type, :string, :limit=>4
  end

  def self.down
    remove_column :jewelry_unit_conversions, :metal_type
    add_column :jewelry_unit_conversions, :type, :string, :limit=>4
  end
end

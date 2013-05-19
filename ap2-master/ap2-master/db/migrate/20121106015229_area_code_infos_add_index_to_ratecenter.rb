class AreaCodeInfosAddIndexToRatecenter < ActiveRecord::Migration
  def self.up
      add_index :area_code_infos, :ratecenter
  end

  def self.down
  end
end

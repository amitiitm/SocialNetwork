class AddAreaCodeInfoToDidRateCenterLocations < ActiveRecord::Migration
  def self.up
    add_column :did_rate_center_locations, :area_code_info_id, :integer
  end

  def self.down
    remove_column :did_rate_center_locations, :area_code_info_id
  end
end

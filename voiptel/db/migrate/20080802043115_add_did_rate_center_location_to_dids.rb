class AddDidRateCenterLocationToDids < ActiveRecord::Migration
  def self.up
    add_column :dids, :did_rate_center_location_id, :integer
  end

  def self.down
    remove_column :dids, :did_rate_center_location_id
  end
end

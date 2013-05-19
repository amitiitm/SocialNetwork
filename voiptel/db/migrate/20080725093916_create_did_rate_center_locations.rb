class CreateDidRateCenterLocations < ActiveRecord::Migration
  def self.up
    create_table :did_rate_center_locations do |t|
      t.string :npa
      t.string :lat
      t.string :long
      t.integer :rate_center_id

      t.timestamps
    end
  end

  def self.down
    drop_table :did_rate_center_locations
  end
end

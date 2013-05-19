class CreateRateCenters < ActiveRecord::Migration
  def self.up
    create_table :rate_centers do |t|
      t.string :rate_center, :limit => 50

      t.timestamps
    end
  end

  def self.down
    drop_table :rate_centers
  end
end

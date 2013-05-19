class CreateRoutes < ActiveRecord::Migration
  def self.up
    create_table :routes do |t|
      t.integer :zone_id
      t.integer :carrier_id

      t.timestamps
    end
  end

  def self.down
    drop_table :routes
  end
end

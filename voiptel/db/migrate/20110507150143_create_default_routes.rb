class CreateDefaultRoutes < ActiveRecord::Migration
  def self.up
    create_table :default_routes do |t|
      t.integer :carrier_id
      t.integer :trunk_id
      t.integer :priority

      t.timestamps
    end
  end

  def self.down
    drop_table :default_routes
  end
end

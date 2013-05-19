class CreateRouteFailures < ActiveRecord::Migration
  def self.up
    create_table :route_failures do |t|
      t.string :uniqueid
      t.integer :route_id
      t.string :disposition
      t.datetime :date

      #t.timestamps
    end
  end

  def self.down
    drop_table :route_failures
  end
end

class CreateCarriers < ActiveRecord::Migration
  def self.up
    create_table :carriers do |t|
      t.string :name
      t.string :trunk_name
      t.integer :channel_limit
      t.integer :set_cid
      t.string :cid
      t.integer :enabled
      t.string :signaling

      t.timestamps
    end
  end

  def self.down
    drop_table :carriers
  end
end

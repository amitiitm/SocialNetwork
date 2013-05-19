class CreateDefaultUis < ActiveRecord::Migration
  def self.up
    create_table :default_uis do |t|
      t.string :partial_name
      t.string :partial_location
      t.string :container
      t.integer :position

      t.timestamps
    end
  end

  def self.down
    drop_table :default_uis
  end
end

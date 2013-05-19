class CreateDiamondLocations < ActiveRecord::Migration
  def self.up
    create_table :diamond_locations do |t|
      t.integer   :company_id,  :null => false
      t.integer   :created_by
      t.integer   :updated_by
      t.timestamp :created_at
      t.timestamp :updated_at
      t.string    :update_flag,  :limit => 1,    :default => "Y"
      t.string    :trans_flag,   :limit => 1,    :default => "A"
      t.integer   :lock_version,                 :default => 0
      t.string    :code,  :limit => 50
      t.string    :name,  :limit => 50

    end
  end

  def self.down
    drop_table :diamond_locations
  end
end

class CreateDids < ActiveRecord::Migration
  def self.up
    create_table :dids do |t|
      t.string :number
      t.string :area
      t.decimal :setup_cost, :precision => 8,:scale => 4
      t.decimal :monthly_charge, :precision => 8,:scale => 4
      t.decimal :per_minute_charge, :precision => 8,:scale => 4
      t.integer :free_minutes
      t.integer :channels
      t.string :url
      t.integer :vendor_id
      t.integer :area_code_id
      t.integer :country_id
      t.integer :assigned_count, :limit => 1, :default => 0

      t.timestamps
    end
  end

  def self.down
    drop_table :dids
  end
end

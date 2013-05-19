class CreateMinutes < ActiveRecord::Migration
  def self.up
    create_table :minutes do |t|
      t.integer :seconds
      t.integer :minutes
      t.date :date

      t.timestamps
    end
    add_index :minutes, :date, :unique => true
  end

  def self.down
    remove_index :minutes, :column => :date
    drop_table :minutes
  end
end

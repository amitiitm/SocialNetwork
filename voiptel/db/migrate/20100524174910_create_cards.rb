class CreateCards < ActiveRecord::Migration
  def self.up
    create_table  :cards do |t|
      t.integer   :serial_number
      t.string    :number, :limit => 16
      t.string    :serial, :limit => 10
      t.boolean   :enabled, :default => false
      t.boolean   :activated, :default => false
      t.datetime  :activation_date
      t.integer   :value
      t.decimal   :balance, :precision => 12, :scale => 4

      t.timestamps
    end
  end

  def self.down
    drop_table :cards
  end
end

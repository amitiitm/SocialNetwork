class CreateForwardings < ActiveRecord::Migration
  def self.up
    create_table :forwardings do |t|
      t.integer :did_id
      t.integer :account_id
      t.decimal :rate, :precision => 6, :scale => 4
      t.integer :priority, :default => 1, :limit => 1
      t.timestamps
    end
  end

  def self.down
    drop_table :forwardings
  end
end

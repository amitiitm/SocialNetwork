class CreateCdrStats < ActiveRecord::Migration
  def self.up
    create_table :cdr_stats do |t|
      t.integer :cdr_id
      t.boolean :account, :default => false
      t.boolean :ap, :default => false

      t.timestamps
    end
  end

  def self.down
    drop_table :cdr_stats
  end
end

class CreateCdrCaches < ActiveRecord::Migration
  def self.up
    create_table :cdr_caches do |t|
      t.text :data
      t.integer :cdr_id, :unique => true
            

      t.timestamps
    end
  end

  def self.down
    drop_table :cdr_caches
  end
end

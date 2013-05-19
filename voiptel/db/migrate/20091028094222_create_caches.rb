class CreateCaches < ActiveRecord::Migration
  def self.up
    create_table :caches do |t|
      t.string :k
      t.string :v
      
      t.timestamps
    end
    add_index :caches, :k, :unique => true
  end

  def self.down
    remove_index :caches, :column => :k
    drop_table :caches
  end
end

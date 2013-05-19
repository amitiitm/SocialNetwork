class AddIndexToCdrCaches < ActiveRecord::Migration
  def self.up
    add_index :cdr_caches, :cdr_id
  end

  def self.down
    remove_index :cdr_caches, :column => :cdr_id
  end
end

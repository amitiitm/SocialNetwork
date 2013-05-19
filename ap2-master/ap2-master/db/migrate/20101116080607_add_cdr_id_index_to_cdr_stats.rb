class AddCdrIdIndexToCdrStats < ActiveRecord::Migration
  def self.up
    add_index :cdr_stats, :cdr_id
  end

  def self.down
    remove_index :cdr_stats, :cdr_id
  end
end

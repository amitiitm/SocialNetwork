class AddIndexToCards < ActiveRecord::Migration
  def self.up
    add_index :cards, [:number, :serial], :unique => true
  end

  def self.down
    remove_index :cards, :column => [:number, :serial]
  end
end

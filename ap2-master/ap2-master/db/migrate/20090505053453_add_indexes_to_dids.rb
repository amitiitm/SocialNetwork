class AddIndexesToDids < ActiveRecord::Migration
  def self.up
    add_index :dids, :number, :unique => true
  end

  def self.down
    remove_index :dids, :number
  end
end

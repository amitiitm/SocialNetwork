class AddIndexForAccountNumbers < ActiveRecord::Migration
  def self.up
    add_index :accounts, :number, :unique => true
  end

  def self.down
    remove_index :accounts, :column => :number
  end
end

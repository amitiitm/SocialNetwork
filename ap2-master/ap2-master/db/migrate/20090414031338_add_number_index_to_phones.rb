class AddNumberIndexToPhones < ActiveRecord::Migration
  def self.up
    add_index :phones, :number, :unique => true
  end

  def self.down
    remove_index :phones, :number
  end
end

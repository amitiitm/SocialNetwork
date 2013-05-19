class AddIndexesToForwardings < ActiveRecord::Migration
  def self.up
    add_index :forwardings, :account_id
    add_index :forwardings, :user_id
    add_index :forwardings, :from_number, :unique => true
  end

  def self.down
    remove_index :forwardings, :account_id
    remove_index :forwardings, :user_id
    remove_index :forwardings, :from_number, :unique => true
  end
end

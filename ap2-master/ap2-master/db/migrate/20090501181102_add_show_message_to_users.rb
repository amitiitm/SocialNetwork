class AddShowMessageToUsers < ActiveRecord::Migration
  def self.up
    add_column :users, :show_message, :boolean, :default => true
  end

  def self.down
    remove_column :users, :show_message
  end
end

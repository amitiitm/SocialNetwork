class AddUserToAuthUsers < ActiveRecord::Migration
  def self.up
    add_column :auth_users, :user_id, :integer
  end

  def self.down
    remove_column :auth_users, :user_id
  end
end

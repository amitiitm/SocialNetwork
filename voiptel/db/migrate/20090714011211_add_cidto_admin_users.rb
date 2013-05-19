class AddCidtoAdminUsers < ActiveRecord::Migration
  def self.up
    add_column :admin_users, :cid, :string
  end

  def self.down
    remove_column :admin_users, :cid
  end
end

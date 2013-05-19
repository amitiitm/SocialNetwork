class AddExtToAdminUsers < ActiveRecord::Migration
  def self.up
    add_column :admin_users, :ext, :string
  end

  def self.down
    remove_column :admin_users, :ext
  end
end

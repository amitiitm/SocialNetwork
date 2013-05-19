class AddAdminUserIdToDefaultAdminUis < ActiveRecord::Migration
  def self.up
    add_column :default_admin_uis, :admin_user_id, :integer
  end

  def self.down
    remove_column :default_admin_uis, :admin_user_id
  end
end

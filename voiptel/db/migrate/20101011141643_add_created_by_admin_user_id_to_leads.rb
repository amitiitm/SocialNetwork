class AddCreatedByAdminUserIdToLeads < ActiveRecord::Migration
  def self.up
    add_column :leads, :admin_user_id, :integer
  end

  def self.down
    remove_column :leads, :admin_user_id
  end
end

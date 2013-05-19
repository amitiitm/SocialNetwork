class AddDoNotCallToLeads < ActiveRecord::Migration
  def self.up
    add_column :leads, :do_not_call, :boolean, :default => false
    change_column_default :leads, :status, 0
  end

  def self.down
    change_column_default :leads, :status
    remove_column :leads, :do_not_call
  end
end

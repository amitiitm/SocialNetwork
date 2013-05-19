class AddRateCenterToLeads < ActiveRecord::Migration
  def self.up
    add_column :leads, :rate_center, :string
  end

  def self.down
    remove_column :leads, :rate_center
  end
end

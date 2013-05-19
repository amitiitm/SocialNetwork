class AddEmailToLeads < ActiveRecord::Migration
  def self.up
    add_column :leads, :email, :string
  end

  def self.down
    remove_column :leads, :email
  end
end

class AddAreaCodeToLeads < ActiveRecord::Migration
  def self.up
    add_column :leads, :area_code, :string
  end

  def self.down
    remove_column :leads, :area_code
  end
end

class AddAreaCodeInfoToPhones < ActiveRecord::Migration
  def self.up
    add_column :phones, :area_code_info_id, :integer
  end

  def self.down
    remove_column :phones, :area_code_info_id
  end
end

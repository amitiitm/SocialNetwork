class AddAreaCodeInfoToDid < ActiveRecord::Migration
  def self.up
    add_column :dids, :area_code_info_id, :integer
  end

  def self.down
    remove_column :dids, :area_code_info_id
  end
end

class AddNpanxxIndexToAreaCodeInfo < ActiveRecord::Migration
  def self.up
    add_index :area_code_infos, :npanxx
  end

  def self.down
    remove_index :area_code_infos, :npanxx
  end
end

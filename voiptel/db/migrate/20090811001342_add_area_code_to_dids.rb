class AddAreaCodeToDids < ActiveRecord::Migration
  def self.up
    add_column :dids, :area_code, :string
    add_index :dids, :area_code
  end

  def self.down
    remove_index :dids, :area_code
    remove_column :dids, :area_code
  end
end

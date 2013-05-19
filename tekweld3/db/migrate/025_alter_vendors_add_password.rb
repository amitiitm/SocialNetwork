class AlterVendorsAddPassword < ActiveRecord::Migration
  def self.up
    add_column :vendors,:password,:string,:limit=>20
  end

  def self.down
    remove_column :vendors,:password
  end
end


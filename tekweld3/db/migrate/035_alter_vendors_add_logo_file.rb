class AlterVendorsAddLogoFile < ActiveRecord::Migration
  def self.up
    add_column :vendors,:logo_file_name,:string,:limit=>50
  end

  def self.down
    remove_column :vendors,:logo_file_name
  end
end

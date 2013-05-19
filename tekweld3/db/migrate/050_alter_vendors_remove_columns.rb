class AlterVendorsRemoveColumns < ActiveRecord::Migration
  def self.up
    remove_column :vendors,:melting_retailer_flag
    remove_column :vendors,:password
  end

  def self.down
    add_column :vendors,:melting_retailer_flag, :string, :limit=>1,:default=>'N' 
    add_column :vendors,:password, :string, :limit=>20
  end
end

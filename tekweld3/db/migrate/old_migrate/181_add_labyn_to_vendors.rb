class AddLabynToVendors < ActiveRecord::Migration
  def self.up
    add_column :vendors, :lab_yn, :string, :limit=>1, :default=>'N'
  end

  def self.down
    remove_column :vendors, :lab_yn
  end
end

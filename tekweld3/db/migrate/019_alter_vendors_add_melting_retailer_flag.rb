class AlterVendorsAddMeltingRetailerFlag < ActiveRecord::Migration
  def self.up
    add_column :vendors,:melting_retailer_flag, :string, :limit=>1,:default=>'N' 
  end

  def self.down
    remove_column :vendors,:melting_retailer_flag
  end
end


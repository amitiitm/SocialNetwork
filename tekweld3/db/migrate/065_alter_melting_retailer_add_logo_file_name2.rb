class AlterMeltingRetailerAddLogoFileName2 < ActiveRecord::Migration
  def self.up
    add_column :melting_retailers, :logo_file_name2, :string, :limit=>30
  end

  def self.down
    remove_column :melting_retailers, :logo_file_name2
  end
end

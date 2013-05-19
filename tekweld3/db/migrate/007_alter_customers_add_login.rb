class AlterCustomersAddLogin < ActiveRecord::Migration
  def self.up
    add_column :customers, :login_code, :string, :limit=>100
    add_column :customers, :first_name, :string, :limit=>50
    add_column :customers, :last_name, :string, :limit=>50
  end

  def self.down
    remove_column :customers, :login_code
    remove_column :customers, :first_name
    remove_column :customers, :last_name
  end
end

class AddPasswordFieldToCustomers < ActiveRecord::Migration
  def self.up
    add_column :customers, :password, :string, :limit=>20  
  end
  
  def self.down
    remove_column :customers, :password
  end
end

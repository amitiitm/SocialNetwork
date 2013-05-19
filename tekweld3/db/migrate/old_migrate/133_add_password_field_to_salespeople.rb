class AddPasswordFieldToSalespeople < ActiveRecord::Migration
  def self.up
    add_column :salespeople, :password, :string, :limit=>20  
  end
  
  def self.down
    remove_column :salespeople, :password
  end
end

class AlterCustomersAddFirstLastName < ActiveRecord::Migration
  def self.up
    add_column :catalog_orders, :first_name, :string, :limit=>50
    add_column :catalog_orders, :last_name, :string, :limit=>50
  end

  def self.down
    remove_column :catalog_orders, :first_name
    remove_column :catalog_orders, :last_name
  end
end

class AlterCustomerShippingsAddNameFields < ActiveRecord::Migration
  def self.up
    add_column :customer_shippings, :first_name, :string, :limit=>50
    add_column :customer_shippings, :last_name, :string, :limit=>50
  end

  def self.down
    add_column :customer_shippings, :first_name
    add_column :customer_shippings, :last_name
  end
end

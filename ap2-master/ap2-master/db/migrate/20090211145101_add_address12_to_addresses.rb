class AddAddress12ToAddresses < ActiveRecord::Migration
  def self.up
    add_column :addresses, :address1, :string
    add_column :addresses, :address2, :string
  end

  def self.down
    remove_column :addresses, :address2
    remove_column :addresses, :address1
  end
end

class AlterMeltingRetailerAddEmail < ActiveRecord::Migration
  def self.up
    add_column :melting_retailers, :address1, :string, :limit => 50, :default => ""
    add_column :melting_retailers, :address2, :string, :limit => 50, :default => ""
    add_column :melting_retailers, :city, :string, :limit => 25, :default => ""
    add_column :melting_retailers, :state, :string, :limit => 25, :default => ""
    add_column :melting_retailers, :zip, :string, :limit => 15, :default => ""
    add_column :melting_retailers, :country, :string, :limit => 20, :default => ""
    add_column :melting_retailers, :email_id, :string, :limit => 50 
    add_column :melting_retailers, :phone, :string, :limit => 50, :default => ""
    add_column :melting_retailers, :fax, :string, :limit => 50, :default => ""
  end

  def self.down
    remove_column :melting_retailers, :address1
    remove_column :melting_retailers, :address2
    remove_column :melting_retailers, :city
    remove_column :melting_retailers, :state
    remove_column :melting_retailers, :zip
    remove_column :melting_retailers, :country
    remove_column :melting_retailers, :email_id
    remove_column :melting_retailers, :phone
    remove_column :melting_retailers, :fax
  end
end

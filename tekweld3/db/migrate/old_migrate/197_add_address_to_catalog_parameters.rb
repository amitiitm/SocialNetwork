class  AddAddressToCatalogParameters < ActiveRecord::Migration
  def self.up
    add_column :catalog_parameters, :address1, :string, :limit=>50
    add_column :catalog_parameters, :address2, :string, :limit=>50
    add_column :catalog_parameters, :city, :string, :limit=>25
    add_column :catalog_parameters, :state, :string, :limit=>25
    add_column :catalog_parameters, :zip, :string, :limit=>15
    add_column :catalog_parameters, :country, :string, :limit=>20
    add_column :catalog_parameters, :phone, :string, :limit=>50
    add_column :catalog_parameters, :fax, :string, :limit=>50
  end

  def self.down
    remove_column :catalog_parameters, :address1
    remove_column :catalog_parameters, :address2
    remove_column :catalog_parameters, :city
    remove_column :catalog_parameters, :state
    remove_column :catalog_parameters, :zip
    remove_column :catalog_parameters, :country
    remove_column :catalog_parameters, :phone
    remove_column :catalog_parameters, :fax
  end
end

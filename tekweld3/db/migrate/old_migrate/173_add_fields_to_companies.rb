class AddFieldsToCompanies < ActiveRecord::Migration
  def self.up
    add_column :companies, :city_tax_code, :string, :limit=>50
    add_column :companies, :state_tax_code, :string, :limit=>50
    add_column :companies, :country_tax_code, :string, :limit=>50
    #add_column :companies, :company_type, :string, :limit=>1  #'H' Headoffice, 'S' Store
  end

  def self.down
    remove_column :companies, :city_tax_code
    remove_column :companies, :state_tax_code
    remove_column :companies, :country_tax_code
    #remove_column :companies, :company_type
  end
end

class AddTypeToCompanies < ActiveRecord::Migration
  def self.up
    add_column :companies, :company_type, :string, :limit=>1  #'H' Headoffice, 'S' Store
  end

  def self.down
    remove_column :companies, :company_type
  end
end

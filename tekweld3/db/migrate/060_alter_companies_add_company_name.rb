class AlterCompaniesAddCompanyName < ActiveRecord::Migration
  def self.up
    add_column :companies, :company_name, :string, :limit=>100  
  end

  def self.down
    remove_column :companies, :company_name
  end
end

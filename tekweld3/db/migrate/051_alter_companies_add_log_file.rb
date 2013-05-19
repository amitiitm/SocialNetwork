class AlterCompaniesAddLogFile < ActiveRecord::Migration
  def self.up
    add_column :companies, :company_logo_file, :string, :limit=>100
  end

  def self.down
    remove_column :companies, :company_logo_file
  end
end

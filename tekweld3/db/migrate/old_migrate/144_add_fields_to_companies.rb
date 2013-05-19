class AddFieldsToCompanies < ActiveRecord::Migration
  def self.up
    add_column :companies, :country, :string, :limit=>20
    add_column :companies, :cell_no, :string, :limit=>15
    add_column :companies, :email_to, :string, :limit=>200
    add_column :companies, :email_cc, :string, :limit=>200
  end

  def self.down
    remove_column :companies, :country
    remove_column :companies, :cell_no
    remove_column :companies, :email_to
    remove_column :companies, :email_cc
  end
end

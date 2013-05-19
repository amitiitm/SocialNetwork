class  AddDefaultFieldToCompanies < ActiveRecord::Migration
  def self.up
    add_column :companies, :default_customer_id, :integer
    add_column :companies, :default_vendor_id, :integer
  end

  def self.down
    remove_column :companies, :default_customer_id
    remove_column :companies, :default_vendor_id
  end
end

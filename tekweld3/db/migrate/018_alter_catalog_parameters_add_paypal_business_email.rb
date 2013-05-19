class AlterCatalogParametersAddPaypalBusinessEmail < ActiveRecord::Migration
  def self.up
    add_column :catalog_parameters, :paypal_business_email, :string, :limit=>100
  end

  def self.down
    remove_column :catalog_parameters, :paypal_business_email
  end
end

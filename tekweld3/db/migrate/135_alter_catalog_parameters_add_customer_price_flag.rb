class AlterCatalogParametersAddCustomerPriceFlag < ActiveRecord::Migration
  def self.up
    add_column :catalog_parameters, :customer_price_flag, :string ,:limit=>1, :default=>''
  end

  def self.down
    remove_column :catalog_parameters, :customer_price_flag
  end
end

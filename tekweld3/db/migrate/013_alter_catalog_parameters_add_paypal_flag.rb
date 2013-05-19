class AlterCatalogParametersAddPaypalFlag < ActiveRecord::Migration
  def self.up
    add_column :catalog_parameters, :paypal_enable_flag, :string, :limit=>1, :default=>'N' #Y Yes , N No
#    add_column  :catalog_parameters, :paypal_ipn_server, :string, :limit=>100
#    add_column  :catalog_parameters, :paypal_business_account, :string, :limit=>100
#    add_column  :catalog_parameters, :paypal_protocol, :string, :limit=>25
#    add_column  :catalog_parameters, :paypal_root, :string, :limit=>100
#    add_column  :catalog_parameters, :paypal_business_email, :string, :limit=>100
#    add_column  :catalog_parameters, :my_domain, :string, :limit=>100
  end

  def self.down
    remove_column :catalog_parameters, :paypal_enable_flag
#    remove_column :catalog_parameters, :paypal_ipn_server
#    remove_column :catalog_parameters, :paypal_protocol
#    remove_column :catalog_parameters, :paypal_root
#    remove_column :catalog_parameters, :paypal_business_account
#    remove_column :catalog_parameters, :paypal_business_email
#    remove_column :catalog_parameters, :my_domain
  end
end

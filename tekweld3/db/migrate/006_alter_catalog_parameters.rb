class AlterCatalogParameters < ActiveRecord::Migration
  def self.up
    add_column :catalog_parameters, :merchant_id, :string, :limit=>100
    add_column :catalog_parameters, :return_url, :string, :limit=>1000
    add_column :catalog_parameters, :pdt_identity_token, :string, :limit=>150
  end

  def self.down
    remove_column :catalog_parameters, :merchant_id
    remove_column :catalog_parameters, :return_url
    remove_column :catalog_parameters, :pdt_identity_token
  end
end

class AlterCatalogParametersAddIpnServer < ActiveRecord::Migration
  def self.up
    add_column :catalog_parameters, :ipn_server, :string, :limit=>200
  end

  def self.down
    remove_column :catalog_parameters, :ipn_server
  end
end

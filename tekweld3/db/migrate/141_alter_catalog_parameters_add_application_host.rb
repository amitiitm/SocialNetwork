class AlterCatalogParametersAddApplicationHost < ActiveRecord::Migration
  def self.up
    add_column :catalog_parameters, :application_host_flag, :string ,:limit=>1, :default=>'S' # 'S' Same Server, 'E' Sepecrate Server
  end

  def self.down
    remove_column :catalog_parameters, :application_host_flag
  end
end

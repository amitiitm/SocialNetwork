class AlterCatalogParametersAddIntegratedApplicationField < ActiveRecord::Migration
  def self.up
    add_column :catalog_parameters, :integrated_application, :string ,:limit=>25,:default=>'RETAIL'
  end

  def self.down
    remove_column :catalog_parameters, :integrated_application 
  end
end

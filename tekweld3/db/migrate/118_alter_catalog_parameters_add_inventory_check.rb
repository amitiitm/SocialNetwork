class AlterCatalogParametersAddInventoryCheck < ActiveRecord::Migration
  def self.up
    add_column :catalog_parameters, :catalog_invn_check, :string ,:limit=>1,:default=>'N'
    
  end

  def self.down
    remove_column :catalog_parameters, :catalog_invn_check 
  end
end

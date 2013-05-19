class AlterCatalogParametersAddSecureAccess < ActiveRecord::Migration
  def self.up
    add_column :catalog_parameters, :secure_access  , :string ,:limit=>1,:default=>'N'
    
  end

  def self.down
    remove_column :catalog_parameters, :secure_access 
   
  end
end

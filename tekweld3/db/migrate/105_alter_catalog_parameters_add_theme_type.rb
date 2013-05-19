class AlterCatalogParametersAddThemeType < ActiveRecord::Migration
  def self.up
    add_column :catalog_parameters, :theme_type  , :string ,:limit=>25,:default=>'BLACK'
    
  end

  def self.down
    remove_column :catalog_parameters, :theme_type 
   
  end
end

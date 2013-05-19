class AlterCatalogParametersAddItemmultipleimageflag < ActiveRecord::Migration
  def self.up
    add_column :catalog_parameters, :itemmultipleimageflag, :string ,:limit=>1, :default=>'N'
  end

  def self.down
    remove_column :catalog_parameters, :itemmultipleimageflag 
  end
end

class AlterCatalogOrdersAddSignatureFileName < ActiveRecord::Migration
  def self.up
    add_column :catalog_orders,:signature_file_name, :string, :limit=>100
  end

  def self.down
    remove_column :catalog_Orders,:signature_file_name
  end
end

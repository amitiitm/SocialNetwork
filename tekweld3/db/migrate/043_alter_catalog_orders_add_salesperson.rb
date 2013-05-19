class AlterCatalogOrdersAddSalesperson < ActiveRecord::Migration
  def self.up
    add_column :catalog_orders, :salesperson_code,  :string, :limit=>25
  end

  def self.down
    remove_column :catalog_orders, :salesperson_code
  end
end

class AlterCatalogOrdersAddRefField < ActiveRecord::Migration
  def self.up
    add_column :catalog_orders,:ref_id, :integer
  end

  def self.down
    remove_column :catalog_orders, :ref_id
  end
end

                   
class AlterCatalogOrdersPgFields < ActiveRecord::Migration
  def self.up
    add_column :catalog_orders, :pg_transaction_id, :string, :limit=>100
  end

  def self.down
    remove_column :catalog_orders, :pg_transaction_id
  end
end

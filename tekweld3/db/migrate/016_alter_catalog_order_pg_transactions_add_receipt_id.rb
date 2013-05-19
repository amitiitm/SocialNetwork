class AlterCatalogOrderPgTransactionsAddReceiptId < ActiveRecord::Migration
  def self.up
    add_column :catalog_order_pg_transactions, :receipt_id, :string, :limit=>25
  end

  def self.down
    add_column :catalog_order_pg_transactions, :receipt_id
  end
end

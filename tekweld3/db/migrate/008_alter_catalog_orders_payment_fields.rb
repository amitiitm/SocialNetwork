class AlterCatalogOrdersPaymentFields < ActiveRecord::Migration
  def self.up
    add_column :catalog_orders, :payment_type, :string, :limit=>1, :default=>'P'
    add_column :catalog_orders, :payment_receipt_id, :string, :limit=>25
    add_column :catalog_orders, :payment_status, :string, :limit=>1, :default=>'U' 
    add_column :catalog_orders, :payment_date, :timestamp
  end

  def self.down
    remove_column :catalog_orders, :payment_type
    remove_column :catalog_orders, :payment_receipt_id
    remove_column :catalog_orders, :payment_status
    remove_column :catalog_orders, :payment_date
  end
end

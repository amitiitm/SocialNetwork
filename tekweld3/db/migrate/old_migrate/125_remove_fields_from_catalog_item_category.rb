class RemoveFieldsFromCatalogItemCategory < ActiveRecord::Migration
  def self.up
    remove_column :catalog_item_categories, :gl_purchase_invoice_id
    remove_column :catalog_item_categories, :gl_purchase_credit_id
    remove_column :catalog_item_categories, :gl_sale_invoice_id
    remove_column :catalog_item_categories, :gl_sale_credit_id
  end

  def self.down
    add_column :catalog_item_categories, :gl_purchase_invoice_id, :integer
    add_column :catalog_item_categories, :gl_purchase_credit_id, :integer
    add_column :catalog_item_categories, :gl_sale_invoice_id, :integer
    add_column :catalog_item_categories, :gl_sale_credit_id, :integer
  end
end

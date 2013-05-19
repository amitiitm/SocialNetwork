class CreateCatalogItemCategories < ActiveRecord::Migration
  def self.up
    create_table :catalog_item_categories do |t|
      t.integer   :company_id, :null=>false
      t.integer   :created_by, :updated_by
      t.datetime  :created_at, :updated_at
      t.string    :update_flag, :limit=>1,:default=>'Y'
      t.string    :trans_flag, :limit=>1,:default=>'A'
      t.integer   :lock_version, :default=>0 
      t.string    :code,  :limit=>25, :null=>false
      t.string    :name,  :limit=>50
      t.integer   :gl_purchase_invoice_id
      t.integer   :gl_purchase_credit_id
      t.integer   :gl_sale_invoice_id
      t.integer   :gl_sale_credit_id
    end
  end

  def self.down
    drop_table :catalog_item_categories
  end
end

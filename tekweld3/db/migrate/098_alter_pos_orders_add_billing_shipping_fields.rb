class AlterPosOrdersAddBillingShippingFields < ActiveRecord::Migration
  def self.up
    add_column :pos_orders, :billing_contact, :string, :limit=>50
    add_column :pos_orders, :billing_email, :string, :limit=>200
    add_column :pos_orders, :billing_cell_no, :string, :limit=>15
    add_column :pos_orders, :shipping_cell_no, :string, :limit=>15
    add_column :pos_orders, :shipping_email, :string, :limit=>200
    add_column :pos_orders, :shipping_contact, :string, :limit=>50
    remove_column :pos_orders ,:catalog_item_description 
       
  end

  def self.down
    remove_column :pos_orders, :billing_contact
    remove_column :pos_orders, :billing_email
    remove_column :pos_orders, :billing_cell_no
    remove_column :pos_orders, :shipping_cell_no
    remove_column :pos_orders, :shipping_email
    remove_column :pos_orders, :shipping_contact
    add_column :pos_orders, :catalog_item_description,:limit =>50
  end
end

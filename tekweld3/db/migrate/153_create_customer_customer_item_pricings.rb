class CreateCustomerCustomerItemPricings < ActiveRecord::Migration
  def self.up
    create_table :customer_customer_item_pricings do |t|

      t.timestamps
    end
  end

  def self.down
    drop_table :customer_customer_item_pricings
  end
end

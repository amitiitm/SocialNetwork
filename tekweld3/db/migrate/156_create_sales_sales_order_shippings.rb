class CreateSalesSalesOrderShippings < ActiveRecord::Migration
  def self.up
    create_table :sales_sales_order_shippings do |t|

      t.timestamps
    end
  end

  def self.down
    drop_table :sales_sales_order_shippings
  end
end

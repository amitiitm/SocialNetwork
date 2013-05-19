class CreateSalesSalesOrderAttributesValues < ActiveRecord::Migration
  def self.up
    create_table :sales_sales_order_attributes_values do |t|

      t.timestamps
    end
  end

  def self.down
    drop_table :sales_sales_order_attributes_values
  end
end

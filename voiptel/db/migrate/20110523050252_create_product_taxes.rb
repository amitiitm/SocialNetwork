class CreateProductTaxes < ActiveRecord::Migration
  def self.up
    create_table :product_taxes do |t|
      t.string :product_name
      t.string :product_code
      t.boolean :enabled
      t.integer :charge_type
      t.timestamps
    end
  end

  def self.down
    drop_table :product_taxes
  end
end

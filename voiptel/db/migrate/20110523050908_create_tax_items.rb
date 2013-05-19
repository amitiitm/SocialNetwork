class CreateTaxItems < ActiveRecord::Migration
  def self.up
    create_table :tax_items do |t|
      t.string :name
      t.string :description
      t.integer :product_tax_id
      t.timestamps
    end
  end

  def self.down
    drop_table :tax_items
  end
end

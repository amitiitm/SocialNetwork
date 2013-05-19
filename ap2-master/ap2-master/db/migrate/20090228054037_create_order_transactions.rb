class CreateOrderTransactions < ActiveRecord::Migration
  def self.up
    create_table :order_transactions do |t|
      t.string :action
      t.integer :amount
      t.boolean :success
      t.string :authorization
      t.text :params
      t.integer :order_id
      t.integer :reference_id

      t.timestamps
    end
  end

  def self.down
    drop_table :order_transactions
  end
end

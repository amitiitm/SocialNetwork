class CreateTransactionReferences < ActiveRecord::Migration
  def self.up
    create_table :transaction_references do |t|
      t.string :reference
      t.string :card_number
      t.integer :exp_month
      t.integer :exp_year
      t.integer :address_id
      t.timestamps
    end
  end

  def self.down
    drop_table :transaction_references
  end
end

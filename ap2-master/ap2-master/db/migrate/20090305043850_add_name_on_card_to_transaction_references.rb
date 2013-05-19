class AddNameOnCardToTransactionReferences < ActiveRecord::Migration
  def self.up
    add_column :transaction_references, :name_on_card, :string
  end

  def self.down
    remove_column :transaction_references, :name_on_card
  end
end

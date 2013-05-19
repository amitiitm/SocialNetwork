class AddCardTypeToTransactionReferences < ActiveRecord::Migration
  def self.up
    add_column :transaction_references, :card_type, :string
  end

  def self.down
    remove_column :transaction_references, :card_type
  end
end

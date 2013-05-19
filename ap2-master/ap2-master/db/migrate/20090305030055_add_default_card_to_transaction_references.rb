class AddDefaultCardToTransactionReferences < ActiveRecord::Migration
  def self.up
    add_column :transaction_references, :default_card, :boolean, :default => false
  end

  def self.down
    remove_column :transaction_references, :default_card
  end
end

class AlterMetalMeltingAddFields < ActiveRecord::Migration
  def self.up
    add_column :melting_transactions, :retailer_store, :string, :limit=>50
    add_column :melting_transactions, :customer_comments, :string, :limit=>500
  end

  def self.down
    remove_column :melting_transactions, :retailer_store
    remove_column :melting_transactions, :customer_comments
  end
end

class AlterMeltingTransactionAddThirdofferreminder < ActiveRecord::Migration
  def self.up
    add_column :melting_transactions, :thirdofferreminder, :string, :limit=>1, :default=>'N'
    add_column :melting_transactions, :thirdofferreminder_date, :datetime
  end

  def self.down
    remove_column :melting_transactions, :thirdofferreminder
    remove_column :melting_transactions, :thirdofferreminder_date
  end
end

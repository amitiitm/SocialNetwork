class AlterMeltingTransactionAddLabelFileName < ActiveRecord::Migration
  def self.up
    add_column :melting_transactions, :label_file_name,:string, :limit=>100  
  end

  def self.down
    remove_column :melting_transactions, :label_file_name
  end
end

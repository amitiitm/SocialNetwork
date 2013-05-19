class AlterMeltingTransactionAddSolicited < ActiveRecord::Migration
  def self.up
#    add_column :melting_transactions, :offer_solicited_flag, :string, :limit=>1, :default=>'N'
#    add_column :melting_transactions, :offer_solicited_date, :datetime
#    add_column :melting_transactions, :commission_due_date, :datetime
  end

  def self.down
    remove_column :melting_transactions, :offer_solicited_flag
    remove_column :melting_transactions, :offer_solicited_date
    remove_column :melting_transactions, :commission_due_date
  end
end

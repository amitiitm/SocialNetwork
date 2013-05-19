class AlterMeltingTransactionAddCommissionFields < ActiveRecord::Migration
  def self.up
    add_column :melting_transactions, :commission_check_date, :datetime
    add_column :melting_transactions, :printcommissioncheck, :string, :limit=>1, :default=>'N'
    add_column :melting_transactions, :printcommissioncheck_date, :datetime
    add_column :melting_transactions, :encashcommissioncheck, :string, :limit=>1, :default=>'N'
    add_column :melting_transactions, :encashcommissioncheck_date, :datetime
    add_column :melting_transactions, :encashcommissioncheck_no, :string, :limit=>25
    add_column :melting_transactions, :encash_commission_date, :datetime
  end

  def self.down
    remove_column  :melting_transactions, :printcommissioncheck
    remove_column  :melting_transactions, :printcommissioncheck_date
    remove_column  :melting_transactions, :encashcommissioncheck
    remove_column  :melting_transactions, :encashcommissioncheck_date
    remove_column  :melting_transactions, :encashcommissioncheck_no
    remove_column  :melting_transactions, :encash_commission_date
  end
end

class AlterCrmAccountsAddAccountSourceField < ActiveRecord::Migration
  def self.up
    add_column :crm_accounts, :account_source, :string ,:limit=>50
   
  end

  def self.down
    remove_column :crm_accounts, :account_source
  end
end


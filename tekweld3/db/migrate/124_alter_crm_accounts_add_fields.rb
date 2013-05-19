class AlterCrmAccountsAddFields < ActiveRecord::Migration
  def self.up
    add_column :crm_accounts, :saluation, :string ,:limit=>50
    add_column :crm_accounts, :first_name, :string ,:limit=>50
    add_column :crm_accounts, :last_name, :string ,:limit=>50
  end

  def self.down
    remove_column :crm_accounts, :saluation
    remove_column :crm_accounts, :first_name
    remove_column :crm_accounts, :last_name
  end
end


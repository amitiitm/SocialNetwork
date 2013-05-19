class AlterCrmAccountsAddRatingField < ActiveRecord::Migration
  def self.up
    add_column :crm_accounts, :account_rating, :string ,:limit=>1 , :default => ' '
  end

  def self.down
    remove_column :crm_accounts, :account_rating
  end
end

                   
class AlterMeltingTransactionAddWebsiteFields < ActiveRecord::Migration
  def self.up
    add_column :melting_transactions, :website_user_code, :string, :limit=>25
    add_column :melting_transactions, :shiplabelrequest, :string, :limit=>1, :default=>'N'
    add_column :melting_transactions, :shiplabelrequest_date, :datetime
    add_column :melting_transactions, :shippacketrequest, :string, :limit=>1, :default=>'N'
    add_column :melting_transactions, :shippacketrequest_date, :datetime
  end

  def self.down
    remove_column :melting_transactions, :website_user_code
    add_column :melting_transactions, :shiplabelrequest
    add_column :melting_transactions, :shiplabelrequest_date
    add_column :melting_transactions, :shippacketrequest
    add_column :melting_transactions, :shippacketrequest_date
  end
end

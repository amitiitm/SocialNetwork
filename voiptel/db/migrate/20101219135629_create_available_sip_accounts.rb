class CreateAvailableSipAccounts < ActiveRecord::Migration
  def self.up
    create_table :available_sip_accounts do |t|
      t.string :username, :limit => 20
      t.string :password, :limit => 20

      t.timestamps
    end
  end

  def self.down
    drop_table :available_sip_accounts
  end
end

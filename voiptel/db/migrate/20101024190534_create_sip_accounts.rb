class CreateSipAccounts < ActiveRecord::Migration
  def self.up
    create_table :sip_accounts do |t|
      t.string :username, :limit => 64
      t.string :domain, :limit => 64
      t.string :password, :limit => 64
      t.string :email_address, :limit => 64
      t.string :ha1, :limit => 64
      t.string :ha1b, :limit => 64
      t.string :rpid, :limit => 64
      t.integer :account_id

      t.timestamps
    end
  end

  def self.down
    drop_table :sip_accounts
  end
end

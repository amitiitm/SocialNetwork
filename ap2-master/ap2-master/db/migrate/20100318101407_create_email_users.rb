class CreateEmailUsers < ActiveRecord::Migration
  def self.up
    create_table :email_users do |t|
      t.string :email
      t.string :first_name
      t.string :last_name
      t.integer :uid
      t.integer :gid
      t.string :home
      t.string :maildir
      t.boolean :enabled
      t.boolean :change_password
      t.string :clear
      t.string :crypt
      t.string :quota
      t.string :procmailrc
      t.string :spamassassinrc

      t.timestamps
    end
  end

  def self.down
    drop_table :email_users
  end
end

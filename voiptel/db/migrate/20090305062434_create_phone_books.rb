class CreatePhoneBooks < ActiveRecord::Migration
  def self.up
    create_table :phone_books do |t|
      t.string :phone_number
      t.string :easy_dial_number
      t.string :name
      t.integer :freq, :default => 0
      t.integer :account_id
      t.integer :user_id

      t.timestamps
    end
  end

  def self.down
    drop_table :phone_books
  end
end

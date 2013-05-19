class AddDetailsToPhoneBooks < ActiveRecord::Migration
  def self.up
    add_column :phone_books, :relationship_id, :integer
    add_column :phone_books, :contact_name, :string
    add_column :phone_books, :contact_email, :string
    add_column :phone_books, :contact_nick_name, :string
  end

  def self.down
    remove_column :phone_books, :contact_nick_name
    remove_column :phone_books, :contact_email
    remove_column :phone_books, :contact_name
    remove_column :phone_books, :relationship_id
  end
end

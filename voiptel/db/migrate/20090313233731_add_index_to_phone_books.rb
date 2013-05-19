class AddIndexToPhoneBooks < ActiveRecord::Migration
  def self.up
    add_index :phone_books, :easy_dial_number
  end

  def self.down
    remove_index :phone_books, :easy_dial_number
  end
end

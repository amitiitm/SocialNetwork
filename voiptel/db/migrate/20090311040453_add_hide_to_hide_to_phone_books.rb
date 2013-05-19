class AddHideToHideToPhoneBooks < ActiveRecord::Migration
  def self.up
    add_column :phone_books, :hide, :boolean, :default => false
  end

  def self.down
    remove_column :phone_books, :hide
  end
end

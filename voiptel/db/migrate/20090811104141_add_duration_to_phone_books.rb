class AddDurationToPhoneBooks < ActiveRecord::Migration
  def self.up
    add_column :phone_books, :duration, :integer, :default => 0
  end

  def self.down
    remove_column :phone_books, :duration
  end
end

class AddAskPinToCards < ActiveRecord::Migration
  def self.up
    add_column :cards, :ask_pin, :boolean, :default => false
  end

  def self.down
    remove_column :cards, :ask_pin
  end
end

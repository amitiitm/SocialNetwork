class AddNotesToPhones < ActiveRecord::Migration
  def self.up
    add_column :phones, :notes, :string
  end

  def self.down
    remove_column :phones, :notes
  end
end

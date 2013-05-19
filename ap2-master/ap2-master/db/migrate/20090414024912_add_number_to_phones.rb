class AddNumberToPhones < ActiveRecord::Migration
  def self.up
    add_column :phones, :number, :string
  end

  def self.down
    remove_column :phones, :number
  end
end

class AddDigitsAndUserInputToCdrs < ActiveRecord::Migration
  def self.up
    add_column :cdrs, :digits, :integer
    add_column :cdrs, :user_input, :string
  end

  def self.down
    remove_column :cdrs, :user_input
    remove_column :cdrs, :digits
  end
end

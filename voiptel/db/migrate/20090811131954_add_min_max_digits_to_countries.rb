class AddMinMaxDigitsToCountries < ActiveRecord::Migration
  def self.up
    add_column :countries, :min_digits, :integer
    add_column :countries, :max_digits, :integer
  end

  def self.down
    remove_column :countries, :max_digits
    remove_column :countries, :min_digits
  end
end

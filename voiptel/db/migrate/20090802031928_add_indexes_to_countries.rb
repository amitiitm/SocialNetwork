class AddIndexesToCountries < ActiveRecord::Migration
  def self.up
    add_index :countries, :country_name_2_letters
    add_index :countries, :country_name_3_letters
    add_index :countries, :country_code
  end

  def self.down
    remove_index :countries, :country_code
    remove_index :countries, :country_name_3_lettersG
    remove_index :countries, :country_name_2_letters
  end
end

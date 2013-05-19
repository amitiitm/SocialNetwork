class AddFieldsToCountries < ActiveRecord::Migration
  def self.up
    add_column :countries, :country_name_2_letters, :string, :limit => 2
    add_column :countries, :country_name_3_letters, :string, :limit => 3
    add_column :countries, :max_cns, :integer
    add_column :countries, :min_cns, :integer
    add_column :countries, :publish, :boolean
  end

  def self.down
    remove_column :countries, :publish
    remove_column :countries, :min_cns
    remove_column :countries, :max_cns
    remove_column :countries, :country_name_3_letters
    remove_column :countries, :country_name_2_letters
  end
end

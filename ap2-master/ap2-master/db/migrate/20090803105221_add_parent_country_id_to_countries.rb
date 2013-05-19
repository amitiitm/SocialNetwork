class AddParentCountryIdToCountries < ActiveRecord::Migration
  def self.up
    add_column :countries, :parent_country_id, :integer
  end

  def self.down
    remove_column :countries, :parent_country_id
  end
end

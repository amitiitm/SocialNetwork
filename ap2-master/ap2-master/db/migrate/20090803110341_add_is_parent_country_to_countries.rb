class AddIsParentCountryToCountries < ActiveRecord::Migration
  def self.up
    add_column :countries, :is_parent_country, :boolean, :default => false
  end

  def self.down
    remove_column :countries, :is_parent_country
  end
end

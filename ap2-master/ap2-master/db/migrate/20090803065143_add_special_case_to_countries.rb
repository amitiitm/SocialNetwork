class AddSpecialCaseToCountries < ActiveRecord::Migration
  def self.up
    add_column :countries, :special_case, :boolean, :default => false
  end

  def self.down
    remove_column :countries, :special_case
  end
end

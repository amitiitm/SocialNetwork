class RatesChangeCountryIdToString < ActiveRecord::Migration
  def self.up
    change_column :rates, :country_id, :string, :limit => 3
  end

  def self.down
    change_column :rates, :country_id, :string
  end
end

class AddOldCountryIdToV2Countries < ActiveRecord::Migration
  def self.up
    add_column :v2_countries, :old_country_id, :integer
  end

  def self.down
    remove_column :v2_countries, :old_country_id
  end
end

class MakeCountryIdDefaultsToNull < ActiveRecord::Migration
  def self.up
    change_column :cdrs, :country_id, :string, :limit => 2, :default => nil
    change_column :cdrs_tmp, :country_id, :string, :limit => 2, :default => nil
    change_column :card_cdrs, :country_id, :string, :limit => 2, :default => nil
    change_column :card_cdrs_tmp, :country_id, :string, :limit => 2, :default => nil
  end

  def self.down
  end
end

class ChangeCountryIdFromIntegerToStringInCdrs < ActiveRecord::Migration
  def self.up
    change_column :cdrs, :country_id, :string, :limit => 2
    change_column :cdrs_tmp, :country_id, :string, :limit => 2
    change_column :card_cdrs, :country_id, :string, :limit => 2
    change_column :card_cdrs_tmp, :country_id, :string, :limit => 2
  end

  def self.down
    change_column :card_cdrs_tmp, :country_id, :string
    change_column :card_cdrs, :country_id, :string
    change_column :cdrs_tmp, :country_id, :string
    change_column :cdrs, :country_id, :string
  end
end

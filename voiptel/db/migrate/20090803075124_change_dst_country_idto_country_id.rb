class ChangeDstCountryIdtoCountryId < ActiveRecord::Migration
  def self.up
    rename_column :cdrs, :dst_country_id, :country_id
  end

  def self.down
    rename_column :cdrs, :country_id, :dst_country_id
  end
end

class AddIndexesToCachedDailyCdrs < ActiveRecord::Migration
  def self.up
    add_index :cached_ap_daily_cdrs, :day
    add_index :cached_ap_daily_country_cdrs, :day
    add_index :cached_ap_daily_country_cdrs, :country_id  
  end

  def self.down
    remove_index :cached_ap_country_cdrs, :country_id
    remove_index :cached_ap_country_cdrs, :day
    remove_index :cached_ap_daily_cdrs, :day
  end
end
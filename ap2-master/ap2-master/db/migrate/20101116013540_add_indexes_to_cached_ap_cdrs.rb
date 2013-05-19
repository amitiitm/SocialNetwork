class AddIndexesToCachedApCdrs < ActiveRecord::Migration
  def self.up
    add_index :cached_ap_cdrs, :month
    add_index :cached_ap_country_cdrs, :month
    add_index :cached_ap_country_cdrs, :country_id
  end

  def self.down
    remove_index :cached_ap_country_cdrs, :country_id
    remove_index :cached_ap_country_cdrs, :month      
    remove_index :cached_ap_cdrs, :month
  end
end

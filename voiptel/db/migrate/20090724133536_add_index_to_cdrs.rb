class AddIndexToCdrs < ActiveRecord::Migration
  def self.up
    add_index :cdrs, :user_id
    add_index :cdrs, :account_id
    add_index :cdrs, :phone_id
    add_index :cdrs, :dst_country_id
    add_index :cdrs, :carrier_id
    add_index :cdrs, :zone_id
    add_index :cdrs, :did_id
  end

  def self.down
    remove_index :cdrs, :did_id
    remove_index :cdrs, :zone_id
    remove_index :cdrs, :carrier_id
    remove_index :cdrs, :dst_country_id
    mind
    remove_index :cdrs, :phone_id
    remove_index :cdrs, :account_id
    remove_index :cdrs, :user_id
  end
end

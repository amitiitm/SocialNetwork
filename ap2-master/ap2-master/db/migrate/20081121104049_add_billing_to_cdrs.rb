class AddBillingToCdrs < ActiveRecord::Migration
  def self.up
    add_column :cdrs, :billing_duration, :integer
    add_column :cdrs, :carrier_id, :integer
    add_column :cdrs, :zone_id, :integer
  end

  def self.down
    remove_column :cdrs, :zone_id
    remove_column :cdrs, :carrier_id
    remove_column :cdrs, :billing_duration
  end
end
